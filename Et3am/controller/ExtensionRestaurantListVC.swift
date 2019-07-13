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
extension RestaurantsListVC {
    
    func loadMoreData(){
        //DispatchQueue.main.async {
            RestaurantDao.sharedRestaurantObject.fetchAllRestaurants(latitude: self.latitude, longitude: self.longitude,page: currentPage, completionHandler: {[unowned self] (restaurantList,pages) in
                print("fetchAllRestaurants .. \(self.currentPage)")
                if restaurantList.count == 0 {
                    SVProgressHUD.dismiss()
                    self.tableView.backgroundView = self.noList
                    self.noList.text = "No Restaurant Found"
                }else{
                    SVProgressHUD.dismiss()
                    self.restaurantsList.append(contentsOf: restaurantList)
                    self.totalPages = pages
                    print("listt.... \(self.restaurantsList.count,self.totalPages)")
                    self.noList.isHidden = false
                }
                self.tableView.reloadData()
            })
       // }
    }
    
    func searchMoreData(query queryText:String){
        DispatchQueue.main.async {
            RestaurantDao.sharedRestaurantObject.searchAboutRestaurants(latitude: self.latitude, longitude: self.longitude,query:queryText,page: self.currentPage, completionHandler: {[unowned self] (restaurantList,pages) in
                print("fetchAllRestaurants .. \(self.currentPage)")
                //print("\(restaurantList[0].restaurantName!,restaurantList[0].distance!)")
                if restaurantList.count == 0 {
                    SVProgressHUD.dismiss()
                    self.tableView.backgroundView = self.noList
                    self.noList.text = "No Restaurant Found"
                }else{
                    SVProgressHUD.dismiss()
                    self.restaurantsList.append(contentsOf: restaurantList)
                    self.totalPages = pages
                    print("listt.... \(self.restaurantsList.count,pages,self.totalPages)")
                    self.noList.isHidden = false
                    self.tableView.reloadData()
                }
            })
        }
    }
}

