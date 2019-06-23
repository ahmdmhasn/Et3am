//
//  LandingViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/22/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!    
    @IBOutlet weak var donatedCouponsLabel: UILabel!
    @IBOutlet weak var receivedCouponsLabel: UILabel!
    
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoBackground: UIView!
    
    var usernameText: String = "" {
        didSet {
            usernameLabel.text = usernameText
        }
    }
    
    var moreInfoText: String = ""{
        didSet {
            if moreInfoText.isEmpty {
                
                displayMoreInfo(false)
                
            } else {
                
                moreInfoLabel.text = moreInfoText
                displayMoreInfo(true)
                
            }
        }
    }
    
    private func displayMoreInfo(_ display: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.moreInfoLabel.alpha = display ? 1 : 0
            self.moreInfoBackground.alpha = display ? 1 : 0
        }, completion: { (done) in
            self.moreInfoLabel.isHidden = !display
            self.moreInfoBackground.isHidden = !display
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreInfoText = ""
    }
    
    
    
    
    
    
    
    @IBAction func showRestaurantList(_ sender: Any) {
        performSegue(withIdentifier: "showRestaurantList", sender: self)
    }
    
    @IBAction func showUserProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "showUserProfile", sender: self)
    }
    
    @IBAction func showDonate(_ sender: UIButton) {
        performSegue(withIdentifier: "showDonate", sender: self)
    }
    
}
