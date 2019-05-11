//
//  AllCouponTableViewCell.swift
//  Et3am
//
//  Created by Jets39 on 5/10/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class AllCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var avaliableStatusLbl: UILabel!
    @IBOutlet weak var couponValueLbl: UILabel!
    @IBOutlet weak var couponCodeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
