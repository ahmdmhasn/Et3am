//
//  LandingViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/22/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class LandingViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!    
    @IBOutlet weak var donatedCouponsLabel: UILabel!
    @IBOutlet weak var receivedCouponsLabel: UILabel!
    
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoBackground: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var moreInfoStackView: UIStackView!
    
    var userSummary: UserSummary?
    let userDao = UserDao.shared
    
    // Timer
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false

    var moreInfoText: String = ""{
        didSet {
            
            func displayMoreInfo(_ display: Bool) {
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.moreInfoStackView
                        .alpha = display ? 1 : 0
                    self.moreInfoBackground.alpha = display ? 1 : 0
                }, completion: { (done) in
                    self.moreInfoStackView.isHidden = !display
                    self.moreInfoBackground.isHidden = !display
                })
            }
            
            if moreInfoText.isEmpty {
                
                displayMoreInfo(false)
                
            } else {
                
                moreInfoLabel.text = moreInfoText
                displayMoreInfo(true)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getUserSummary()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Remove this and add refresh button
        getUserSummary()
    }
    
    
    private func getUserSummary() {
        
//        SVProgressHUD.show()
        
        userDao.getUserSummaryData { (result) in
            
//            SVProgressHUD.dismiss()
            
            if let summary = result {
                self.userSummary = summary
                
                self.updateUI()

            }
        }
    }
    
    private func updateUI() {
        
        usernameLabel.text = userDao.user.userName ?? ""
        donatedCouponsLabel.text = "\(userSummary?.donatedCoupons ?? 0)"
        receivedCouponsLabel.text = "\(userSummary?.usedCoupons ?? 0)"
        
        if let date = userSummary?.reservedCouponExpDate {
            
            moreInfoText = "Use your reserved coupon before"
            
            seconds = Int(date.timeIntervalSince1970 - Date().timeIntervalSince1970)
            
            self.runTimer()
            
        } else {
            // to hide the center view and all it's content
            moreInfoText = ""
        }
        
    }
    
    // MARK: - Timer Methods
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
    }
    
    // MARK: - Segure Methods
    @IBAction func showRestaurantList(_ sender: Any) {
        performSegue(withIdentifier: "showRestaurantList", sender: self)
    }
    
    @IBAction func showUserProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "showUserProfile", sender: self)
    }
    
    @IBAction func showDonate(_ sender: UIButton) {
        performSegue(withIdentifier: "showDonate", sender: self)
    }
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        UserHelper.logoutUser()
    }
    
    
}
