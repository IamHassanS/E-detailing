//
//  ViewmoreCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

class ViewmoreCVC: UICollectionViewCell {

    @IBOutlet var viewLessLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewLessLbl.textColor = .appTextColor
        viewLessLbl.setFont(font: .bold(size: .BODY))
    }

}
