//
//  Et3amAPI.swift
//  Et3am
//
//  Created by Jets39 on 5/15/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation

enum UserURLQueries:String {
    case add = "/add"
    case list = "/list"
    case validateEmail="/validate/userEmail"
    case validateName="/validate/userName"
    case loginValidation = "/validate/login"
    case update = "/update"
    case updatePassword = "/update/password"
    case getUser = "/u"
    
    func getUrl() -> String {
        
        let baseUrl = "https://et3am.herokuapp.com"
        let baseUserUrl = "\(baseUrl)/user\(self.rawValue)/"
        
        guard let userID = UserDao.shared.user.userID else {
            fatalError("User ID cannot be nil")
        }
        
        switch self {
        case .updatePassword:
            return baseUserUrl + userID
        case .getUser:
            return baseUserUrl + userID
        default:
            return ""
        }
    }
}

enum QueryItems: String {
    case emailQuery = "email"
    case passwordQuery = "password"
    case stringParam = "string"
}

enum ChangePassword: String {
    case oldPassword = "oldPass"
    case newPassword = "newPass"
}

enum CouponURLQueries:String {
    case add = "/add"
    case user_idQuery = "user_id"
    case value_50Query = "value_50"
    case value_100Query = "value_100"
    case value_200Query = "value_200"
    case used_coupon = "/user_used_coupon"
}

enum RestaurantQueries:String {
    case rest = "/rest"
    case meals = "/meals"
    case list = "/list"
}

struct Et3amAPI {
    private static let baseUrlString = "https://et3am.herokuapp.com"
    static let baseUserUrlString = "\(baseUrlString)/user"
    static let baseCouponUrlString = "\(baseUrlString)/coupon"
    static let baseRestaurantUrlString = "\(baseUrlString)/restaurant/"
}

