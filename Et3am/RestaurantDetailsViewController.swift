//
//  RestaurantDetailsViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/21/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class RestaurantDetailsViewController: UIViewController {
   @IBOutlet weak var restuarantAndMealsTableView: UITableView!
    var restuarantObj = Restaurant()
    var mealsArray:Array<Meal> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        restuarantAndMealsTableView.dataSource = self
        restuarantAndMealsTableView.delegate = self
            fetchRestarurantMeals()
    }
    
    func fetchRestarurantMeals() {
        let restaurantDao:RestaurantDao = RestaurantDao.sharedRestaurantObject
        let mealsUrl:String  = "\(Et3amAPI.baseRestaurantUrlString)\(restuarantObj.restaurantID!)/\(RestaurantQueries.meals)"
        SVProgressHUD.show()
        restaurantDao.fetchJsonForMeals(typeURL: mealsUrl) { fetchedArray in
            SVProgressHUD.dismiss()
            if let mealsList = fetchedArray {
                DispatchQueue.main.async {
                    self.mealsArray = mealsList
                    self.restuarantAndMealsTableView.reloadData()
                }
            }
        }
    }
    
}

extension RestaurantDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeholderImage = UIImage(named: "placeholder")
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restCell", for: indexPath) as! RestaurantDetailsCell
            cell.restaurantName.text = restuarantObj.restaurantName
            cell.restaurantCountyCity.text = restuarantObj.city! + ", " + restuarantObj.country!
            
            let imageURL = ImageAPI.getImage(type: .original, publicId: restuarantObj.image ?? "")
            cell.restaurantImage.sd_setShowActivityIndicatorView(true)
            cell.restaurantImage.sd_setImage(with: URL(string: imageURL), placeholderImage: placeholderImage, options: [], completed: nil)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
            
            let meal = mealsArray[indexPath.row]
            cell.mealName.text = meal.mealName ?? ""
            let imageURL = ImageAPI.getImage(type: .original, publicId: meal.mealImage ?? "")
            cell.mealImage.sd_setShowActivityIndicatorView(true)
            cell.mealImage.sd_setImage(with: URL(string: imageURL), placeholderImage: placeholderImage, options: [], completed: nil)
            
            return cell
        }
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return mealsArray.count
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 245
        } else {
            return 120
        }
    }
    
}
