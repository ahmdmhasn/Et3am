//
//  PopUpViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class GetCouponViewController: UIViewController {

    private let couponDao = CouponDao.shared
    private let currentUser = UserDao.shared.user
    private let getFreeCouponURL: String = CouponURLQueries.getFreeCoupon.getUrl()
    private var capturedScreenShotView:UIView!
    
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet var outerContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var barCodeLable: UILabel!
    @IBOutlet weak var errorMsgLable: UILabel!
    @IBOutlet weak var imageViewQR: UIImageView!
    @IBOutlet weak var requestButton: UIBarButtonItem!
    @IBOutlet weak var btnScreenshotOutlet: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        capturedScreenShotView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        capturedScreenShotView.backgroundColor = UIColor.black
       view.addSubview(capturedScreenShotView)
        capturedScreenShotView.isHidden = true
        print(currentUser.userID ?? 0)
    }
    
    @IBAction func cancelProcess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenShotButton(_ sender: Any) {
        captureScreenshot()
    }
    
    @IBAction func requestCouponButton(_ sender: Any) {
        getFreeCoupon(URL: getFreeCouponURL)
        requestButton.isEnabled = false
    }

    
    func getFreeCoupon(URL: String) -> Void {
        couponDao.getFreeCoupon(typeURL: URL, handler: {result in
            DispatchQueue.main.async {
                if let coupon = result {
                    self.barCodeLable.text = coupon.barCode
                    self.imageViewQR.image = Helper.generateQRCOde(barCode: coupon.barCode)
                    self.errorMsgLable.isHidden = true
                    self.btnScreenshotOutlet.isHidden = false
                } else {
                    DispatchQueue.main.async {
                        self.barCodeLable.isHidden = true
                        self.imageViewQR.isHidden = true
                        self.errorMsgLable.text = "User is not verified or no coupon exists at the moment"
                    }
                }
            }})
    }

    
    func captureScreenshot(){
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        notifyUser(data: screenshot ?? 0)
        
        capturedScreenShotView.isHidden = false
        self.capturedScreenShotView.alpha = 1
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.capturedScreenShotView.alpha = 0
        }) { (completed) in
            self.capturedScreenShotView.isHidden = true
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
