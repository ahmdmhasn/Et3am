//
//  Helper.swift
//  Et3am
//
//  Created by Wael M Elmahask on 11/12/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    class func generateQRCOde(barCode:String!) -> UIImage {
        guard let myString = barCode else { fatalError("image Not founded") }
        let data = myString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let image = filter?.outputImage?.applying(transform) {
            return UIImage(ciImage: image)
        }
        return UIImage()
    }

    
}
