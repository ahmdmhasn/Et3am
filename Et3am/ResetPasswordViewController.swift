//
//  ResetPasswordViewController.swift
//  Et3am
//
//  Created by Jets39 on 6/22/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPasswordViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var valdiatelabel: UILabel!
   let userDao = UserDao.shared
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var userEmail: UITextField!
    @IBAction func generatenewPassword(_ sender: Any) {
            guard let userEmail = userEmail.text , !userEmail.isEmpty else {
            valdiatelabel.text = "Email is required!"
            return
            }
        
            SVProgressHUD.show()
            userDao.resetPassword(userEmail: userEmail){
            response in
               SVProgressHUD.dismiss()
            switch response
            {
        
            case .success(let status):
            if status == 1
            {
            self.performSegue(withIdentifier: "showgenerationNewPassword", sender: self)
            } else {
           self.valdiatelabel.text = "Email is not exist"
            }
            case .failure(let error):
    self.valdiatelabel.text = "Something went wrong, please try again later."
            print(error)
            
            }
            
            }

    }
  
}
