//
//  MoreInfoTableViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 02.06.2021.
//

import UIKit
import Kingfisher



class MoreInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var currentDataForMoreInfo: DataResult?
    
    struct Props {
        var path: String?
        var size: CGSize?
    }
    
    var headerView: UIView!
    private var newHiderLayer: CAShapeLayer!
    private var newHIderLayerImage = CAShapeLayer()
    private let headerHight: CGFloat = 540
    
    private let headerCut: CGFloat = 2
    
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
        updateView()
        
    }
    func updateView() {
       
        tableView.backgroundColor = .gray
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(headerView)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 1),
//            headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 1),
//            headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
//            headerView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1),
//            headerView.widthAnchor.constraint(equalToConstant: 245)
//        
//        ])
        headerView.layer.cornerRadius = 10
            headerView.backgroundColor = .gray
        imageView.layer.cornerRadius = 20
        imageView.kf.indicatorType = .activity
        imageView.setImage(secondPartURL: currentDataForMoreInfo!.posterPath)
        
        
        
    
        newHiderLayer = CAShapeLayer()
        newHiderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHiderLayer
        
       
        
        let newHight = headerHight - headerCut / 2
        tableView.contentInset = UIEdgeInsets(top: newHight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHight)
        
        self.setupNewView()
    }
    func setupNewView() {
        let newHight = headerHight - headerCut / 2
        var getHeadrFrame = CGRect(x: 0, y: -newHight, width: tableView.bounds.width, height: headerHight)
        if tableView.contentOffset.y < newHight {
            getHeadrFrame.origin.y = tableView.contentOffset.y
            getHeadrFrame.size.height = -tableView.contentOffset.y + headerCut / 2
            
        }
        
        
        headerView.frame = getHeadrFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeadrFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeadrFrame.width, y: getHeadrFrame.height - 1))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeadrFrame.height - 1))
        newHiderLayer.path = cutDirection.cgPath
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
//        tableView.reloadData()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setupNewView()
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
            return 3
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
}
