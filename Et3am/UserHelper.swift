//
//  helper.swift
//  Et3am
//
//  Created by Jets39 on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserProperties: String {
    case userId, userName, userEmail, password, verified, userStatus, mobileNumber, profileImage, nationalId, job, nationalIdFront, nationalIdBack, birthdate, userDetailses
}

class UserHelper: NSObject {    
    
    class func parseUser(json: JSON) -> User {
        let user = User()
        
        user.userID = json[UserProperties.userId.rawValue].string
        user.userName = json[UserProperties.userName.rawValue].string
        user.email = json[UserProperties.userEmail.rawValue].string
        user.password = json[UserProperties.password.rawValue].string
        user.verified = (json[UserProperties.verified.rawValue].int == 1) ? true : false
        user.userStatus = (json[UserProperties.userStatus.rawValue].int == 1) ? true : false
        
        let details = json[UserProperties.userDetailses.rawValue][0]
        user.nationalID = details[UserProperties.nationalId.rawValue].string
        user.nationalID_Front = details[UserProperties.nationalIdFront.rawValue].string
        user.nationalID_Back = details[UserProperties.nationalIdBack.rawValue].string
        user.mobileNumber = details[UserProperties.mobileNumber.rawValue].string
        user.job = details[UserProperties.job.rawValue].string
        //TODO: - Convert date string to date
//        user.birthdate = Date(details[UserProperties.birthdate.rawValue].string)
        user.profileImage = details[UserProperties.profileImage.rawValue].string
        
        return user
    }
    
    class func getUser_Id() ->String? {
        let def = UserDefaults.standard
        return def.string(forKey: "userId")
    }
    
}
