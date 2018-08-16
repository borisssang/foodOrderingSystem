//
//  RestaurantTableViewCell.swift
//  SampleTutorial
//
//  Created by Boris Angelov on 1/20/17.
//  Copyright © 2017 Boris Angelov. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantDescribtion: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var restaurantAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        //          backgroundCardView.bringSubview(toFront: restaurantLabel)
        //          backgroundCardView.sendSubview(toBack: restaurantImage)
        //          backgroundCardView.bringSubview(toFront: restaurantAddress)
        //          backgroundCardView.bringSubview(toFront: restaurantDescribtion)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
