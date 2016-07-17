//
//  Friend.swift
//  Eventyk
//
//  Created by Alfredo Luco on 14-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift

public class Friend: Object {
    private dynamic var Id: String = ""
    public dynamic var Name: String = ""
    
    convenience init(id:String, name: String){
        self.init()
        self.Id = id
        self.Name = name
    }
    
    //MARK: - Getter
    public func getId()->String{
        return self.Id
    }
    
    //MARK: - Realm Methods
    override public static func primaryKey() -> String? {
        return "Id"
    }
}