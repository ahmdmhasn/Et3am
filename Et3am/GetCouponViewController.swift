//
//  PopUpViewController.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/23/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit

class GetCouponViewController: UIViewController {
    let couponDao = CouponDao.shared
    let currentUser = UserDao.shared.user
     var capturedScreenShotView:UIView!
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet var outerContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var barCodeLable: UILabel!
    @IBOutlet weak var errorMsgLable: UILabel!
    @IBOutlet weak var imageViewQR: UIImageView!
    @IBOutlet weak var requestButton: UIBarButtonItem!
    @IBAction func cancelProcess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func screenShotButton(_ sender: Any) {
        
        captureScreenshot()
    }
    private  let getFreeCouponURL: String = CouponURLQueries.getFreeCoupon.getUrl()
    
    @IBAction func requestCouponButton(_ sender: Any) {
        print(getFreeCouponURL)
        
        getFreeCoupon(URL: getFreeCouponURL)
        requestButton.isEnabled = false
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        capturedScreenShotView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        capturedScreenShotView.backgroundColor = UIColor.black
       view.addSubview(capturedScreenShotView)
        capturedScreenShotView.isHidden = true
    }
    
    func getFreeCoupon(URL: String) -> Void {
        couponDao.getFreeCoupon(typeURL: URL, handler: {result in
            DispatchQueue.main.async {
                if let coupon = result {
                self.barCodeLable.text = coupon.barCode
                    self.generateQRCOde(barCode: coupon.barCode)
                    self.errorMsgLable.isHidden = true
                    
                } else {
                    DispatchQueue.main.async {
                        self.barCodeLable.isHidden = true
                        self.imageViewQR.isHidden = true
                        self.errorMsgLable.text = "User is not verified or no coupon exists at the moment"
                    }
                }
            }})
    }
    
    func generateQRCOde(barCode:String!) -> Void {
        if let myString = barCode
        {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
            imageViewQR.image = img
        }
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
       notifyUser(data: screenshot)
        
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
