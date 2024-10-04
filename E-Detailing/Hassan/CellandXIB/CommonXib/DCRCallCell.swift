//
//  DCRCallCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 31/07/24.
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
        nameLbl.text =   model.custName
        //"\(model.name)(\(model.designation))"
        timeLbl.text = model.vstTime.toDate(format: "yyyy-MM-dd HH:mm:ss").toString(format: "MMM d, h:mm a")
        
        if model.custType == 1 {
            imgProfile.image = UIImage(named: "ListedDoctor")
        } else if model.custType == 2 {
            imgProfile.image = UIImage(named: "Chemist")
        } else if model.custType == 5 {
            imgProfile.image = UIImage(named: "cip")
        } else if model.custType == 4 {
            imgProfile.image = UIImage(named: "Doctor")
        } else if model.custType == 6 {
            imgProfile.image = UIImage(named: "hospital")
        } else if model.custType == 3 {
            imgProfile.image = UIImage(named: "Stockist")
        }
        
    }
}
