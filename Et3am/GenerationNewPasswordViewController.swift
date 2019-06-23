//
//  GenerationNewPasswordViewController.swift
//  Et3am
//
//  Created by Jets39 on 6/23/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class GenerationNewPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoginPage", sender: self)
    }

}
