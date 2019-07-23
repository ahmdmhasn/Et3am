//
//  CouponView.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 7/23/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import ChameleonFramework

class CouponView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coupon: Coupon! {
        didSet {
            codeLabel.text = coupon.barCode
            qrCodeImageView.image = Helper.generateQRCOde(barCode: coupon.barCode)
            valueLabel.text = "\(coupon.couponValue!)"
            dateLabel.text = coupon.creationDate
        }
    }
    
    var couponValue: Float! {
        didSet {
            
        }
    }
    
    var creationDate: String! {
        didSet {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CouponView", owner: self, options: nil)
        
        self.addSubview(containerView)
        
        containerView.frame = self.bounds
        
        containerView.backgroundColor = UIColor.init(gradientStyle: .radial,
                                            withFrame: self.frame,
                                            andColors: [UIColor.primaryEt3am().lighten(byPercentage: 0.20), UIColor.primaryEt3am()])

        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    
}
