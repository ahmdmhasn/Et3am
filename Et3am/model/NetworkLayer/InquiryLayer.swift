//
//  InquiryLayer.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 7/6/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Inquiry {
    
    var id: Int?
    var status: Int?
    var image: String = ""
    var message: String = ""
    var user: User = UserDao.shared.user
//    "users": {
//    "userId": ""
//    },
//    "image": "",
//    "message": ""
//    }

}

class InquiryLayer {
    
    class func submit(service: InquiryServices = .submit, inquiry: Inquiry, completionHandler: @escaping (Inquiry?) -> Void) {
        
        let parameters = ["users" : ["userId" : inquiry.user.userID],
                          "image" : inquiry.image,
                          "message" : inquiry.message] as [String : Any]
        
        Alamofire.request(URL(string: service.url())!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var tempInquiry = Inquiry()
                tempInquiry.id = json["id"].int
                completionHandler(tempInquiry)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
            
        }
        
    }
    
}
