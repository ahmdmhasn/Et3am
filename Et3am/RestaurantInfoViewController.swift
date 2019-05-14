//
//  RestaurantInfoViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/9/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class RestaurantInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    
    
    
    var restuarantObj = Restaurant()
    
    
    
    
    


    
    var mealsArray:Array<Meal> = []
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLable: UILabel!
    
    @IBOutlet weak var CountryCityLable: UILabel!
    
    
    @IBOutlet weak var MealsTableView: UITableView!
    @IBAction func inviteFriendButton(_ sender: Any) {
    }
    
    @IBAction func getFreeCouponButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        restuarantObj.city = "cairo"
        restuarantObj.country = "Egypt"
        restuarantObj.restaurantName = "El Shabrawy"
        restuarantObj.image = "restaurant"

        restaurantNameLable.text = restuarantObj.restaurantName
        CountryCityLable.text = restuarantObj.country! + ", " + restuarantObj.city!
        var restuarantImg: UIImage = UIImage(named: restuarantObj.image!)!
        restaurantImage.image = restuarantImg
        
        let meal1 = Meal()
        meal1.mealName="Shawrma"
        meal1.mealImage="food"
        
        let meal2 = Meal()
        meal2.mealName="Shawrma"
        meal2.mealImage="food"
        
        
        
        mealsArray.append(meal1)
        mealsArray.append(meal2)
        
        
        
        
        MealsTableView.reloadData()
        
        
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
        cell.mealNameLabel.text = mealsArray[indexPath.row].mealName
        let image : UIImage = UIImage(named: "food")!
        cell.mealPhotoImage.image = image
        return cell
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mealsArray.count
        
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
