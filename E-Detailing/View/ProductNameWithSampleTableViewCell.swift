//
//  ProductNameWithSampleTableViewCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 28/10/23.
//

import Foundation
import UIKit


class ProductNameWithSampleTableViewCell : UITableViewCell {
    
//    enum productType: String {
//        case sale = ""
//    }
    
    @IBOutlet var samplesVXview: UIVisualEffectView!
    
    @IBOutlet var samplesView: UIView!
    
    @IBOutlet weak var btnSelected: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSample: UILabel!
    
    
    var product : Objects! {
        didSet {
            lblName.text = product.Object.name
            
            let productMode = product.Object.productMode ?? ""
            
            if productMode == "Sale/Sample"{
                lblSample.text = "SM/SL"
                lblSample.textColor = .appLightTextColor
                samplesVXview.backgroundColor = .appLightTextColor
            }else if productMode == "Sample" {
                lblSample.text = " SM "
                lblSample.textColor = .appLightPink
                samplesVXview.backgroundColor = .appLightPink
                
            }else if productMode == "Sale" {
                lblSample.text = " SL "
                lblSample.textColor = .appBlue
                samplesVXview.backgroundColor = .appBlue
            }
            
            if product.priority != "" {
                lblSample.text = product.priority
                lblSample.textColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(198.0/255.0), blue: CGFloat(137.0/255.0), alpha: CGFloat(1.0))
                samplesVXview.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(198.0/255.0), blue: CGFloat(137.0/255.0), alpha: CGFloat(0.15))
            }
            
            btnSelected.isSelected = product.isSelected
            if product.isSelected {
                lblName.textColor = .appTextColor
            } else {
                lblName.textColor = .appLightTextColor
            }
         
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        samplesView.layer.cornerRadius = 3
        samplesVXview.layer.cornerRadius = 3
        lblName.textColor = .appLightTextColor
        
    }
}

