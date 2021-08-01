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
extension UIColor {
    static func mainWhite() -> UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
    }
}
