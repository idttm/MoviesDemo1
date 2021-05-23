// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let test2 = try? newJSONDecoder().decode(Test2.self, from: jsonData)

import Foundation

// MARK: - SearchData
struct SearchData: Codable {
    let page: Int
    let results: [DataSearch]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct DataSearch: Codable {
    let name: String
    let id: Int
}
