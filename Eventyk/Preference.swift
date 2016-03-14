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

public class Preference {
    public var Id: String
    public var Nombre: String
    public var Chosen: Bool
    
    init(identificator: String, name: String){
        self.Id = identificator
        self.Nombre = name
        self.Chosen = false
    }
}