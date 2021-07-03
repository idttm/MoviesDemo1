//
//  ModelSearch.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 23.05.2021.
//

import UIKit

class ModelSearch {
    
    private let networkManager = NetworkingManager()
    private var data: [DataSearch] = []
    var numberOfRows: Int { data.count }
    var page = 1 
    var onLoadingStateChanged: (Bool) -> Void = { _ in }

    func getData(_ textSearch: String?, completion: @escaping() -> Void) {
        guard let textSearch = textSearch else {return}
        networkManager.getDataSearch(page: page, query: textSearch, completion: { [weak self] result in
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
        guard let newSearchText = text?.replacingOccurrences(of: " ", with: "%20") else {return}
        if isFiltering(at: searchController) && antiSpam(text: newSearchText) {

            print(newSearchText)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.onLoadingStateChanged(true)
                self.getData(newSearchText) { [weak self] in
                    self?.onLoadingStateChanged(false)
                    tableView.reloadData()
                }
//            }
            
        }
    }
    
}
