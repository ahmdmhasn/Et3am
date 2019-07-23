//
//  ChangePasswordViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var popContainer: UIView!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var reNewPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        popContainer.layer.cornerRadius = 10
        popContainer.layer.masksToBounds = true
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let userDao = UserDao.shared
        
        guard let oldPassword = userDao.user.password, let newPassword = newPassTextField.text, let reNewPassword = reNewPasswordTextField.text else {
            return
        }
        
        if newPassword != reNewPassword {
            showErrorLabel(text: "Passwords doesn't match")
            return
        }
        
        SVProgressHUD.show()
        userDao.updateUserPassword(oldPass: oldPassword, newPass: newPassword, completionHandler: { (code) in
            
            if code == 1 {
                
                userDao.user.password = newPassword
                
                userDao.addToUserDefaults(userDao.user)
                
                SVProgressHUD.showSuccess(withStatus: "Password changed successfully.")
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                SVProgressHUD.dismiss()
                
                self.showErrorLabel(text: "Something went worng, please try again later!")
            }
        })
    }
    
    
    func showErrorLabel(text: String) {
        
        self.errorLabel.isHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.errorLabel.alpha = 1
            self.errorLabel.text = text
        }) { (bool) in
            UIView.animate(withDuration: 1, delay: 3.0, options: [.curveEaseInOut], animations: { 
                self.errorLabel.alpha = 0
            }, completion: nil)
        }
        
    }
    
}
