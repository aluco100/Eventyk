//
//  EVProfileTableViewCell.swift
//  Eventyk
//
//  Created by Alfredo Luco on 17-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

protocol EVProfileTableViewCellDelegate {
    func didSelectSwitch(atIndex: Int, cellSwitch: UISwitch)
}

class EVProfileTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet var likehoodTitle: UILabel!
    
    @IBOutlet var likehoodSwitch: UISwitch!
    
    //MARK: - Global variables
    
    var delegate: EVProfileTableViewCellDelegate? = nil
    var index: Int? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBActions
    
    
    @IBAction func selectSwitch(sender: AnyObject) {
        
        if let delegate = self.delegate{
            
            delegate.didSelectSwitch(self.index!, cellSwitch: self.likehoodSwitch)
            
        }
        
    }
}
