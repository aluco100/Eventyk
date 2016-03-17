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
    private var RelatedUser: Friend
    public var RelatedEvent: Event
    
    init(relatedUser: Friend, relatedEvent: Event){
        self.RelatedUser = relatedUser
        self.RelatedEvent = relatedEvent
    }
    
    //MARK: - Getter
    public func getUser()->Friend{
        return self.RelatedUser
    }
    
    //MARK: - Main Methods
}