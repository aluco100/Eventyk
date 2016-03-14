//
//  Preference.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

public class Preference: Object {
    public dynamic var Id: String = ""
    public dynamic var Nombre: String = ""
    public dynamic var Chosen: Bool = false
    
    convenience init(identificator: String, name: String){
        self.init()
        self.Id = identificator
        self.Nombre = name
        self.Chosen = false
    }
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
}