//
//  ModelMoreInfo.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 15.05.2021.
//

import UIKit
import Kingfisher

class ImageDataFromURL {
    
    private var partOneImageUrl = "https://image.tmdb.org/t/p/w500"

    func imageTitle (_ partTwoImageUrl: String) -> Data? {
        guard let imageUrl = URL(string: partOneImageUrl+partTwoImageUrl) else {return nil }
        guard let imageData = try? Data(contentsOf: imageUrl) else {return nil }
        return imageData
    }
    func downloadImage(_ partTwoImageUrl: String, indexPath: IndexPath) -> UIImageView? {
        guard let url = URL(string: partOneImageUrl+partTwoImageUrl) else { return nil }
        let imageView = UIImageView()
        KF.url(url)
            .fade(duration: 1)
            .loadDiskFileSynchronously()
            .onProgress { (received, total) in print("\(indexPath.row + 1): \(received)/\(total)") }
            .onSuccess { print($0) }
            .onFailure {  err in print("Error: \(err)") }
            .set(to: imageView)
        return imageView
    }
    
   
}
