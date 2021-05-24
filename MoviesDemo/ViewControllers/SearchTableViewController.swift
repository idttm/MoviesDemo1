//
//  SearchTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 24.05.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    
    let viewModel = ModelSearch()
    let viewModelMoreInfo = ImageDataFromURL()
    private var filterArraySearch = [DataSearch]()
    let searchResultController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchResultController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchResultController.isActive && !searchBarIsEmpty
    }
    private var selectedMovie: DataSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = "Search"
        searchResultController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchResultController
        
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterArraySearch.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel?.text = filterArraySearch[indexPath.row].title
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMovie = viewModel.dataResult(at: indexPath)
        
        performSegue(withIdentifier: "moreInfo", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "moreInfo" else { return }
        guard let moreVC = segue.destination as? MoreInfoViewController else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        if isFiltering {
            moreVC.currentDataForMoreInfoSearch = filterArraySearch[indexPath.row]
            
            
        }
    }
}
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.getData(searchResultController.searchBar.text!, completio: { [weak self] in
            self?.tableView.reloadData()
        })
        filterContentForSearch(searchController.searchBar.text!)
    }
    
    private func filterContentForSearch(_ searchText: String) {
        let  arrayDataTitle = viewModel.searchArrayTitle()
        filterArraySearch = arrayDataTitle.filter({ titleSearch in
            return titleSearch.title.lowercased().contains(searchText.lowercased())
            print(arrayDataTitle)
        })
        tableView.reloadData()
    }
}
