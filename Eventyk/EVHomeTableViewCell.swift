//
//  EVHomeTableViewCell.swift
//  Eventyk
//
//  Created by Alfredo Luco on 22-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

//MARK: - Protocol
protocol EVHomeTableViewCellDelegate {
    func asistToEvent(eventAtIndex: Int)
    func seeAsistPeople(eventAtIndex: Int)
    func seeMore(eventAtIndex: Int)
}

class EVHomeTableViewCell: UITableViewCell {

    //MARK: - IBoutlets
    @IBOutlet var imageEvent: UIImageView!
    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var dateEvent: UILabel!
    
    //MARK: - Global Variables
    
    var delegate = EVHomeTableViewCellDelegate?()
    var index: Int? = nil
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.titleEvent.backgroundColor = UIColor.orangeColor()
        self.titleEvent.textColor = UIColor.whiteColor()
        self.titleEvent.layer.cornerRadius = 15.0
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func asistToEvent(sender: AnyObject) {
        //code
        if let delegate = self.delegate{
            delegate.asistToEvent(index!)
        }
    }
    
    @IBAction func seeAsistPeople(sender: AnyObject) {
        //code
        if let delegate = self.delegate{
            delegate.seeAsistPeople(index!)
        }
    }
    
    @IBAction func seeMore(sender: AnyObject) {
        //code
        if let delegate = self.delegate{
            delegate.seeMore(index!)
        }
    }
    
    
}
