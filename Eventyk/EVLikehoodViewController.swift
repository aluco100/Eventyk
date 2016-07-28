//
//  EVLikehoodViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 14-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftCarousel

class EVLikehoodViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,EVLikehoodCollectionViewCellDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var carouselView: UIView!
    @IBOutlet var likehoodCollectionView: UICollectionView!
    @IBOutlet var seeMoreButton: UIButton!
    
    //MARK: - Global Variables
    
    var likehood: [Preference] = []
    var associatedLikehood: Preference? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the preferences
        
        let realm = try! Realm()
        
        let preferences = realm.objects(Preference)
        
        for i in preferences{
            
            self.likehood.append(i)
            
        }
                
        //CollectionView Setting
        
        self.likehoodCollectionView.delegate = self
        self.likehoodCollectionView.dataSource = self
        self.likehoodCollectionView.reloadData()
        
        //Button Style Settings
        self.seeMoreButton.backgroundColor = UIColor.orangeColor()
        self.seeMoreButton.layer.cornerRadius = 15.0
        
        //CarouselView Settings
        
        self.carouselView.layer.cornerRadius = 15.0
        
        //Navigation Style Settings
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        //TODO: - Cuando se suba la pagina configurar el carousel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Preferred Status Bar Style
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - Collection View Delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.likehood.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("likehoodIdentifier", forIndexPath: indexPath) as? EVLikehoodCollectionViewCell
        //Image
        let imageNamed = self.likehood[indexPath.row].Nombre
        
        cell?.likehoodImage.image = UIImage(named: imageNamed)
        
        //Title
        
        cell?.likehoodTitle.text = imageNamed
        
        //Delegate
        
        cell?.index = indexPath.row
        
        cell?.delegate = self
        
        return cell!
            
        
    }
    
    
    //MARK: - EVLikehoodCollectionView Delegate
    
    func didSelectLikehood(atIndex: Int) {
        //Code
        
        print(self.likehood[atIndex])
        
        self.associatedLikehood = self.likehood[atIndex]
        
        self.performSegueWithIdentifier("likehoodEventSegue", sender: self)
        
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "likehoodEventSegue"){
            
            if let destination = segue.destinationViewController as? EVLikehoodEventViewController{
                
                destination.likehood = self.associatedLikehood
                
            }
            
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func goToMap(sender: AnyObject) {
        self.performSegueWithIdentifier("mapSegue", sender: self)
    }
    
    
}
