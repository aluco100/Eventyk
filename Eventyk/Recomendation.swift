//
//  Recomendation.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift

public class Recomendation {
    private var RelatedUser: User
    public var RelatedEvent: Event
    
    init(relatedUser: User, relatedEvent: Event){
        self.RelatedUser = relatedUser
        self.RelatedEvent = relatedEvent
    }
    
    //MARK: - Getter
    public func getUser()->User{
        return self.RelatedUser
    }
    
    //MARK: - Main Methods
}