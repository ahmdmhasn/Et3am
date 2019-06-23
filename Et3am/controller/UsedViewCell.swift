//
//  UsedViewCell.swift
//  Et3am
//
//  Created by Esraa on 6/23/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class UsedViewCell: UITableViewCell {

    @IBOutlet weak var couponBarCode: UILabel!
    @IBOutlet weak var usedDate: UILabel!
    @IBOutlet weak var priceMeal: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var usedBy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
