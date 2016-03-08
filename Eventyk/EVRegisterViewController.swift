//
//  EVRegisterViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

class EVRegisterViewController: UIViewController {

    //outlets
    
    @IBOutlet var registerButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var confPassTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.registerButton.enabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO: hacer que cambie de color el status bar
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
