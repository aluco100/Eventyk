//
//  EVHomeViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift

class EVHomeViewController: UIViewController {

    //MARK: - Global Variables
    var User: String = ""
    var Pass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let prefs = realm.objects(Preference)
        
        if(prefs.count > 0){
            //return preferences
            print("Preferences: \(prefs)")
        }else{
            let provider = Provider()
            provider.getPreferences({
                prefs in
                print("Preferences: \(prefs)")
            })
        }
        
        //load events
        
        let events = realm.objects(Event)
        
        if(events.count > 0){
            //return events
            print("Events:  \(events)")
        }else{
            let provider = Provider()
            
            provider.getEvents(10, success: {
                events in
                print("Events: \(events)")
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
