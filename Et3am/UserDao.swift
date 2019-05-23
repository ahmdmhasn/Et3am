//
//  UserDao.swift
//  Et3am
//
//  Created by Jets39 on 5/15/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import Foundation
import Alamofire

class UserDao{
  var user = User()
    var status:String = ""
    public  func addUser(parameters : [String:String]) -> String
    
    {
         Alamofire.request(Et3amAPI.baseUrlString+UserURLQueries.add.rawValue,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: nil).responseJSON {
                        response in
                        switch response.result {
                        case .success:
                          let sucessDataValue = response.result.value
                            let returnedData = sucessDataValue as! NSDictionary
                          let userDataDictionary:NSDictionary =  returnedData.value(forKey: "user")! as! NSDictionary
                          
                          self.user.userID=userDataDictionary.value(forKey: "userId") as! String?
                          self.user.userName=userDataDictionary.value(forKey: "userName") as! String?
                          self.user.email=userDataDictionary.value(forKey: "userEmail") as! String?
                          self.user.password=userDataDictionary.value(forKey: "password") as! String?
                          self.user.verified=false
                          self.status = "sucess"
                          
                          self.addUserObjectIntoUserDefault(userObject: self.user)
                          
                            break
                        case .failure(let error):
                            print(error)
                            self.status="failure"
                        }
                        
        }
     return status
        
        
}
    func addUserObjectIntoUserDefault(userObject : User) ->Void
    {
      UserDefaults.standard.set(userObject.userName, forKey: "userName")
         UserDefaults.standard.set(userObject.email, forKey: "userEmail")
         UserDefaults.standard.set(userObject.password, forKey: "password")
         UserDefaults.standard.set(userObject.verified, forKey: "verified")
    }
    
    func validateEmail(email:String)->String
    {
        var emailFound : String!
        
        Alamofire.request(Et3amAPI.baseUrlString+UserURLQueries.validateEmail.rawValue+email).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                emailFound="Email Alrady Exist"
                break;
            case .failure:
                emailFound = ""
            }
            
        }
        
    return emailFound
    }
    func validateLogin(userEmail:String,password:String,completionHandler:@escaping (String?)->Void)->Void
    {
        
        var userFound : String!
        var urlComponents = URLComponents(string: Et3amAPI.baseUrlString+UserURLQueries.loginValidation.rawValue)
        urlComponents?.queryItems = [URLQueryItem(name: UserURLQueries.emailQuery.rawValue , value:userEmail),
        URLQueryItem(name: UserURLQueries.passwordQuery.rawValue , value:password)]
    
        Alamofire.request((urlComponents?.url!)!).validate().responseJSON{
            response in
          
            switch response.result {
            case .success:
                let sucessDataValue = response.result.value
                let returnedData = sucessDataValue as! NSDictionary
                let codeDataDictionary:Int =  returnedData.value(forKey: "code")! as! Int
                
                switch codeDataDictionary
                {
                case 1:
                    userFound = "user is found"
                    completionHandler(userFound)
                    let userDataDictionary:NSDictionary =  returnedData.value(forKey: "user")! as! NSDictionary
                    self.user.userID=userDataDictionary.value(forKey: "userId") as! String?
                    self.user.userName=userDataDictionary.value(forKey: "userName") as! String?
                    self.user.email=userDataDictionary.value(forKey: "userEmail") as! String?
                    self.user.password = password
                    self.user.verified=false
                    
                    if((UserDefaults.standard.string(forKey: "userEmail") == nil)){
                        self.addUserObjectIntoUserDefault(userObject: self.user)
                        
                    }

                    break
                    
                case 0:
                    userFound = "user is not found"
                    completionHandler(userFound)
                    break
                default:
                    break
                }
                
            case .failure:
                print("there is error in connection")
            }
            
        }
        
        
    }
    
    
}
