//
//  DonateViewController.swift
//  Et3am
//
//  Created by jets on 9/5/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class DonateViewController: UITableViewController {
    
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
            if couponDonate == "coupon is donated" {
                
                //TODO: - push to unpublished view controller
                
//                let storyboard = UIStoryboard(name: "CouponsDonated", bundle: nil)
//                
//                let CuoponsTabBarController = storyboard.instantiateViewController(withIdentifier: "listofCouponsid") as? CuoponsTabBarController
//                let unpublishCouponTableViewController = CuoponsTabBarController?.viewControllers?[0] as! UnpublishCouponTableViewController
//                
//                unpublishCouponTableViewController.listOfCoupons = ["50": Int(self.countOfValue_50Label.text!)!
//                    ,"100": Int(self.countOfValue_100Label.text!)!
//                    ,"200":  Int(self.countOfValue_200Label.text!)!]
//                self.navigationController?.pushViewController(CuoponsTabBarController!, animated: false)
            } else {
                self.showAlert(message: "Connection error. Please try again later.", title:"")
            }
            
        })
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
