//
//  EVProfileViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import RealmSwift
import MBProgressHUD

class EVProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,EVProfileTableViewCellDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileUserName: UITextField!
    @IBOutlet var profileEmail: UITextField!
    @IBOutlet var profileBirthday: UITextField!
    @IBOutlet var likeHoodTableView: UITableView!
    @IBOutlet var saveProfileButton: UIButton!
    
    //MARK: - Global Variables
    
    var likehoods: [Preference] = []
    
    var datePickerView: UIDatePicker = UIDatePicker()
    
    var user: User? = nil
    
    var profileHUD: MBProgressHUD? = nil
    
    var EVManager: eventManager = eventManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Profile View Style
        
        self.profileView.layer.cornerRadius = 15.0
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.barStyle = .Black
        
        let realm = try! Realm()

        
        //Load User Data
        let users = realm.objects(User)
        
        for i in users{
            
            if(i.Logged){
                
                self.user = i
                break
                
            }
            
        }
        
        print("logged: \(self.user)")
        if(self.user!.FBLogged){
            self.saveProfileButton.enabled = false
        }else{
            self.saveProfileButton.enabled = true
        }

        
        //Load Preferences
        
        let preferences = realm.objects(Preference)
        
        for i in preferences{
            self.likehoods.append(i)
        }
        
        self.EVManager.reloadUserPreferences(self.user!, success: {
            self.likeHoodTableView.reloadData()
        })
                
        
        //Table View Settings
        
        self.likeHoodTableView.delegate = self
        self.likeHoodTableView.dataSource = self
        
        
        //Username textfield settings
        self.profileUserName.placeholder = user!.Name
        
        //Mail TextField Settings
        self.profileEmail.placeholder = user!.Mail
        self.profileEmail.keyboardType = .EmailAddress
        
        //Birthday TextField Settings
        let birthdateFormatter = NSDateFormatter()
        birthdateFormatter.locale = NSLocale.systemLocale()
        birthdateFormatter.dateFormat = "yyyy-MM-dd"
        self.profileBirthday.placeholder = birthdateFormatter.stringFromDate(self.user!.getBirthdate())
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EVProfileViewController.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.datePickerView = UIDatePicker(frame: CGRectMake(0, 200, view.frame.width, 300))
        self.datePickerView.addTarget(self, action: #selector(EVProfileViewController.birthdateChanged), forControlEvents: .ValueChanged)
        self.datePickerView.datePickerMode = .Date
        self.profileBirthday.inputView = self.datePickerView
        self.profileBirthday.inputAccessoryView = toolBar
        
        //Profile Image Settings
        
        self.profileImage.image = UIImage(named: "Profile")
        
        //Profile HUD Settings
        
        self.profileHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.profileHUD?.mode = .Indeterminate
        
        self.profileHUD?.labelText = "Cargando"
        
        self.profileHUD?.hidden = true
        

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
        return self.likehoods.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileIdentifier", forIndexPath: indexPath) as? EVProfileTableViewCell
        
        cell?.likehoodTitle.text = self.likehoods[indexPath.row].Nombre
        cell?.index = indexPath.row
        cell?.likehoodSwitch.on = self.likehoods[indexPath.row].Chosen
        cell?.delegate = self
        
        return cell!
    }
    
    //MARK: - Custom Cell Delegate
    
    func didSelectSwitch(atIndex: Int,cellSwitch: UISwitch) {
        //Code
        
        self.profileHUD?.hidden = false
        
        print(self.likehoods[atIndex].Nombre)
        
        let realm = try! Realm()
        
        let provider = Provider()
        
        provider.updateLikehood(self.user!.getId(), idLikehood: self.likehoods[atIndex].Id, switchFlag: cellSwitch.on, success: {
            //success
            
            try! realm.write({
                
                self.likehoods[atIndex].Chosen = cellSwitch.on
                
                realm.add(self.likehoods[atIndex], update: true)
                
                self.profileHUD?.hidden = true
            })
            
            
            }, failure: {
                //failure
                
                print("FAILURE!")
                self.profileHUD?.hidden = true
                
        })
        
        
        
    }
    
    
    //MARK: - Selectors
    
    func donePicker(){
        self.view.endEditing(true)
    }
    
    func birthdateChanged(){
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd"
        self.profileBirthday.text = formatter.stringFromDate(self.datePickerView.date)
        
    }

    //MARK: - IBActions
    
    @IBAction func SaveDataProfile(sender: AnyObject) {
        
        self.profileHUD?.hidden = false
        
        let userProfile = self.profileUserName.text != "" ? self.profileUserName.text : self.profileUserName.placeholder
        let mailProfile = self.profileEmail.text != "" ? self.profileEmail.text : self.profileEmail.placeholder
        let birthdayProfile = self.profileBirthday.text != "" ? self.profileBirthday.text : self.profileBirthday.placeholder
        
        let provider = Provider()
        
        provider.updateUserData(user!.getId(), user: userProfile!, mail: mailProfile!, date: birthdayProfile!, success: {
            
            let realm = try! Realm()
                        
            try! realm.write({
                
                self.user?.Name = userProfile!
                self.user?.Mail = mailProfile!
                
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale.systemLocale()
                formatter.dateFormat = "yyyy-MM-dd"
                self.user?.setUserBirthdate(formatter.dateFromString(birthdayProfile!)!)
                realm.add(self.user!, update: true)
                
                self.profileHUD?.hidden = true
                
            })
            
        })
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}
