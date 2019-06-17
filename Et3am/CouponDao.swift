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
    public func getReceivedCoupons(completionHandler:@escaping (NSArray,NSArray,NSArray,Int)->Void)
        
    {
        var urlComponents = URLComponents(string: Et3amAPI.baseCouponUrlString+CouponURLQueries.used_coupon.rawValue)
        urlComponents?.queryItems = [URLQueryItem(name: "userId", value:
           "0db77343-e323-4ec1-9896-6c9853d30f5d")]
        print(urlComponents!)
        Alamofire.request(urlComponents!).validate().responseJSON{ response in
            switch response.result {
            case .success:
                let sucessDataValue = response.result.value
                let returnedData = sucessDataValue as! NSDictionary
               
                let codeDataDictionary:Int =  returnedData.value(forKey: "code")! as! Int
                
                switch codeDataDictionary
                {
                case 1:
                  
                 
                    let couponDataDictionary:NSArray =  returnedData.value(forKey: "Coupons")! as! NSArray
                    let restaurants =  couponDataDictionary.value(forKey: "restaurants") as! NSArray
                  
                    let userReserveCoupon =  couponDataDictionary.value(forKey: "userReserveCoupon") as! NSArray
                    let coupons =  userReserveCoupon.value(forKey: "coupons") as! NSArray
                    
                    
                   
                  let useDate =  couponDataDictionary.value(forKey: "useDate")
                        let restaurantName =  restaurants.value(forKey: "restaurantName")
            
                        let couponBarcode =  coupons.value(forKey: "couponBarcode")
                    
                    completionHandler(useDate as! NSArray,restaurantName as! NSArray,couponBarcode as! NSArray,codeDataDictionary)
                    
                    
                case 0:
                  
                    completionHandler([],[],[],codeDataDictionary)
                default:
                    break
                }
                
            case .failure(let error):
          
                print(error.localizedDescription)
               
            }
            
        }

        }
        
    
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
