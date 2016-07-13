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
class EVHomeViewController: UIViewController ,SwiftCarouselDelegate{

    //MARK: - Global Variables
    var User: String = ""
    var Mail: String = ""
    var Pass: String = ""
    var flagFB: Bool = false
    
    var eventsStorage:[Event] = []
    
    var selectedEvent: Event? = nil
    var selectedLikehood: String? = nil
    
    //MARK: - Outlet Variables
    
    @IBOutlet var carouselView: UIView!
    @IBOutlet var carouselLabel: UILabel!
    
    var carousel: SwiftCarousel? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User: \(self.User) mail: \(self.Mail) flag: \(flagFB)")
        
        let realm = try! Realm()
        
        
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

        //MARK: - carousel of Images
        
        //TODO: Cuando me respondan de github solucionare el problema, el scroll es para un cierto tipo
        
        self.carousel = SwiftCarousel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 574, height: 455)))
        
        try! self.carousel!.itemsFactory(itemsCount: self.eventsStorage.count, factory: {
            choice in
            let baseUrl = "http://www.eventyk.com/events-media/"
            let url = NSURL(string: "\(baseUrl)\(self.eventsStorage[choice].imageNamed)")
            let data = NSData(contentsOfURL: url!)
            let imageView = UIImageView(image: UIImage(data: data!))
            imageView.frame = CGRect(x: 0.0, y: 0.0, width: 574, height: 455)
            print(imageView)
            return imageView
        })
        
        self.carousel!.resizeType = .VisibleItemsPerPage(1)
        self.carousel!.delegate = self
        self.carousel?.selectByTapEnabled = false
        self.carousel?.scrollType = .Freely
        self.carousel?.didSetDefaultIndex = false
        self.carouselView.addSubview(carousel!)
        self.carouselView.addSubview(self.carouselLabel)
        
        //MARK: - Initial event by default
        
        self.selectedEvent = self.eventsStorage.first
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func logOut(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func AsistToEvent(sender: AnyObject) {
        //code
        
        
        
    }
    
    @IBAction func seeMore(sender: AnyObject) {
        //code
        self.performSegueWithIdentifier("detailsSegue", sender: self)
    }
    
    @IBAction func seeAsistPeople(sender: AnyObject) {
        //code
    }
    
    
    //MARK: - SwiftCaroiusel Delegate
    
    func didSelectItem(item item: UIView, index: Int, tapped: Bool) -> UIView? {
        self.carouselLabel.text = self.eventsStorage[index].Name
        self.selectedEvent = self.eventsStorage[index]
        
        print(self.eventsStorage[index].Likehood)
        
//        self.selectedLikehood = self.eventsStorage[index].Likehood!.Nombre
        print(self.selectedEvent)
        return item
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
                    destination.associatedEvent?.Likehood = self.selectedEvent?.Likehood
//                    destination.associatedLikehood = self.selectedLikehood
                }
            }
        }
     }
    
}
