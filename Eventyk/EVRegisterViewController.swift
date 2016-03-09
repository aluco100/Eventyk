//
//  EVRegisterViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 08-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

class EVRegisterViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    //outlets
    
    @IBOutlet var registerButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var confPassTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    
    
    //global vars
    var cityPickerView: UIPickerView = UIPickerView()
    let cities = ["Valparaiso","Santiago","La Serena", "Puerto Varas", "Punta Arenas"]
    var birthdatePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial button state
        self.registerButton.enabled = false
        
        //textfields settings
        self.nameTextField.delegate = self
        self.mailTextField.delegate = self
        self.mailTextField.keyboardType = .EmailAddress
        self.passTextField.delegate = self
        self.confPassTextField.delegate = self
        
        //city settings
        self.cityPickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 200))
        self.cityPickerView.delegate = self
        self.cityPickerView.dataSource = self
        self.cityPickerView.showsSelectionIndicator = true
        self.cityTextField.delegate = self
        self.cityTextField.inputView = self.cityPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        self.cityTextField.inputAccessoryView = toolBar
        
        //birthdate settings
        self.birthdatePicker = UIDatePicker(frame: CGRectMake(0, 200, view.frame.width, 300))
        self.birthdatePicker.addTarget(self, action: "birthdateChanged", forControlEvents: .ValueChanged)
        self.birthdatePicker.datePickerMode = .Date
        self.birthTextField.inputView = self.birthdatePicker
        self.birthTextField.inputAccessoryView = toolBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - View Controller Style
    
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
    
    //MARK: - PickerView Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cities.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.cities[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cityTextField.text = self.cities[row]
        self.registerButton.enabled = registerIsValid()
    }
    
    //MARK: - TextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.registerButton.enabled = registerIsValid()
        return true
    }
    
    //MARK: - Events
    
    func donePicker(){
        self.view.endEditing(true)
    }
    
    func birthdateChanged(){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthTextField.text = formatter.stringFromDate(self.birthdatePicker.date)
        self.registerButton.enabled = registerIsValid()
    }
    
    //MARK: - IBActions
    
    @IBAction func register(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: - Other Functions
    func registerIsValid()->Bool{
        if(verifyMail(self.mailTextField.text!) && self.nameTextField.text != "" && self.passTextField.text == self.confPassTextField.text && self.passTextField.text != "" && self.confPassTextField.text != "" && self.birthTextField.text != "" && self.cityTextField.text != ""){
            return true
        }else{
            return false
        }
    }
    
    func verifyMail(mail: String)->Bool{
        let stricterFilter: Bool = false
        let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailRegex: String = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluateWithObject(mail)
    }

}
