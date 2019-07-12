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

class RestaurantsListVC: UITableViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var SearchBarInTable: UISearchBar!
    var filteredData = [Restaurant]()
    var inSearchMode = false
    var shared : RestaurantDao = RestaurantDao.sharedRestaurantObject
    var currentUser = UserDao.shared.user
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
        SearchBarInTable.delegate = self

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
        } else {
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
//        print("numberOfRowsInSection \(restaurantsList.count)")
        if inSearchMode {
            
            return filteredData.count
        }
        else{
            
            return restaurantsList.count;}
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell() as RestaurantCell
        if inSearchMode {
            
            drawCell(cell: cell, selectedList: filteredData, indexPath: indexPath)
        
            
        }
            
            
        else{
        
            drawCell(cell: cell, selectedList: restaurantsList, indexPath: indexPath)
        
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView : RestaurantDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailsVCID") as! RestaurantDetailsViewController
        
        
        if inSearchMode{
        detailsView.restuarantObj = self.filteredData[indexPath.row]
        }
        else{
        detailsView.restuarantObj = self.restaurantsList[indexPath.row]
        }
        self.navigationController?.pushViewController(detailsView, animated: true);
    }
    func drawCell(cell:RestaurantCell ,selectedList:Array<Restaurant> , indexPath: IndexPath)  {
        let placeholderImage = UIImage(named: "placeholder")!
        let imageURL = ImageAPI.getImage(type: .width150, publicId: selectedList[indexPath.row].image ?? "")
        cell.restaurantImage.sd_setShowActivityIndicatorView(true)
        cell.restaurantImage.sd_setImage(with: URL(string: imageURL), placeholderImage: placeholderImage, options: [], completed: nil)
        cell.restaurantNameLabel.text = selectedList[indexPath.row].restaurantName
        cell.restaurantDistanceLabel.text = String(describing: (selectedList[indexPath.row].distance)!)+" km"
        cell.restaurantTimeLabel.text = String(describing: (selectedList[indexPath.row].travelTime)!)+" min"
    }
    
}
extension RestaurantsListVC {

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if searchBar.text! == "" {
            
                       filteredData = restaurantsList
                      inSearchMode = false
                      tableView.reloadData()
            
            }

        shared.searchAboutRestaurants(latitude: currentUser.lat!, longitude: currentUser.longt!, query: searchBar.text!, page: 1) { (fetchedRestaurantList, totalPages) in
            self.filteredData = fetchedRestaurantList
            self.inSearchMode = true
            self.tableView.reloadData()
            
        }
    }



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            filteredData = restaurantsList
            inSearchMode = false
            tableView.reloadData()
            
        }
            
//        else {
//            
//            
//            
//            filteredData = restaurantsList.filter({($0.restaurantName?.lowercased().contains(searchText.lowercased()))! })
//            print("Searccing now ...... ")
//            inSearchMode = true
//            tableView.reloadData()
//        }
   }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredData = restaurantsList
        searchBar.text = ""
        
       self.tableView.reloadData()
        inSearchMode = false
    }


}
