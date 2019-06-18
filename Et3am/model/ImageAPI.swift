//
//  ImageAPI.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/18/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation

enum ImageTransformation: String {
    case original = ""
    case width150 = "w_150/"
    case width500 = "w_500/"
    case profile_r250 = "w_250,h_250,c_fill,r_125/"
}

struct ImageAPI {
    private static let key = "hngqi3qgk"
    private static let baseURL = "https://res.cloudinary.com/"
    
    static func getImage(type: ImageTransformation, publicId: String) -> String {
        let imageUrl = "\(baseURL)\(key)/image/upload/"
        return imageUrl + type.rawValue + publicId
    }
}
