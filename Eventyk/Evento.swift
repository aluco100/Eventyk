//
//  Evento.swift
//  Eventyk
//
//  Created by Alfredo Luco on 13-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

public class Event {
    private var Id: String
    public var Name: String
    public var Date: NSDate
    private var Participants: [String]
    public var Description: String
    public var ShortDescription: String
    public var Place: String
    public var Zone: String
    public var Type: String
    public var IsDestacable: Bool
    public var Company: String
    public var Link: NSURL
    public var Likehood: Preference
    public var imageNamed: String
    
    init(identificator: String,name: String, date: NSDate, visitors: [String], descrip : String, shortDescrip: String, place: String, zone: String, type: String, isDestacable: Bool, company: String, link: NSURL, likehood: Preference, image: String){
        
        self.Id = identificator
        self.Name = name
        self.Date = date
        self.Participants = visitors
        self.Description = descrip
        self.ShortDescription = shortDescrip
        self.Place = place
        self.Zone = zone
        self.Type = type
        self.IsDestacable = isDestacable
        self.Company = company
        self.Link = link
        self.Likehood = likehood
        self.imageNamed = image
        
    }
    
    //MARK: - Getter
    
    public func getId()->String{
        return self.Id
    }
    
    public func getParticipants()->[String]{
        return self.Participants
    }
    
    //MARK: - Setter
    
    public func setParticipants(success:()->Void){
        let provider = Provider()
        provider.getEventParticipants(self, success: {
            names in
            self.Participants = names
            success()
        })
    }
    
    //MARK: - Main Methods
    
}