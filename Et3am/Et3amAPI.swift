//
//  Et3amAPI.swift
//  Et3am
//
//  Created by Jets39 on 5/15/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
struct Et3amAPI
{
    static let baseUrlString = "https://et3am.herokuapp.com/user"
}
enum UserURLQueries:String
{
    case add = "/add"
    case list = "/list"
    case validateEmail="/validate/email/"
    case loginValidation = "/validate/login"
    case emailQuery = "email"
    case passwordQuery = "password"
}
