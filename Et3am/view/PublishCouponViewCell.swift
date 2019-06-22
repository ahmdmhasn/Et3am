//
//  PublishCouponViewCell.swift
//  Et3am
//
//  Created by Wael M Elmahask on 10/12/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

@IBDesignable
class PublishCouponViewCell: UICollectionViewCell {
    
    weak var delegate: PublishCouponViewCellDelegate?
    
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var barCodeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func selectPost(_ sender: UIButton) { delegate?.didPressPost() }
    @IBAction func didSelectShare(_ sender: UIButton) { delegate?.didPressShare() }
    @IBAction func didSelectPrint(_ sender: UIButton) { delegate?.didPressPrint() }
    
    func didSelect(coupon : Coupon){
        barCodeLabel.text = coupon.barCode
        valueLabel.text = coupon.couponCode
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

protocol PublishCouponViewCellDelegate: class {
    func didPressPost()
    func didPressShare()
    func didPressPrint()
}
