// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let test = try? newJSONDecoder().decode(Test.self, from: jsonData)

import Foundation

// MARK: - Test
struct Test: Codable {
    let page: Int
    let results: [DataResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct DataResult: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview, posterPath: String
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let mediaType: MediaType

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case mediaType = "media_type"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
}

