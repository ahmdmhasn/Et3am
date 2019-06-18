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

enum UserProfileSections: Int {
    case profile, coupons, settings, nationalID, logout
}

enum CouponsSection: Int {
    case donated, received
}

enum SettingsSection: Int {
    case emailAddress, profile, changePassword
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        getUserData()
    }
    
    func updateUI() {
        isVerifiedLabel.isHidden = !(userDao.user.verified ?? false)
        usernameLabel.text = userDao.user.userName ?? ""
        userIDLabel.text = userDao.user.nationalID ?? ""
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        
        if let image = userDao.user.profileImage, !image.isEmpty {
            userImageView.sd_setShowActivityIndicatorView(true)
            userImageView.sd_setIndicatorStyle(.gray)
            userImageView.sd_setImage(with: URL(string: ImageAPI.getImage(type: .profile_r250, publicId: image)), completed: nil)
        }
    }
    
    func getUserData() {
        userDao.getUserData { (result) in
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = UserProfileSections(rawValue: indexPath.section)!
        switch section {
        case .profile:
            break
        case .coupons:
            break
        case .settings:
            getUserSettings(section: SettingsSection(rawValue: indexPath.row)!)
        case .nationalID:
            print("ID")
        case .logout:
            logoutUser()
        }
        
    }
    
    
}

// MARK - Selection Methods
extension UserProfileViewController {
    
    
    func getUserSettings(section: SettingsSection) {
        switch section {
        case .emailAddress:
            break
        case .profile:
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
    
    func logoutUser() {
        userDao.removeUserFromUserDefaults()
        
        let window = UIApplication.shared.keyWindow
        let storyboard
            = UIStoryboard(name: "RegisterAndLogin", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "registerViewController") as! RegisterandLoginViewController
        window?.rootViewController  = LoginVC
        UIView.transition(with: window!, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
    }
}
