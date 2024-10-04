//
//  SpecificDCRgeneralinfoCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/07/24.
//

import UIKit

class SpecificDCRgeneralinfoCVC: UICollectionViewCell {
    @IBOutlet var typeIV: UIImageView!
    
    @IBOutlet var typeName: UILabel!
    
    @IBOutlet var visitTime: UILabel!
    
    @IBOutlet var visitTimeDesc: UILabel!
    
    @IBOutlet var cluster: UILabel!
    
    @IBOutlet var clusterDesc: UILabel!
    
    @IBOutlet var modifiedTime: UILabel!
    
    @IBOutlet var modifiedTimeDesc: UILabel!
    
    @IBOutlet var pobLbl: UILabel!
    
    
    @IBOutlet var pobDesc: UILabel!
    
    @IBOutlet var jointWork: UILabel!
    
    
    @IBOutlet var jointWorkDesc: UILabel!
    
    @IBOutlet var bottomSeperator: UIView!
    
    
    @IBOutlet var topSeperator: UIView!
    
    @IBOutlet var cellSeperatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func toPopulateCell(model: ApprovalDetailsModel) {
        // self.userTypeIV.image = UIImage(named: "")
         self.typeName.text = model.transDetailName
         self.visitTimeDesc.text = model.visitTime == "" ? "-" :  model.visitTime
         self.modifiedTimeDesc.text = model.modTime == "" ? "-" :  model.modTime
   
        
         self.clusterDesc.text = model.sdpName == "" ? "-" : model.sdpName

         self.pobDesc.text = model.pob == 0 ? "-" : "\(model.pob)"
        
         self.jointWorkDesc.text = model.jointwrk == "" ? "-" : model.jointwrk.replacingOccurrences(of: "$$", with: ", ")
        switch model.type {
        case "DOCTOR":
            
            typeIV.image = UIImage(named: "ListedDoctor")
            
        case "CHEMIST":
            
            typeIV.image = UIImage(named: "Chemist")
        case "STOCKIST":
            
            typeIV.image = UIImage(named: "Stockist")
            
        case "ULDOCTOR":
            
            typeIV.image = UIImage(named: "Doctor")
            
        default:
            print("Yet to")
            
        }
        
    }

    func setupUI() {
        let seperators: [UIView] = [ bottomSeperator, topSeperator, cellSeperatorView]
        seperators.forEach { aView in
            aView.backgroundColor = .appSelectionColor
        }
        
        
        let titleLbl : [UILabel] =  [visitTime, modifiedTime, cluster, pobLbl,  jointWork]
        
        
        titleLbl.forEach { lbl in

                lbl.setFont(font: .medium(size: .BODY))
      
                lbl.textColor = .appLightTextColor
            
               
            
            
          
        }
        
        let descLbl : [UILabel] =   [visitTimeDesc, modifiedTimeDesc, clusterDesc, pobDesc, typeName,  jointWorkDesc]
        descLbl.forEach { lbl in
            lbl.setFont(font: .bold(size: .BODY))
            lbl.textColor = .appTextColor
        }
        
    }
    
    
    

    

}
