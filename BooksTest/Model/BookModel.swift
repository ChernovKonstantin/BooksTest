//
//  BookModel.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 24.02.2024.
//

struct MainModel: Codable {
    let jsonData: JsonDataModel
    let detailsCarousel: CarouselDataModel
}

struct JsonDataModel: Codable {
    let books: [BookModel]
    let topBannerSlides: [TopBannerSlide]
    let recommendations: [Int]
    
    enum CodingKeys: String, CodingKey {
        case books
        case topBannerSlides = "top_banner_slides"
        case recommendations = "you_will_like_section"
    }
}

struct CarouselDataModel: Codable {
    let books: [BookModel]
    
    enum CodingKeys: String, CodingKey {
        case books
    }
}

struct BookModel: Codable, Identifiable {
    let id: Int
    let name: String
    let author: String
    let summary: String
    let genre: String
    let coverURL: String
    let views: String
    let likes: String
    let quotes: String

    enum CodingKeys: String, CodingKey {
        case id, name, author, summary, genre, views, likes, quotes
        case coverURL = "cover_url"
    }
}

struct TopBannerSlide: Codable, Identifiable {
    let id: Int
    let bookID: Int
    let cover: String

    enum CodingKeys: String, CodingKey {
        case id, cover
        case bookID = "book_id"
    }
}

