//
//  ProductSectionReusableView2.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/04/24.
//

import UIKit

class ProductSectionReusableView: UICollectionReusableView {

    let sectionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .appLightTextColor
        label.backgroundColor = .clear
        label.text = "Product"
        label.clipsToBounds = true
        label.backgroundColor = .clear
        label.setFont(font: .medium(size: .BODY))
        return label
    }()
    
    let productLbl: UILabel = {
        let label = PaddedLabel()
        label.text = "Product Name"
        label.textColor = .appTextColor
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        // Define right padding
        let padding: CGFloat = 10 // Adjust the padding value as needed
         label.textInsets.right = padding
        return label
    }()
    
    let promoterLbl: UILabel = {
        let label = UILabel()
        label.text = "Promoted"
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let samplesLbl: UILabel = {
        let label = UILabel()
        label.text = "Samples"
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let rxQTYlbl: UILabel = {
        let label = UILabel()
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.text = "Rx(Qty)"
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let rcpaLbl: UILabel = {
        let label = UILabel()
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.text = "RCPA"
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // addSubviews()
       // self.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  self.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
       // addSubviews()
    }
    

    override func layoutSubviews()  {
        let labels: [UILabel] = [productLbl, promoterLbl, samplesLbl, rxQTYlbl, rcpaLbl]
        
        // Create a stack view
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.layer.cornerRadius = 5
//
        
        // Define the width for the first label (1/3 of the stack view's width)
        let firstLabelWidth = stackView.frame.width / 4
        
        // Calculate the remaining width for the other 4 labels
        let remainingWidth = stackView.frame.width - firstLabelWidth
        
        // Distribute the remaining width equally among the other 4 labels
        let otherLabelsWidth = remainingWidth / 4
        
        labels.enumerated().forEach {index, label in
              // Set the frame for the label
            switch label {
            case productLbl:
                label.frame = CGRect(origin: .zero, size: CGSize(width: firstLabelWidth, height: stackView.frame.height))
            case promoterLbl:
                label.frame = CGRect(origin: .zero, size: CGSize(width: otherLabelsWidth, height: stackView.frame.height))
            default:
                print("yet to")
            }

            stackView.addArrangedSubview(label)
          }
        
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


class PaddedLabel: UILabel {
    // Define insets for padding
    var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func drawText(in rect: CGRect) {
        let insetsRect = rect.inset(by: textInsets)
        super.drawText(in: insetsRect)
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += textInsets.left + textInsets.right
        contentSize.height += textInsets.top + textInsets.bottom
        return contentSize
    }
}
