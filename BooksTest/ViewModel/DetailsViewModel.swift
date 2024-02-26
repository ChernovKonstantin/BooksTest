//
//  DetailsViewController.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 25.02.2024.
//

import SwiftUI

class DetailsViewModel: ObservableObject {
    @Published var cachedImages: [String: Image] = [:]
    @Published var books: MainModel
    
    private let apiService = APIService()
    
    init(books: MainModel) {
        self.books = books
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
