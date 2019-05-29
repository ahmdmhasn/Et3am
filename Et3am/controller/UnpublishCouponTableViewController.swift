//
//  UnpublishCouponTableViewController.swift
//  Et3am
//
//  Created by Jets39 on 5/10/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class UnpublishCouponTableViewController: UITableViewController {
    var listOfCoupons:[String:Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let listOfCoupons = listOfCoupons{
        switch(section)
        {
        case 0:
                return listOfCoupons["50"]!
        case 1:
                return listOfCoupons["100"]!
        case 2:
                return listOfCoupons["200"]!
        default :
            break
            
            
        }
        }
        
       return 0
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "donatedcoupon", for: indexPath) as! UnpublishCouponTableViewCell
        cell.couponCodeLbl.text="15******"
        switch(indexPath.section)
        {
        case 0:
            cell.couponValueLbl.text="50LE"
        case 1:
           cell.couponValueLbl.text="100LE"
        case 2:
        cell.couponValueLbl.text="200LE"
        default :
            break
            
            
        }
    

        return cell
   
    }
    

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
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
