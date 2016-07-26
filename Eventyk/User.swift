//
//  User.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//


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
    public dynamic var Logged: Bool = false
    public dynamic var FBLogged: Bool = false
    
    convenience init(identificator: String,email: String, pass: String, name: String, birthdate: NSDate, friendlist: [Friend],gustos: [Preference], city: String,fbFlag: Bool){
        
        self.init()
        
        //User initial configuration
        self.UserId = identificator
        self.Mail = email
        self.Password = pass
        self.Name = name
        self.Birthdate = birthdate
        self.Friends = friendlist
        self.Gustos = gustos
        self.City = city
        self.FBLogged = fbFlag
        
    }
    
    //MARK: - Getter and Setter
    
    public func getId()->String{
        return self.UserId
    }
    
    public func getBirthdate()->NSDate{
        return self.Birthdate
    }
    
    public func setUserBirthdate(date:NSDate){
        self.Birthdate = date
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