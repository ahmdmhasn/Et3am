//
//  UserProfileViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/25/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

enum UserProfileSections: Int {
    case profile, coupons, settings, nationalID, logout
}

enum CouponsSection: Int {
    case donated, received
}

enum SettingsSection: Int {
    case emailAddress, mobileNumber, job, changePassword
}

enum AlertSwitcher {
    case mobileNumber, job
}

class UserProfileViewController: UITableViewController {
    
    // MARK - Properties
    let userDao = UserDao.shared
    
    // MARK - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userMobileNumberLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    @IBOutlet weak var isVerifiedLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isVerifiedLabel.isHidden = (userDao.user.verified ?? false) ? false : true
//        userImageView.image = userDao.user.profileImage
        usernameLabel.text = userDao.user.userName ?? ""
        userIDLabel.text = userDao.user.nationalID ?? ""
        userMobileNumberLabel.text = userDao.user.mobileNumber ?? ""
        userJobLabel.text = userDao.user.job ?? ""
        userEmailLabel.text = userDao.user.email ?? ""
        
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
        case .mobileNumber:
            showInputAlert(type: .mobileNumber)
        case .job:
            showInputAlert(type: .job)
        case .changePassword:
            break
        }
    }
    
    func showInputAlert(type: AlertSwitcher) {
        var title: String?
        var message: String?
        switch type {
        case .mobileNumber:
            title = "Change Mobile Number"
            message = "Kindly add your mobile number. Only you can see this."
        case .job:
            title = "Change Job"
            message = "Kindly add your current job. Only you can see this."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            let textField = alertController.textFields![0]
            print(textField.text ?? "")
            switch type {
            case .mobileNumber:
                print(type)
            case .job:
                print(type)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        present(alertController, animated: true, completion: nil)
    }
    
    func logoutUser() {
        
    }
}
