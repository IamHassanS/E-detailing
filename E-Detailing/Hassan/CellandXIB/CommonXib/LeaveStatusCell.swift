//
//  LeaveStatusCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 13/07/23.
//

import Foundation
import UIKit



class LeaveStatusCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet var seperatorLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblDate.setFont(font: .medium(size: .BODY))
        seperatorLbl.backgroundColor = .appBlue
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
