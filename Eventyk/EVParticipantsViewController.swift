//
//  EVParticipantsViewController.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

class EVParticipantsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - IBOutlets
    @IBOutlet var participantsTableView: UITableView!
    
    //MARK: -  Global Variables
    
    var participants: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.participantsTableView.delegate = self
        self.participantsTableView.dataSource = self
        self.participantsTableView.reloadData()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.barStyle = .Black

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
        return self.participants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("participantsIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 20.0)
        
        cell.textLabel?.text = self.participants[indexPath.row].Name
        
        return cell
    }
    
}
