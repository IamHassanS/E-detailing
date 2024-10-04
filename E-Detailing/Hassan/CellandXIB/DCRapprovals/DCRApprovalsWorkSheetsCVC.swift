//
//  DCRApprovalsWorkSheetsCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/07/24.
//

import UIKit

class DCRApprovalsWorkSheetsCVC: UICollectionViewCell {


    @IBOutlet var HQ: UILabel!
    @IBOutlet var cluster: UILabel!
    @IBOutlet var workType: UILabel!
    
    @IBOutlet var remarks: UILabel!
    @IBOutlet var clusterDesc: UILabel!
    
    @IBOutlet var remasrksDesc: UILabel!
    @IBOutlet var workTypeDesc: UILabel!
    @IBOutlet var HQdesc: UILabel!
    @IBOutlet var seperatorView: UIView!
    
    var isLastElement : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    func populateCell(model: ApprovalsListModel, routes: String) {
        seperatorView.backgroundColor = isLastElement ? .clear : .appSelectionColor
        workTypeDesc.text = model.workTypeName
        remasrksDesc.text = model.remarks
        clusterDesc.text = routes
        //model.planName
        HQdesc.text = model.sfName
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
            HQ.isHidden = true
            HQdesc.isHidden = true
        }
    
        //model.
    }

    func setupUI() {
       
       // seperatorView.backgroundColor =
        
        let titleLbl : [UILabel] = [HQ, cluster, workType, remarks ]
        titleLbl.forEach { lbl in
            lbl.setFont(font: .medium(size: .BODY))
            lbl.textColor = .appLightTextColor
        }
        
        
        let descLbl : [UILabel] = [HQdesc, workTypeDesc, clusterDesc, remasrksDesc]
        
        descLbl.forEach { lbl in
            lbl.setFont(font: .bold(size: .BODY))
            lbl.textColor = .appTextColor
        }
    }
    
}
