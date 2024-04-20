//
//  DoctorCallCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 07/08/23.
//

import UIKit


class DoctorCallCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSpecialty: UILabel!
    @IBOutlet weak var lblTownName: UILabel!
    
    
    @IBOutlet weak var btnTownName: UIButton!
    
    
    
    func setupUI() {
        lblName.setFont(font: .bold(size: .SUBHEADER))
        lblName.textColor = .appTextColor
        lblCategory.setFont(font: .medium(size: .BODY))
        lblCategory.textColor = .appLightTextColor
        lblSpecialty.setFont(font: .medium(size: .BODY))
        lblSpecialty.textColor = .appLightTextColor
        lblTownName.setFont(font: .bold(size: .BODY))
        lblTownName.textColor = .appLightPink
    }
    
    var CallDetail : CallViewModel! {
        didSet{
            self.lblName.text = CallDetail.name
            self.lblTownName.text = CallDetail.territory
            self.lblCategory.text = CallDetail.category
            self.lblSpecialty.text =  CallDetail.speciality
            
            
            self.btnTownName.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            self.btnTownName.setTitle(CallDetail.territory, for: .normal)
            
            self.btnTownName.backgroundColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(83.0/255.0), blue: CGFloat(110.0/255.0), alpha: CGFloat(0.2))
            
            
            
            
            
//            if DCRType.doctor == CallDetail.type || DCRType.unlistedDoctor == CallDetail.type {
//                self.lblCategory.text = CallDetail.category
//                self.lblSpecialty.text =  CallDetail.speciality
//            }else {
//                self.lblCategory.text = ""
//                self.lblSpecialty.text = ""
//            }
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
