//
//  ActivityDualEntryVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/08/24.
//

import UIKit

class ActivityDualEntryVC: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var entry1CurvedView: UIView!
    
    @IBOutlet var entry2CurvedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        entry1CurvedView.layer.borderWidth = 1
        entry1CurvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor
        entry1CurvedView.layer.cornerRadius = 1
        
        entry2CurvedView.layer.borderWidth = 1
        entry2CurvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor
        entry2CurvedView.layer.cornerRadius = 1
        
        titleLbl.setFont(font: .medium(size: .BODY))
    }
    
}
