//
//  Provider.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

//TODO: GET USER DATA CON FACEBOOK

import Foundation
import Alamofire
import RealmSwift

class Provider {
    private var BaseURL: String
    private var realm: Realm
    
    init(){
//        BaseURL = "http://eeventyk-api.esy.es/"
        BaseURL = "http://eventyk.com/api/"
        realm = try! Realm()
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
                        try! self.realm.write({
                            self.realm.add(relatedPreference, update: true)
                        })
                        preferencesResult.append(relatedPreference)
                        
                    }
                }
            }
            success(preferencesResult)
        })
        
    }
    
    //MARK: - Get User Data
    
    internal func getUserData(mail: String, pass: String,success: (User) -> Void){
        let params = ["user": mail, "pass": pass]
        Alamofire.request(.GET, "\(BaseURL)getUser.php", parameters: params).responseJSON(completionHandler: {
            response in
            
            var userData:User
            
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale.currentLocale()
            formatter.lenient = true
            formatter.dateFormat = "yyyy-MM-dd"
            
            print("response: \(response)")
            
            if let data = response.result.value as? NSDictionary{
                print("data: \(data)")
                
                if let identificator = data["idUsuario"] as? String{
                    
                    if let name = data["Nombre"] as? String{
                        
                        if let birthdate = formatter.dateFromString(data["Fecha_Nacimiento"] as! String) as NSDate?{
                            
                            if let city = data["Ciudad"] as? String{
                                
                                userData = User(identificator: identificator, email: mail, pass: pass, name: name, birthdate: birthdate, friendlist: [], gustos: [], city: city)
                                
                                //TODO: set preferences
                                userData.setUserPreferences({
                                    
                                    try! self.realm.write({
                                        self.realm.add(userData, update: true)
                                    })
                                    
                                    success(userData)
                                    return
                                })
                                
                                
                            }
                        }
                    }
                }
            }
            
            
        })
        
    }
    
    //MARK: - Get User Preferences
    
    internal func getUserPreferences(relatedUser: User, success: ([Preference])->Void){
        
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
    
    //MARK: - Get Events
    
    internal func getEvents(limit: Int,success: ([Event])->Void){
        var eventList: [Event] = []
        
        let params = ["limit": limit]
        
        Alamofire.request(.GET, "\(BaseURL)events.php", parameters: params).responseJSON(completionHandler: {
            response in
            
            let dataArray = response.result.value as! NSArray
            
            for objects in dataArray{
                if let dict = objects as? NSDictionary{
                    if let idEvent = dict["idEvento"] as? String, name = dict["Nombre"] as? String, date = dict["Fecha"] as? String, hour = dict["Hora_inicio"] as? String, descrip = dict["Descripcion"] as? String, shortDescrip = dict["BreveDescripcion"] as? String, place = dict["Lugar"] as? String, pref = dict["Gusto_evento"] as? String, zone = dict["Zona"] as? String, type = dict["Tipo"] as? String, isDestacable = dict["esDestacado"] as? String, link = dict["Link_Evento"] as? String, image = dict["Imagen"] as? String, company = dict["NombreEmpresa"] as? String{
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                        let flagDestacable = isDestacable == "1" ? true : false
                        
                        
                        let prefs = self.realm.objects(Preference).filter("Nombre = %@",pref)
                        
                        let likeHood = prefs.first!
                        
                        let event = Event(identificator: idEvent, name: name, date: dateFormatter.dateFromString("\(date) \(hour)")!, descrip: descrip, shortDescrip: shortDescrip, place: place, zone: zone, type: type, isDestacable: flagDestacable, company: company, link: link, likehood: likeHood, image: image)
                        
                        //Por ahora no necesita participantes, el controlador se encarga
                        event.setParticipants({
                            try! self.realm.write({
                                self.realm.add(event, update: true)
                            })
                            
                        })
                        eventList.append(event)
                        
                    }
                }
            }
            success(eventList)
        })
    }
    
    //MARK: - Get Event Participants
    
    internal func getEventParticipants(id: String,success:(List<Friend>)->Void){
        
        let names = List<Friend>()
        
        let params = ["idEvent": id]
        
        Alamofire.request(.GET, "\(BaseURL)getEventParticipants.php", parameters: params).responseJSON(completionHandler: {
            response in
            let dataArray = response.result.value as! NSArray
            
            for objectList in dataArray{
                if let dict = objectList as? NSDictionary{
                    if let user = dict["Nombre"] as? String, id = dict["idUsuario"] as? String{
                        let friend = Friend(id: id, name: user)
                        names.append(friend)
                    }
                }
            }
            success(names)
        })
        
    }
    
    //MARK: - Register From Facebook
    
    internal func registerFromFacebook(name: String, email: String, success:()->Void){
        let params = ["name":name,"user":email]
        
        Alamofire.request(.POST, "\(BaseURL)fbLogin.php", parameters: params).responseJSON(completionHandler: {
            response in
            
            success()
        })
        
    }
    
    //MARK: - Get User Data From Facebook
    
    internal func getUserDataFromFacebook(email: String, completion: (user: User)->Void){
        
        let params = ["user" : email]
        
        Alamofire.request(.GET, "\(BaseURL)fbUserData.php", parameters: params).responseJSON(completionHandler: {
            response in
            print(response.result.value)
            if let dataArray = response.result.value as? NSArray{
                if let dict = dataArray[0] as? NSDictionary{
                    print("dict")
                    let id = dict["idUsuario"] as! String
                    let name = dict["Nombre"] as! String
                    let email = dict["email"] as! String
                    let user = User(identificator: id, email: email, pass: "", name: name, birthdate: NSDate(), friendlist: [], gustos: [], city: "")
                    try! self.realm.write({
                        self.realm.add(user, update: true)
                        completion(user: user)
                    })
//                    if let id = dict["idUsuario"] as? Int, name = dict["Nombre"] as? String, email = dict["email"] as? String{
//                        print("ok")
//                        let user = User(identificator: id, email: email, pass: "", name: name, birthdate: NSDate(), friendlist: [], gustos: [], city: "")
//                        try! self.realm.write({
//                            self.realm.add(user, update: true)
//                            completion(user: user)
//                        })
//                    }

                }
                
            }
            
        })
    }
    
    //MARK: - Get Events From Likehood
    
    func getEventsFromLikehood(likehood: Preference,success: ([Event])->Void, failure: () -> Void){
        
        var eventList: [Event] = []
        
        let params = ["like": likehood.Nombre]
        
        Alamofire.request(.GET, "\(self.BaseURL)getEventsFromLikehood.php", parameters: params).responseJSON(completionHandler: {
            response in
            
            if let eventArray = response.result.value as? NSArray{
                
                
                for i in eventArray{
                    
                    if let dict = i as? NSDictionary{
                        
                        if let idEvent = dict["idEvento"] as? String, name = dict["Nombre"] as? String, date = dict["Fecha"] as? String, hour = dict["Hora_inicio"] as? String, descrip = dict["Descripcion"] as? String, shortDescrip = dict["BreveDescripcion"] as? String, place = dict["Lugar"] as? String, pref = dict["Gusto_evento"] as? String, zone = dict["Zona"] as? String, type = dict["Tipo"] as? String, isDestacable = dict["esDestacado"] as? String, link = dict["Link_Evento"] as? String, image = dict["Imagen"] as? String, company = dict["NombreEmpresa"] as? String{
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                            let flagDestacable = isDestacable == "1" ? true : false
                            
                            
                            let prefs = self.realm.objects(Preference).filter("Nombre = %@",pref)
                            
                            let likeHood = prefs.first!
                            
                            let event = Event(identificator: idEvent, name: name, date: dateFormatter.dateFromString("\(date) \(hour)")!, descrip: descrip, shortDescrip: shortDescrip, place: place, zone: zone, type: type, isDestacable: flagDestacable, company: company, link: link, likehood: likeHood, image: image)
                                                        
                            //Por ahora no necesita participantes, el controlador se encarga
                            event.setParticipants({
                                try! self.realm.write({
                                    self.realm.add(event, update: true)
                                })
                                
                            })
                            eventList.append(event)

                        
                    
                        }
                    

                    }
                
                }
            }
            
            if(eventList.count > 0){
                success(eventList)
            }else{
                failure()
            }
            
        })
        
    }
    
    //MARK: - Update User Data
    
    func updateUserData(id: String,user:String,mail:String, date: String, success:()->Void){
        
        let params = ["username":user,
                      "mail":mail,
                      "birthdate":date,
                      "id":id]
        
        Alamofire.request(.GET, "\(self.BaseURL)updateUserData.php", parameters: params).responseJSON(completionHandler: {
            
            response in
                        
            success()
        })
        
    }
    
}