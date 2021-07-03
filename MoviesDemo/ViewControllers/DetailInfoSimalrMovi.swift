//
//  DetailInfoSimalrMovi.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 30.06.2021.
//

import UIKit

class DetailInfoSimalrMovi: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var label: UILabel!
    var data: ResultSimilar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setImage(secondPartURL: data!.posterPath)
        overview.text = data?.overview
        label.text = data?.title
    }
    
}
