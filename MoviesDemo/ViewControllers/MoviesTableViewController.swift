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
    
    @IBOutlet weak var trandingButton: UIBarButtonItem!
    var week = true
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
        self.title = "Week tranding"
        viewModel.getData(week: true) { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    @IBAction func trandingButtonAction(_ sender: UIBarButtonItem) {
        if trandingButton.title != "Week tranding" {
            trandingButton.title = "Week tranding"
            week = false
            self.title = "Day tranding"
            viewModel.pageDay = 1
            viewModel.getData(week: false) { [weak self] in
                self?.tableView.reloadData()
            }
            
        } else {
            trandingButton.title = "Day tranding"
            week = true
            self.title = "Week tranding"
            viewModel.pageWeak = 1
            viewModel.getData(week: true) { [weak self] in
                self?.tableView.reloadData()
            }
            
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
            viewModel.getData(week: week) {
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
        guard let moreVC = segue.destination as? MoreInfoTableViewController else {return}
        moreVC.currentDataForMoreInfo = selectedData
        moreVC.props = MoreInfoTableViewController.Props(path: selectedData?.posterPath, size: CGSize(width: 268, height: 585))
    }
}

extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       viewModel.filterContentForSearch(searchController.searchBar.text!)
        tableView.reloadData()
    }
}


