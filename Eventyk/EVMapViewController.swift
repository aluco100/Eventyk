//
//  EVMapViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 27-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift
import MBProgressHUD

class EVMapViewController: UIViewController,MKMapViewDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var mapView: MKMapView!
    
    //MARK: - Global Variables
    var locationManager: CLLocationManager = CLLocationManager()
    var eventAnnotation: [MKAnnotation] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManager Settings
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //mapKitSettings
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        //add annotations
        
        let realm = try! Realm()
        
        let events = realm.objects(Event)
        
        for i in events{
            
            let address = i.Place
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, inRegion: nil, completionHandler: {
                (placemarks, error) in
                
                let placemark = placemarks![0]
                
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                
            })
            
        }

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
