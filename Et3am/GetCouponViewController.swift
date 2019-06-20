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
    //let user:User = UserDao.shared.user
    let currentUser = UserDao.shared.user
    
    
    @IBOutlet var outerContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var barCodeLable: UILabel!
    @IBOutlet weak var errorMsgLable: UILabel!
    @IBOutlet weak var imageViewQR: UIImageView!
    @IBOutlet weak var requestButton: UIBarButtonItem!
    
    @IBAction func cancelProcess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private  let getFreeCouponURL: String = CouponURLQueries.getFreeCoupon.getUrl()
    
    @IBAction func requestCouponButton(_ sender: Any) {
        print(getFreeCouponURL)
        
        getFreeCoupon(URL: getFreeCouponURL)
        requestButton.isEnabled = false
    }
    
    
    
    
    override func viewDidLoad() {
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        print(currentUser.userID ?? 0)
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

}
