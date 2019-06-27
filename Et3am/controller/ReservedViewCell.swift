//
//  ReservedViewCell.swift
//  Et3am
//
//  Created by Esraa on 6/23/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class ReservedViewCell: UITableViewCell {

    weak var delegate: ATableViewController?
    var indexPath:IndexPath!
    
    @IBOutlet weak var couponBarCode: UILabel!
    @IBOutlet weak var reservationDate: UILabel!
    @IBOutlet weak var couponValue: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    @IBAction func didCancelSelected(_ sender: UIButton) {delegate?.didPressCancel(cellIndex:indexPath)}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol ReservedCellDelegate: class {
    func didPressCancel(cellIndex:IndexPath)
}
