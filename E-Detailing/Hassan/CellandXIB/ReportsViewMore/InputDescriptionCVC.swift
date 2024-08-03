//
//  InputDescriptionCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/04/24.
//

import UIKit

class InputDescriptionCVC: UICollectionViewCell {

    @IBOutlet var inputName: UILabel!
    
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var inputCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seperatorView.backgroundColor = .appSelectionColor
        inputName.setFont(font: .medium(size: .BODY))
        inputCount.setFont(font: .medium(size: .BODY))
    }
    
    func topopulateCell(modelStr: SampleInput) {
        inputName.text = modelStr.prodName
        inputCount.text = modelStr.noOfSamples
    }

}
