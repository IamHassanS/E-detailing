//
//  VisitInfoCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

class VisitInfoCVC: UICollectionViewCell {
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
    
    @IBOutlet var feedBack: UILabel!
    
    @IBOutlet var feedBaxkDesc: UILabel!
    
    @IBOutlet var remarks: UILabel!
    
    @IBOutlet var remarksDesc: UILabel!
    
    
    @IBOutlet var bottomSeperator: UIView!
    
    @IBOutlet var remarksSeperator: UIView!
    
    @IBOutlet var topSeperator: UIView!
    
    @IBOutlet var cellSeperatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func toPopulateCell(model: DetailedReportsModel) {
        // self.userTypeIV.image = UIImage(named: "")
         self.typeName.text = model.name
         self.visitTimeDesc.text = model.visitTime == "" ? "-" :  model.visitTime

        
        
         self.modifiedTimeDesc.text = model.modTime == "" ? "-" :  model.modTime
   
        
         self.clusterDesc.text = model.territory == "" ? "-" : model.territory
      
        
        
         self.pobDesc.text = model.pobValue == 0 ? "-" : "\(model.pobValue)"
       
        
         self.feedBaxkDesc.text = model.callFdback == "" ? "-" : model.callFdback
       
        
         self.jointWorkDesc.text = model.wWith == "" ? "-" : model.wWith
       
        
         self.remarksDesc.text = model.remarks == "" ? "-" : model.remarks
       
        
        
    }

    func setupUI() {
        let seperators: [UIView] = [remarksSeperator, bottomSeperator, topSeperator, cellSeperatorView]
        seperators.forEach { aView in
            aView.backgroundColor = .appSelectionColor
        }
        
        
        let titleLbl : [UILabel] =  [visitTime, modifiedTime, cluster, pobLbl, feedBack, jointWork, remarks]
        
        
        titleLbl.forEach { lbl in

                lbl.setFont(font: .medium(size: .BODY))
      
                lbl.textColor = .appLightTextColor
            
               
            
            
          
        }
        
        let descLbl : [UILabel] =   [visitTimeDesc, modifiedTimeDesc, clusterDesc, pobDesc, feedBaxkDesc, typeName,  jointWorkDesc, remarksDesc]
        descLbl.forEach { lbl in
            lbl.setFont(font: .bold(size: .BODY))
            lbl.textColor = .appTextColor
        }
        
    }
    
    
    

    
    
}
