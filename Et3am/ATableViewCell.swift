//
//  ATableViewCell.swift
//  Et3am
//
//  Created by Wael M Elmahask on 10/18/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class ATableViewCell: UITableViewCell {

    weak var delegate: ATableViewController?
    var indexPath:IndexPath!
    
    @IBOutlet weak var barCode: UILabel!
    @IBOutlet weak var couponValue: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var imageQR: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func didPostPressed(_ sender: Any) { delegate?.didPressPost(cellIndex:indexPath)}
    @IBAction func didSMSPressed(_ sender: Any) { delegate?.didPressShare(cellIndex:indexPath) }
    @IBAction func didSharePressed(_ sender: Any) { delegate?.didPressPrint(cellIndex:indexPath) }
    
}

protocol ATableViewCellDelegate: class {
    func didPressPost(cellIndex:IndexPath)
    func didPressShare(cellIndex:IndexPath)
    func didPressPrint(cellIndex:IndexPath)
}
