//
//  JointWorkTableViewCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/05/24.
//

import Foundation
import UIKit

class JointWorkTableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var jointWorkSample : JointWorkViewModel! {
        didSet {
            self.lblName.text = jointWorkSample.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
