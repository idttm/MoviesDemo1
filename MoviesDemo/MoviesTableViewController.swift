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
    var arrryTitleTest = [String]()
    var arrayVoite = [Double]()
    var arrayOverview = [String]()
    var arrayImage = [String]()
   
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
//       let indexPath = IndexPath()
//        let titleArray1 = arrayTitle[indexPath.row].originalTitle
//
        return arrryTitleTest.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = arrryTitleTest[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let navigaionVC = segue.destination as? MoreInfoViewController
        let objectT = arrryTitleTest[indexPath.row]
        let objectV = arrayVoite[indexPath.row]
        let objectO = arrayOverview[indexPath.row]
        let objectI = arrayImage[indexPath.row]
        
        navigaionVC?.currentTitle = objectT
        navigaionVC?.currentVoide = objectV
        navigaionVC?.currentOverview = objectO
        navigaionVC?.partTwoImageUrl = objectI
    }
    
}
extension MoviesTableViewController: NetworkManagerDelegate {
    func updateInterface(_: NetworkMoviesManager, with usedDate: UsedData) {
        var array = [String]()
        for array1 in usedDate.originalTitle {
            array.append(array1)
        }
        var arrayV = [Double]()
        for arary2 in usedDate.voteAverage {
            arrayV.append(arary2)
        }
        var arrayO = [String]()
        for array3 in usedDate.overview {
            arrayO.append(array3)
        }
        var arrayI = [String]()
        for arra4 in usedDate.backdropPath {
            arrayI.append(arra4)
        }
        arrryTitleTest = array
        arrayVoite = arrayV
        arrayOverview = arrayO
        arrayImage = arrayI
    }
    
}
