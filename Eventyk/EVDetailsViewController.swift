//
//  EVDetailsViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 25-06-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift

class EVDetailsViewController: UIViewController {

    var associatedEvent: Event? = nil
    var associatedLikehood: String? = nil
    
    //MARK: - IBOutlets
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventLikehood: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventPlace: UILabel!
    @IBOutlet var eventDescription: UITextView!
    
    //MARK: - IBOutlets views
    
    @IBOutlet var eventView: UIView!
    @IBOutlet var gotoPage: UIButton!
    
    //TODO: optionals types
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.eventView.layer.cornerRadius = 15.0
        self.eventDescription.layer.cornerRadius = 15.0
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "logo")!)
        self.gotoPage.layer.cornerRadius = 15.0
        
        //TODO: Encontrar el nuevo path del archivo
        //event Image
        let baseUrl = "http://www.eventyk.com/events-media/"
        let url = NSURL(string: "\(baseUrl)\(associatedEvent!.imageNamed)")
        let data = NSData(contentsOfURL: url!)
//        self.eventImageView.image = UIImage(data: data!)
//        self.eventImageView.contentMode = .ScaleAspectFit
        
        //event name
        self.eventTitle.text = associatedEvent?.Name
        
        //TODO: corregir bug
        //event likehood
        let realm = try!Realm()
        let event = realm.objects(Event).filter("Id = %@ ",self.associatedEvent!.getId()).first
        print(event)
        self.eventLikehood.text = event?.Likehood?.Nombre
        
        //event date
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "dd-MM-yyyy"
        self.eventDate.text = formatter.stringFromDate(self.associatedEvent!.Date)
        
        //event place
        self.eventPlace.text = self.associatedEvent!.Place
        
        //event description
        self.eventDescription.text = self.associatedEvent!.Description

        print(self.associatedEvent?.Name)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBActions
    
    @IBAction func visitWebPage(sender: AnyObject) {
        
        //code
        
        let link = self.associatedEvent?.Link
        
        UIApplication.sharedApplication().openURL(NSURL(string: link!)!)
        
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
