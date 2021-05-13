//
//  MoreInfoViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {

  
    var currentTitle = ""
    var currentVoide = 0.0
    var currentOverview = ""
    var partTwoImageUrl = ""
    var partOneImageUrl = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        titleLable.text = currentTitle
        overviewLabel.text = currentOverview
        ratingLabel.text = String(currentVoide)
        
        guard let imageUrl = URL(string: partOneImageUrl+partTwoImageUrl) else {return}
        guard let imageData = try? Data(contentsOf: imageUrl) else {return}
        
        imageView.image = UIImage(data: imageData)

    }

}


