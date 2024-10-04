//
//  BrandsNameTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import UIKit

class BrandsNameTVC: UITableViewCell {

    @IBOutlet var contentsHolderView: UIView!
    
    @IBOutlet var brandsTitle: UILabel!
    @IBOutlet var countsLbl: UILabel!
    @IBOutlet var countsVXVew: UIVisualEffectView!
    @IBOutlet var accessoryIV: UIImageView!
    @IBOutlet var countsHolderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentsHolderView.backgroundColor = .appWhiteColor
       
        contentsHolderView.layer.cornerRadius = 5
        countsHolderView.layer.cornerRadius = 3
        countsVXVew.backgroundColor = .appGreen
        countsLbl.textColor = .appGreen
        countsLbl.setFont(font: .bold(size: .SMALL))
        brandsTitle.textColor = .appTextColor
        brandsTitle.setFont(font: .bold(size: .BODY))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func toPopulateCell(_ model: GroupedBrandsSlideModel) {
        if !model.groupedSlide.isEmpty {
            brandsTitle.text = model.groupedSlide[0].name
        }
        
        self.countsHolderView.isHidden = model.groupedSlide.isEmpty ? true : false
        
       let selectedModel = model.groupedSlide.filter { aSlidesModel in
            aSlidesModel.isSelected == true
        }
        
        //self.countsLbl.text = "\(model.groupedSlide.count)"
        self.countsHolderView.isHidden = selectedModel.count == 0 ? true : false
        self.countsLbl.text = selectedModel.count == 0 ? "" : "\(selectedModel.count)"

        
    }
    
}
