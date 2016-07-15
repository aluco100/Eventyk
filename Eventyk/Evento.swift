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

public class Event: Object{
    private dynamic var Id: String = ""
    public dynamic var Name: String = ""
    public dynamic var Date: NSDate = NSDate()
    private var Participants = List<Friend>()
    public dynamic var Description: String = ""
    public dynamic var ShortDescription: String = ""
    public dynamic var Place: String = ""
    public dynamic var Zone: String = ""
    public dynamic var Type: String = ""
    public dynamic var IsDestacable: Bool = false
    public dynamic var Company: String = ""
    public dynamic var Link: String = ""
    public dynamic var Likehood: Preference? = nil
    public dynamic var imageNamed: String = ""
    
    convenience init(identificator: String,name: String, date: NSDate, descrip : String, shortDescrip: String, place: String, zone: String, type: String, isDestacable: Bool, company: String, link: String, likehood: Preference, image: String){
//        self.init(identificator: identificator, name: name, date: date, visitors: visitors, descrip: descrip, shortDescrip: shortDescrip, place: place, zone: zone, type: type, isDestacable: isDestacable, company: company, link: link, likehood: likehood, image: image)
        self.init()
        self.Id = identificator
        self.Name = name
        self.Date = date
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
    
    public func getParticipants()->List<Friend>{
        return self.Participants
    }
    
    
    //MARK: - Setter
    
    func setParticipants(success:()->Void){
        let provider = Provider()
        provider.getEventParticipants(self.getId(), success: {
            names in
            for i in names{
                print("Name: \(i)")
                self.Participants.append(i)
            }
            success()
        })
    }
    
    //MARK: - Main Methods
    
    
    //MARK: - REALM Methods
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
}