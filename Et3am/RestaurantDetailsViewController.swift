//
//  RestaurantDetailsViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/21/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {
    
    var getMealsFinished:Bool = false
    var getRestaurantDetails:Bool = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    private func showLoadingActivityIndicator(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    private func hideLoadingActivityIndicator(){
        
       activityIndicator.stopAnimating()
      UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    

    @IBAction func inviteFriend(_ sender: Any) {
    }
    
    @IBAction func getFreeCoupon(_ sender: Any) {
        
         }
    var restaurantName :String = ""
    var restaurantCountry :String = ""
    var restaurantCity:String = ""
    
    @IBOutlet weak var restuarantAndMealsTableView: UITableView!
    
    
    var restuarantObj = Restaurant()
    
    var mealsArray:Array<Meal> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingActivityIndicator()

        
        restuarantAndMealsTableView.dataSource = self
        restuarantAndMealsTableView.delegate = self
        
        
        let restaurantDao:RestaurantDao = RestaurantDao.sharedRestaurantObject
        let restaurantUrl:String = "\(Et3amAPI.baseRestaurantUrlString)\(RestaurantQueries.rest)/1"
        let mealsUrl:String  = "\(Et3amAPI.baseRestaurantUrlString)1/\(RestaurantQueries.meals)"
        
        print(mealsUrl)
        restaurantDao.fetchJsonForRestaurant(typeURL: restaurantUrl, handler: {restuarant in
            
            
            DispatchQueue.main.async {
                self.restaurantName = restuarant.restaurantName!
                self.restaurantCountry =  restuarant.country!
                self.restaurantCity = restuarant.city!
                //self.hideLoadingActivityIndicator()
                self.getRestaurantDetails = true
                if self.getRestaurantDetails == true && self.getMealsFinished == true {
                    self.hideLoadingActivityIndicator()
                }
                            }
                   })
        
        restaurantDao.fetchJsonForMeals(typeURL: mealsUrl) { fetchedArray in
              
            DispatchQueue.main.async {
                self.mealsArray = fetchedArray
                self.restuarantAndMealsTableView.reloadData()
                //self.hideLoadingActivityIndicator()
                self.getMealsFinished = true
                if self.getRestaurantDetails == true && self.getMealsFinished == true {
                    self.hideLoadingActivityIndicator()
                }
            }
            
        }
        
        
        
        
    }
    
    
    
    
}

extension RestaurantDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restCell", for: indexPath) as! RestaurantDetailsCell
            cell.restaurantName.text = restuarantObj.restaurantName
            cell.restaurantCountyCity.text = restuarantObj.city! + "," + restuarantObj.country!
            let image : UIImage = UIImage(named: "food")!
            cell.restaurantImage.image = image
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
            cell.mealName.text = mealsArray[indexPath.row].mealName!
            let image : UIImage = UIImage(named: "food")!
            cell.mealImage.image = image
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "INFO"
        }
        else{
            return "Meals For You"
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
