//
//  DCRApprovalsInfoTVC.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import UIKit


protocol DCRApprovalsInfoTVCDelegate: AnyObject {
    
    func didDCRinfoTapped(index: Int )
    
}

class DCRApprovalsInfoTVC: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var shadowView: ShadowView!
    @IBOutlet var optionsBtn: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet var timeLbl: UILabel!
    weak var delegate : DCRApprovalsInfoTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // shadowView.elevate(2)
       // shadowView.layer.cornerRadius = 5
        shadowView.backgroundColor = .appWhiteColor
        nameLbl.textColor = .appTextColor
        timeLbl.textColor = .appLightTextColor

        imgProfile.layer.cornerRadius =  imgProfile.height / 2
    }
    
    func populateDCRArroval(model: ApprovalDetailsModel) {
        
 
        
        nameLbl.setFont(font: .bold(size: .BODY))
        timeLbl.setFont(font: .medium(size: .SMALL))
        
        nameLbl.text =  model.transDetailName
        timeLbl.text = model.sdpName
        
        switch model.type {
        case "DOCTOR":
            
            imgProfile.image = UIImage(named: "ListedDoctor")
            
        case "CHEMIST":
            
            imgProfile.image = UIImage(named: "Chemist")
        case "STOCKIST":
            
            imgProfile.image = UIImage(named: "Stockist")
            
        case "ULDOCTOR":
            
            imgProfile.image = UIImage(named: "Doctor")
            
        default:
            print("Yet to")
            
        }
        
     
        
    }
    
    func topopulateCell(_ model: TodayCallsModel) {
        nameLbl.setFont(font: .medium(size: .BODY))
        timeLbl.setFont(font: .medium(size: .SMALL))
        
        nameLbl.text =  "\(model.name)(\(model.designation))"
        timeLbl.text = model.vstTime
        
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
