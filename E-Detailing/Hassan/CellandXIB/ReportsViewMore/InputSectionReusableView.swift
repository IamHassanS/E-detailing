//
//  InputSectionReusableView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/04/24.
//

import UIKit

class InputSectionReusableView: UICollectionReusableView {
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .appLightTextColor
        label.backgroundColor = .clear
        label.text = "Input"
        label.clipsToBounds = true
        label.backgroundColor = .appWhiteColor
        label.setFont(font: .medium(size: .BODY))
        return label
    }()
    
    let productLbl: UILabel = {
        let label = PaddedLabel()
        label.text = "Input Name"
        label.textColor = .appTextColor
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        // Define right padding
        let padding: CGFloat = 10 // Adjust the padding value as needed
         label.textInsets.right = padding
        return label
    }()
    

    
    let samplesLbl: UILabel = {
        let label = UILabel()
        label.text = "Samples"
        label.textColor = .appTextColor
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  self.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
       // addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  self.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
       // addSubviews()
    }
    

    override func layoutSubviews()  {
        let labels: [UILabel] = [productLbl, samplesLbl]
        
        // Create a stack view
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.layer.cornerRadius = 5

        
        let overAllStack = UIStackView(arrangedSubviews: [sectionTitle, stackView])
        overAllStack.axis = .vertical
        overAllStack.alignment = .fill
        overAllStack.distribution = .fillEqually
        overAllStack.spacing = 0 // Adjust spacing between labels
        
        // Add stack view to the view hierarchy
        addSubview(overAllStack)
        
        // Set stack view constraints to fill the entire bounds of the view
        overAllStack.frame = CGRect(x: self.width / 60 , y: 0, width: self.width - (self.width / 60 * 2) , height: self.height)
    }
}
