//
//  EVHomeTableViewCell.swift
//  Eventyk
//
//  Created by Alfredo Luco on 22-03-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

class EVHomeTableViewCell: UITableViewCell {

    @IBOutlet var imageEvent: UIImageView!
    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var descriptionEvent: UILabel!
    @IBOutlet var dateEvent: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
