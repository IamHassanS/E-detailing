//
//  RadioSelectionTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import UIKit

class RadioSelectionTVC: UITableViewCell {
    @IBOutlet var typeTitle: UILabel!
    
    @IBOutlet var selectionIV: UIImageView!
    var selectdSection: Int? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeTitle.setFont(font: .medium(size: .BODY))
        typeTitle.textColor = .appTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
