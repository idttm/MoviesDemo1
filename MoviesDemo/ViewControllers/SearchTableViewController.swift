//
//  SearchTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 24.05.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    
    let viewModel = ModelSearch()
    private var searchData: DataSearch?
    
    private var filterArraySearch = [DataSearch]()
    
    
    
    
    private lazy var searchResultController: UISearchController = {
        let searchResultController = UISearchController(searchResultsController: nil)
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = "Search"
        searchResultController.obscuresBackgroundDuringPresentation = false
        return searchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        addSearchController()
            }
    private func addSearchController() {
        navigationItem.searchController = searchResultController
        definesPresentationContext = true
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
       
        cell.textLabel?.text = viewModel.dataResult(at: indexPath).title
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchData = viewModel.dataResult(at: indexPath)
        performSegue(withIdentifier: "moreInfo", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "moreInfo" else { return }
        guard let moreVC = segue.destination as? MoreInfoViewController else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        if viewModel.isFiltering(at: searchResultController) {
            moreVC.currentDataForMoreInfoSearch = searchData
            print(searchData)
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.getData(searchResultController.searchBar.text){
            tableView.reloadData()
            }
        }
    }
}
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.launchSearch(text: searchResultController.searchBar.text, searchController: searchResultController, tableView: tableView)
        
    }
}
