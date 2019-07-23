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
    
    func fadeTo(alpha: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
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

extension UIView {
    
    func bindToKeyboard(withTapGesture: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if withTapGesture {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let cutFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        let targetFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let deltaY = ((targetFrame?.cgRectValue.origin.y)! - (cutFrame?.cgRectValue.origin.y)!)
        
        UIView.animateKeyframes(withDuration: duration!, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            
            self.frame.size.height += deltaY
            
        }, completion: nil)
    }
    
    @objc private func handleScreenTap (sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
}

