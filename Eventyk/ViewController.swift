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

class ViewController: UIViewController,UITextFieldDelegate {

    //Outlets
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        provider.signIn(self.userTextField.text!, pass: self.passTextField.text!, success: {
            
            print("access allowed")
            self.hud.hidden = true
            self.performSegueWithIdentifier("loginSigninSegue", sender: self)
            
            }, failure: {
                //TODO: hacer que el pop funcione
                print("access denied")
                self.hud.hidden = true
                
        })

        
    }
    
    @IBAction func goToRegister(sender: AnyObject) {
        self.performSegueWithIdentifier("registerSegue", sender: self)
    }
    //MARK: - Events Methods
    func hideKeyboard(){
        self.view.endEditing(true)
    }

}

