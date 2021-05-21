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
    let fetchCurrentSearch = SearchManager.shared
    var array = [String]()
    var nameString = "mortal"

    override func viewDidLoad() {
        super.viewDidLoad()
        print(nameString)
        fetchCurrentSearch.delegate = self
        fetchCurrentSearch.fetchCurrentJSONSearch(nameString)
//        modelTableView.modelTableView()
//        modelTableView.networkManager.fetchCurrentJson()
//
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return array.count
//        return modelTableView.arrryTitleTest.count
      
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cell.textLabel?.text = modelTableView.arrryTitleTest[indexPath.row]
        
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        modelMoreInfo.transferDate(indexPath)
  
    }
    
}
extension MoviesTableViewController: NetworkSearchManagerDelegate {
    func updateInterface(_: SearchManager, with usedDate: SearchUserData) {
        var array1 = [String]()
        for array2 in usedDate.name {
            array1.append(array2)
        }
        array = array1
//        print(array)
    }
    
}
