//
//  MoreInfoCell.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 02.06.2021.
//

import UIKit

class MoreInfoCell: UITableViewCell {

    @IBOutlet var myImageView: UIImageView!
    
    static let indetifire = "MoreInfoCell"
    static func nib() -> UINib {
        return UINib(nibName: "MoreInfoCell", bundle: nil)
    }
    public func cofigure(with imageName: String) {
        myImageView.image = UIImage(named: imageName)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
