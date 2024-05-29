//
//  HomeWorktypeTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/01/24.
//

import UIKit

class HomeWorktypeTVC: UITableViewCell {

    @IBOutlet var holderView: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    
    
    @IBOutlet var accessoryBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        holderView.backgroundColor = .appWhiteColor
        accessoryBtn.setTitle("", for: .normal)
        holderView.layer.cornerRadius = 5
        holderView.layer.borderWidth = 1
        holderView.layer.borderColor = UIColor.appGreyColor.cgColor
        titleLbl.setFont(font: .medium(size: .BODY))
        titleLbl.textColor = .appTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
