//
//  VisitInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/12/23.
//

import UIKit

class VisitInfoTVC: UITableViewCell {
    
    @IBOutlet var elevationView: UIView!
    
    @IBOutlet var visitTime: UILabel!
    
    @IBOutlet var visitTimeDesc: UILabel!
    
    
    @IBOutlet var cluster: UILabel!
    
    @IBOutlet var clusterDesc: UILabel!
    
    
    @IBOutlet var pobLbl: UILabel!
    
    @IBOutlet var feedBack: UILabel!
    
    @IBOutlet var jointWork: UILabel!
    
    @IBOutlet var remarks: UILabel!
    
    
    
    @IBOutlet var pobDesc: UILabel!
    
    
    @IBOutlet var modifiedTime: UILabel!
    
    @IBOutlet var jointWorkDesc: UILabel!
    @IBOutlet var modifiedTimeDesc: UILabel!
    
    @IBOutlet var feedBaxkDesc: UILabel!
    
    
    @IBOutlet var viewMoreDesc: UILabel!
    
    
    @IBOutlet var userTitle: UILabel!
    
    @IBOutlet var userTypeIV: UIImageView!
    
    @IBOutlet var topSeperator: UIView!
    
    @IBOutlet var seperatorView: UIView!
    
    @IBOutlet var holderStach: UIStackView!
    @IBOutlet var bottomSeperator: UIView!
    
    @IBOutlet var remarksDesc: UILabel!
    @IBOutlet var remarksSeperator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    

    func toPopulateCell(model: DetailedReportsModel) {
       // self.userTypeIV.image = UIImage(named: "")
        self.userTitle.text = model.name
        self.visitTimeDesc.text = model.visitTime == "" ? "-" :  model.visitTime
        self.modifiedTimeDesc.text = model.modTime == "" ? "-" :  model.modTime
        self.clusterDesc.text = model.territory == "" ? "-" : model.territory
        self.pobDesc.text = model.pobValue == 0 ? "-" : "\(model.pobValue)"
        self.feedBaxkDesc.text = model.callFdback == "" ? "-" : model.callFdback
        self.jointWorkDesc.text = model.wWith == "" ? "-" : model.wWith
        self.remarksDesc.text = model.remarks == "" ? "-" : model.remarks
    }
    
    func setupUI() {
        
        let seperators: [UIView] = [remarksSeperator, bottomSeperator, seperatorView, topSeperator]
        seperators.forEach { aView in
            aView.backgroundColor = .appSelectionColor
        }
    
        
        let titleLbl : [UILabel] =  [visitTime, modifiedTime, cluster, pobLbl, feedBack, jointWork, remarks]
        
        
        titleLbl.forEach { lbl in

                lbl.setFont(font: .medium(size: .BODY))
                lbl.textColor = .appLightTextColor
            
            
          
        }
        
        let descLbl : [UILabel] =   [visitTimeDesc, modifiedTimeDesc, clusterDesc, pobDesc, feedBaxkDesc, viewMoreDesc, userTitle, jointWorkDesc]
        descLbl.forEach { lbl in
            lbl.setFont(font: .bold(size: .BODY))
            lbl.textColor = .appTextColor
        }
        remarksDesc.setFont(font: .medium(size: .BODY))
        remarksDesc.textColor = .appTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override class func awakeFromNib() {
       
        
    }
    
}

