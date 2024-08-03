//
//  resourceInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 06/03/24.
//

import UIKit

class resourceInfoTVC: UITableViewCell {
    @IBOutlet var doctorNameLbl: UILabel!
    
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var countLbl: UILabel!
    
    
    @IBOutlet var spec1: UILabel!
    
    @IBOutlet var spec2: UILabel!
    
    @IBOutlet var spec3: UILabel!
    
    @IBOutlet var btnViewLocation: UIButton!
    
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var specialityVIew: UIStackView!
    
    @IBOutlet var holderViewHeight: NSLayoutConstraint!
    
    func setupHeight(type: MenuView.CellType) {
        
        switch type {
            
        case .doctorInfo, .unlistedDoctorinfo :
            holderViewHeight.constant = 100
            specialityVIew.isHidden = false
            
        default:
            holderViewHeight.constant = 100 - 33.3
            specialityVIew.isHidden = true
            
            print("Yet to implement")
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    
    
    
    
    
    func setupUI() {
        doctorNameLbl.setFont(font: .bold(size: .SMALL))
        doctorNameLbl.textColor = .appTextColor
        countLbl.setFont(font: .bold(size: .SMALL))
        countLbl.textColor = .appTextColor
        
        spec1.setFont(font: .bold(size: .SMALL))
        spec1.textColor = .appLightTextColor
        
        spec2.setFont(font: .bold(size: .SMALL))
        spec2.textColor = .appLightTextColor
        
        spec3.setFont(font: .bold(size: .SMALL))
        spec3.textColor = .appLightTextColor
        
        addressLbl.setFont(font: .bold(size: .SMALL))
        addressLbl.textColor = .appLightTextColor
        
    }
    
    func populateCell(model: DoctorFencing) {
        
        doctorNameLbl.text = model.name
        spec1.text = model.category ?? "-"
        spec2.text = model.speciality ?? "-"
        spec3.text = model.docDesig ?? "-"
        addressLbl.text = model.townName == "" ? "-" :  model.townName
        
//        if let address = model.addrs   {
//         
//            btnViewLocation.isHidden = address == ""
//        }
        
        
    }
    
    func populateCell(model: Chemist) {
        
        doctorNameLbl.text = model.name
       
        addressLbl.text = model.townName == "" ? "-" :  model.townName
//        if let address = model.addr  {
//            //  addressLbl.text = address == "" ? "Address not yet listed." :  address
//            btnViewLocation.isHidden = address == ""
//        }
 

        
        
    }
    
    func populateCell(model: WorkType) {
        
        doctorNameLbl.text = model.name ?? ""
        
        addressLbl.text = model.tpDCR ?? ""
//        if let address = model.addr  {
//            //  addressLbl.text = address == "" ? "Address not yet listed." :  address
//            btnViewLocation.isHidden = address == ""
//        }
 

        
        
    }
    
    func populateCell(model: SlideTheraptic) {
        
        doctorNameLbl.text = model.name ?? ""
        
 //       addressLbl.text = model.tpDCR ?? ""
//        if let address = model.addr  {
//            //  addressLbl.text = address == "" ? "Address not yet listed." :  address
//            btnViewLocation.isHidden = address == ""
//        }
 

        
        
    }
    
    
    func populateCell(model: UnListedDoctor) {
        
        doctorNameLbl.text = model.name
        spec1.text = model.specialty ?? "-"
        spec2.text = model.category ?? "-"
        spec2.text =  "-"
        addressLbl.text = model.townName == "" ? "-" :  model.townName
        
//        if let address = model.addrs   {
//        
//            btnViewLocation.isHidden = address == ""
//        }
  
        
    }
    
    
    func populateCell(model: Stockist) {
        
        doctorNameLbl.text = model.name
        addressLbl.text = model.townName == "" ? "-" :  model.townName
//        if let address = model.addr  {
//          //  addressLbl.text = address == "" ? "Address not yet listed." :  address
//            btnViewLocation.isHidden = address == ""
//        }
        
    
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
