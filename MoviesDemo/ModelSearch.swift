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
    var numberOfRows: Int { data.count }
    var page = 1 
    
    func getData(_ textSearch: String?, completion: @escaping() -> Void) {
        guard let textSearch = textSearch else {return}
        networkManager.gettingDataSearchFromJSON(page: page, query: textSearch, completion: { [weak self] result in
            switch result {
            case .success(let data):
                    self?.data.append(contentsOf: data)
            case .failure(let error):
                break
            }
            completion()
        })
        pagePlus()
    }
    
    func pagePlus() {
        page += 1
    }
    func dataResult(at indexPath: IndexPath) -> DataSearch {
       data[indexPath.row]
    }
    func removeData() {
        data.removeAll()
    }
    
    func searchArrayTitle() -> [DataSearch] {
        return data
    }
    
}
