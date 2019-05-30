//
//  UIView.swift
//  Et3am
//
//  Created by Jets39 on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func setnetworkIndicator()
    {
       var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = self.center
        indicator.startAnimating()
        self.addSubview(indicator)
            }
}
