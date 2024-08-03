//
//  SpecificDCRadditioanCallsinfoReusableView.swift
//  SAN ZEN
//
//  Created by San eforce on 23/07/24.
//

import Foundation
import UIKit
class SpecificDCRadditioanCallsinfoReusableView: UICollectionReusableView {
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .appLightTextColor
        label.backgroundColor = .clear
        label.text = "Additional calls"
        label.clipsToBounds = true
       
        label.setFont(font: .medium(size: .BODY))
        return label
    }()
    
    let productLbl: UILabel = {
        let label = PaddedLabel()
        label.text = "  Cust. name"
        label.textColor = .appTextColor
        label.setSpecificCornersForLeft(cornerRadius: 3)
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
        label.text = "Product"
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let samplesLbl: UILabel = {
        let label = UILabel()
        label.text = "Qty"
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let rxQTYlbl: UILabel = {
        let label = UILabel()
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.text = "Input"
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        return label
    }()
    
    let rcpaLbl: UILabel = {
        let label = UILabel()
        label.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        label.text = "Qty"
        label.textColor = .appTextColor
        label.clipsToBounds = true
        label.setFont(font: .bold(size: .BODY))
        label.setSpecificCornersForRight(cornerRadius: 3)
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
            default:
                label.frame = CGRect(origin: .zero, size: CGSize(width: otherLabelsWidth, height: stackView.frame.height))
//            default:
//                print("yet to")
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
