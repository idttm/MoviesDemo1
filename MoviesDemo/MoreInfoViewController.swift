//
//  MoreInfoViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {

  
    var currentMovie = [UsedData]()
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title1 = ""
        
        for title in currentMovie {
            title1 = title.originalTitle
        }
        var overview1 = ""
        for  overview in currentMovie {
            overview1 = overview.overview
        }
        var rating1 = ""
        for rating in currentMovie {
            rating1 = rating.voteAverageString
        }
    
        titleLable.text = title1
        overviewLabel.text = overview1
        ratingLabel.text = "Rating: \(rating1)"
        
        // Do any additional setup after loading the view.
    }

}


