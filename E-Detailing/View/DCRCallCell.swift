//
//  DCRCallCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 31/07/23.
//

import UIKit



class DCRCallCell: UITableViewCell {
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var shadowView: ShadowView!
    @IBOutlet var optionsBtn: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.backgroundColor = .appGreyColor
        nameLbl.textColor = .appTextColor
        timeLbl.textColor = .appLightTextColor
        nameLbl.setFont(font: .medium(size: .BODY))
        timeLbl.setFont(font: .medium(size: .SMALL))
        imgProfile.layer.cornerRadius =  imgProfile.height / 2
    }
    
    func topopulateCell(_ model: TodayCallsModel) {
        nameLbl.text = "\(model.name)(\(model.designation))"
        timeLbl.text = model.vstTime
        
        if model.designation == "Doctor" {
            imgProfile.image = UIImage(named: "ListedDoctor")
        } else if model.designation == "Chemist" {
            imgProfile.image = UIImage(named: "Chemist")
        } else if model.designation == "CIP" {
            imgProfile.image = UIImage(named: "cip")
        } else if model.designation == "UnlistedDr." {
            imgProfile.image = UIImage(named: "Doctor")
        } else if model.designation == "Hospital" {
            imgProfile.image = UIImage(named: "hospital")
        } else if model.designation == "Stockist" {
            imgProfile.image = UIImage(named: "Stockist")
        }
        
    }
}
