//
//  ModelSearch.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 23.05.2021.
//

import Foundation

class ModelSearch {
    
    private let networkManager = NetworkMoviesManager()
    private var data: [DataSearch] = []
    
    func getData(_ textSearch: String, completio: @escaping() -> Void) {
        
        networkManager.gettingDataSearchFromJSON(query: textSearch, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
            case .failure(let error):
                break
            }
            completio()
        })
    }
    func dataResult(at indexPath: IndexPath) -> DataSearch {
        data[indexPath.row]
    }
    
    func searchArrayTitle() -> [DataSearch] {
        return data
    }
    
}
