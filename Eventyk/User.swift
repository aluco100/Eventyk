//
//  User.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift
public class User {
    private var UserId: String
    public var Name: String
    private var Password: String
    public var Mail: String
    private var Birthdate: NSDate
    private var Friends: [User]
    private var Gustos: [Preference]
    public var City: String
    
    init(identificator: String,email: String, pass: String, name: String, birthdate: NSDate, friendlist: [User],gustos: [Preference], city: String){
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
    }
    
    public func setUserPreferences(){
        
    }
}