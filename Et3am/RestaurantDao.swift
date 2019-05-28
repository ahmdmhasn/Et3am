//
//  RestaurantDao.swift
//  Et3am
//
//  Created by jets on 9/17/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire

class RestaurantDao
{
    public static let sharedRestaurantObject = RestaurantDao()
    private init() {
        
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




























