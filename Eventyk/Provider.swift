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
    
}