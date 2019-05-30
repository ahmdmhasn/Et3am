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
    private init() {
        
    }
    
    // Resquest With Parameter using Alamofire
    func fetchAllRestaurants(latitude:Double ,longitude:Double ,completionHandler: @escaping (Array<Restaurant>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var restaurantsList = [Restaurant]()
            Alamofire.request("https://et3am.herokuapp.com/restaurant/list", method: .get, parameters: ["latitude": latitude,"longitude":longitude])
                .validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                        print("Error while fetching remote restaurants: \(response.result.error)")
                        return
                    }
                    
                    guard let values = response.result.value as? [Dictionary<String, Any>] else{
                        print("Malformed data received from service")
                        return
                    }
                    
                    for value in values{
                        let restaurant:Restaurant! = Restaurant()
                        restaurant.restaurantID = value["restaurantId"] as? Int
                        restaurant.restaurantName = value["restaurantName"] as? String
                        restaurant.city = value["city"] as? String
                        restaurant.country = value["country"] as? String
                        restaurant.image = "restaurant"
                        restaurant.latitude = value["latituse"] as? Double
                        restaurant.longitude = value["longitude"] as? Double
                        restaurant.distance = value["distance"] as? Double
                        restaurantsList.append(restaurant)
                    }
                    DispatchQueue.main.async {
                    completionHandler(restaurantsList)
                    }
            }
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
                print(restuarantObj.city ?? "No City is Found")
                print(restuarantObj.restaurantName ?? "No Name is Found")
                //
                handler(restuarantObj)
            }
        }
    }
    
    func fetchJsonForMeals (typeURL:String, handler:@escaping(Array<Meal>) -> Void){
        var mealsArray:Array<Meal> = []
        
        Alamofire.request(typeURL).responseJSON { (response) in
            if let responseValue = response.result.value as! [Dictionary<String, Any>]? {
                // self.responseJson = responseValue as! [[String: Any]]
                for item in responseValue{
                    let meal = Meal()
                    //    print(item["mealName"] as! String)
                    meal.mealName = item["mealName"] as? String
                    // print(meal.mealName)
                    meal.mealID = item["mealId"] as? String
                    meal.mealImage="food"
                    // print(item["mealName"])
                    mealsArray.append(meal)
                }
                
                handler(mealsArray)
                
                
            }
        }
    }
    
}




























