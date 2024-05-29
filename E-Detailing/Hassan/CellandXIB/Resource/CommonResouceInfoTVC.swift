//
//  CommonResouceInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/03/24.
//

import UIKit

class CommonResouceInfoTVC: UITableViewCell {

    @IBOutlet var contentHeight: NSLayoutConstraint!
    @IBOutlet var itemTypeLbl: UILabel!
    @IBOutlet var itemCountLbl: UILabel!
    @IBOutlet var itemNameLBl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        itemCountLbl.setFont(font: .bold(size: .SMALL))
        itemCountLbl.textColor = .appTextColor
        itemNameLBl.setFont(font: .bold(size: .SMALL))
        itemNameLBl.textColor = .appTextColor
        itemTypeLbl.setFont(font: .bold(size: .SMALL))
        itemTypeLbl.textColor = .appLightTextColor
    }
    
    func populateCell(model: Input) {
        itemNameLBl.text = model.name
        guard let effF = model.effF , let effT = model.effT else {
         return
        }
        let fromDate = effF.date?.toDate(format: "yyyy-MM-dd HH:mm:ss")
        let toDate =  effT.date?.toDate(format: "yyyy-MM-dd HH:mm:ss")
        let fromDateStr = fromDate?.toString(format:  "MMMM dd, yyyy") ?? ""
        let toDateStr = toDate?.toString(format: "MMMM dd, yyyy") ?? ""
        itemTypeLbl.text = "From: \(fromDateStr) To: \(toDateStr)"

        
    }
    
    func populateCell(model: Product) {
        itemNameLBl.text = model.name
        itemTypeLbl.text = model.productMode
        
    }
    
    func populateCell(model: Territory) {
        itemNameLBl.text = model.name
      //  itemTypeLbl.text = model.productMode
    }
    
    

    
    func populateCell(model: VisitControl) {
        itemNameLBl.text = model.custName
        
        itemTypeLbl.text = model.townName
      //  itemTypeLbl.text = model.productMode
    }
    
    func setupHeight(type: MenuView.CellType) {
        
        switch type {
        case  .clusterInfo:
            contentHeight.constant = 30
            itemTypeLbl.isHidden = true
        case .product, .doctorVisit, .inputs:
            contentHeight.constant = 60
            itemTypeLbl.isHidden = false
        default:
            contentHeight.constant = 30
            itemTypeLbl.isHidden = true
        }
        
        
        
      
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
