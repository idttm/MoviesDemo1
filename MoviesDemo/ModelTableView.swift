//
//  ModelTableView.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 15.05.2021.
//

import Foundation

class ModelTableView {
    
    static let shared = ModelTableView()
    private init () {}
    
    let networkManager = NetworkMoviesManager()
    var arrryTitleTest = [String]()
    var arrayVoite = [Double]()
    var arrayOverview = [String]()
    var arrayImage = [String]()
    
    func modelTableView() {
        networkManager.delegate = self
    }
}
extension ModelTableView: NetworkManagerDelegate {
    func updateInterface(_: NetworkMoviesManager, with usedDate: UsedData) {
        
        var array = [String]()
        for array1 in usedDate.originalTitle {
            array.append(array1)
        }
        var arrayV = [Double]()
        for arary2 in usedDate.voteAverage {
            arrayV.append(arary2)
        }
        var arrayO = [String]()
        for array3 in usedDate.overview {
            arrayO.append(array3)
        }
        var arrayI = [String]()
        for arra4 in usedDate.backdropPath {
            arrayI.append(arra4)
        }
        arrryTitleTest = array
        arrayVoite = arrayV
        arrayOverview = arrayO
        arrayImage = arrayI
    }
    
}
