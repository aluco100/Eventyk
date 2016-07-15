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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - View Settings
        self.eventView.layer.cornerRadius = 15.0
        self.eventDescription.layer.cornerRadius = 15.0
        self.gotoPage.layer.cornerRadius = 15.0
        
        //TODO: Encontrar el nuevo path del archivo
        
        //MARK: - Data Management
        //event Image
        let baseUrl = "http://www.eventyk.com/events-media/"
        let url = NSURL(string: "\(baseUrl)\(associatedEvent!.imageNamed)")
        let data = NSData(contentsOfURL: url!)
//        self.eventImageView.image = UIImage(data: data!)
//        self.eventImageView.contentMode = .ScaleAspectFit
        
        //event name
        self.eventTitle.text = associatedEvent?.Name
        
        //event likehood
        self.eventLikehood.text = self.associatedEvent?.Likehood?.Nombre
        
        //event date
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "dd-MM-yyyy"
        self.eventDate.text = formatter.stringFromDate(self.associatedEvent!.Date)
        
        //event place
        self.eventPlace.text = self.associatedEvent!.Place
        
        //event description
        self.eventDescription.text = self.associatedEvent!.Description

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBActions
    
    @IBAction func visitWebPage(sender: AnyObject) {
        
        let link = self.associatedEvent?.Link
        
        UIApplication.sharedApplication().openURL(NSURL(string: link!)!)
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
