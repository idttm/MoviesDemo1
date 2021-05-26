//
//  MoviesTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    let viewModel = MoviewTBVViewModel()
    let viewModelMoreInfo = ImageDataFromURL()
    
    let searchResultController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchResultController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchResultController.isActive && !searchBarIsEmpty
    }

    private var selectedData: DataResult?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultController.searchResultsUpdater = self
        searchResultController.searchBar.placeholder = "Search"
        searchResultController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchResultController
        viewModel.getData { [weak self] in
            self?.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering {
            return viewModel.numberOfRowsSearch
        }
        return viewModel.numberOfRows

    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.startUnpagination()
            viewModel.getData { [weak self] in
            self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        if isFiltering {
            let title = viewModel.titleForRowSearch(at: indexPath)
                cell.textLabel?.text = title
        } else {
            let title = viewModel.titleForRow(at: indexPath)
            cell.textLabel?.text = title
        }
        return cell

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
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
