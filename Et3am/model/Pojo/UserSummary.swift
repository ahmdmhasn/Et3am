//
//  UserSummary.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/23/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation

struct UserSummary {
    
    var donatedCoupons: Int?
    var usedCoupons: Int?
    var reservedCouponExpNumber: Double?
    var reservedCouponExpDate: Date? {
        if let resDate = reservedCouponExpNumber {
            return Date(timeIntervalSince1970: resDate/1000)
        } else {
            return nil
        }
    }
    
}
