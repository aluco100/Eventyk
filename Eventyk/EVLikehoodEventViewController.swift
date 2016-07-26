//
//  EVLikehoodEventViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 16-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift
import MBProgressHUD

class EVLikehoodEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, EVHomeTableViewCellDelegate {

    
    //MARK: - IBOutlets
    @IBOutlet var likehoodEventTableView: UITableView!
    
    //MARK: - Global Variables
    
    var likehood: Preference? = nil
    
    var eventsStorage: [Event] = []
    
    var associatedEvent: Event? = nil
    
    var associatedFriends: [Friend] = []
    
    var relatedUser: User? = nil
    
    var likehoodEventHUD: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Table View Settings
        
        self.likehoodEventTableView.delegate = self
        self.likehoodEventTableView.dataSource = self
        self.likehoodEventTableView.separatorColor = UIColor.orangeColor()
        
        //Load the events
        
        let provider = Provider()
        
        provider.getEventsFromLikehood(self.likehood!, success: {
            events in
            
            print("Events from likehood: \(events)")
            
            self.eventsStorage = events
            
            //Load  the user
            
            let realm = try! Realm()
            
            let users = realm.objects(User)
            
            for i in users{
                
                if(i.Logged){
                    self.relatedUser = i
                    break
                }
                
            }
            self.likehoodEventTableView.reloadData()
            print(self.relatedUser)
            
            }, failure: {
                
                print("Failure")
                
        })
        
        
        
        //HUD Settings
        
        self.likehoodEventHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.likehoodEventHUD?.mode = .Indeterminate
        self.likehoodEventHUD?.labelText = "Cargando"
        self.likehoodEventHUD?.hidden = true
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("likehoodEventIdentifier", forIndexPath: indexPath) as! EVHomeTableViewCell
        
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
        
        print(self.eventsStorage[indexPath.row].getParticipants())
        
        for i in self.eventsStorage[indexPath.row].getParticipants(){
            print(i)
            if(i.getId() == self.relatedUser!.getId()){
                cell.asistButton.enabled = false
                break
            }else{
                cell.asistButton.enabled = true
            }
        }
        
        return cell
    }
    
    //MARK: - Custom Table View Cell Delegate
    
    func asistToEvent(eventAtIndex: Int) {
        
        self.likehoodEventHUD?.hidden = false
        
        self.associatedEvent = self.eventsStorage[eventAtIndex]
        
        let provider = Provider()
        
        provider.AsistToEvent(self.relatedUser!, event: self.associatedEvent!, success: {
            self.likehoodEventHUD?.hidden = true
            
            self.associatedEvent?.setParticipants({
                
            })
        })

    }
    
    func seeAsistPeople(eventAtIndex: Int) {
        
        self.associatedEvent = self.eventsStorage[eventAtIndex]
        self.associatedFriends = []
        
        let provider = Provider()
        
        provider.getEventParticipants(self.associatedEvent!.getId(), success: {
            friends in
            
            for i in friends{
                self.associatedFriends.append(i)
            }
            
            self.performSegueWithIdentifier("seeAsistPeopleSegue", sender: self)
            
        })

        
    }
    
    func seeMore(eventAtIndex: Int) {
        
        self.associatedEvent = self.eventsStorage[eventAtIndex]
        self.performSegueWithIdentifier("seeMoreSegue", sender: self)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "seeMoreSegue"){
            
            if let destination = segue.destinationViewController as? EVDetailsViewController{
                
                destination.associatedEvent = self.associatedEvent
                
            }
        }else if(segue.identifier == "seeAsistPeopleSegue"){
            
            if let destination = segue.destinationViewController as? EVParticipantsViewController{
                
                destination.participants = self.associatedFriends
                
            }
            
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func logout(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    

}
