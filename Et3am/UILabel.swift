//
//  UITextView.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/20/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

extension UILabel {
    
    func showMessage(_ text: String) {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
            self.text = text
        }) { (bool) in
            UIView.animate(withDuration: 1, delay: 3.0, options: [.curveEaseInOut], animations: {
                self.alpha = 0
            }, completion: nil)
        }
    }
    
}
