//
//  User.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/6/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation


struct User {
    
    var userID: String?
    var userName: String?
    var email: String?
    var password: String?
    var verified: Bool?
    var userStatus: Bool?
    
    //User Details Table in DB
    var mobileNumber: String?
    var profileImage: String?
    var nationalID: String?
    var job: String?
    var nationalID_Front: String?
    var nationalID_Back: String?
    var birthdate: Date?
    
}
