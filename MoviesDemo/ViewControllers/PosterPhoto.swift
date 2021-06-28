//
//  PosterPhoto.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import UIKit
import Kingfisher

protocol SelfconfiguringCell {
    static var reusedId: String {get}
}

class PosterPhoto: UICollectionViewCell, SelfconfiguringCell {
    static var reusedId: String = "PosterPhoto"
    
    func configure(with intValue: Int) {
        print("123")
    }
    
    let posterPhoto = UIImageView()
    let contentContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstrains() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)
        posterPhoto.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(posterPhoto)
        posterPhoto.frame = self.bounds
        posterPhoto.kf.indicatorType = .activity
        posterPhoto.contentMode = .scaleAspectFill
        contentContainer.layer.cornerRadius = 10
        contentContainer.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterPhoto.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            posterPhoto.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            posterPhoto.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            posterPhoto.topAnchor.constraint(equalTo: contentContainer.topAnchor)
        ])
    }
}
