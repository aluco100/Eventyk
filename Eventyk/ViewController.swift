//
//  ViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import pop 

class ViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate {

    //MARK: - Outlets
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var fbLogin: FBSDKLoginButton!
    
    
    //MARK: - Global Variables
    var hud: MBProgressHUD = MBProgressHUD()
    var fbUser: String = ""
    var fbMail: String = ""
    var fbFlag: Bool = false
    var User: String = ""
    var Pass: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Textfield Settings
        self.userTextField.delegate = self
        self.userTextField.keyboardType = .EmailAddress
        self.passTextField.delegate = self
        
        //Gesture Settings
        let textFieldGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyboard))
        self.view.addGestureRecognizer(textFieldGesture)
        
        //ProgressHud Settings
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Cargando"
        hud.hidden = true
        
        //Keyboard's Toolbar
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        toolbar.barStyle = .Default
        
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.okToolbar))]
        toolbar.sizeToFit()
        
        self.userTextField.inputAccessoryView = toolbar
        self.passTextField.inputAccessoryView = toolbar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            returnUserData({
                
                let provider = Provider()
                self.hud.hidden = false
                provider.registerFromFacebook(self.fbUser, email: self.fbMail, success: {
                    
                    self.hud.hidden = true
                    self.performSegueWithIdentifier("loginSigninSegue", sender: self)
                    
                
                })
            })
            
            
        }else{
            
            self.fbLogin.readPermissions = ["public_profile", "email", "user_friends"]
            self.fbLogin.delegate = self
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return .Default
        
    }
    
    //MARK: - TextField Delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
        
    }
    
    
    //MARK: - SignIn
    
    @IBAction func SignIn(sender: AnyObject) {
        
        hud.hidden = false
        
        let provider = Provider()
        
        provider.getPreferences({
            preferences in
            provider.signIn(self.userTextField.text!, pass: self.passTextField.text!, success: {
                
                print("access allowed")
                self.hud.hidden = true
                self.fbFlag = false
                self.User = self.userTextField.text!
                self.Pass = self.passTextField.text!
                self.performSegueWithIdentifier("loginSigninSegue", sender: self)
                
                }, failure: {
                    print("access denied")
                    self.hud.hidden = true
                    
            })
        })
        

        
    }
    
    //MARK: - Register
    
    @IBAction func goToRegister(sender: AnyObject) {
        self.performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    
    //MARK: - Events Methods
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: - Facebook Delegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                print("Loggin success!")
                self.performSegueWithIdentifier("loginSigninSegue", sender: self)
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //logout
    }

    func returnUserData(completion: ()->Void)
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                self.fbMail = userEmail as String
                self.fbUser = userName as String
                print("fbMail: \(self.fbMail) fbUser: \(self.fbUser)")
                self.fbFlag = true
                completion()
            }
        })
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "loginSigninSegue"){
            if let barViewControllers = segue.destinationViewController as? UITabBarController{
                if let navContr = barViewControllers.viewControllers![0] as? UINavigationController{
                    if let destination = navContr.viewControllers[0] as? EVHomeViewController{
                        if(self.fbFlag){
                            destination.Usuario = self.fbUser
                            destination.Mail = self.fbMail
                            destination.flagFB = true
                        }else{
                            destination.Usuario = self.User
                            destination.Pass = self.Pass
                            destination.flagFB = false
                        }

                    }
                    
                }
                
            }
            
        }
    }
    
    //MARK: - Unwind Segues Selector
    
    @IBAction func unwindLogOut(segue:UIStoryboardSegue){
        //code
        self.userTextField.text = ""
        self.passTextField.text = ""
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        
    }
    
    
    //MARK: - selector toolbar
    
    func okToolbar(){
        self.view.endEditing(true)
    }
}

