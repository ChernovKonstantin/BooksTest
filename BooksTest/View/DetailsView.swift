//
//  DetailsView.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 25.02.2024.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @ObservedObject var viewModel: DetailsViewModel
    @State var selectedTab: Int
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        topScrollDetailsCarousel
                        summaryView(for: viewModel.books.detailsCarousel.books[selectedTab])
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                })
            }
        }
        
    }
    
    @ViewBuilder
    private var topScrollDetailsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollReader in
                HStack(spacing: 80) {
                    if let slides = viewModel.books.detailsCarousel.books {
                        Spacer()
                        ForEach(slides) { slide in
                            VStack {
                                imageFrom(url: slide.coverURL)
                                    .cornerRadius(16)
                                    .frame(width: selectedTab == slide.id ? 200 : 160,
                                           height: selectedTab == slide.id ? 250 : 200)
                                    .animation(.linear(duration: 0.1), value: selectedTab)
                                    .id(slide.id)
                                
                                Text(slide.name)
                                    .font(.custom("Nunito Sans", fixedSize: 22))
                                    .foregroundColor(Color(hex: "FFFFFF"))
                                Text(slide.author)
                                    .font(.custom("Nunito Sans", fixedSize: 14))
                                    .foregroundColor(Color(hex: "FFFFFF").opacity(0.8))
                            }
                        }
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width < 0 {
                                    selectedTab = selectedTab == slides.count-1 ? selectedTab : selectedTab + 1
                                    withAnimation {
                                        scrollReader.scrollTo(selectedTab, anchor: .center)
                                    }
                                } else if value.translation.width > 0 {
                                    selectedTab = selectedTab == 0 ? selectedTab : selectedTab - 1
                                    withAnimation {
                                        scrollReader.scrollTo(selectedTab, anchor: .center)
                                    }
                                }
                            }))
                        Spacer()
                    }
                    else {
                        Text("No banners")
                            .font(.custom("Nunito Sans", fixedSize: 30))
                            .foregroundColor(Color(hex: "D0006E"))
                    }
                }
                .onAppear {
                    scrollReader.scrollTo(selectedTab, anchor: .center)
                }
                .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder
    private func summaryView(for slide: BookModel) -> some View {
        ZStack(alignment: .top) {
            Color.white
                .edgesIgnoringSafeArea(.bottom)
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    summaryTextView(topText: slide.views, bottomText: "Readers")
                    Spacer()
                    summaryTextView(topText: slide.likes, bottomText: "Likes")
                    Spacer()
                    summaryTextView(topText: slide.quotes, bottomText: "Quotes")
                    Spacer()
                    summaryTextView(topText: slide.genre, bottomText: "Genre")
                    Spacer()
                }
                Divider()
                Text("Summary")
                    .font(.custom("Nunito Sans", fixedSize: 20))
                    .foregroundColor(Color(hex: "0B080F"))
                    .padding([.top, .bottom], 8)
                Text(slide.summary)
                    .lineLimit(nil)
                    .font(.custom("Nunito Sans", fixedSize: 14))
                    .foregroundColor(Color(hex: "393637"))
                Divider()
                Text("You will also like")
                    .font(.custom("Nunito Sans", fixedSize: 20))
                    .foregroundColor(Color(hex: "0B080F"))
                    .padding([.top, .bottom], 8)
                horizontalBooksView
                HStack {
                    Spacer()
                    Button("Read now", action: {
                        if let url = URL(string: slide.coverURL) {
                            openURL(url)
                        } else {
                            showingAlert = true
                        }
                    })
                    .frame(width: 278, height: 48)
                    .foregroundColor(.white)
                    .background(Color(hex: "DD48A1"))
                    .cornerRadius(30)
                    .alert("Sorry, could not load book. Try again", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                    Spacer()
                }
            }
            .padding()
        }
        .roundedCorner(20, corners: [.topLeft, .topRight])
        .frame(minHeight: 700, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func summaryTextView(topText: String, bottomText: String) -> some View {
        VStack {
            Text(topText)
                .font(.custom("Nunito Sans", fixedSize: 18))
                .foregroundColor(Color(hex: "0B080F"))
            Text(bottomText)
                .font(.custom("Nunito Sans", fixedSize: 12))
                .foregroundColor(Color(hex: "D9D5D6"))
        }
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
    private var horizontalBooksView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(viewModel.books.jsonData.books) { book in
                    if viewModel.books.jsonData.recommendations.contains(book.id) {
                        NavigationLink(destination: {
                            DetailsView(viewModel: viewModel,
                                        selectedTab: book.id)
                        }, label: {
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
                        })
                    }
                }
            }
        }
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
