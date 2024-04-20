//
//  AdditionalCallSampleEntryTableViewCell.swift
//  E-Detailing
//
//  Created by San eforce on 22/03/24.
//

import UIKit

class AdditionalCallSampleEntryTableViewCell : UITableViewCell {
    
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var txtAvailableStock: UITextField!
    @IBOutlet weak var txtSampleStock: UITextField!
    
    @IBOutlet weak var btnProduct: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var viewProduct: UIView!
    
    
    var product : ProductViewModel! {
        didSet {
            self.lblName.text = product.name == "" ? "Select" : product.name
            self.lblName.textColor = .appTextColor
            //product.name == "" ? . : product.name
            self.txtAvailableStock.text = product.availableCount
            self.txtSampleStock.text = product.sampleCount
        }
    }
    
    var input : InputViewModel!{
        didSet {
            self.lblName.text = input.name == "" ? "Select" :  input.name
            self.lblName.textColor = .appTextColor
            self.txtAvailableStock.text = input.input.availableCount
            self.txtSampleStock.text = input.inputCount
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtSampleStock.layer.cornerRadius = 5
//        txtSampleStock.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
//        txtSampleStock.layer.borderWidth = 1
        
        txtAvailableStock.layer.cornerRadius = 5
//        txtAvailableStock.layer.borderColor = UIColor.appLightTextColor.cgColor
//        txtAvailableStock.layer.borderWidth = 1
        
        viewProduct.layer.cornerRadius = 5
        viewProduct.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        viewProduct.layer.borderWidth = 1
        
        [txtSampleStock,txtAvailableStock].forEach { textfield in
            if textfield != txtAvailableStock {
                textfield?.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1
          
            }
            textfield?.layer.cornerRadius = 5
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textfield?.frame.height ?? 50))
            
            textfield?.leftView = paddingView
            textfield?.leftViewMode = .always
            
        }
        
        
    }
}
