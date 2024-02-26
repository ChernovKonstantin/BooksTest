//
//  LibraryViewModel.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 24.02.2024.
//

import SwiftUI

class LibraryViewModel: ObservableObject {
    @Published var cachedImages: [String: Image] = [:]
    @Published var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @Published var books: MainModel
    
    private(set) var genreArray: [String] = []
    private let apiService = APIService()
    
    
    init(books: MainModel) {
        self.books = books
        createGenreArray()
    }
    
    func createGenreArray() {
        for book in books.jsonData.books {
            if !genreArray.contains(book.genre) {
                genreArray.append(book.genre)
            }
        }
    }
    
    func calculateNextSlidePosition(for value: Double, currentTabIndex: Int) -> Int {
        if value < 0 {
            return currentTabIndex == books.jsonData.topBannerSlides.count - 1 ? 0 : currentTabIndex + 1
        } else if value > 0 {
            return currentTabIndex == 0 ? books.jsonData.topBannerSlides.count - 1 : currentTabIndex - 1
        }
        return 0
    }
    
    func changeSlideOnTimerFrom(currentTabIndex: Int) -> Int {
        return currentTabIndex == books.jsonData.topBannerSlides.count - 1 ? 0 : currentTabIndex + 1
    }
    
    func fetchImage(from url: String) async {
        do {
            let image = try await apiService.loadImage(url: url)
            DispatchQueue.main.async { [self] in
                cachedImages[url] = image
            }
        } catch let error {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}
