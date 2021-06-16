//
//  TestViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 08.06.2021.
//

import UIKit
import Combine
import Kingfisher

class TestViewController: UITableViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    private var resultData = [DataResult]()
    var headerView: UIView!
    private var newHiderLayer: CAShapeLayer!
    var secondPart = [String]()
    private let headerHight: CGFloat = 600
    private let headerCut: CGFloat = 1
    
    private var store = Set<AnyCancellable>()
    let publisher = MoviesManager.popularMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        let data = publisher.sink {  completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        } receiveValue: { result in
            self.resultData = result.results
            
            for i in self.resultData {
                self.secondPart.append(i.posterPath)
            }
            self.imageView.kf.indicatorType = .activity
            self.imageView.setImage(secondPartURL: self.secondPart[2])
        }.store(in: &store)
        
    }
    func updateView() {
        tableView.backgroundColor = .gray
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(headerView)
        headerView.backgroundColor = .gray
        
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

    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setupNewView()
//        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return secondPart.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = resultData[indexPath.row].title
        
        return cell
    }
}
    
