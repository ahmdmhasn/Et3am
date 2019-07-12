//
//  RestaurantDao.swift
//  Et3am
//
//  Created by jets on 9/17/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RestaurantDao
{
    public static let sharedRestaurantObject = RestaurantDao()
    private init() {}
    
    // Resquest With Parameter using Alamofire
    func fetchAllRestaurants(latitude:Double ,longitude:Double ,page:Int,completionHandler: @escaping ([Restaurant], _ pages:Int) -> Void) {
        var restaurantsList = [Restaurant]()
        Alamofire.request("https://et3am.herokuapp.com/restaurant/list", method: .get, parameters: ["latitude": latitude,"longitude":longitude,"page":page])
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote restaurants: \(response.result.error)")
                    return
                }
                guard let values = response.result.value as? Dictionary<String, Any> else{
                    print("Malformed data received from service")
                    return
                }
                guard let fetchedValues = values["results"] as? [Dictionary<String, Any>] else{
                    print("Results Faild")
                    return
                }
                print(values)
                guard let totalPages = values["total_results"] as? Int else{
                    print("Total Pages Faild")
                    return
                }

                for value in fetchedValues{
                    let restaurant:Restaurant! = Restaurant()
                    restaurant.restaurantID = value["restaurantID"] as? Int
                    restaurant.restaurantName = value["restaurantName"] as? String
                    restaurant.city = value["city"] as? String
                    restaurant.country = value["country"] as? String
                    restaurant.image = value["restaurantImage"] as? String
                    restaurant.latitude = value["latitude"] as? Double
                    restaurant.longitude = value["longitude"] as? Double
                    restaurant.distance = value["distance"] as? Double
                    restaurant.travelTime = value["travelTime"] as? Double
                    restaurantsList.append(restaurant)
                }
                completionHandler(restaurantsList,totalPages)
        }
    }
    
    
    //Search in Database by Restaurant Name or by City Name
    func searchAboutRestaurants(latitude:Double ,longitude:Double ,query:String ,page:Int,completionHandler: @escaping ([Restaurant], _ pages:Int) -> Void) {
        var restaurantsList = [Restaurant]()
        Alamofire.request("https://et3am.herokuapp.com/restaurant/searchList", method: .get, parameters: ["latitude": latitude,"longitude":longitude,"query":query,"page":page])
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote restaurants: \(response.result.error)")
                    return
                }
                guard let values = response.result.value as? Dictionary<String, Any> else{
                    print("Malformed data received from service")
                    return
                }
                guard let fetchedValues = values["results"] as? [Dictionary<String, Any>] else{
                    print("Results Faild")
                    return
                }
                print(values)
                guard let totalPages = values["total_results"] as? Int else{
                    print("Total Pages Faild")
                    return
                }
                
                for value in fetchedValues{
                    let restaurant:Restaurant! = Restaurant()
                    restaurant.restaurantID = value["restaurantID"] as? Int
                    restaurant.restaurantName = value["restaurantName"] as? String
                    restaurant.city = value["city"] as? String
                    restaurant.country = value["country"] as? String
                    restaurant.image = value["restaurantImage"] as? String
                    restaurant.latitude = value["latitude"] as? Double
                    restaurant.longitude = value["longitude"] as? Double
                    restaurant.distance = value["distance"] as? Double
                    restaurant.travelTime = value["travelTime"] as? Double
                    restaurantsList.append(restaurant)
                }
                completionHandler(restaurantsList,totalPages)
        }
    }
    
    
    func fetchJsonForRestaurant(typeURL:String, handler:@escaping (Restaurant) -> Void)   {
        let restuarantObj:Restaurant! = Restaurant()
        Alamofire.request(typeURL).responseJSON { (response) in
            if let responseValue = response.result.value as! [String: Any]? {
                restuarantObj.restaurantName = responseValue["restaurantName"] as! String?
                restuarantObj.city = responseValue["city"] as! String?
                restuarantObj.country = responseValue["country"] as! String?
                restuarantObj.image = "restaurant"
                handler(restuarantObj)
            }
        }
    }
    
    func fetchJsonForMeals (typeURL:String, handler:@escaping(Array<Meal>?) -> Void){
        var mealsArray:Array<Meal> = []
        Alamofire.request(typeURL).responseJSON { (response) in
            guard let responseValue = response.result.value as? Dictionary<String, Any> else {
                handler(nil)
                return
            }
            guard let fetchedValues = responseValue["results"] as? [Dictionary<String, Any>] else{
                print("faild")
                return
            }
            for item in fetchedValues{
                let meal = Meal()
                meal.mealName = item["mealName"] as? String
                meal.mealID = item["mealId"] as? String
                meal.mealImage=item["mealImage"] as? String
                meal.mealValue = item["mealValue"] as? Float
                mealsArray.append(meal)
            }
            handler(mealsArray)
        }
    
    
    //Search in Database by Restaurant Name or by City Name
    func searchAboutRestaurants(latitude:Double ,longitude:Double ,query:String ,page:Int,completionHandler: @escaping ([Restaurant], _ pages:Int) -> Void) {
        var restaurantsList = [Restaurant]()
        Alamofire.request("https://et3am.herokuapp.com/restaurant/searchList", method: .get, parameters: ["latitude": latitude,"longitude":longitude,"query":query,"page":page])
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote restaurants: \(response.result.error)")
                    return
                }
                guard let values = response.result.value as? Dictionary<String, Any> else{
                    print("Malformed data received from service")
                    return
                }
                guard let fetchedValues = values["results"] as? [Dictionary<String, Any>] else{
                    print("Results Faild")
                    return
                }
                print(values)
                guard let totalPages = values["total_results"] as? Int else{
                    print("Total Pages Faild")
                    return
                }
                
                for value in fetchedValues{
                    let restaurant:Restaurant! = Restaurant()
                    restaurant.restaurantID = value["restaurantID"] as? Int
                    restaurant.restaurantName = value["restaurantName"] as? String
                    restaurant.city = value["city"] as? String
                    restaurant.country = value["country"] as? String
                    restaurant.image = value["restaurantImage"] as? String
                    restaurant.latitude = value["latitude"] as? Double
                    restaurant.longitude = value["longitude"] as? Double
                    restaurant.distance = value["distance"] as? Double
                    restaurant.travelTime = value["travelTime"] as? Double
                    restaurantsList.append(restaurant)
                }
                completionHandler(restaurantsList,totalPages)
        }
    }
    
    }
}
