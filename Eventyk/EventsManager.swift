//
//  EventsManager.swift
//  Eventyk
//
//  Created by Alfredo Luco on 20-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import Foundation
import RealmSwift

public class eventManager {
    
    public var eventsStorage: [Event]
    
    init(){
        self.eventsStorage = []
    }
    
    //MARK: - Methods
    
    public func getPrefs(success:()->Void){
        
        let realm = try! Realm()
        
        let prefs = realm.objects(Preference)
        
        
        if(prefs.count <= 0){
            
            let provider = Provider()
            
            provider.getPreferences({
                prefs in
                success()
                
            })

        }else{
            success()
        }
    }
    
    public func getEvents(success:(events:[Event])->Void){
        
        let realm = try! Realm()
        self.eventsStorage = []
        
        //verificar si se tiene seteado el perfil
        
        let preferences = realm.objects(Preference)
        
        var chosens: [Preference] = []
        
        for i in preferences{
            
            if i.Chosen{
                chosens.append(i)
            }
            
        }
        
        //obtener eventos
        self.getPrefs({
            let events = realm.objects(Event)
            let provider = Provider()
            
            if(events.count > 0){
                //return events
                print("Ya tengo")
                print("Events:  \(events)")
                for i in events{
                    //append events
                    if(i.Likehood!.Chosen && chosens.count > 0){
                        self.eventsStorage.append(i)
                    }else{
                        self.eventsStorage.append(i)
                    }
                }
                success(events: self.eventsStorage)
            }else{
                
                provider.getEvents(10, success: {
                    events in
                    print("No tengo")
                    print("Events: \(events)")
                    
                    for i in events{
                        if(i.Likehood!.Chosen && chosens.count>0){
                            self.eventsStorage.append(i)
                        }else{
                            self.eventsStorage.append(i)
                        }
                    }
                    success(events: self.eventsStorage)
                })
                
            }
            
        })

        
    }
    
    func reloadUserPreferences(relatedUser: User, success: ()->Void){
        
        let provider = Provider()
        let realm = try! Realm()
        let preferences = realm.objects(Preference)
        
        provider.getUserPreferences(relatedUser, success: {
            prefs in
            for i in preferences{
                
                for j in prefs{
                    if(j.Id == i.Id){
                        try!realm.write({
                            i.Chosen = true
                            realm.add(i, update: true)
                            if(i == preferences.last){
                                success()
                            }
                        })
                        break
                    }else{
                        try!realm.write({
                            i.Chosen = false
                            realm.add(i, update: true)
                            if(i == preferences.last){
                                success()
                            }
                        })
                        
                    }
                    
                }
            }
        })

    }
    
}