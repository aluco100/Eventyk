//
//  User.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

//TODO: Collection types in Realm

import Foundation
import RealmSwift
public class User: Object {
    private dynamic var UserId: String = ""
    public dynamic var Name: String = ""
    private dynamic var Password: String = ""
    public dynamic var Mail: String = ""
    private dynamic var Birthdate: NSDate = NSDate()
    private var Friends: [Friend] = []
    private var Gustos: [Preference] = []
    public dynamic var City: String = ""
    
    convenience init(identificator: String,email: String, pass: String, name: String, birthdate: NSDate, friendlist: [Friend],gustos: [Preference], city: String){
        
        self.init(identificator: identificator, email: email, pass: pass, name: name, birthdate: birthdate, friendlist: friendlist, gustos: gustos, city: city)
        
        //User initial configuration
        self.UserId = identificator
        self.Mail = email
        self.Password = pass
        self.Name = name
        self.Birthdate = birthdate
        self.Friends = friendlist
        self.Gustos = gustos
        self.City = city
        
    }
    
    //MARK: - Getter and Setter
    
    public func getId()->String{
        return self.UserId
    }
    
    public func setUserFriends(){
        //code
        /*
        NOTE: Function only allows with facebook
        */
    }
    
    public func setUserPreferences(success:()->Void){
        let provider = Provider()
        
        provider.getUserPreferences(self, success: {
            
            preferences in
            self.Gustos = preferences
            success()
            
        })
    }
    
    //MARK: - Realm methods
    
    override public static func primaryKey() -> String? {
        return "UserId"
    }
}