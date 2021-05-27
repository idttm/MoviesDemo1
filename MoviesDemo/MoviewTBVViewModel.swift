//
//  MoviewTBVViewModel.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 22.05.2021.
//

import UIKit

class MoviewTBVViewModel {
    
    private let networkManager = NetworkMoviesManager()
    private var data: [DataResult] = []
    private var filterArraySearch = [DataResult]()
    var numberOfRows: Int { data.count }
    var numberOfRowsSearch: Int { filterArraySearch.count }
    var currentPage = 1
    var totalPages = 1000
    
    
    func getData(completio: @escaping() -> Void) {
        DispatchQueue.main.async {
            self.networkManager.gettingDataFromJSON(page: self.currentPage) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.data.append(contentsOf: data)
                case .failure(let error):
                    break
                }
                completio()
            }
        }
        
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        data[indexPath.row].title
    }
    func dataResult(at indexPath: IndexPath) -> DataResult {
        data[indexPath.row]
    }
    func titleForRowSearch(at indexPath: IndexPath) -> String {
        filterArraySearch[indexPath.row].title
    }
    func dataResultSearch(at indexPath: IndexPath) -> DataResult {
        filterArraySearch[indexPath.row]
    }
    
    func filterContentForSearch(_ searchText: String) {
        let  arrayDataTitle = data
        filterArraySearch = arrayDataTitle.filter({ titleSearch in
            return titleSearch.title.lowercased().contains(searchText.lowercased())
        })
    }
    func startUnpagination() {
        if currentPage < totalPages {
            currentPage += 1
        }
    }
    private func searchBarIsEmpty(at seachController: UISearchController) -> Bool {
        guard let text = seachController.searchBar.text else {return false }
        return text.isEmpty
    }
    func isFiltering (at seachController: UISearchController) -> Bool {
        return seachController.isActive && !searchBarIsEmpty(at: seachController)
    }
    
}
