//
//  EVHomeViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift
import MBProgressHUD
class EVHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,EVHomeTableViewCellDelegate{

    //MARK: - Global Variables
    var Usuario: String = ""
    var Mail: String = ""
    var Pass: String = ""
    var flagFB: Bool = false
    
    var eventsStorage:[Event] = []
    
    var selectedEvent: Event? = nil
    var selectedLikehood: String? = nil
    var relatedUser: User? = nil
    var associatedFriends: [Friend] = []
    
    var homeHUD: MBProgressHUD? = nil
    
    //MARK: - Outlet Variables
    
    @IBOutlet var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User: \(self.Usuario) mail: \(self.Mail) flag: \(flagFB)")
        
        //MARK: - Facebook
        
        if(self.flagFB){
            print("hola")
            let provider = Provider()
            provider.getUserDataFromFacebook(self.Mail, completion: {
                user in
                self.relatedUser = user
                
                print("User from fb: \(user)")
                self.eventTableView.reloadData()
                
            })
        }else{
            
            let provider = Provider()
            provider.getUserData(self.Usuario, pass: self.Pass, success: {
                user in
                
                self.relatedUser = user
                
                print("User from registration: \(user)")
                self.eventTableView.reloadData()

            })
        }
        
        
        //MARK: - Initial event by default
        
        self.selectedEvent = self.eventsStorage.first
        
        //MARK: - TableView Settings
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.separatorColor = UIColor.orangeColor()
        
        //MARK: - navBar settings
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //Home HUD Settings
        
        self.homeHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.homeHUD?.mode = .Indeterminate
        
        self.homeHUD?.labelText = "Cargando"
        
        self.homeHUD?.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let realm = try! Realm()
        
        //MARK: - Event Management
        
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
        
        //Button
        
        for i in self.eventsStorage[indexPath.row].getParticipants(){
            if(i.getId() == self.relatedUser!.getId()){
                cell.asistButton.enabled = false
            }
        }
        
        return cell
    }
    
    
    //MARK: - Custom Cell Delegate
    
    func seeMore(eventAtIndex: Int) {
        self.selectedEvent = self.eventsStorage[eventAtIndex]
        self.performSegueWithIdentifier("detailsSegue", sender: self)
    }
    
    func asistToEvent(eventAtIndex: Int) {
        
        self.homeHUD?.hidden = false
        
        self.selectedEvent = self.eventsStorage[eventAtIndex]
        
        let provider = Provider()
        
        provider.AsistToEvent(self.relatedUser!, event: self.selectedEvent!, success: {
            self.homeHUD?.hidden = true
                        
            self.selectedEvent?.setParticipants({
                
            })
        })
        
    }
    
    func seeAsistPeople(eventAtIndex: Int) {
        
        self.selectedEvent = self.eventsStorage[eventAtIndex]
        self.associatedFriends = []
        
        let provider = Provider()
        
        provider.getEventParticipants(self.selectedEvent!.getId(), success: {
            friends in
            
            for i in friends{
                self.associatedFriends.append(i)
            }
            
            self.performSegueWithIdentifier("participantsSegue", sender: self)
            
        })
        
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
        }else if(segue.identifier == "participantsSegue"){
            if let destination = segue.destinationViewController as? EVParticipantsViewController{
                
                destination.participants = self.associatedFriends
                
            }
        }
     }
    
}
