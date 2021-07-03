//
//  StrucktSection.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import Foundation

struct PosterPhotoData: Hashable {
    
    static func == (lhs: PosterPhotoData, rhs: PosterPhotoData) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    var posterPath: String
    
    init?(currentMoview: DataResult) {
        self.posterPath = currentMoview.posterPath
        self.id = currentMoview.id
    }
}

struct MoreTextInfo: Hashable {
    var title: String
    var rating: Double
    var overview: String
    
    init?(currentMoview: DataResult) {
        self.title = currentMoview.title
        self.rating = currentMoview.voteAverage
        self.overview = currentMoview.overview
    }
}

struct SimilarMovies: Hashable {
   
    var moviewSimilar: [ResultSimilar]
    
    init?(similarData: [ResultSimilar]) {
        self.moviewSimilar = similarData
    }
}






