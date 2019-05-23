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
    let userDao = UserDao()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var signInView: signInView!
    
    @IBOutlet weak var signUpView: signUpView!
    var emailValid,userNameValid,passValid,repeatPassValid,emailValidForSignIn,passValidForSignIn: Bool!
   
    
    @IBAction func signUpButton(_ sender: Any) {
        userName = signUpView.userNameTxtField.text
        userEmail = signUpView.emailTxtField.text
        userPassword = signUpView.passTxtField.text
        userRepeatPassword = signUpView.repeatedPassTxtField.text
        let parameters : [String:String] = [
            
            "userName" : userName! ,
            "userEmail" : userEmail! ,
            "password" : userPassword!
        ]
        
        userDao.addUser(parameters: parameters, completionHandler: {(isRegistered) in
            if isRegistered {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name:"RestaurantInfo", bundle:nil)
                    let HomeViewController = storyboard.instantiateViewController(withIdentifier: "restaurantID") as! RestaurantInfoViewController
                    self.navigationController?.pushViewController(HomeViewController, animated: false)
                }
               
            
            }
            else {
            
            // add alert
                
                let alert = UIAlertController(title: "", message: "Error In Register,Try Again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        
        })
    }
   
   
    @IBAction func userNameEditingChange(_ sender: UITextField) {
        
    print(sender.text!)
    if(sender.text?.isEmpty)!{
    userNameValid = false;
    signUpView.userNameValidLabel.text = "Enter Valid Name"
    
    }
    else{
    userNameValid = true
    signUpView.userNameValidLabel.text = ""
    
    
    }
    enableSignUpBtn()

    }
  
    @IBAction func emailEditingEndAction(_ sender: UITextField) {
        
        if(sender.text?.isEmpty)!{
            emailValid = false;
            signUpView.emailLabel.text = "Enter Your Email"
            
        }
        else{
            
            signUpView.emailLabel.text = ""
            if isValidEmailAddress(emailAddressString: sender.text!){
                userDao.validateEmail(email: sender.text!, completionHandler: {(isEmailValid) in
                    DispatchQueue.main.async {
                        
                        if isEmailValid {
                            
                            
                            self.signUpView.emailLabel.text = "Email is Valid"
                            self.emailValid = true
                        }
                            
                            
                            
                        else
                        {
                            self.signUpView.emailLabel.text = "Email is not Valid"
                            self.emailValid = false
                        }
                    }
                    
                })
                
            }
            else{
            
                self.signUpView.emailLabel.text = "Enter a valid email"
                self.emailValid = false
            
            }
            
            
            
            
        }
        
        enableSignUpBtn()
    }
    

    @IBAction func passEditingChangeAction(_ sender: UITextField) {
        if(sender.text?.isEmpty)!{
            
            passValid = false;
            signUpView.passwordLabel.text = "Enter Your Password"
            
        }
        else{
            
           
            if isPasswordValid(sender.text!){
            signUpView.passwordLabel.text = ""
                passValid = true

            }
            else{
                signUpView.passwordLabel.text = "Enter A Valid Password"
                passValid = false
            }
            
        }
        enableSignUpBtn()
        
        
    }
    
    @IBAction func repeatedPassEditingChangeAction(_ sender: UITextField) {
        
        if(sender.text?.isEmpty)!{
            repeatPassValid = false;
            signUpView.repeatPassLabel.text = "Enter Your Password"
            
        }
        else{
            repeatPassValid = true
            signUpView.repeatPassLabel.text = ""
            
        }
        enableSignUpBtn()
        
    }
    @IBAction func signUpWithFacebookButton(_ sender: Any) {
      
    }
 
    @IBAction func signInButton(_ sender: Any) {

        userEmail = signInView.emailTxtField.text
        userPassword = signInView.passTxtField.text
        userDao.validateLogin(userEmail: userEmail!, password: userPassword!) {userFound in
            print(self.userEmail!)
            print(userFound!)
            if userFound! == "user is found"
            {
                   let storyboard = UIStoryboard(name: "RestaurantInfo", bundle: nil)
               let HomeViewController = storyboard.instantiateViewController(withIdentifier: "restaurantID") as! RestaurantInfoViewController
               self.navigationController?.pushViewController(HomeViewController, animated: false)
            }
            else{
                self.signInView.valdiatelabel.text = "email or password is wrong"
            }
        }
    }
   
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameValid = false
        emailValid = false
        passValid = false
        repeatPassValid = false
        
       
    }
  
    @IBOutlet weak var signUpBtn: UIButton!
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
    func enableSignUpBtn(){
    
        if emailValid && passValid && repeatPassValid && userNameValid {
        signUpBtn.isEnabled = true

        
        }
        else {
        signUpBtn.isEnabled = false
        
        }
        
    }
    func enableSignInBtn(){
    
    
    
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    
    
}

