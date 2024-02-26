//
//  APIService.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import SwiftUI

struct APIService {
    
    func loadImage(url: String) async throws -> Image {
        guard let url = URL(string: url) else { throw APIError.dataTaskError }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.responseStatusError }
        guard let image = UIImage(data: data) else { throw APIError.imageDataError }
        return Image(uiImage: image)
    }
    
}

enum APIError: Error {
    case responseStatusError
    case imageDataError
    case dataTaskError
}
