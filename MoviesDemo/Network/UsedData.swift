//
//  UsedData.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import Foundation

struct UsedData {
    
    let originalTitle: String
    let voteAverage: Double
    let overview: String
    var voteAverageString: String {
        return "\(voteAverage.rounded())"
    }
    
    init?(dataStruct: Test) {
        
        originalTitle = dataStruct.originalTitle
        voteAverage = dataStruct.voteAverage
        overview = dataStruct.overview
        
    }
}
