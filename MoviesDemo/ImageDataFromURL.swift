//
//  ModelMoreInfo.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 15.05.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(secondPartURL: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + secondPartURL) else { return }
        kf.setImage(with: url)
        
    }
}
