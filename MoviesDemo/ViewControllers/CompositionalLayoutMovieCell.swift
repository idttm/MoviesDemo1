//
//  CompositionalLayoutMovieCell.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import UIKit

class CompositionalLayoutMovieCell: UICollectionViewCell, SelfconfiguringCell {
    static var reusedId: String  = "CompositionalLayoutMovieCell"
    
    let photoMovie = UIImageView()
    let contentContainer = UIView()
    let label = UILabel()
    let selectedView: UIView
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupConstrains()
//    }
    
    public override init(frame: CGRect) {
        
        self.selectedView = UIView()

        super.init(frame: frame)

        self.selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.selectedView.isHidden = true

        self.accessibilityIgnoresInvertColors = true

        self.contentView.addSubview(self.selectedView)
        self.contentView.bringSubviewToFront(self.selectedView)

        self.isAccessibilityElement = true
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setHighlighted(_ highlighted: Bool) {
        self.selectedView.isHidden = !highlighted
    }

    func setupConstrains() {

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)
        photoMovie.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(photoMovie)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(label)
        photoMovie.kf.indicatorType = .activity
        photoMovie.contentMode = .scaleAspectFill
        photoMovie.layer.cornerRadius = 10
        photoMovie.clipsToBounds = true
        photoMovie.backgroundColor = .red
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.font = UIFont(name: "Helvetica", size: 15)
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            photoMovie.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 5),
            photoMovie.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -5),
            photoMovie.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 5),
            photoMovie.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -30),

            label.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -5),
        ])
    }
}
