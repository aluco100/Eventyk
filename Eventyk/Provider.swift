//
//  Provider.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import Alamofire

class Provider {
    private var BaseURL: String
    
    init(){
        BaseURL = "http://eeventyk-api.esy.es/"
    }
    
    //MARK : - Sign In
    
    internal func signIn(user: String, pass: String, success: ()->Void, failure: () ->Void){
        
        let params = ["user": user, "pass": pass]
        
        Alamofire.request(.GET, "\(BaseURL)signin.php", parameters: params).responseJSON(completionHandler: {
            
            response in
            let data = response.result.value
            
            if let flag = data!["success"] as? Int{
                if(flag == 1){
                    success()
                }else{
                    failure()
                }
            }
                        
        })
        
    }
    
    //MARK: - Register
    
    internal func register(name: String, pass: String, mail: String, birthdate: String, city: String, success: ()->Void, failure: ()->Void){
        
        let params = ["name": name, "pass": pass, "birthdate": birthdate, "email": mail, "city": city]
        
        Alamofire.request(.POST, "\(BaseURL)register.php", parameters: params).responseJSON(completionHandler: {
            response in
//            print(response)
//            let data = response.result.value
//            
//            if let flag = data!["success"] as? Int{
//                if(flag == 1){
//                    success()
//                }else{
//                    failure()
//                }
//            }
            success()
        })
        
    }
    
}