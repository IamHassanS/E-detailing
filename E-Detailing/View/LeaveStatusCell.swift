//
//  LeaveStatusCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 13/07/23.
//

import Foundation
import UIKit



class LeaveStatusCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
