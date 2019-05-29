//
//  PopUpViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class GetCouponViewController: UIViewController {
    
    
    
    @IBOutlet var outerContainerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    
  
    @IBAction func cancelProcess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        
        
    }
    
    
}
