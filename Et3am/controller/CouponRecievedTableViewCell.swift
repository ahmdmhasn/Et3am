//
//  CouponRecievedTableViewCell.swift
//  Et3am
//
//  Created by Jets39 on 5/10/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class CouponRecievedTableViewCell: UITableViewCell {

    @IBOutlet weak var couponNumberLbl: UILabel!
    
    
    @IBOutlet weak var couponStateLbl: UILabel!
    @IBOutlet weak var couponValueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
