//
//  ViewController.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 5/8/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import ChameleonFramework

class RegisterandLoginViewController: UIViewController {
    
    //MARK: Properties
    var userName:String?
    var userEmail:String?
    var userPassword:String?
    var userRepeatPassword:String?
    let userDao = UserDao.shared
    var emailValid: Bool = false {
        didSet {
            signUpView.emailLabel.isHidden = false
            signUpView.emailLabel.text = emailValid ? "✓ Valid" : "Email is not valid"
            signUpView.emailLabel.textColor = emailValid ? UIColor.flatGreen() : UIColor.red
            enableSignUpBtn()
        }
    }
    
    var userNameValid: Bool = false {
        didSet {
            signUpView.userNameValidLabel.isHidden = false
            signUpView.userNameValidLabel.text = userNameValid ? "✓ Valid" : "Username is not valid"
            signUpView.userNameValidLabel.textColor = userNameValid ? UIColor.flatGreen() : UIColor.red
            enableSignUpBtn()
        }
    }
    
    var passwordValid: Bool = false {
        didSet {
            signUpView.passwordValidLabel.isHidden = false
            signUpView.passwordValidLabel.textColor = passwordValid ? UIColor.flatGreen() : UIColor.red
            enableSignUpBtn()
        }
    }
    
    var signinValidation: Bool = false {
        didSet {
            signInView.valdiatelabel.isHidden = false
            signInView.valdiatelabel.textColor = UIColor.red
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpView: SignUpView!
    @IBOutlet weak var signInView: SignInView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSigninView()
        signUpView.userNameValidLabel.isHidden = true
        signUpView.emailLabel.isHidden = true
        signUpView.passwordValidLabel.isHidden = true
        signInView.valdiatelabel.isHidden = true
        
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.layer.masksToBounds = true
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.layer.masksToBounds = true
        
        //TODO: For testing SDWebImage Library, you can remove it #hassan
        logoImageView.sd_setShowActivityIndicatorView(true)
        logoImageView.sd_setIndicatorStyle(.gray)
        logoImageView.sd_setImage(with: URL(string: "https://global.canon/en/imaging/eosd/samples/eos1300d/downloads/01.jpg"), completed: nil)
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let userName = signUpView.userNameTxtField.text, let userEmail = signUpView.emailTxtField.text, let userPassword = signUpView.passTxtField.text, let userRepeatPassword = signUpView.repeatedPassTxtField.text, userPassword == userRepeatPassword else {
            return
        }
        
        let parameters: [String:String] = [UserProperties.userName.rawValue : userName,
                                           UserProperties.userEmail.rawValue : userEmail,
                                           UserProperties.password.rawValue : userPassword]
        print(parameters)
        
        SVProgressHUD.show()
        signUpButton.isEnabled = false
        
        userDao.addUser(parameters: parameters, completionHandler: {(isRegistered) in
            
            SVProgressHUD.dismiss()
            self.signUpButton.isEnabled = true
            
            if isRegistered {
                self.performSegue(withIdentifier: "showRestaurantList", sender: self)
            } else {
                SVProgressHUD.showError(withStatus: "Something went wrong!")
            }
        })
    }
    
    @IBAction func signInUser(_ sender: Any) {
        
        guard let userEmail = signInView.emailTxtField.text , !userEmail.isEmpty else {
            signinValidation = false
            self.signInView.valdiatelabel.text = "Email is required!"
            return
        }
        
         guard let userPassword = signInView.passTxtField.text ,!userPassword.isEmpty else {
            signinValidation = false
            self.signInView.valdiatelabel.text = "Password is required!"
            return
        }
        
        SVProgressHUD.show()
        signInButton.isEnabled = false
        
        userDao.validateLogin(userEmail: userEmail, password: userPassword) {
            response in

            SVProgressHUD.dismiss()
            self.signInButton.isEnabled = true
            
            switch response {
            case .success(let code):
                if code == 1 {
                    self.performSegue(withIdentifier: "showRestaurantList", sender: self)
                } else {
                    self.signinValidation = false
                    self.signInView.valdiatelabel.text = "Username/ password doesn't match."
                }
                
            case .failure(let error):
                self.signinValidation = false
                self.signInView.valdiatelabel.text = "Something went wrong, please try again later."
                print(error)
            }
        }
    }
    
    @IBAction func signUpWithFacebookButton(_ sender: Any) {
        
    }
    
    @IBAction func forgetUserPassword(_ sender: Any) {
        
    }
    
    func enableSignUpBtn(){
        if emailValid && passwordValid && userNameValid {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }
    
    //MARK: - Segment controller switching methods
    @IBAction func segmenetdControlAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showSigninView()
        case 1:
            showSignupView()
        default:
            break
        }
    }
    
    func showSignupView() {
        signInView.isHidden = true
        signUpView.isHidden = false
    }
    
    func showSigninView() {
        signInView.isHidden = false
        signUpView.isHidden = true
    }
    
    //MARK: - Validation of email & password
    @IBAction func userNameEditingChange(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty {
            userDao.validateUsername(username: text, completionHandler: { (isUsernameValid) in
                self.userNameValid = isUsernameValid
            })
        }
    }
    
    @IBAction func emailEditingEndAction(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty, UserHelper.isEmailValid(emailAddressString: text){
            userDao.validateEmail(email: sender.text!, completionHandler: {(isEmailValid) in
                self.emailValid = isEmailValid
            })
        }
    }
    
    @IBAction func passwordEditingChangeAction(_ sender: UITextField) {
        
        guard let text = sender.text, let password1 = signUpView.passTxtField.text, let password2 = signUpView.repeatedPassTxtField.text else {
            return
        }
        
        passwordValid = false
        
        if text.isEmpty {
            signUpView.passwordValidLabel.text = "Password cannot be empty!"
        } else if UserHelper.isPasswordValid(text) && password1 == password2 {
            passwordValid = true
            signUpView.passwordValidLabel.text = "✓ Valid"
        } else if password2.isEmpty {
            signUpView.passwordValidLabel.text = ""
        } else {
            signUpView.passwordValidLabel.text = "Password is not valid!"
        }
        
    }
    
}

