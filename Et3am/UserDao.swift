//
//  UserDao.swift
//  Et3am
//
//  Created by Jets39 on 5/15/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIResponse {
    case success(Int)
    case failure(Error)
}

class UserDao{
    
    public static let shared = UserDao()
    
    let userDefaults = UserDefaults.standard
    
    private init() {
        self.user = getUserFromUserDefaults()
    }
    
    var user = User() {
        didSet {
            if oldValue != user {
                updateUserDetails(completionHandler: { if $0 == 1 { self.addToUserDefaults(self.user)} })
            }
        }
    }
    
    public  func addUser(parameters : [String:String], completionHandler:@escaping (Bool) -> Void) {
        
        var isRegistered:Bool = false
        Alamofire.request(Et3amAPI.baseUserUrlString + UserURLQueries.add.rawValue, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                
                print(value)
                
                let json = JSON(value)
                guard let code = json["status"].int else {
                    return
                }
                
                if code == 1 {

                    self.user = UserHelper.parseUser(json: json["user"])
                    
                    isRegistered = true
                    
                    self.addToUserDefaults(self.user)
                }
                
            case .failure(let error):
                print(error)
            }
            
            completionHandler(isRegistered)
            
        }
    }
    
    func validateUsername(username: String, completionHandler: @escaping (Bool) -> Void ) {
        
        var urlComponents = URLComponents(string: Et3amAPI.baseUserUrlString + UserURLQueries.validateName.rawValue)
        
        urlComponents?.queryItems = [URLQueryItem(name: QueryItems.stringParam.rawValue, value: username)]
        
        let url = urlComponents?.url
        
        Alamofire.request(url!).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let code = (json["code"].int == 1) ? true : false
                completionHandler(code)
                
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    func validateEmail(email: String, completionHandler: @escaping (Bool) -> Void ) {
        
        var urlComponents = URLComponents(string: Et3amAPI.baseUserUrlString + UserURLQueries.validateEmail.rawValue)
        
        urlComponents?.queryItems = [URLQueryItem(name: QueryItems.stringParam.rawValue, value: email)]
        
        let url = urlComponents?.url
        
        Alamofire.request(url!).validate(statusCode: 200..<500).responseJSON{
            response in
            
            var isEmailValid: Bool = false
                        
            switch response.result {
            case .success:
                let sucessDataValue = response.result.value
                let returnedData = sucessDataValue as! NSDictionary
                let code = returnedData.value(forKey: "code")! as! Int
                if(code == 1){
                    isEmailValid = true
                } else {
                    isEmailValid = false
                }
                
            case .failure(let error):
                print(error)
            }
            
            completionHandler(isEmailValid)
            
        }
    }
    
    // User to update user details and verify user
    func updateUserDetails(type: UserURLQueries = .update, completionHandler: @escaping (Int) -> Void) {
        
        let url = URLComponents(string: type.getUrl())
        
        let user = self.user
        
        let parameters: [String : Any] = [UserProperties.mobileNumber.rawValue: user.mobileNumber ?? "",
                          UserProperties.nationalId.rawValue: user.nationalID ?? "",
                          UserProperties.job.rawValue: user.job ?? "",
                          UserProperties.nationalIdFront.rawValue: user.nationalID_Front ?? "",
                          UserProperties.nationalIdBack.rawValue: user.nationalID_Back ?? "",
                          UserProperties.profileImage.rawValue: user.profileImage ?? ""/*,
                          UserProperties.birthdate.rawValue: user.birthdate ?? Date()*/]
        
        Alamofire.request(url!, method: .put, parameters: parameters, encoding: JSONEncoding.default,
                          headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let code = json["status"].int {
                    completionHandler(code)
                } else {
                    completionHandler(0)
                }
            case .failure(let error):
                print(error)
                completionHandler(0)
            }
            
        }
        
    }
    
    func updateUserPassword(oldPass: String, newPass: String, completionHandler: @escaping (Int) -> Void ) {
        
        var url = URLComponents(string: UserURLQueries.updatePassword.getUrl())
        
        url?.queryItems = [URLQueryItem(name: ChangePassword.oldPassword.rawValue, value: oldPass), URLQueryItem(name: ChangePassword.newPassword.rawValue, value: newPass)]
        
        Alamofire.request(url!, method: .put).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let code = json["status"].int {
                    completionHandler(code)
                } else {
                    completionHandler(0)
                }
                
            case .failure(let error):
                print(error)
                completionHandler(0)
            }
        }
    }
    
    func getUserData(completionHandler: @escaping (Int) -> Void) {
        
        Alamofire.request(UserURLQueries.getUser.getUrl()).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                
                guard let code = json["status"].int else {
                    print("Status doesn't exist!")
                    return
                }
                
                if code == 1 {
                    self.user = UserHelper.parseUser(json: json["user"])
                    
                    self.addToUserDefaults(self.user)
                }
                
                completionHandler(code)
                
            case .failure(let error):
                print(error)
                completionHandler(0)
            }
        }
        
    }
    
    func getUserSummaryData(completionHandler: @escaping (UserSummary?) -> Void) {
        
        Alamofire.request(UserURLQueries.summary.getUrl()).responseJSON { (response) in
            
            print(response.result.value ?? "123")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                guard let code = json["status"].int else {
                    print("Status doesn't exist!")
                    return
                }
                
                if code == 1 {
                    let summary = UserHelper.parseUserSummary(json: json["summary"])
                    completionHandler(summary)
                } else {
                    completionHandler(nil)
                }
                
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }

    
    func validateLogin(userEmail:String, password:String, completionHandler:@escaping (APIResponse)->Void) {
        
        var urlComponents = URLComponents(string: Et3amAPI.baseUserUrlString + UserURLQueries.loginValidation.rawValue)
        
        urlComponents?.queryItems = [URLQueryItem(name: QueryItems.emailQuery.rawValue, value:userEmail), URLQueryItem(name: QueryItems.passwordQuery.rawValue, value:password)]
        
        Alamofire.request((urlComponents?.url!)!).validate(statusCode: 200..<500).responseJSON{
            response in
            
            switch response.result {
            case .success:
                
                guard let responseValue = response.result.value else {
                    return
                }
                
                let json = JSON(responseValue)
                let code: Int =  json["code"].int ?? 0
                
                if code == 1 {
                    
                    //Parse user json
                    self.user = UserHelper.parseUser(json: json["user"])
                    
                    //Add user to user defaults
                    self.addToUserDefaults(self.user)
                    
                } else {
                    
                    print("Username/ password doesn't match or user doesn't exist!")
                    
                }
                
                completionHandler(.success(code))
                
            case .failure(let error):
                print("Connection error: \(error)")
                completionHandler(.failure(error))
            }
            
        }
    }
    
    func addToUserDefaults(_ user: User) {
        
        userDefaults.set(user.userID, forKey: UserProperties.userId.rawValue)
        userDefaults.set(user.userName, forKey: UserProperties.userName.rawValue)
        userDefaults.set(user.email, forKey: UserProperties.userEmail.rawValue)
        userDefaults.set(user.password, forKey: UserProperties.password.rawValue)
        userDefaults.set(user.verified?.rawValue, forKey: UserProperties.verified.rawValue)
        userDefaults.set(user.userStatus, forKey: UserProperties.userStatus.rawValue)
        
        userDefaults.set(user.mobileNumber, forKey: UserProperties.mobileNumber.rawValue)
        userDefaults.set(user.profileImage, forKey: UserProperties.profileImage.rawValue)
        userDefaults.set(user.nationalID, forKey: UserProperties.nationalIdFront.rawValue)
        userDefaults.set(user.job, forKey: UserProperties.job.rawValue)
        userDefaults.set(user.nationalID_Front, forKey: UserProperties.nationalIdFront.rawValue)
        userDefaults.set(user.nationalID_Back, forKey: UserProperties.nationalIdBack.rawValue)
        userDefaults.set(user.birthdate, forKey: UserProperties.birthdate.rawValue)
    }
    
    func getUserFromUserDefaults() -> User {
        var user = User()
        
        user.userID = userDefaults.object(forKey: UserProperties.userId.rawValue) as? String
        user.userName = userDefaults.object(forKey: UserProperties.userName.rawValue) as? String
        user.email = userDefaults.object(forKey: UserProperties.userEmail.rawValue) as? String
        user.password = userDefaults.object(forKey: UserProperties.password.rawValue) as? String
        user.userStatus = userDefaults.object(forKey: UserProperties.userStatus.rawValue) as? Bool
        
        let verifiedTemp = userDefaults.object(forKey: UserProperties.verified.rawValue) as? Int
        user.verified = VerificationStatus(rawValue: verifiedTemp ?? 0)
        
        user.mobileNumber = userDefaults.object(forKey: UserProperties.mobileNumber.rawValue) as? String
        user.profileImage = userDefaults.object(forKey: UserProperties.profileImage.rawValue) as? String
        user.nationalID = userDefaults.object(forKey: UserProperties.nationalId.rawValue) as? String
        user.job = userDefaults.object(forKey: UserProperties.job.rawValue) as? String
        user.nationalID_Front = userDefaults.object(forKey: UserProperties.nationalIdFront.rawValue) as? String
        user.nationalID_Back = userDefaults.object(forKey: UserProperties.nationalIdBack.rawValue) as? String
        user.birthdate = userDefaults.object(forKey: UserProperties.birthdate.rawValue) as? Date
        
        return user
    }
    
    func removeUserFromUserDefaults() {
        
        userDefaults.removeObject(forKey: UserProperties.userId.rawValue)
        userDefaults.removeObject(forKey: UserProperties.userName.rawValue)
        userDefaults.removeObject(forKey: UserProperties.userEmail.rawValue)
        userDefaults.removeObject(forKey: UserProperties.password.rawValue)
        userDefaults.removeObject(forKey: UserProperties.verified.rawValue)
        userDefaults.removeObject(forKey: UserProperties.userStatus.rawValue)
        
        userDefaults.removeObject(forKey: UserProperties.mobileNumber.rawValue)
        userDefaults.removeObject(forKey: UserProperties.profileImage.rawValue)
        userDefaults.removeObject(forKey: UserProperties.nationalIdFront.rawValue)
        userDefaults.removeObject(forKey: UserProperties.job.rawValue)
        userDefaults.removeObject(forKey: UserProperties.nationalIdFront.rawValue)
        userDefaults.removeObject(forKey: UserProperties.nationalIdBack.rawValue)
        userDefaults.removeObject(forKey: UserProperties.birthdate.rawValue)
    }
}
