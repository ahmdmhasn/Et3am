//
//  Coupon.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/6/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation

class Coupon {
    var couponID:String?
    var couponCode:String?
    var barCode:String?
    var creationDate:String?
    var reservationDate:String?
    var couponValue:Float?
    var inBalance:Int?
    
    class func getCreationDate(milisecond: Double) -> String {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        let date = dateFormatter.string(from: dateVar)
         print(date)
        return date
    }
}
