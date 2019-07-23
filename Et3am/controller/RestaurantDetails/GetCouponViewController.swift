//
//  PopUpViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class GetCouponViewController: UIViewController {

    private let couponDao = CouponDao.shared
    private let currentUser = UserDao.shared.user
    private let getFreeCouponURL: String = CouponURLQueries.getFreeCoupon.getUrl()
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet weak var outerContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorMsgLable: UILabel!
    @IBOutlet weak var btnScreenshotOutlet: RoundedButton!
    @IBOutlet weak var generatedCouponView: CouponView!

    @IBOutlet weak var requestButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        
        // Setup view
        self.errorMsgLable.isHidden = true
        self.generatedCouponView.isHidden = true
    }
    
    @IBAction func cancelProcess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenShotButton(_ sender: Any) {
        captureScreenshot()
    }
    
    
    @IBAction func requestCouponPressed(_ sender: Any) {
        getFreeCoupon(URL: getFreeCouponURL)
        
        requestButton.isEnabled = false
    }

    
    func getFreeCoupon(URL: String) -> Void {
        SVProgressHUD.show()
        couponDao.getFreeCoupon(typeURL: URL, handler: { [weak self] result in
            SVProgressHUD.dismiss()
            self?.handleResult(result)
        })
    }

    private func handleResult(_ result: Coupon?) {
        if let coupon = result {
            generatedCouponView.coupon = coupon
            
            generatedCouponView.isHidden = false
            btnScreenshotOutlet.isHidden = false
            generatedCouponView.alpha = 0
            btnScreenshotOutlet.alpha = 0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.headerLabel.text = "Congratulations!"
                self?.generatedCouponView.alpha = 100
                self?.btnScreenshotOutlet.alpha = 100
                self?.requestButton.alpha = 0
            }, completion: { [weak self] done in
                self?.requestButton.isHidden = true
            })
            
        } else {
            if UserDao.shared.user.verified! != .verified {
                errorMsgLable.text = "Your account is not verified! Please verify your account then try again."
            } else {
                errorMsgLable.text = "Something went wrong. Please try again later."
            }
            errorMsgLable.isHidden = false
            errorMsgLable.alpha = 0
            errorMsgLable.fadeTo(alpha: 1, duration: 0.3)
            
            requestButton.isEnabled = true
        }
    }
    
    func captureScreenshot(){
        // Setup Capture screenshot view
        let capturedScreenShotView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        capturedScreenShotView.backgroundColor = UIColor.black
        view.addSubview(capturedScreenShotView)
        
//        let layer = UIApplication.shared.keyWindow!.layer
        let layer = self.generatedCouponView.layer
        let scale = UIScreen.main.scale
        
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        notifyUser(data: screenshot ?? 0)
        
        capturedScreenShotView.isHidden = false
        capturedScreenShotView.alpha = 1
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            capturedScreenShotView.alpha = 0
        }) { (completed) in
            capturedScreenShotView.isHidden = true
        }
    }
    
    func notifyUser(data:Any) -> Void {
        let alert = UIAlertController(title: "Save Screenshot", message: "Screenshot is captured, Do you Save?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            // THIS IS TO SAVE SCREENSHOT TO PHOTOS
            UIImageWriteToSavedPhotosAlbum(data as! UIImage, nil, nil, nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

}
