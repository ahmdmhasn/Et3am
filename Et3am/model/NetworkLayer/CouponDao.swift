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
    
    public func getReceivedCoupons(currentPage: Int, completionHandler:@escaping ([Double], [Restaurant], [String], APIResponse) -> Void) {
        var couponBarcode = [String]()
        var useDate = [Double]()
        let restaurantObject = Restaurant()
        var restaurantArray = [Restaurant]()
        var urlComponents = URLComponents(string: Et3amAPI.baseCouponUrlString+CouponURLQueries.used_coupon.rawValue)
        
        let userQueryItem = URLQueryItem(name: "userId", value:UserDao.shared.userDefaults.string(forKey: "userId"))
        let pageQueryItem = URLQueryItem(name: "page", value: "\(currentPage)")
        urlComponents?.queryItems = [userQueryItem, pageQueryItem]
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
                    
                    if(codeDataDictionary == 1) {
                        
                        guard let couponDataDictionary = json["Coupons"].array else {
                            return
                        }
                        
                        print(couponDataDictionary)
                        
                        for i in 0 ..< couponDataDictionary.count {
                            let restaurantsJson = couponDataDictionary[i]["restaurants"]
                            restaurantObject.restaurantName = restaurantsJson["restaurantName"].string
                            restaurantObject.latitude = restaurantsJson["latitude"].double
                            restaurantObject.longitude = restaurantsJson["longitude"].double
                            restaurantArray.append(restaurantObject)
                            
                            let barcode = couponDataDictionary[i]["userReserveCoupon"]["coupons"]["couponBarcode"].string
                            
                            couponBarcode.append(barcode?.substring(from:(barcode?.index((barcode?.endIndex)!, offsetBy: -3))!) ?? "")

                            
                            useDate.append((couponDataDictionary[i]["useDate"].double ?? 0) / 1000)
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
        /*couponObj.barCode = "LNDU37RYDHFS"
        couponObj.couponValue = 200
        couponObj.creationDate = Coupon.getCreationDate(milisecond: 135132151613)
        handler(couponObj)*/
        
        Alamofire.request(typeURL).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let status  = json["status"]
                if status == 1  {
                    let barCode = json["coupon"]["coupons"]["couponBarcode"].string
                    let couopnValue = json["coupon"]["coupons"]["couponValue"].float
                    let creationDate = json["coupon"]["coupons"]["creationDate"].double
                    couponObj.barCode = barCode
                    couponObj.couponValue = couopnValue
                    if let creationDate = creationDate {
                        couponObj.creationDate = Coupon.getCreationDate(milisecond: creationDate)
                    }
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
    
    func getInBalanceCoupon(userId:String, page:Int = 1, inBalanceHandler:@escaping ([Coupon],_ totalResults:Int) -> Void){
        
        var listCoupon = [Coupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_inBalance_coupon", method: .get, parameters:["user_id": userId,"page":page]).validate().responseJSON{ (response) in
            
            print(response.result)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let code  = json["code"]
                let totalResults  = json["total_results"].int
                print("totalResults .. \(totalResults)")
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
                    inBalanceHandler(listCoupon,totalResults!)
                }
                else {
                    inBalanceHandler([],totalResults!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllUsedCoupon(userId:String, page:Int = 1, couponUsedHandler:@escaping ([UsedCoupon],_ totalResults:Int) -> Void){
        
        var listUsedCoupon = [UsedCoupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_all_used_coupon", method: .get, parameters:["user_id": userId,"page":page]).validate().responseJSON{ (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let totalResults  = json["total_results"].int
                print("totalResults .. \(totalResults)")
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
                        usedCoupon.barCode = item["barCode"] as? String
                        usedCoupon.userName = item["userName"] as? String
                        usedCoupon.restaurantName = item["restaurantName"] as? String
                        usedCoupon.restaurantAddress = item["restaurantAddress"] as? String
                        usedCoupon.price = item["price"] as? Float
                        usedCoupon.useDate = self.getCreationDate(milisecond: (item["useDate"] as? Double)!)
                        listUsedCoupon.append(usedCoupon)
                    }
                    couponUsedHandler(listUsedCoupon,totalResults!)
                }
                else {
                    couponUsedHandler([],totalResults!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllReservedCoupon(userId:String, page:Int = 1, couponReservedHandler:@escaping ([ReservedCoupon],_ totalResults:Int) -> Void){
        
        var listResCoupon = [ReservedCoupon]()
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        Alamofire.request("https://et3am.herokuapp.com/coupon/get_all_reserved_coupon", method: .get, parameters:["user_id": userId,"page":page]).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let totalResults  = json["total_results"].int
                print("totalResults .. \(totalResults)")
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
                         "couponBarcode": 229F8D1F8E7A,
                         "couponQrCode": "229F8D1F8E7A",
                         "couponValue": 50,
                         "reservationDate": 1561296942000
                         }
                         */
                        rCoupon.userId = item["userId"] as? String
                        rCoupon.couponId = item["couponId"] as? String
                        rCoupon.couponBarcode = item["couponBarcode"] as? String
                        rCoupon.couponQrCode = item["couponQrCode"] as? String
                        rCoupon.couponValue = item["couponValue"] as? Float
                        rCoupon.reservationDate = self.getCreationDate(milisecond: (item["reservationDate"] as? Double)!)
                        listResCoupon.append(rCoupon)
                    }
                    couponReservedHandler(listResCoupon,totalResults!)
                }
                else {
                    couponReservedHandler([],totalResults!)
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
    
    
    //cancel_reservation
    func cancelReservation(couponId:String, cancelHandler:@escaping (Bool) -> Void) {
        Alamofire.request("https://et3am.herokuapp.com/coupon/cancel_reservation", method: .get, parameters: ["coupon_id":couponId]).validate().responseJSON{
            (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status  = json["status"]
                if status == 1 {
                    print("true")
                    cancelHandler(true)
                }else{
                    print("false")
                    cancelHandler(false)
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
