//
//  CouponDao.swift
//  Et3am
//
//  Created by Jets39 on 5/27/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CouponDao {
    
    public static let shared = CouponDao()
    private init() {}
    
    public func getReceivedCoupons(completionHandler:@escaping (NSMutableArray, [Restaurant], NSMutableArray,APIResponse) -> Void) {
        let couponBarcode:NSMutableArray = []
        let useDate:NSMutableArray = []
        let restaurantObject = Restaurant()
        var restaurantArray = [Restaurant]()
        var urlComponents = URLComponents(string: Et3amAPI.baseCouponUrlString+CouponURLQueries.used_coupon.rawValue)
        //0db77343-e323-4ec1-9896-6c9853d30f5d
        urlComponents?.queryItems = [URLQueryItem(name: "userId", value:UserDao.shared.userDefaults.string(forKey: "userId"))]
        print(urlComponents!)
        Alamofire.request(urlComponents!).validate(statusCode: 200..<500).responseJSON
            { response in
            switch response.result {
            case .success:
                guard let responseValue = response.result.value else {
                    return
                }
                let json = JSON(responseValue)
                let codeDataDictionary:Int =  json["code"].int ?? 0
                if(codeDataDictionary == 1)
                    {
                   guard let couponDataDictionary = json["Coupons"].array else
                   {
                    return
                   }
                      for i in 0 ..< couponDataDictionary.count
                      {
                       let restaurantsJson = couponDataDictionary[i]["restaurants"]
                       restaurantObject.restaurantName = restaurantsJson["restaurantName"].string
                       restaurantObject.latitude = restaurantsJson["latitude"].double
                       restaurantObject.longitude = restaurantsJson["longitude"].double
                       restaurantArray.append(restaurantObject)
                        let barcode = couponDataDictionary[i]["userReserveCoupon"]["coupons"]["couponBarcode"].string
                        couponBarcode[i] = barcode?.substring(to:(barcode?.index((barcode?.startIndex)!, offsetBy: 3))!) ?? 0
                       useDate[i] =  couponDataDictionary[i]["useDate"].double ?? 0
                        }
                }
                  completionHandler(useDate ,restaurantArray ,couponBarcode ,.success(codeDataDictionary))
            case .failure(let error):
                
                print(error.localizedDescription)
                completionHandler([],[],[],.failure(error))
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
                let statusDataDictionary = returnedData.value(forKey: "status") as? Int ?? 0
                
                switch statusDataDictionary {
                case 1:
                    couponDonate = "coupon is donated"
                    completionHandler(couponDonate)
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
    
    func getFreeCoupon(typeURL:String, handler:@escaping (Coupon?) -> Void)    {
        
        let couponObj:Coupon! = Coupon()
        
        Alamofire.request(typeURL).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let status  = json["status"]
                if status == 1  {
                    let barCode = json["coupon"]["coupons"]["couponBarcode"].string
                    let couopnValue = json["coupon"]["coupons"]["couponValue"].float
                    _ = json[]
                    print(barCode ?? "d")
                    couponObj.barCode = barCode
                    couponObj.couponValue = couopnValue
                    handler(couponObj)
                }
                else {
                    handler(nil)
                }
                
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}
