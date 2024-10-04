//
//  AdditionalCallSampleInputView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/05/24.
//

import Foundation
import UIKit


class AdditionalCallSampleInputView: UIView {
    
    
    @IBOutlet var inputQtyCurvedView: UIView!
    @IBOutlet var productQtyCurvedVIew: UIView!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblProductQty: UILabel!
    @IBOutlet weak var lblInput: UILabel!
    @IBOutlet weak var lblInputQty: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productQtyCurvedVIew.layer.cornerRadius = 3
        inputQtyCurvedView.layer.cornerRadius = 3
        
        productQtyCurvedVIew.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        inputQtyCurvedView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
    }
    
    var productQty: String! {
        didSet {
            lblProductQty.text = productQty
            productQtyCurvedVIew.isHidden = productQty == "" ? true : false
        }
    }
    
    
    
    var product : Product! {
        didSet {
            lblProduct.text = product.name
        }
    }
    
    var input : Input! {
        didSet {
            lblInput.text = input.name
            
          
        }
    }
    
    var inputQty : String! {
        didSet {
            lblInputQty.text = inputQty
            inputQtyCurvedView.isHidden = inputQty == "" ? true : false
        }
    }
    
    
    class func instanceFromNib() -> AdditionalCallSampleInputView{
        return Bundle.main.loadNibNamed("AdditionalCallSampleInputView", owner: self, options: nil)?.first as! AdditionalCallSampleInputView
    }
    
}
