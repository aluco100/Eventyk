//
//  EVHomeViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftCarousel
class EVHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,EVHomeTableViewCellDelegate{

    //MARK: - Global Variables
    var User: String = ""
    var Mail: String = ""
    var Pass: String = ""
    var flagFB: Bool = false
    
    var eventsStorage:[Event] = []
    
    var selectedEvent: Event? = nil
    var selectedLikehood: String? = nil
    
    //MARK: - Outlet Variables
    
    @IBOutlet var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User: \(self.User) mail: \(self.Mail) flag: \(flagFB)")
        
        let realm = try! Realm()
        
        
        //MARK: - Event Management
        
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
                self.eventTableView.reloadData()
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
                    self.eventTableView.reloadData()
                })
                
            }
            
        })
        
        //MARK: - Facebook
        
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
        
        
        //MARK: - Initial event by default
        
        self.selectedEvent = self.eventsStorage.first
        
        //MARK: - TableView Settings
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.separatorColor = UIColor.orangeColor()
        self.eventTableView.reloadData()
        
        //MARK: - navBar settings
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    //MARK: - Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsStorage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventIdentifier", forIndexPath: indexPath) as! EVHomeTableViewCell
        
        //TODO: cambio de url + hacer que no se laguee el table view
        //event Image
        let baseUrl = "http://www.eventyk.com/events-media/"
        let url = NSURL(string: "\(baseUrl)\(self.eventsStorage[indexPath.row].imageNamed)")
        let data = NSData(contentsOfURL: url!)
//        cell.imageEvent.image = UIImage(data: data!)
//        cell.imageEvent.contentMode = .ScaleAspectFit
        
        //Title
        
        cell.titleEvent.text = self.eventsStorage[indexPath.row].Name
        
        //Date
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateStyle = .FullStyle
        
        cell.dateEvent.text = formatter.stringFromDate(self.eventsStorage[indexPath.row].Date)
        
        //index
        
        cell.index = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: - Custom Cell Delegate
    
    func seeMore(eventAtIndex: Int) {
        self.selectedEvent = self.eventsStorage[eventAtIndex]
        self.performSegueWithIdentifier("detailsSegue", sender: self)
    }
    
    func asistToEvent(eventAtIndex: Int) {
        self.selectedEvent = self.eventsStorage[eventAtIndex]
    }
    
    func seeAsistPeople(eventAtIndex: Int) {
        self.selectedEvent = self.eventsStorage[eventAtIndex]
    }
    
    
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
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "detailsSegue"){
            if let destination = segue.destinationViewController as? EVDetailsViewController{
                if(self.selectedEvent != nil){
                    destination.associatedEvent = self.selectedEvent
                }
            }
        }
     }
    
}
