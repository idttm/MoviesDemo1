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
    let modelTableView = ModelTableView.shared
    var currentTitle = ""
    var currentVoide = ""
    var currentOverview = ""
    var partTwoImageUrl = ""
    var partOneImageUrl = "https://image.tmdb.org/t/p/w500"
    
    func imageTitle () -> Data? {
        guard let imageUrl = URL(string: partOneImageUrl+partTwoImageUrl) else {return nil}
        guard let imageData = try? Data(contentsOf: imageUrl) else {return nil}
        return imageData
    }
    
    func transferDate(_ indexPath: IndexPath) -> () {
        
        let objectT = modelTableView.arrryTitleTest[indexPath.row]
        let objectV = modelTableView.arrayVoite[indexPath.row]
        let objectO = modelTableView.arrayOverview[indexPath.row]
        let objectI = modelTableView.arrayImage[indexPath.row]
        currentTitle = objectT
        currentVoide = "Raing: \(String(objectV))"
        currentOverview = objectO
        partTwoImageUrl = objectI
        
    }
    
}
