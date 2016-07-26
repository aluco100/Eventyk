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
    var homeEventsManager: eventManager = eventManager()
    
    //MARK: - Outlet Variables
    
    @IBOutlet var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facebook
        
        if(self.flagFB){
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
        
        
        //TableView Settings
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.separatorColor = UIColor.orangeColor()
        
        //navBar settings
        
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - Load Events Management
    
    override func viewDidAppear(animated: Bool) {
        
        self.homeHUD?.hidden = false
        
        self.homeEventsManager.getEvents({
            events in
            self.eventsStorage = events
            self.homeHUD?.hidden = true
            self.eventTableView.reloadData()
            
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
//        let baseUrl = "http://www.eventyk.com/events-media/"
//        let url = NSURL(string: "\(baseUrl)\(self.eventsStorage[indexPath.row].imageNamed)")
//        let data = NSData(contentsOfURL: url!)
//        cell.imageEvent.image = UIImage(data: data!)
//        cell.imageEvent.contentMode = .ScaleAspectFit
        
        //Title
        
        cell.titleEvent.text = self.eventsStorage[indexPath.row].Name
        
        //Date
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd"
        
        cell.dateEvent.text = formatter.stringFromDate(self.eventsStorage[indexPath.row].Date)
        
        //index
        
        cell.index = indexPath.row
        
        cell.delegate = self
        
        //Button
                
        for i in self.eventsStorage[indexPath.row].getParticipants(){
            if(i.getId() == self.relatedUser!.getId()){
                cell.asistButton.enabled = false
                break
            }else{
                cell.asistButton.enabled = true
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
    
    // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
