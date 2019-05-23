        //
        //  RestaurantInfoViewController.swift
        //  Et3am
        //
        //  Created by Mohamed Korany Ali on 9/9/1440 AH.
        //  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
        //
        
        import UIKit
        import Alamofire
        
        class RestaurantInfoViewController: UIViewController{
            var maxHeight: CGFloat = UIScreen.main.bounds.size.height
            //var resturant
            var responseJson:[[String: Any]]=[]
            var restuarantObj = Restaurant()
            var mealsArray:Array<Meal> = []
            @IBOutlet weak var restaurantImage: UIImageView!
            @IBOutlet weak var restaurantNameLable: UILabel!
            @IBOutlet weak var CountryCityLable: UILabel!
            @IBOutlet weak var scrollView: UIScrollView!
            @IBOutlet weak var mealsTableView: UITableView!
            @IBOutlet weak var containerHight: NSLayoutConstraint!
            
            
            @IBAction func inviteFriendButton(_ sender: Any) {
            }
            
            
            @IBAction func getFreeCouponButton(_ sender: Any) {
            }
            
            
            func reloadDataWithHeight() {
                let totalHeight = mealsTableView.rowHeight * CGFloat(mealsArray.count)
                mealsTableView.frame = CGRect(x: mealsTableView.frame.origin.x, y: mealsTableView.frame.origin.y, width: mealsTableView.frame.size.width, height: totalHeight)
                self.mealsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                containerHight.constant += (totalHeight - (mealsTableView.rowHeight*3-50))
                self.view.layoutIfNeeded()
            }
            
            
            override func viewDidLoad() {
                super.viewDidLoad()
                restuarantObj.city = ""
                restuarantObj.country = ""
                restuarantObj.restaurantID=1
                restuarantObj.restaurantName = ""
                restuarantObj.image = "restaurant"
                mealsTableView.delegate = self
                mealsTableView.dataSource = self
                let restaurantDao:RestaurantDao = RestaurantDao()
                restaurantDao.fetchJsonForRestaurant(typeURL: "https://et3am.herokuapp.com/restaurant/rest/1", handler: {restuarant in
                    DispatchQueue.main.async {
                        self.restaurantNameLable.text = restuarant.restaurantName!
                        self.CountryCityLable.text = restuarant.city! + ", " + restuarant.country!
                        let restuarantImg: UIImage = UIImage(named: restuarant.image!)!
                        self.restaurantImage.image = restuarantImg
                    }
                })
                
                restaurantDao.fetchJsonForMeals(typeURL: "https://et3am.herokuapp.com/restaurant/1/meals") { fetchedArray in
                    DispatchQueue.main.async {
                        self.mealsArray = fetchedArray
                        self.reloadDataWithHeight()
                        self.mealsTableView.reloadData()
                    }
                }
            }
        }
        
        
        extension RestaurantInfoViewController:UITableViewDelegate,UITableViewDataSource{
            
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
                cell.mealNameLabel.text = mealsArray[indexPath.row].mealName!
                let image : UIImage = UIImage(named: "food")!
                cell.mealPhotoImage.image = image
                return cell
            }
            
            public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.mealsArray.count
            }
            
            func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                
                return "Meals For  You"
                
            }
            
        }
        
