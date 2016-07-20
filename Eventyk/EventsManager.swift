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
        
        if(prefs.count < 0){
            
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
        
        getPrefs({
            let events = realm.objects(Event)
            let provider = Provider()
            
            if(events.count > 0){
                //return events
                print("Ya tengo")
                print("Events:  \(events)")
                for i in events{
                    //append events
                    if(i.Likehood!.Chosen){
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
                        if(i.Likehood!.Chosen){
                            self.eventsStorage.append(i)
                        }
                    }
                    success(events: self.eventsStorage)
                })
                
            }
            
        })

        
    }
    
}