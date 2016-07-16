//
//  EVLikehoodCollectionViewCell.swift
//  Eventyk
//
//  Created by Alfredo Luco on 14-07-16.
//  Copyright © 2016 Innovarco. All rights reserved.
//

import UIKit

protocol EVLikehoodCollectionViewCellDelegate {
    
    func didSelectLikehood(atIndex: Int)
    
}

class EVLikehoodCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet var likehoodImage: UIImageView!
    @IBOutlet var likehoodTitle: UILabel!
    
    
    //MARK: - Global Variables
    
    var delegate: EVLikehoodCollectionViewCellDelegate? = nil
    var index: Int? = nil
    
    //MARK: - Init
    
    override func awakeFromNib() {
        
        //MARK: - Gesture
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EVLikehoodCollectionViewCell.goToLikehood))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - Selector
    
    func goToLikehood(){
        
        if let delegate = self.delegate{
            
            delegate.didSelectLikehood(self.index!)
            
        }
        
    }
    
}
