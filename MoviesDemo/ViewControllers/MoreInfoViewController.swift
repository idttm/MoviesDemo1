//
//  MoreInfoViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {

    private let modelMoreInfo = ImageDataFromURL()
    var currentDataForMoreInfo: DataResult?
    var currentDataForMoreInfoSearch: DataSearch?
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentDataForMoreInfoSearch == nil { titleLable.text = currentDataForMoreInfo?.title
            overviewLabel.text = currentDataForMoreInfo?.overview
            ratingLabel.text = String(currentDataForMoreInfo!.voteAverage)
            guard let imageData = modelMoreInfo.imageTitle(currentDataForMoreInfo!.backdropPath)  else { return }
            imageView.image = UIImage(data: imageData)
        }  else {
            titleLable.text = currentDataForMoreInfoSearch?.title
            overviewLabel.text = currentDataForMoreInfoSearch?.overview
            ratingLabel.text = String(currentDataForMoreInfoSearch!.voteAverage)
            guard let imageData = modelMoreInfo.imageTitle(currentDataForMoreInfoSearch!.backdropPath!) else {return}
            imageView.image = UIImage(data: imageData)
        }
    }
}


