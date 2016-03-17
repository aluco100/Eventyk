//
//  ViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit
import Alamofire
import pop
import MBProgressHUD

class ViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate {

    //Outlets
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    @IBOutlet var fbLogin: FBSDKLoginButton!
    //global variables
    var hud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textfield delegate
        self.userTextField.delegate = self
        self.userTextField.keyboardType = .EmailAddress
        self.passTextField.delegate = self
        
        //gesture
        let textFieldGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(textFieldGesture)
        
        //hud
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Cargando"
        hud.hidden = true
        
        //Facebook 
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
            self.performSegueWithIdentifier("loginSigninSegue", sender: self)
        }else{
            self.fbLogin.readPermissions = ["public_profile", "email", "user_friends"]
            self.fbLogin.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
            self.performSegueWithIdentifier("loginSigninSegue", sender: self)
        }else{
            self.fbLogin.readPermissions = ["public_profile", "email", "user_friends"]
            self.fbLogin.delegate = self
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //TODO: Hacer que funcione el pop
        let animation:POPSpringAnimation = POPSpringAnimation(propertyNamed: "kPOPViewScaleXY")
        animation.toValue = NSValue(CGPoint: CGPoint(x: 1, y: 1))
        animation.velocity = NSValue(CGPoint: CGPoint(x: 2, y: 2))
        animation.springBounciness = 20
        textField.pop_addAnimation(animation, forKey: "scaleUp")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func SignIn(sender: AnyObject) {
        
        /*
        ############################################
        default user: admin@eventyk.com
        default pass: alt001
        ############################################
        */
        
        hud.hidden = false
        
        let provider = Provider()
        provider.getPreferences({
            preferences in
            provider.signIn(self.userTextField.text!, pass: self.passTextField.text!, success: {
                
                print("access allowed")
                self.hud.hidden = true
                self.performSegueWithIdentifier("loginSigninSegue", sender: self)
                
                }, failure: {
                    //TODO: hacer que el pop funcione
                    print("access denied")
                    self.hud.hidden = true
                    
            })
        })
        

        
    }
    
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
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //logout
    }

    func returnUserData()
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
                self.performSegueWithIdentifier("loginSigninSegue", sender: self)
            }
        })
    }
}

