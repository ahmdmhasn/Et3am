//
//  ChangePasswordViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var popContainer: UIView!
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var reNewPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideErrorLabel()
        popContainer.layer.cornerRadius = 10
        popContainer.layer.masksToBounds = true
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        if newPassTextField != reNewPasswordTextField {
            showErrorLabel(text: "Passwords doesn't match")
        }
    }
    
    func hideErrorLabel() {
        UIView.animate(withDuration: 1) {
            self.errorLabel.alpha = 0
        }
    }
    
    func showErrorLabel(text: String) {
        UIView.animate(withDuration: 1) {
            self.errorLabel.alpha = 1
            self.errorLabel.text = text
        }
    }
    
}
