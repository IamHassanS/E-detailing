//
//  JointWorkTableViewCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 27/10/23.
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
