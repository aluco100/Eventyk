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
//        BaseURL = "http://eeventyk-api.esy.es/"
        BaseURL = "http://eventyk.com/api/"
    }
    
    //MARK : - Sign In
    
    internal func signIn(user: String, pass: String, success: ()->Void, failure: () ->Void){
        
        let params = ["user": user, "pass": pass]
        
        Alamofire.request(.GET, "\(BaseURL)signin.php", parameters: params).responseJSON(completionHandler: {
            
            response in
            let data = response.result.value as! NSDictionary
            
            if let flag = data["success"] as? Int{
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
            
            success()
        })
        
    }
    
    internal func getPreferences(success: ([Preference])->Void){
        var preferencesResult: [Preference] = []
        
        Alamofire.request(.GET, "\(BaseURL)getPreferences.php").responseJSON(completionHandler: {
            response in
            
            let data = response.result.value as! NSArray
            for object in data{
                
                let dictionary = object as! NSDictionary
                
                if let name = dictionary["Nombre"] as? String{
                    
                    if let identificator = dictionary["idGustos"] as? String{
                        
                        let relatedPreference = Preference(identificator: identificator, name: name)
                        preferencesResult.append(relatedPreference)
                        
                    }
                }
            }
            success(preferencesResult)
        })
        
    }
    
    
    internal func getUserData(mail: String, pass: String,success: (User) -> Void){
        let params = ["user":mail, "pass": pass]
        Alamofire.request(.GET, "\(BaseURL)getUserData.php", parameters: params).responseJSON(completionHandler: {
            response in
            
            var userData:User
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let data = response.result.value as? NSDictionary{
                
                if let identificator = data["idUsuario"] as? String{
                    
                    if let name = data["Nombre"] as? String{
                        
                        if let birthdate = formatter.dateFromString(data["Fecha_Nacimiento"] as! String)! as NSDate?{
                            
                            if let city = data["Ciudad"] as? String{
                                
                                userData = User(identificator: identificator, email: mail, pass: pass, name: name, birthdate: birthdate, friendlist: [], gustos: [], city: city)
                                //TODO: set preferences
                                success(userData)
                                
                            }
                        }
                    }
                }
            }
            
            
        })
        
    }
    
    internal func getUserPreferences(relatedUser: User, success: ([Preference])->Void){
        
        //TODO: actualizar con Realm
        var prefs:[Preference] = []
        
        let params = ["idUser":relatedUser.getId()]
        
        Alamofire.request(.GET, "\(BaseURL)getUserPreferences.php", parameters: params).responseJSON(completionHandler: {
            response in
            let data = response.result.value as! NSArray
            for object in data{
                let dict = object as! NSDictionary
                if let identificator = dict["idGustos"] as? String{
                    if let name = dict["Nombre"] as? String{
                        let gusto = Preference(identificator: identificator, name: name)
                        prefs.append(gusto)
                    }
                }
            }
            success(prefs)
        })
    }
}