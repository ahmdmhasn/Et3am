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
                    
                    print(json)
                    let codeDataDictionary:Int =  json["code"].int ?? 0
                    if(codeDataDictionary == 1)
                    {
                        guard let couponDataDictionary = json["Coupons"].array else {
                            return
                        }
                        
                        for i in 0 ..< couponDataDictionary.count {
                            let restaurantsJson = couponDataDictionary[i]["restaurants"]
                            restaurantObject.restaurantName = restaurantsJson["restaurantName"].string
                            restaurantObject.latitude = restaurantsJson["latitude"].double
                            restaurantObject.longitude = restaurantsJson["longitude"].double
                            restaurantArray.append(restaurantObject)
                            let barcode = couponDataDictionary[i]["userReserveCoupon"]["coupons"]["couponBarcode"].string
                            couponBarcode[i] = barcode?.substring(to:(barcode?.index((barcode?.startIndex)!, offsetBy: 3))!) ?? 0
                            useDate[i] =  (couponDataDictionary[i]["useDate"].double ?? 0) / 1000
                        }
                    }
                    completionHandler(useDate ,restaurantArray ,couponBarcode ,.success(codeDataDictionary))
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    completionHandler([],[],[],.failure(error))
                }
        }
    }
    
    
    public func addCoupon(value_50:String, value_100:String, value_200:String, completionHandler:@escaping (Int)->Void) {
        
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
                
                completionHandler(statusDataDictionary)
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(0)
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
    
    func getInBalanceCoupon(userId:String, inBalanceHandler:@escaping ([Coupon]) -> Void){
        
        var listCoupon = [Coupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_inBalance_coupon", method: .get, parameters:["user_id": userId]).validate().responseJSON{ (response) in
            
            print(userId)
            
            print(response.result.value)

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let code  = json["code"]
                if code == 1 {
                    guard let coupons = json["Coupons"].arrayObject else  {return}
                    arrRes = coupons as! [[String:AnyObject]]
                    for item in arrRes {
                        let coupon:Coupon = Coupon()
                        coupon.couponID = item["couponId"] as? String
                        coupon.barCode = item["couponBarcode"] as? String
                        coupon.couponValue = item["couponValue"] as? Float
                        coupon.creationDate = self.getCreationDate(milisecond: (item["creationDate"] as? Double)!)
                        listCoupon.append(coupon)
                    }
                    inBalanceHandler(listCoupon)
                }
                else {
                    inBalanceHandler([])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllUsedCoupon(userId:String, couponUsedHandler:@escaping ([UsedCoupon]) -> Void){
        
        var listUsedCoupon = [UsedCoupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_all_used_coupon", method: .get, parameters:["user_id": userId]).validate().responseJSON{ (response) in
            
            print(response.result.value)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                let code  = json["code"]
                if code == 1 {
                    guard let coupons = json["Coupons"].arrayObject else  {return}
                    arrRes = coupons as! [[String:AnyObject]]
                    for item in arrRes {
                        let usedCoupon:UsedCoupon = UsedCoupon()
                        /*
                         {
                         "couponId": "8a6ee49a-ad9f-4c16-9d22-3b25214c7d62",
                         "userId": "b492b816-28f6-4182-aacf-37c7a3787f4f",
                         "userName": "nesma",
                         "restaurantName": "Zanobia",
                         "restaurantAddress": "Ismailia, Egypt",
                         "useDate": 1561231501000,
                         "price": 30
                         }
                         */
                        usedCoupon.couponId = item["couponId"] as? String
                        usedCoupon.userId = item["userId"] as? String
                        usedCoupon.userName = item["userName"] as? String
                        usedCoupon.restaurantName = item["restaurantName"] as? String
                        usedCoupon.restaurantAddress = item["restaurantAddress"] as? String
                        usedCoupon.price = item["price"] as? Float
                        usedCoupon.useDate = self.getCreationDate(milisecond: (item["useDate"] as? Double)!)
                        print(usedCoupon.couponId ?? "66666666")
                        listUsedCoupon.append(usedCoupon)
                        print("listUsedCoupon \(listUsedCoupon.count)")
                    }
                    couponUsedHandler(listUsedCoupon)
                }
                else {
                    couponUsedHandler([])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllReservedCoupon(userId:String, couponReservedHandler:@escaping ([ReservedCoupon]) -> Void){
        
        var listResCoupon = [ReservedCoupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_all_reserved_coupon", method: .get, parameters:["user_id": userId]).validate().responseJSON{ (response) in
            print(response.result.value)

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                let code  = json["code"]
                if code == 1 {
                    guard let coupons = json["Coupons"].arrayObject else  {return}
                    arrRes = coupons as! [[String:AnyObject]]
                    for item in arrRes {
                        let rCoupon:ReservedCoupon = ReservedCoupon()
                        /*
                         {
                         "userId": "3ae825e4-a646-4c12-b4b7-66eb2ff6d67c",
                         "couponId": "5c1fb624-b74d-4141-902f-b687d29ea325",
                         "couponBarcode": null,
                         "couponQrCode": "229F8D1F8E7A",
                         "couponValue": 50,
                         "reservationDate": 1561296942000
                         }
                         */
                        rCoupon.userId = item["userId"] as? String
                        rCoupon.couponId = item["couponId"] as? String
                        rCoupon.couponBarcode = item["couponBarcode"] as? String
//                        rCoupon.couponQrCode = item["couponQrCode"] as? String
                        rCoupon.couponValue = item["couponValue"] as? Float
                        rCoupon.reservationDate = self.getCreationDate(milisecond: (item["reservationDate"] as? Double)!)
                        listResCoupon.append(rCoupon)
                    }
                    couponReservedHandler(listResCoupon)
                }
                else {
                    couponReservedHandler([])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
    func publishCoupon(couponId:String, completedHandler:@escaping (Bool) -> Void) {
        Alamofire.request("https://et3am.herokuapp.com/coupon/publish_coupon", method: .get, parameters: ["coupon_id":couponId]).validate().responseJSON{
            (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status  = json["status"]
                if status == 1 {
                    print("true")
                    completedHandler(true)
                }else{
                    print("false")
                    completedHandler(false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCreationDate(milisecond: Double) -> String {
        let dateVar = Date(timeIntervalSince1970: (milisecond / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a dd/MM/yyyy"
        let date = dateFormatter.string(from: dateVar)
        print(date)
        return date
    }
    
}
