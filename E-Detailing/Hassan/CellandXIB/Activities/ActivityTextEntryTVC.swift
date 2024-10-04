//
//  ActivityTextEntryTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/08/24.
//

import UIKit

class ActivityTextEntryTVC: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var entryCurvedView: UIView!

    @IBOutlet var entryTF: UITextField!
    
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
        entryCurvedView.layer.borderWidth = 1
        entryCurvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor
        entryCurvedView.layer.cornerRadius = 1
        
    
        
        titleLbl.setFont(font: .medium(size: .BODY))
    }
    
    
    
}
