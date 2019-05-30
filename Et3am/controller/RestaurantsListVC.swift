//
//  RestaurantsListVC.swift
//  Et3am
//
//  Created by Wael M Elmahask on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantsListVC: UITableViewController {
    
    var restaurantsList = [Restaurant]()
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        setupLocationManager()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("_count \(restaurantsList.count)")
        return restaurantsList.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        let image : UIImage = UIImage(named: "food")!
        cell.restaurantImage.image = image
        cell.restaurantNameLabel.text = restaurantsList[indexPath.row].restaurantName
        cell.restaurantDistanceLabel.text = String(describing: (restaurantsList[indexPath.row].distance)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView : RestaurantDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailsVCID") as! RestaurantDetailsViewController
        detailsView.restuarantObj = self.restaurantsList[indexPath.row]
        self.navigationController?.pushViewController(detailsView, animated: true);
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
