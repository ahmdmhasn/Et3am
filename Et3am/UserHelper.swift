//
//  helper.swift
//  Et3am
//
//  Created by Jets39 on 5/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class UserHelper: NSObject {

    class func addUserObjectIntoUserDefault(userObject : User) ->Void {
        UserDefaults.standard.set(userObject.userID, forKey: "userId")
        UserDefaults.standard.set(userObject.userName, forKey: "userName")
        UserDefaults.standard.set(userObject.email, forKey: "userEmail")
        UserDefaults.standard.set(userObject.password, forKey: "password")
        UserDefaults.standard.set(userObject.verified, forKey: "verified")
        
    }
    
    class func getUser_Id() ->String?
    {
        let def = UserDefaults.standard
        return def.string(forKey: "userId")
    }
    
}
