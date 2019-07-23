//
//  UIView.swift
//  Et3am
//
//  Created by Jets39 on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setnetworkIndicator() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = self.center
        indicator.startAnimating()
        self.addSubview(indicator)
    }
}

extension UIView {

    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
                drawHierarchy(in: bounds, afterScreenUpdates: true)
            }
        } else {
            //TODO: solve it for earlier versions
            UIGraphicsBeginImageContextWithOptions(CGSize(width: (rect?.width)!, height: (rect?.height)!), true, 0.0)
            
            let window = UIApplication.shared.keyWindow
            
            window?.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            return img
        }
    }
}

