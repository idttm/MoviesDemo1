//
//  MoreInfoTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 02.06.2021.
//

import UIKit
import Kingfisher



class MoreInfoTableViewController: UITableViewController {
    
    var currentDataForMoreInfo: DataResult?
    
    struct Props {
        var path: String?
        var size: CGSize?
    }
    
  var props: Props?
    
//    init(props: Props) {
//        self.props = props
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreInfoCell.indetifire, for: indexPath) as? MoreInfoCell
            else { return UITableViewCell() }
           
            cell.render(props: props!)
            
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 30)
            cell.textLabel?.text = currentDataForMoreInfo?.title
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 17)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text =  "Vote Average \(String(currentDataForMoreInfo!.voteAverage))"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndRatingTableViewCell.indetifire, for: indexPath) as! TitleAndRatingTableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 17)
        cell.textLabel?.textAlignment = .justified
        cell.textLabel?.text = currentDataForMoreInfo?.overview
        
        return cell
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newSize = CGSize(width: 268, height: 800)
        self.props?.size = newSize
        tableView.reloadData()
    }
    
}
