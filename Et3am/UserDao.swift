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
    var status:String?
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
                          
                            break
                        case .failure(let error):
                            print(error)
                            self.status="failure"
                        }
                        
        }
     return status!
        
        
        
        
        
        
        
        
        
        
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
    
}
