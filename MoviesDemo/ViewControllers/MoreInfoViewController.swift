//
//  MoreInfoViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {

  
    let modelMoreInfo = ModelMoreInfo.shared
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = modelMoreInfo.currentTitle
        overviewLabel.text = modelMoreInfo.currentOverview
        ratingLabel.text = modelMoreInfo.currentVoide
        guard let imageData = modelMoreInfo.imageTitle() else {return}
        imageView.image = UIImage(data: imageData)

    }

}


