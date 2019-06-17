//
//  DonateViewController.swift
//  Et3am
//
//  Created by jets on 9/5/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class DonateViewController: UITableViewController
{

    var coupounDao = CouponDao()
    @IBOutlet weak var countOfValue_50Label: UILabel!

  
    @IBOutlet weak var countOfValue_100Label: UILabel!
    
 
    @IBOutlet weak var countOfValue_200Label: UILabel!
    @IBOutlet weak var TotalCouponLabel: UILabel!
    
    @IBOutlet weak var TotalValueLabel: UILabel!
    
    var totalCoupons:String {
        return String(Int(countOfValue_50Label.text!)!+Int(countOfValue_100Label.text!)!+Int(countOfValue_200Label.text!)!)
    }
    var totalValues:String {
        return String(50*Int(countOfValue_50Label.text!)!+100*Int(countOfValue_100Label.text!)!+200*Int(countOfValue_200Label.text!)!)
    }
    @IBAction func value_50Stepper(_ sender: UIStepper) {
        
        countOfValue_50Label.text = String(Int(sender.value))
        TotalCouponLabel.text = totalCoupons
        TotalValueLabel.text = totalValues
        
    }
   
    @IBAction func value_100Stepper(_ sender: UIStepper) {
        countOfValue_100Label.text = String(Int(sender.value))
           TotalCouponLabel.text = totalCoupons
         TotalValueLabel.text = totalValues
    }
    @IBAction func value_200Stepper(_ sender: UIStepper) {
        countOfValue_200Label.text = String(Int(sender.value))
        TotalCouponLabel.text = totalCoupons
         TotalValueLabel.text = totalValues
    }
    
    @IBAction func DonateButton(_ sender: UIBarButtonItem) {
        print(countOfValue_100Label.text!)
        
        coupounDao.addCoupon(value_50: countOfValue_50Label.text! , value_100: countOfValue_100Label.text!, value_200: countOfValue_200Label.text!, completionHandler: {couponDonate in
            print(couponDonate)
            
            if couponDonate == "coupon is donated"
                
            {
              
                let storyboard = UIStoryboard(name: "CouponsDonated", bundle: nil)
             
                let CuoponsTabBarController = storyboard.instantiateViewController(withIdentifier: "listofCouponsid") as? CuoponsTabBarController
                let unpublishCouponTableViewController = CuoponsTabBarController?.viewControllers?[0] as! UnpublishCouponTableViewController
                
                unpublishCouponTableViewController.listOfCoupons = ["50": Int(self.countOfValue_50Label.text!)!
               ,"100": Int(self.countOfValue_100Label.text!)!
                ,"200":  Int(self.countOfValue_200Label.text!)!]
               
                
                self.navigationController?.pushViewController(CuoponsTabBarController!, animated: false)
            }
            else{
                self.showAlert(message: "you are not connected", title:"")
                
            }
            
        })

    }
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()

        }

 

// 
//    override func numberOfSections(in tableView: UITableView) -> Int {
//      
//        return numberOfSections
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//     
//        return numberOfRows
//    }
 


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
