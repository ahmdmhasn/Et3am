//
//  MealCell.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/9/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

    @IBOutlet weak var mealPhotoImage: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
