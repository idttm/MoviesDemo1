//
//  MoviewTBVViewModel.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 22.05.2021.
//

import UIKit

class MoviewTBVViewModel {
    
    private let networkManager = NetworkingManager()
    private let newNetworkManager = NetworkingManager()
    var data: [DataResult] = []
    private var filterArraySearch = [DataResult]()
    var numberOfRows: Int { data.count }
    var numberOfRowsSimilar: Int { similarMovies.count }
    var numberOfRowsSearch: Int { filterArraySearch.count }
    private var page = 1
    private var week: Bool = true
    
    var onDataUpdated: () -> Void = {}
    var similarMovies: [ResultSimilar] = []
    
    func getData(week: Bool, completio: @escaping() -> Void) {
        if page == 1 {
            data.removeAll()
        }
        self.newNetworkManager.getTrandinMovies(page: page, week: week) {
            [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                self?.onDataUpdated()
            case .failure(let error):
                break
            }
            self?.pagePlus()
            completio()
        }
    }
    
    func getDataLayout(movieId: Int, completion: @escaping() -> Void) {
        let dg = DispatchGroup()
        //        networkManager.getDataTrending(page: 1, week: false) { [weak self] result in
        //            switch result {
        //            case .success(let data):
        //                self?.posterURLString = data.first?.posterPath  ?? ""
        //                self?.sectionDataForMoreInfo = MoreTextInfo(currentMoview: data)
        //            case .failure(let error):
        //                break
        //            }
        //            dg.leave()
        //        }
        
        dg.enter()
        networkManager.getSimilarMovies(page: 1, movieId: movieId) { [weak self] result  in
            switch result {
            case .success(let data):
                self?.similarMovies = data
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            dg.leave()
            
            dg.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
    
    var title: String {
        week ? "Day tranding" : "Week tranding"
    }
    
    var buttonTitle: String {
        week ? "Week tranding" : "Day tranding"
    }
    
    func toggleTrandingMode() {
        week.toggle()
        refresh()
    }
    
    func refresh() {
        page = 1
        getNextPage()
    }
    
    func getNextPage() {
        print(self.page)
        getData(week: week) { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func pagePlus() {
        page += 1
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        data[indexPath.row].title
    }
    
    func titleForRowSimilar(at indexPath: IndexPath) -> String {
        similarMovies[indexPath.row].title
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
