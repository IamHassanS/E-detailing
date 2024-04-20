//
//  ProductNameCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 10/08/23.
//

import Foundation
import UIKit


class ProductNameTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var btnSelected: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    
    var product : Objects! {
        didSet {
            lblName.text = product.Object.name
            btnSelected.isSelected = product.isSelected
        }
    }
    
    var input : Objects! {
        didSet {
            lblName.text = input.Object.name
            btnSelected.isSelected = input.isSelected
            
            
            if input.isSelected {
                lblName.textColor = .appTextColor
            } else {
                lblName.textColor = .appLightTextColor
            }
            
        }
    }
    
    var jointWork : Objects! {
        didSet{
            lblName.text = jointWork.Object.name
            btnSelected.isSelected = jointWork.isSelected
        }
    }
    
    var additionalCall : Objects! {
        didSet{
            lblName.text = additionalCall.Object.name
            btnSelected.isSelected = additionalCall.isSelected
            
            
            if additionalCall.isSelected {
                lblName.textColor = .appTextColor
            } else {
                lblName.textColor = .appLightTextColor
            }
            
        }
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

