//
//  RCPAdetailsDesctiptionCVC.swift
//  E-Detailing
//
//  Created by San eforce on 30/05/24.
//

import UIKit
import Combine

class RCPAdetailsDesctiptionCVC: UICollectionViewCell {

    @IBOutlet var productNameLbl: UILabel!
    
    @IBOutlet var productQtyLbl: UILabel!
    
    @IBOutlet var chemistNameLBl: UILabel!
    
    @IBOutlet var competitorNameLbl: UILabel!
    
    @IBOutlet var commentsIV: UIImageView!
    
    @IBOutlet var competitorProductNameLbl: UILabel!
    
    
    @IBOutlet var competitorProductQty: UILabel!
    
    @IBOutlet var infoView: UIView!
    
    var commentSubject = PassthroughSubject<Int, Never>()
    
    func populateCell(model: RCPAresonseModel) {
        productNameLbl.text = model.opName
        productQtyLbl.text = "\(model.opQty)"
        chemistNameLBl.text = model.chmName
        competitorNameLbl.text = model.compName
        competitorProductNameLbl.text = model.compPName
        competitorProductQty.text = "\(model.cpQty)" 
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let labels: [UILabel] = [productNameLbl, productQtyLbl, chemistNameLBl, competitorNameLbl, competitorProductNameLbl, competitorProductQty]
        labels.forEach { aLabel in
            aLabel.setFont(font: .medium(size: .BODY))
            aLabel.textColor = .appTextColor
        }
    }

}
