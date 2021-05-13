//
//  UsedData.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import Foundation

struct UsedData {
    
    let originalTitle: [String]
    let voteAverage: [Double]
    let overview: [String]
    let backdropPath: [String]
    
    
    init?(dataStruct: Test) {
        
        var reselt1 = [String]()
        for result in dataStruct.results {
            reselt1.append(result.title)
        }
        var voteAvarege1 = [Double]()
        for voteAvarge in dataStruct.results {
            voteAvarege1.append(voteAvarge.voteAverage)
        }
        var overview1 = [String]()
        for overview in dataStruct.results {
            overview1.append(overview.overview)
        }
        var path1 = [String]()
        for path in dataStruct.results {
            path1.append(path.backdropPath)
        }
        originalTitle = reselt1
        voteAverage = voteAvarege1
        overview = overview1
        backdropPath = path1
    }
}
