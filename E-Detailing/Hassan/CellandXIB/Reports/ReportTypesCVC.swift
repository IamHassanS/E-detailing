//
//  ReportTypesCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import UIKit

class ReportTypesCVC: UICollectionViewCell {
    
    @IBOutlet var elevateView: UIView!
    @IBOutlet var reportTypeIV: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var reportTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        elevateView.elevate(2)
        elevateView.layer.cornerRadius = 5
        elevateView.backgroundColor = .appWhiteColor
        reportTypeLbl.setFont(font: .bold(size: .BODY))
        titleLbl.setFont(font: .bold(size: .BODY))
        // Initialization code
    }
    
    func setupUI(type: ReportsVC.PageType, modal: ReportsView.ReportInfo) {
        switch type {
            
        case .reports:
            titleLbl.isHidden = true
            reportTypeIV.isHidden = false
            reportTypeIV.image = UIImage(named: modal.image)
            reportTypeLbl.text = modal.name
        case .approvals:
            titleLbl.isHidden = false
            reportTypeIV.isHidden = true
            titleLbl.text = modal.name
            reportTypeLbl.text = modal.image
        case .myResource:
            titleLbl.isHidden = false
            reportTypeIV.isHidden = true
            titleLbl.text = modal.name
            reportTypeLbl.text = modal.image
        }
    }

}
