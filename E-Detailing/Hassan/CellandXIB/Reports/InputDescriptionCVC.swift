//
//  InputDescriptionCVC.swift
//  E-Detailing
//
//  Created by San eforce on 24/04/24.
//

import UIKit

class InputDescriptionCVC: UICollectionViewCell {

    @IBOutlet var inputName: UILabel!
    
    @IBOutlet var inputQty: UILabel!
    
    @IBOutlet var seperatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        inputName.textColor = .appTextColor
        inputName.setFont(font: .medium(size: .BODY))
        inputQty.textColor = .appTextColor
        inputQty.setFont(font: .medium(size: .BODY))
        seperatorView.backgroundColor = .appSelectionColor
    }

    
    func topopulateCell(modelStr: SampleInput) {
        inputName.text = modelStr.prodName
        inputQty.text = modelStr.noOfSamples
    }
}
