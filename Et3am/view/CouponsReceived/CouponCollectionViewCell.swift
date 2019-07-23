//
//  CouponCollectionViewCell.swift
//  Et3am
//
//  Created by Jets39 on 6/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var restaurantLoation: UIImageView!
    @IBOutlet weak var couponBarCode: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var useDate: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
        
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
    }

}
