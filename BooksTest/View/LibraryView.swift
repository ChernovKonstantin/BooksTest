//
//  LibraryView.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @State var currentTabIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                
                ScrollView (.vertical, showsIndicators: false) {
                    HStack {
                        Text("Library")
                            .font(.custom("Nunito Sans", fixedSize: 20))
                            .foregroundColor(Color(hex: "D0006E"))
                        Spacer()
                    }
                    carouselView
                    ForEach(viewModel.genreArray, id: \.self) { genre in
                        VStack(alignment: .leading) {
                            Text(genre)
                                .font(.custom("Nunito Sans", fixedSize: 22))
                                .foregroundColor(Color(hex: "FFFFFF"))
                            horizontalBooksViewFor(genre: genre)
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private var carouselView: some View {
        TabView(selection: $currentTabIndex) {
            if let slides = viewModel.books.jsonData.topBannerSlides {
                ForEach(slides) { slide in
                    if viewModel.cachedImages[slide.cover] == nil {
                        ProgressView()
                            .task {
                                await viewModel.fetchImage(from: slide.cover)
                            }
                    } else {
                        NavigationLink(destination: {
                            DetailsView(viewModel: DetailsViewModel(books: viewModel.books),
                                        selectedTab: slide.bookID)
                        }, label: {
                        imageFrom(url: slide.cover)
                            .frame(height: 160)
                            .cornerRadius(16)
                            .tag(slide.id)
                            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                                .onEnded({ value in
                                    currentTabIndex = viewModel
                                        .calculateNextSlidePosition(for: value.translation.width,
                                                                    currentTabIndex: currentTabIndex)
                                }))
                        })
                    }
                }
            } else {
                Text("No banners")
                    .font(.custom("Nunito Sans", fixedSize: 20))
                    .foregroundColor(Color(hex: "D0006E"))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 170)
        .onAppear {
            setupAppearance()
        }
        .onReceive(viewModel.timer, perform: { _ in
            currentTabIndex = viewModel.changeSlideOnTimerFrom(currentTabIndex: currentTabIndex)
        })
    }
    
    @ViewBuilder
    private func imageFrom(url: String) -> some View {
        if viewModel.cachedImages[url] == nil {
            ProgressView()
                .task {
                    await viewModel.fetchImage(from: url)
                }
        } else {
            viewModel.cachedImages[url]?
                .resizable()
                .scaledToFill()
        }
    }
    
    @ViewBuilder
    private func horizontalBooksViewFor(genre: String) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(viewModel.books.jsonData.books) { book in
                    NavigationLink(destination: {
                        DetailsView(viewModel: DetailsViewModel(books: viewModel.books),
                                    selectedTab: book.id)
                    }, label: {
                    if book.genre == genre {
                        VStack {
                            imageFrom(url: book.coverURL)
                                .frame(width: 120, height: 150)
                                .cornerRadius(16)
                            Text(book.name)
                                .font(.custom("Nunito Sans", fixedSize: 16))
                                .foregroundColor(Color(hex: "FFFFFF").opacity(0.7))
                                .lineLimit(nil)
                                .frame(width: 120)
                        }
                    }
                    })
                }
            }
        }
    }
    
    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: "D0006E"))
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel:
                        LibraryViewModel(books:
                                            MainModel(jsonData:
                                                        JsonDataModel(books: [],
                                                                      topBannerSlides: [],
                                                                      recommendations: []),
                                                      detailsCarousel:
                                                        CarouselDataModel(books: []))))
    }
}

