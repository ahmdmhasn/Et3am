//
//  UserProfileViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/25/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import ChameleonFramework

enum UserProfileSections: Int {
    case profile, coupons, settings, nationalID, logout
}

enum CouponsSection: Int {
    case donated, received
}

enum SettingsSection: Int {
    case emailAddress, phone, job, changePassword
}

class UserProfileViewController: UITableViewController {
    
    // MARK - Properties
    let userDao = UserDao.shared
    
    // MARK - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var isVerifiedLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        getUserData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.didTapOnImageSection()
        }
        
        // Dismiss keyboard
        self.view.bindToKeyboard(withTapGesture: true)
    }
    
    func updateUI() {
        usernameLabel.text = userDao.user.userName ?? ""
        userIDLabel.text = userDao.user.nationalID ?? ""
        userEmailLabel.text = userDao.user.email ?? ""
        userPhoneNumberLabel.text = userDao.user.mobileNumber ?? ""
        jobTextField.text = userDao.user.job ?? ""
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        
        if let image = userDao.user.profileImage, !image.isEmpty {
            userImageView.sd_setShowActivityIndicatorView(true)
            userImageView.sd_setIndicatorStyle(.gray)
            userImageView.sd_setImage(with: URL(string: ImageAPI.getImage(type: .profile_r250, publicId: image)), completed: nil)
        }
        
        switch userDao.user.verified! {
        case .verified:
            isVerifiedLabel.isHidden = false
            isVerifiedLabel.text = "Verified"
            isVerifiedLabel.textColor = UIColor.flatGreen()
        case .pending:
            isVerifiedLabel.isHidden = false
            isVerifiedLabel.text = "Pending"
            isVerifiedLabel.textColor = UIColor.flatGray()
        case .rejected:
            isVerifiedLabel.isHidden = false
            isVerifiedLabel.text = "Rejected!"
            isVerifiedLabel.textColor = UIColor.flatRed()
        default:
            isVerifiedLabel.isHidden = true
        }

    }
    
    func getUserData() {
        DispatchQueue.global().async {
            self.userDao.getUserData { (result) in
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = UserProfileSections(rawValue: indexPath.section)!
        switch section {
        case .profile:
            didTapOnImageSection()
            
        case .coupons:
            break
            
        case .settings:
            getUserSettings(section: SettingsSection(rawValue: indexPath.row)!)
            
        case .nationalID:
            if userDao.user.verified! != VerificationStatus.verified {
                performSegue(withIdentifier: "showVerification", sender: self)
            }
            
        case .logout:
            UserHelper.logoutUser()
        }
    }
    
    
    @IBAction func editJob(_ sender: UITextField) {

        if let text = sender.text {
            userDao.user.job = text
        }
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = false
            
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    func didTapOnImageSection() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let isHidden = self.changeImageButton.isHidden
            self.changeImageButton.alpha = (isHidden) ? 1 : 0
            self.changeImageButton.isHidden = !isHidden
        }, completion: nil)
    }
    
    
}

// MARK: - User Data Methods
extension UserProfileViewController {
    
    func getUserSettings(section: SettingsSection) {
        switch section {
        case .emailAddress, .phone, .job:
            break
        case .changePassword:
            showPasswordInputAlert()
        }
    }
    
    func showPasswordInputAlert() {
        let title = "Change Password"
        let message = "Enter your current password to proceed"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Proceed", style: .default, handler: { _ in
            
            let textField = alertController.textFields![0]

            guard let text = textField.text else {
                return
            }
            
            if text == self.userDao.user.password {
                self.performSegue(withIdentifier: "showChangePassword", sender: self)
            } else {
                SVProgressHUD.showError(withStatus: "Wrong password", maskType: .clear)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        present(alertController, animated: true, completion: nil)
    }
    
}


//MARK: - Select image from gallery
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData: Data = UIImageJPEGRepresentation(image, 0.2)!
            
            uploadUserImage(imageData)
            
            userImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Image Uploading
extension UserProfileViewController {
    
    func uploadUserImage(_ imageData: Data) {
        
        uploadStarts()
        
        ImageAPI.uploadImage(imgData: imageData, completionHandler: { result in
            
            self.uploadCompleted()
            
            if let _ = result.0, let publicId = result.1 {
                self.userDao.user.profileImage = publicId
            }
        })
    }
    
    func uploadStarts() {
        imageActivityIndicator.startAnimating()
        userImageView.alpha = 0.3
    }
    
    
    func uploadCompleted() {
        imageActivityIndicator.stopAnimating()
        userImageView.alpha = 1.0
    }
}
