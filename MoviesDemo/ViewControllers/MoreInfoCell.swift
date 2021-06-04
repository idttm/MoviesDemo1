//
//  MoreInfoCell.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 02.06.2021.
//

import UIKit
import Kingfisher

class MoreInfoCell: UITableViewCell {

   
    @IBOutlet private var myImageView: UIImageView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    
    static let indetifire = "MoreInfoCell"
    static func nib() -> UINib {
        return UINib(nibName: "MoreInfoCell", bundle: nil)
    }
    
    public func cofigure(with imageName: String) {
        myImageView.image = UIImage(named: imageName)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    private func setupUI() {
        myImageView.kf.indicatorType = .activity
    }
    
    func render(props: MoreInfoTableViewController.Props) {
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        print("\(myImageView.setImage(secondPartURL: props.path!))")
        print("\(props.size!.height))")
        print("\(props.size!.width))")
        print("\(props.path)")
        myImageView.setImage(secondPartURL: props.path!)
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            myImageView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: 0),
            myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
//            myImageView.heightAnchor.constraint(equalToConstant: 800),
//            myImageView.widthAnchor.constraint(equalToConstant: 268)
            myImageView.heightAnchor.constraint(equalToConstant: props.size!.height),
            myImageView.widthAnchor.constraint(equalToConstant: props.size!.width)
        ])
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
