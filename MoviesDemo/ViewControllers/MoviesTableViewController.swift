//
//  MoviesTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    let modelTableView = ModelTableView.shared
    let modelMoreInfo = ModelMoreInfo.shared
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelTableView.modelTableView()
        modelTableView.networkManager.fetchCurrentJson()
//
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return modelTableView.arrryTitleTest.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = modelTableView.arrryTitleTest[indexPath.row]
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        modelMoreInfo.transferDate(indexPath)
  
    }
    
}
