//
//  VerificationViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/19/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import ChameleonFramework

enum ImageNumber {
    case first, second
}

class VerificationViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var imageActivityIndicaator1: UIActivityIndicatorView!
    @IBOutlet weak var imageActivityIndicaator2: UIActivityIndicatorView!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // Properties
    var firstImage: Bool = true
    var firstImageId: String?
    var secondImageId: String?
    let userDao = UserDao.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        
        let user = userDao.user
        
        infoLabel.isHidden = false
        
        switch user.verified! {
        case .pending:
            infoLabel.text = "Your national ID is being verified. You can update your data."
            infoLabel.textColor = UIColor.flatYellow()
        case .rejected:
            infoLabel.text = "Your national ID infomation was rejected. Please update your data and submit again."
            infoLabel.textColor = UIColor.flatRed()
        case .notVerified, .verified:
            infoLabel.isHidden = true
        }
        
        if let frontImage = user.nationalID_Front, let backImage = user.nationalID_Back, let id = user.nationalID, let mobileNumber = user.mobileNumber {
            
            let placeholder = UIImage(named: "placeholder")
            
            let urlFront = URL(string: ImageAPI.getImage(type: .width500, publicId: frontImage))
            image1.sd_setShowActivityIndicatorView(true)
            image1.sd_setIndicatorStyle(.whiteLarge)
            image1.sd_setImage(with: urlFront, placeholderImage: placeholder, options: [], completed: nil)
            
            let urlBack = URL(string: ImageAPI.getImage(type: .width500, publicId: backImage))
            image2.sd_setShowActivityIndicatorView(true)
            image2.sd_setIndicatorStyle(.whiteLarge)
            image2.sd_setImage(with: urlBack, placeholderImage: placeholder, options: [], completed: nil)
            
            firstImageId = frontImage
            secondImageId = backImage
            idTextField.text = id
            phoneNumberTextField.text = mobileNumber
        }
        
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        submitButton.layer.masksToBounds = true
    }
    
    @IBAction func imageChooser(_ sender: UIButton) {
        
        firstImage = (sender.tag == 1)
        
        let myPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = false
            
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if let img1 = firstImageId, let img2 = secondImageId, let idText = idTextField.text, !idText.isEmpty, let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
            
            sender.isEnabled = false
            SVProgressHUD.show()
            
            userDao.updateUserDetails(type: .verify, completionHandler: { (code) in
                
                sender.isEnabled = true
                
                if code == 1 {
                    var userTemp = self.userDao.user
                    userTemp.nationalID = idText
                    userTemp.nationalID_Front = img1
                    userTemp.nationalID_Back = img2
                    userTemp.mobileNumber = phoneNumber
                    
                    self.userDao.user = userTemp
                    
                    SVProgressHUD.showSuccess(withStatus: "Successfully updated.")
                    
                    let _ = self.navigationController?.popViewController(animated: true)
                    
                } else {
                    SVProgressHUD.showError(withStatus: "Something went wrong!")
                }
            })
            
        } else {
            SVProgressHUD.showError(withStatus: "Some fields are empty!")
        }
    }
    
}

//MARK: - Select image from gallery
extension VerificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if firstImage {
                image1.image = image
                uploadImage(image, number: .first)
            } else {
                image2.image = image
                uploadImage(image, number: .second)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Image Uploading
extension VerificationViewController {
    
    func uploadImage(_ image: UIImage, number: ImageNumber) {
        
        guard let imageData: Data = UIImageJPEGRepresentation(image, 0.2) else {
            return
        }
        
        uploadStarts(number)
        
        ImageAPI.uploadImage(imgData: imageData, completionHandler: { result in
            
            self.uploadCompleted(number)
            
            if let _ = result.0, let publicId = result.1 {
                
                switch number {
                case .first:
                    self.firstImageId = publicId
                case .second:
                    self.secondImageId = publicId
                }
                
            }
        })
    }
    
    func uploadStarts(_ number: ImageNumber) {
        switch number {
        case .first:
            imageActivityIndicaator1.startAnimating()
            image1.alpha = 0.3
        case .second:
            imageActivityIndicaator2.startAnimating()
            image2.alpha = 0.3
        }
    }
    
    func uploadCompleted(_ number: ImageNumber) {
        switch number {
        case .first:
            imageActivityIndicaator1.stopAnimating()
            image1.alpha = 1
        case .second:
            imageActivityIndicaator2.stopAnimating()
            image2.alpha = 1
        }
    }
}
