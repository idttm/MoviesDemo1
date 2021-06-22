//
//  SimalarMoviewTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 15.06.2021.
//

import UIKit

class SimalarMoviewTableViewController: UITableViewController {

    
    let viewModel = MoviewTBVViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDataSimilar { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRowsSimilar
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let title = viewModel.titleForRowSimilar(at: indexPath)
        cell.textLabel?.text = title

        return cell
    }
   
 
}
