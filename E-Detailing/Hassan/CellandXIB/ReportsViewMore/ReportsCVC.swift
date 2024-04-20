//
//  ReportsCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

class ReportsCVC: UICollectionViewCell {

    @IBOutlet var seperatorView: UIView!
    @IBOutlet var remarksDesc: UILabel!
    @IBOutlet var remarksTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        remarksDesc.textColor = .appTextColor
        remarksTitle.textColor = .appLightTextColor
        remarksDesc.setFont(font: .bold(size: .BODY))
        remarksTitle.setFont(font: .medium(size: .BODY))
        
        
        seperatorView.backgroundColor = .appSelectionColor
    }

}
