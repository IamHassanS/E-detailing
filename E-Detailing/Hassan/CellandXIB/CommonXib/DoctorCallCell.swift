//
//  DoctorCallCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/04/24.
//

import UIKit


class DoctorCallCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSpecialty: UILabel!
    @IBOutlet weak var lblTownName: UILabel!
    
    
    @IBOutlet weak var btnTownName: UIButton!
    
    
    
    func setupUI() {
        btnTownName.layer.cornerRadius = 3
        lblName.setFont(font: .bold(size: .BODY))
        lblName.textColor = .appTextColor
        lblCategory.setFont(font: .medium(size: .BODY))
        lblCategory.textColor = .appLightTextColor
        lblSpecialty.setFont(font: .medium(size: .BODY))
        lblSpecialty.textColor = .appLightTextColor
        lblTownName.setFont(font: .bold(size: .BODY))
        lblTownName.textColor = .appLightPink
    }
    
    var selectedTerritories: [Territory]?
    
    func tosetTerritoryLbl(selectedTerritories : [Territory]) -> Void {
        selectedTerritories.forEach { aTerritory in
            if aTerritory.code == CallDetail.townCode {
                self.btnTownName.backgroundColor = .appLightPink.withAlphaComponent(0.2)
               // self.btnTownName.tintColor = .appPink
            } else {
                self.btnTownName.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
              //  self.btnTownName.tintColor = .appTextColor
            }
        }
    }
    
    var CallDetail : CallViewModel! {
        didSet{
          
            
            self.lblName.text = CallDetail.name
            self.lblTownName.text = CallDetail.territory
            self.lblCategory.text = CallDetail.category
            self.lblSpecialty.text =  CallDetail.speciality
            
         
            self.btnTownName.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            self.btnTownName.titleLabel?.setFont(font: .medium(size: .BODY))
         
            self.btnTownName.titleLabel?.numberOfLines = 1
            self.btnTownName.setTitle(truncateText(CallDetail.territory, maxLength: 18), for: .normal)
        }
    }
    
    func truncateText(_ text: String, maxLength: Int) -> String {
        if text.count > maxLength {
            let endIndex = text.index(text.startIndex, offsetBy: maxLength - 3)
            return text[text.startIndex..<endIndex] + "..."
        } else {
            return text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
