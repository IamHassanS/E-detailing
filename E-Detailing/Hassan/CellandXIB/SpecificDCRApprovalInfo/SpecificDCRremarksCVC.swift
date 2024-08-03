//
//  SpecificDCRremarksCVC.swift
//  SAN ZEN
//
//  Created by San eforce on 23/07/24.
//

import UIKit

class SpecificDCRremarksCVC: UICollectionViewCell {

    @IBOutlet var remarksTitle: UILabel!
    @IBOutlet var feedbackTitle: UILabel!
    @IBOutlet var feedbackDescLbl: UILabel!
    @IBOutlet var remarlsDescLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        feedbackTitle.setFont(font: .medium(size: .BODY))
        feedbackTitle.textColor = .appLightTextColor
        
        remarksTitle.setFont(font: .medium(size: .BODY))
        remarksTitle.textColor = .appLightTextColor
        
        remarlsDescLbl.setFont(font: .bold(size: .BODY))
        feedbackDescLbl.setFont(font: .bold(size: .BODY))
    }
    func toPopulateCell(model: ApprovalDetailsModel) {
        
    }
}
