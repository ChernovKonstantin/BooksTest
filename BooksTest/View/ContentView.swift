//
//  ContentView.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = MainViewModel()
    @State var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashScreen()
                .onAppear {
                    Task {
                        await viewModel.startFetching()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        showSplash.toggle()
                    })
                }
        } else {
            if let books = viewModel.books {
                LibraryView(viewModel: LibraryViewModel(books: books))
            } else {
                ZStack {
                    Color.black
                        .ignoresSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2.0)
                        .tint(Color(hex: "D0006E"))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
