//
//  CouponCollectionViewCell.swift
//  Et3am
//
//  Created by Jets39 on 6/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var couponBarCode: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var useDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
