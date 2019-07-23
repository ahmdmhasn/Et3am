//
//  DonateViewController.swift
//  Et3am
//
//  Created by jets on 9/5/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class DonateViewController: UITableViewController {
    
    var coupounDao = CouponDao.shared
    
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
        
        let alert = UIAlertController(title: "Are you sure you want to pay for '\(totalCoupons)' coupons with a total value of \(totalValues) EGP?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.donateCoupons()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func donateCoupons() {
        
        SVProgressHUD.show()
        
        coupounDao.addCoupon(value_50: countOfValue_50Label.text! , value_100: countOfValue_100Label.text!, value_200: countOfValue_200Label.text!, completionHandler: {couponDonate in
            
            if couponDonate == 1 {
                
                SVProgressHUD.showSuccess(withStatus: "\(self.totalCoupons) coupons donated successfully.")
                
//                self.performSegue(withIdentifier: "showCouponsDonated", sender: self)
                let _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                
                SVProgressHUD.dismiss()
                
                self.showAlert(message: "Connection error. Please try again later.", title:"")
                
            }
        })
    }
}
