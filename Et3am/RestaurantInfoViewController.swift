//
//  RestaurantInfoViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/9/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    

    var responseJson:[[String: Any]]=[]
    
    var restuarantObj = Restaurant()

    var mealsArray:Array<Meal> = []
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLable: UILabel!
    
    @IBOutlet weak var CountryCityLable: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mealsTableView: UITableView!
    @IBAction func inviteFriendButton(_ sender: Any) {
    }
    
    @IBAction func getFreeCouponButton(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mealsTableView.reloadData()
    }
    
    func reloadTableviewDataWithHeight() {
        let totalHeight = mealsTableView.rowHeight * CGFloat(mealsArray.count)
        mealsTableView.frame = CGRect(x: mealsTableView.frame.origin.x, y: mealsTableView.frame.origin.y, width: mealsTableView.frame.size.width, height: totalHeight)
        self.mealsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        restuarantObj.city = ""
        restuarantObj.country = ""
        restuarantObj.restaurantName = ""
        restuarantObj.image = "restaurant"
        
        mealsTableView.delegate = self
        mealsTableView.dataSource = self

     
        let restuarantImg: UIImage = UIImage(named: restuarantObj.image!)!
        restaurantImage.image = restuarantImg
        
//        let meal1 = Meal()
//        meal1.mealName="Shawrma"
//        meal1.mealImage="food"
//        
//        let meal2 = Meal()
//        meal2.mealName="Kabab"
//        meal2.mealImage="food"
//        
//        let meal3 = Meal()
//        meal3.mealName="Shawrma"
//        meal3.mealImage="food"
//        
//        let meal4 = Meal()
//        meal4.mealName="Kabab"
//        meal4.mealImage="food"
//
//        
        
//        mealsArray.append(meal1)
//        mealsArray.append(meal2)
//        mealsArray.append(meal3)
//        mealsArray.append(meal4)
//        mealsArray.append(meal4)
//        mealsArray.append(meal4)
//        mealsArray.append(meal4)
        
        fetchJsonForRestaurant(typeURL: "https://et3am.herokuapp.com/restaurant/rest/1")
        fetchJsonForMeals(typeURL: "https://et3am.herokuapp.com/restaurant/1/meals")
        
        self.mealsTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
        cell.mealNameLabel.text = mealsArray[indexPath.row].mealName!
        print(mealsArray[indexPath.row].mealName!)
        let image : UIImage = UIImage(named: "food")!
        cell.mealPhotoImage.image = image
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(mealsArray.count)
        return self.mealsArray.count
    }
}


extension RestaurantInfoViewController{
    
    func fetchJsonForRestaurant(typeURL:String){
        
        DispatchQueue.main.async {
            Alamofire.request(typeURL).responseJSON { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    
                    // let fetchedRestaurant:Restaurant! = Restaurant()
                    
                    self.restuarantObj.restaurantName = responseValue["restaurantName"] as! String?
                    self.restuarantObj.city = responseValue["city"] as! String?
                    self.restuarantObj.country = responseValue["country"] as! String?
                    
                    self.restaurantNameLable.text = self.restuarantObj.restaurantName
                    self.CountryCityLable.text = self.restuarantObj.country! + ", " + self.restuarantObj.city!
                }
            }
        }
        
    }
    
    
    func fetchJsonForMeals(typeURL:String){
        Alamofire.request(typeURL).responseJSON { (response) in
            if let responseValue = response.result.value as! [Dictionary<String, Any>]? {
                // self.responseJson = responseValue as! [[String: Any]]
                for item in responseValue{
                    var meal = Meal()
                    //    print(item["mealName"] as! String)
                    meal.mealName = item["mealName"] as? String
                    // print(meal.mealName)
                    meal.mealID = item["mealId"] as? String
                    meal.mealImage="food"
                    self.mealsArray.append(meal)
                }
               //self.mealsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                self.mealsTableView.reloadData()
                self.reloadTableviewDataWithHeight()
            }
            
        }
    }
}

