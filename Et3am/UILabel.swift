//
//  UITextView.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/20/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

extension UILabel {
    
    func showMessage(_ text: String, with color: UIColor) {
        UIView.animate(withDuration: 1, animations: {
            self.textColor = color
            self.isHidden = false
            self.alpha = 1
            self.text = text
        }) { (bool) in
            UIView.animate(withDuration: 1, delay: 3.0, options: [.curveEaseInOut], animations: {
                self.alpha = 0
                self.isHidden = true
            }, completion: nil)
        }
    }
    
}
