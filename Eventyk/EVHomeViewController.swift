//
//  EVHomeViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift

class EVHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK: - Global Variables
    var User: String = ""
    var Mail: String = ""
    var Pass: String = ""
    var flagFB: Bool = false
    
    var eventsStorage:[Event] = []
    
    //MARK: - Outlet Variables
    @IBOutlet var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User: \(self.User) mail: \(self.Mail) flag: \(flagFB)")
        
        let realm = try! Realm()
        
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        
        //load events
        
        getPrefs({
            let events = realm.objects(Event)
            let provider = Provider()
            
            if(events.count > 0){
                //return events
                print("Events:  \(events)")
                for i in events{
                    //append events
                    self.eventsStorage.append(i)
                }
            }else{
                
                
                provider.getEvents(10, success: {
                    events in
                    print("Events: \(events)")
                })
                
                
            }
            
        })
        
        if(self.flagFB){
            print("hola")
            let provider = Provider()
            provider.getUserDataFromFacebook(self.Mail, completion: {
                user in
                print("User from fb: \(user)")
                
            })
        }else{
            
            let provider = Provider()
            provider.getUserData(self.User, pass: self.Pass, success: {
                user in
                print("User from registration: \(user)")
            })
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsStorage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.eventsTableView.dequeueReusableCellWithIdentifier("eventIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = self.eventsStorage[indexPath.row].Name
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBActions
    
    @IBAction func logOut(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    //MARK: - Other Methods
    func getPrefs(success:()->Void){
        let realm = try! Realm()
        
        let prefs = realm.objects(Preference)
        
        if(prefs.count > 0){
            //return preferences
            print("Preferences: \(prefs)")
            success()
        }else{
            let provider = Provider()
            provider.getPreferences({
                prefs in
                print("Preferences: \(prefs)")
                success()
            })
        }

    }
}
