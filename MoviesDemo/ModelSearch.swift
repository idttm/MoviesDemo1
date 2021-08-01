//
//  ModelSearch.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 23.05.2021.
//

import UIKit

class ModelSearch {
    
    private let networkManager = NetworkingManager()
    var data: [DataSearch] = []
    var numberOfRows: Int { data.count }
    var page = 1 
    var onLoadingStateChanged: (Bool) -> Void = { _ in }

    func getData(pagination: Bool = false, _ textSearch: String?, completion: @escaping() -> Void) {
        guard let textSearch = textSearch else {return}
        if pagination == true {
            pagePlus()
        }
        networkManager.getSearchMovies(page: page, query: textSearch, completion: { [weak self] result in
            switch result {
            case .success(let data):
                    self?.data.append(contentsOf: data)
               
            case .failure(let error):
                break
            }
            completion()
        })
        
    }

    func pagePlus() {
        page += 1
    }

    func dataResult(at indexPath: IndexPath) -> DataSearch {
       data[indexPath.row]
    }

    func removerData() {
        data.removeAll()
    }
    
    func searchArrayTitle() -> [DataSearch] {
        return data
    }

    func antiSpam(text: String) -> Bool {
        let text = text
        let characters = Array(text)
        if characters.count > 2 {
            return true
        }
        return false
    }

    private func searchBarIsEmpty(at seachController: UISearchController) -> Bool {
        guard let text = seachController.searchBar.text else {return false }
        return text.isEmpty
    }

    func isFiltering (at seachController: UISearchController) -> Bool {
        return seachController.isActive && !searchBarIsEmpty(at: seachController)
    }
    
    func launchSearch(text: String?, searchController: UISearchController, tableView: UITableView) {
        removerData()
        page = 1
        if isFiltering(at: searchController) && antiSpam(text: text!) {
            self.onLoadingStateChanged(true)
                self.getData(text) { [weak self] in
                    self?.onLoadingStateChanged(false)
                    tableView.reloadData()
                }
        }
    }
}
