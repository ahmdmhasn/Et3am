//
//  File.swift
//  Et3am
//
//  Created by Wael M Elmahask on 9/24/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SVProgressHUD

extension UITableView{
    func registerNib<Cell:UITableViewCell>(cell: Cell.Type){
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier:nibName)
    }
    
    func dequeueCell<Cell:UITableViewCell>()->Cell{
        let IdentifierCell = String(describing:Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: IdentifierCell) as? Cell else{
            fatalError("Cell Identifier Not founded")
        }
        return cell;
    }
}
extension RestaurantsListVC : CLLocationManagerDelegate{
    
    // MARK: - Core Location
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.startUpdatingLocation()
        
    }
    
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            let restaurantDao = RestaurantDao.sharedRestaurantObject
            print("locations = \(locationValue)")
            restaurantDao.fetchAllRestaurants(latitude: locationValue.latitude, longitude: locationValue.longitude, completionHandler: {restaurantList in
                print("\(restaurantList[0].restaurantName,restaurantList[0].distance)")
                print(restaurantList.count)
                if restaurantList.count == 0 {
                    SVProgressHUD.dismiss()
                    self.tableView.backgroundView = self.noList
                    self.noList.text = "No Restaurant Found"
                }else{
                    SVProgressHUD.dismiss()
                    self.restaurantsList = restaurantList
                    self.noList.isHidden = false
                    self.tableView.reloadData()
                }
            })
            
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
