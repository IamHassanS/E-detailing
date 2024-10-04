//
//  MasterSyncTbCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/12/23.
//

import UIKit



class MasterSyncTbCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet var selectedIV: UIImageView!
    

    
    @IBOutlet weak var btnSyncAll: UIButton!
    
    
    @IBOutlet var contentHolderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.setFont(font: .bold(size: .BODY))
        btnSyncAll.layer.cornerRadius = 5
        contentHolderView.backgroundColor = .appWhiteColor
        contentHolderView.layer.cornerRadius = 5
        lblName.textColor = .appTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
