//
//  ModelMoreInfo.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 15.05.2021.
//

import Foundation

class ModelMoreInfo {
    
    static let shared = ModelMoreInfo()
    private init() {}

    private var partOneImageUrl = "https://image.tmdb.org/t/p/w500"
    
    
    func imageTitle (_ partTwoImageUrl: String) -> Data? {
        guard let imageUrl = URL(string: partOneImageUrl+partTwoImageUrl) else {return nil }
        guard let imageData = try? Data(contentsOf: imageUrl) else {return nil }
        return imageData
    }
    
   
}
