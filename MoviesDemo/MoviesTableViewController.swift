//
//  MoviesTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    let networkManager = NetworkMoviesManager()
    var arrayTitle = [UsedData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        networkManager.fetchCurrentJson()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayTitle.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var title1 = ""
        
        for title in arrayTitle {
            title1 = title.originalTitle
        }
        
        cell.textLabel?.text = title1
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let navigaionVC = segue.destination as? MoreInfoViewController
        let object = arrayTitle[indexPath.row]
//        let object = fetchResultController.object(at: indexPath)
        navigaionVC?.currentMovie.append(object)
        print(object)
    }
    
}
extension MoviesTableViewController: NetworkManagerDelegate {
    func updateInterface(_: NetworkMoviesManager, with usedDate: UsedData) {
        
        arrayTitle.append(usedDate)
        
    }
    
}
