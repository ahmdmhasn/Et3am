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
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = self.center
        indicator.startAnimating()
        self.addSubview(indicator)
    }
}

extension UIView {
    
    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.
    
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

