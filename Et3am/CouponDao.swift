//
//  CouponDao.swift
//  Et3am
//
//  Created by Jets39 on 5/27/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire

class CouponDao
{
    public func addCoupon(value_50:String,value_100:String,value_200:String,completionHandler:@escaping (String)->Void) {/*UserDefaults.standard.string(forKey: "user_id"))*/
        var couponDonate : String = ""
        var urlComponents = URLComponents(string: Et3amAPI.baseCouponUrlString+CouponURLQueries.add.rawValue)
        urlComponents?.queryItems = [URLQueryItem(name: CouponURLQueries.user_idQuery.rawValue , value:
            UserHelper.getUser_Id()),
                                     URLQueryItem(name: CouponURLQueries.value_50Query.rawValue , value: value_50),
                                     URLQueryItem(name: CouponURLQueries.value_100Query.rawValue , value: value_100),
                                     URLQueryItem(name: CouponURLQueries.value_200Query.rawValue , value: value_200)]
        Alamofire.request((urlComponents?.url!)!).validate(statusCode: 200..<600).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let sucessDataValue = response.result.value
                let returnedData = sucessDataValue as! NSDictionary
                print (returnedData)
               let statusDataDictionary:Int =  returnedData.value(forKey: "status")! as! Int
                
                switch statusDataDictionary
               {
                case 1:
                    couponDonate = "coupon is donated"
                    completionHandler(couponDonate)
//                    let userDataDictionary:NSDictionary =  returnedData.value(forKey: "user")! as! NSDictionary
//                    self.user.userID=userDataDictionary.value(forKey: "userId") as! String?
//                    self.user.userName=userDataDictionary.value(forKey: "userName") as! String?
//                    self.user.email=userDataDictionary.value(forKey: "userEmail") as! String?
//                    self.user.password = password
//                    self.user.verified=false
//                    
//                    if((UserDefaults.standard.string(forKey: "userEmail") == nil)){
//                        self.addUserObjectIntoUserDefault(userObject: self.user)
//                        
//                 }
//                    
              case 0:
                    couponDonate = "coupon is not donated"
                    completionHandler(couponDonate)
                    
                default:
                    break
                }
                
            case .failure(let error):
                couponDonate = "there is error in connection"
                print(error.localizedDescription)
                completionHandler(couponDonate)
            }
            
        }

    }
    
}
