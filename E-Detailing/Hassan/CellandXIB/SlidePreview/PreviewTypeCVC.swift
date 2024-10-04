//
//  PreviewTypeCVC.swift
//  SAN ZEN
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
        selectionView.isHidden = true
        holderVIew.isHidden = true

    }
   
    func setupUI(pageType: PreviewHomeView.pageType) {
        if pageType == .detailing {
            holderVIew.isHidden = false
            holderVIew.backgroundColor = .appTextColor
            titleLbl.textColor = .appWhiteColor
            titleLbl.setFont(font: .medium(size:  .BODY))
            holderVIew.layer.cornerRadius = 5
        } else {
            selectionView.isHidden = false
            selectionView.backgroundColor = .appTextColor
            holderVIew.isHidden = true
            titleLbl.setFont(font: .bold(size:  .BODY))
            titleLbl.textColor = .appTextColor
            holderVIew.layer.cornerRadius = 5
        }
    }
    
    

}
