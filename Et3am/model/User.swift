//
//  User.swift
//  Et3am
//
//  Created by Mohamed Korany Ali on 9/6/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import Foundation

enum VerificationStatus: Int {
    case notVerified, verified, pending, rejected
}

struct User: Equatable {
    
    var userID: String?
    var userName: String?
    var email: String?
    var password: String?
    var verified: VerificationStatus?
    var userStatus: Bool?
        
    //User Details Table in DB
    var mobileNumber: String?
    var profileImage: String?
    var nationalID: String?
    var job: String?
    var nationalID_Front: String?
    var nationalID_Back: String?
    var birthdate: Date?
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
                && lhs.userName == rhs.userName
                && lhs.email == rhs.email
                && lhs.verified == rhs.verified
                && lhs.userStatus == rhs.userStatus
                && lhs.mobileNumber == rhs.mobileNumber
                && lhs.profileImage == rhs.profileImage
                && lhs.nationalID == rhs.nationalID
                && lhs.job == rhs.job
                && lhs.nationalID_Front == rhs.nationalID_Front
                && lhs.nationalID_Back == rhs.nationalID_Back
        //TODO: Add birthdate to compare
    }
}
