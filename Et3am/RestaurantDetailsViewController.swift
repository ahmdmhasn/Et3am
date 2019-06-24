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
import MapKit

class RestaurantDetailsViewController: UIViewController {
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var restuarantAndMealsTableView: UITableView!
    
    var restuarantObj = Restaurant()
    var mealsArray:Array<Meal> = []
    let noList = UILabel()
    
    fileprivate var lastOffestPosition: CGFloat = 0
    
    override func viewDidLoad() {
        
        
       

        super.viewDidLoad()
        restuarantAndMealsTableView.dataSource = self
        restuarantAndMealsTableView.delegate = self
        
        
        fetchRestarurantMeals()
        
        restuarantAndMealsTableView.rowHeight = UITableViewAutomaticDimension
        restuarantAndMealsTableView.estimatedRowHeight = 250
    }
    
    func fetchRestarurantMeals() {
        let restaurantDao:RestaurantDao = RestaurantDao.sharedRestaurantObject
        let mealsUrl:String  = "\(Et3amAPI.baseRestaurantUrlString)\(restuarantObj.restaurantID!)/\(RestaurantQueries.meals)"
        SVProgressHUD.show(withStatus: "loading Meals")
        restaurantDao.fetchJsonForMeals(typeURL: mealsUrl) { fetchedArray in
            SVProgressHUD.dismiss()
            if let mealsList = fetchedArray {
                DispatchQueue.main.async {
                    self.mealsArray = mealsList
                        self.noList.center = self.restuarantAndMealsTableView.center
                        self.noList.text = "No Meals Exist"
                        self.noList.textColor = UIColor.black
                        self.noList.textAlignment = .center
                        self.restuarantAndMealsTableView.addSubview(self.noList)
                    
                    
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
            
            let tapGesture = UITapGestureRecognizer (target: self, action: #selector(imgTap(tapGesture:)))
            cell.mapImageView.isUserInteractionEnabled = true
            cell.mapImageView.addGestureRecognizer(tapGesture)
            
            let imageURL = ImageAPI.getImage(type: .width500, publicId: restuarantObj.image ?? "")
            cell.restaurantImage.sd_setShowActivityIndicatorView(true)
            cell.restaurantImage.sd_setImage(with: URL(string: imageURL), placeholderImage: placeholderImage, options: [], completed: nil)
            
            //Load restaurant image
            let path = "https://maps.googleapis.com/maps/api/staticmap?size=500x200"+"&markers=color:red%7C"+"\(restuarantObj.latitude ?? 0),\(restuarantObj.longitude ?? 0)&key=AIzaSyDIJ9XX2ZvRKCJcFRrl-lRanEtFUow4piM"
            print(path)
            cell.mapImageView.sd_setShowActivityIndicatorView(true)
            cell.mapImageView.sd_setIndicatorStyle(.whiteLarge)
            cell.mapImageView.sd_setImage(with: URL(string: path), completed: nil)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
            
            let meal = mealsArray[indexPath.row]
            cell.mealName.text = meal.mealName ?? ""
            cell.mealValue.text = String(describing: meal.mealValue!)+" €"
            let imageURL = ImageAPI.getImage(type: .width150, publicId: meal.mealImage ?? "")
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
            return UITableViewAutomaticDimension
        } else {
            return 100
        }
    }
    
    
    
    // Show/ hide the bottom container view depending on the current position on view
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        let topEdge = scrollView.contentOffset.y
        
        if bottomEdge < scrollView.contentSize.height {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomContainerView.alpha = 1
            })
            
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomContainerView.alpha = 0
            })
        }

    }
 
}

extension RestaurantDetailsViewController : RestaursntCellDelegate {

       func tapedImage() {
        print("inside taped image")
    }
    func imgTap(tapGesture: UITapGestureRecognizer) {
        let imgView = tapGesture.view as! UIImageView
        let idToMove = imgView.tag
        openMap(restaurantName: restuarantObj.restaurantName!, lat: restuarantObj.latitude!, longt: restuarantObj.longitude!)
   
    }
    func openMap(restaurantName:String , lat: Double , longt: Double){
        let latitude:CLLocationDegrees = lat
        let longitude:CLLocationDegrees = longt
        let regionDistance:CLLocationDistance = 500;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurantName
        mapItem.openInMaps(launchOptions: options)
    }

}
