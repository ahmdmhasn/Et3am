//
//  ResturantDetails.swift
//  Et3am
//
//  Created by jets on 9/5/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class ResturantDetails : UIViewController{
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
     var coupons = ["50","100","150","200"]
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
coupons = ["50","100","150","200"]
        // Do any additional setup after loading the view.
    }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = coupons.count
        if pickerView == dropdown {
            
            countrows = self.coupons.count
        }
        
        return countrows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dropdown {
            
            let titleRow = coupons[row]
            
            return titleRow
            
        }
            
        else if pickerView == dropdown{
            let titleRow = coupons[row]
            
            return titleRow
        }
        
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dropdown {
            self.textBox.text = self.coupons[row]
            self.dropdown.isHidden = true
        }
            
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.textBox){
            self.dropdown.isHidden = false
            
        }
       
        
    }

    

}
