//
//  SearchTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 21.05.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {

    
    let fetchCurrentSearch = SearchManager.shared
    var array = [String]()
    var nameString = "mortal"

    override func viewDidLoad() {
        super.viewDidLoad()
        print(nameString)
        fetchCurrentSearch.delegate = self
        fetchCurrentSearch.fetchCurrentJSONSearch(nameString)
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row]

        return cell
    }
    

}
extension SearchTableViewController: NetworkSearchManagerDelegate {
    func updateInterface(_: SearchManager, with usedDate: SearchUserData) {
        var array1 = [String]()
        for array2 in usedDate.name {
            array1.append(array2)
        }
        array = array1
//        print(array)
    }
    
}

