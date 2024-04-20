//
//  PreviewTypeCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/02/24.
//

import UIKit

class PreviewTypeCVC: UICollectionViewCell {

    @IBOutlet var holderVIew: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.setFont(font: .bold(size:  .BODY))
        selectionView.backgroundColor = .appTextColor
    }
    
    

}
