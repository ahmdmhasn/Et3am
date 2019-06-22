//
//  RestaurantsListVC.swift
//  Et3am
//
//  Created by Wael M Elmahask on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import SDWebImage

class RestaurantsListVC: UITableViewController {
    

    var restaurantsList = [Restaurant]()
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation?
    let noList = UILabel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        setupLocationManager()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noList.center = view.center
        //noList.text = "You don't have any used coupon."
        noList.text = "No Restaurant Found"
        noList.textAlignment = .center
        noList.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        view.addSubview(noList)
        SVProgressHUD.show(withStatus : "Loading Restaurants", maskType: .none)
        if restaurantsList.count == 0 {
            self.tableView.backgroundView = self.noList
        }
        else{
            self.noList.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("numberOfRowsInSection \(restaurantsList.count)")
        return restaurantsList.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell() as RestaurantCell
        
        let placeholderImage = UIImage(named: "placeholder")!
        let imageURL = ImageAPI.getImage(type: .profile_r250, publicId: restaurantsList[indexPath.row].image ?? "")
        cell.restaurantImage.sd_setShowActivityIndicatorView(true)
        cell.restaurantImage.sd_setImage(with: URL(string: imageURL), placeholderImage: placeholderImage, options: [], completed: nil)
        cell.restaurantNameLabel.text = restaurantsList[indexPath.row].restaurantName
        cell.restaurantDistanceLabel.text = String(describing: (restaurantsList[indexPath.row].distance)!)+" km"
        cell.restaurantTimeLabel.text = String(describing: (restaurantsList[indexPath.row].travelTime)!)+" min"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView : RestaurantDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailsVCID") as! RestaurantDetailsViewController
        detailsView.restuarantObj = self.restaurantsList[indexPath.row]
        self.navigationController?.pushViewController(detailsView, animated: true);
    }
    
}
