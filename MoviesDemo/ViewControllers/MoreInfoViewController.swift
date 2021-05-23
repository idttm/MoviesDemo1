//
//  MoreInfoViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {

  
    let modelMoreInfo = ModelMoreInfo.shared
    var currentDataForMoreInfo: DataResult?
   
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLable.text = currentDataForMoreInfo?.title
        overviewLabel.text = currentDataForMoreInfo?.overview
        ratingLabel.text = String(currentDataForMoreInfo!.voteAverage)
        guard let imageData = modelMoreInfo.imageTitle(currentDataForMoreInfo!.backdropPath)  else { return }
        imageView.image = UIImage(data: imageData)

    }

}


