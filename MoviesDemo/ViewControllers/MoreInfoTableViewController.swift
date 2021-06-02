//
//  MoreInfoTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 02.06.2021.
//

import UIKit

class MoreInfoTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MoreInfoCell.nib(), forCellReuseIdentifier: MoreInfoCell.indetifire)
        tableView.register(TitleAndRatingTableViewCell.self, forCellReuseIdentifier: TitleAndRatingTableViewCell.indetifire)
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 3
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoreInfoCell.indetifire, for: indexPath) as! MoreInfoCell
            cell.imageView?.image = UIImage(systemName: "paperplane.circle")
            return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
            cell.textLabel?.text = "Title"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
            cell.textLabel?.text = "Raiting"
            return cell
        }
           let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
           cell.textLabel?.text = "description"
           return cell
           }
}
