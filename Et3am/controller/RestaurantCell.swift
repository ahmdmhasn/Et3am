//
//  RestaurantCell.swift
//  Et3am
//
//  Created by Wael M Elmahask on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
