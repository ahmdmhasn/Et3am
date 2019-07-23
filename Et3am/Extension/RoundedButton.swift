//
//  RoundedButton.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/21/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundedButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cornerRadius = self.bounds.height / 2
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.titleEdgeInsets.left = cornerRadius
        self.titleEdgeInsets.right = cornerRadius
    }
    
}
