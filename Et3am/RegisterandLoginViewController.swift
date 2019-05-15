//
//  ViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/8/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit


class RegisterandLoginViewController: UIViewController {
    
    var userName:String?
    var userEmail:String?
    var userPassword:String?
    var userRepeatPassword:String?
   
  
    @IBAction func signUpButton(_ sender: Any) {
    }

  
    @IBAction func signUpWithFacebookButton(_ sender: Any) {
        userName = signUpView.userNameTxtField.text
        userEmail = signUpView.emailTxtField.text
        userPassword = signUpView.passTxtField.text
        userRepeatPassword = signUpView.repeatedPassTxtField.text
    }
    
    @IBAction func signInButton(_ sender: Any) {
    }
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    
    @IBOutlet weak var signInView: signInView!
    @IBOutlet weak var signUpView: signUpView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        signUpView.userNameTxtField.addTarget(self, action: #selector(), for: .editingChanged)
        //    }
    }
  
    @IBAction func segmenetdControlAction(_ sender: Any) {
    
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            signInView.isHidden = true
            signUpView.isHidden = false
        case 1:
            signInView.isHidden = false
            signUpView.isHidden = true
            break
            
        default:
            break;
        }
    }
   
    
    
}

