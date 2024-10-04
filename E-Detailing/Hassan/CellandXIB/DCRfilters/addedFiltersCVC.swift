//
//  addedFiltersCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 16/03/24.
//

import UIKit

class addedFiltersCVC: UICollectionViewCell {

    @IBOutlet var filtersTit: UILabel!
    
    @IBOutlet var dropdownIV: UIImageView!
    
    @IBOutlet var hilderVIew: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hilderVIew.layer.borderWidth = 1
        hilderVIew.layer.cornerRadius = 5
        hilderVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
    }

}
