//
//  MoreInfoMovie.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import UIKit

class MoreInfoMovie: UICollectionViewCell, SelfconfiguringCell {
    
    
    static var reusedId: String = "MoreInfoMovie"
    
    func configure(with intValue: Int) {
        label.text = String(intValue)
    }
    let contentContainer = UIView()
    let label = UILabel()
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(label)
        contentContainer.backgroundColor = .mainWhite()
        contentContainer.layer.cornerRadius = 10
        contentContainer.clipsToBounds = true
        label.font = UIFont(name: "Helvetica", size: 23)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = self.bounds
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10)
        ])
    }
}

