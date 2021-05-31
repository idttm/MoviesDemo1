//
//  MoviesTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    private let viewModel = MoviewTBVViewModel()
   
    private var selectedData: DataResult?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()
        viewModel.getData { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    private func addSearchController() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if viewModel.isFiltering(at: searchController) {
            return viewModel.numberOfRowsSearch
        }
        return viewModel.numberOfRows

    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.getData { 
            tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        if viewModel.isFiltering(at: searchController){
            
            let title = viewModel.titleForRowSearch(at: indexPath)
                cell.textLabel?.text = title
        } else {
            let title = viewModel.titleForRow(at: indexPath)
            cell.textLabel?.text = title
        }
        return cell

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if viewModel.isFiltering(at: searchController) {
            selectedData = viewModel.dataResultSearch(at: indexPath)
        } else {
            selectedData = viewModel.dataResult(at: indexPath)
        }
            performSegue(withIdentifier: "showMovie", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        guard let moreVC = segue.destination as? MoreInfoViewController else {return}
        moreVC.currentDataForMoreInfo = selectedData
    }
}
extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       viewModel.filterContentForSearch(searchController.searchBar.text!)
        tableView.reloadData()
    }
}


