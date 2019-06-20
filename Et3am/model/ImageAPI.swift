//
//  ImageAPI.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 6/18/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ImageTransformation: String {
    case original = ""
    case width150 = "w_150/"
    case width500 = "w_500/"
    case profile_r250 = "w_250,h_250,c_fill,r_125/"
}

class ImageAPI {
    private static let key = "hngqi3qgk"
    private static let baseURL = "https://res.cloudinary.com/"
    
    static func getImage(type: ImageTransformation, publicId: String) -> String {
        let imageUrl = "\(baseURL)\(key)/image/upload/"
        return imageUrl + type.rawValue + publicId
    }
    
    static func uploadImage(imgData: Data, completionHandler: @escaping (Int?, String?) -> Void) {
        
        let url = "https://et3am.herokuapp.com/image/fileupload"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    guard let result = response.result.value else {
                        return
                    }
                    
                    let json = JSON(result)
                    let code = json["code"].int
                    let imageId = json["image"]["public_id"].string
                    completionHandler(code, imageId)
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(0, nil)
            }
        }
        
    }
}
