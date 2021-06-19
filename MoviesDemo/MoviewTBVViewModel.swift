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
    private var dataSimilar: [ResultSimilar] = []
    private var filterArraySearch = [DataResult]()
    var numberOfRows: Int { data.count }
    var numberOfRowsSimilar: Int {dataSimilar.count}
    var numberOfRowsSearch: Int { filterArraySearch.count }
//    var pageWeak = 1
    var pageDay = 1
    var pageWeak = 1
    func getData(week: Bool, completio: @escaping() -> Void) {
        
        switch week {
        
        case true:
            
            if pageWeak == 1 {
                data.removeAll()
            }
            self.networkManager.gettingDataFromJSON(page: pageWeak, week: week) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.data.append(contentsOf: data)
                    case .failure(let error):
                        break
                    }
                    completio()
                }
            pagePlus()
        case false:
            if pageDay == 1 {
                data.removeAll()
            }
            self.networkManager.gettingDataFromJSON(page: pageDay, week: week) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.data.append(contentsOf: data)
                    case .failure(let error):
                        break
                    }
                    completio()
                }
            
            pagePlus1()
        }
        
    }
    func getDataSimilar(completion: @escaping() -> Void ) {
        self.networkManager.gettingDataSimilarFromJSON(page: pageWeak, query: "1726") { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataSimilar.append(contentsOf: data)
            case .failure(let error):
                break
            }
            completion()
        }
        pagePlus()
    }
    
    func pagePlus() {
        pageWeak += 1
    }
    func pagePlus1() {
        pageDay += 1
    }

    
    func titleForRow(at indexPath: IndexPath) -> String {
        data[indexPath.row].title
    }
    func titleForRowSimilar(at indexPath: IndexPath) -> String {
        dataSimilar[indexPath.row].title
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
    func partTwoImageUrl(at indexPath: IndexPath) -> String {
        data[indexPath.row].posterPath
    }
    
    private func searchBarIsEmpty(at seachController: UISearchController) -> Bool {
        guard let text = seachController.searchBar.text else {return false }
        return text.isEmpty
    }
    func isFiltering (at seachController: UISearchController) -> Bool {
        return seachController.isActive && !searchBarIsEmpty(at: seachController)
    }
    
}
