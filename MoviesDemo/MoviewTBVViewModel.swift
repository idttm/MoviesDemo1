//
//  MoviewTBVViewModel.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 22.05.2021.
//

import Foundation

class MoviewTBVViewModel {
    
    private let networkManager = NetworkMoviesManager()
    private var data: [DataResult] = []
    var numberOfRows: Int { data.count }
    var currentPage = 1
    var totalPages = 1000
    
    
    func getData(completio: @escaping() -> Void) {
        
        networkManager.fetchCurrentJson(page: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
            case .failure(let error):
                break
            }
            completio()
        }
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        data[indexPath.row].title
    }
    func dataResult(at indexPath: IndexPath) -> DataResult {
        data[indexPath.row]
    }
    func searchArrayTitle() -> [String] {
        var arrayTitle = [String]()
        for array in data {
            arrayTitle.append(array.title)
        }
        return arrayTitle
    }
    

    
}
