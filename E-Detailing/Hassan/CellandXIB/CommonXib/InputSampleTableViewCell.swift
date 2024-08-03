//
//  InputSampleTableViewCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/04/24.
//

import Foundation
import UIKit


class InputSampleTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtInputCount: UITextField!
    @IBOutlet weak var txtSampleQty: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var viewSampleQty: UIView!
    
    
    var inputSample : InputViewModel! {
        didSet {
            self.lblName.text = inputSample.name
            self.txtSampleQty.text = inputSample.inputCount
        }
    }
    
    var additionalCallSample : AdditionalCallViewModel! {
        didSet {
            self.lblName.text = additionalCallSample.docName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [txtInputCount,txtSampleQty].forEach { textfield in
            
            txtInputCount.backgroundColor = .appLightTextColor.withAlphaComponent(0.3)
            
            if textfield != txtInputCount {
                textfield?.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1.5
            }
    
            textfield?.layer.cornerRadius = 5
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield?.frame.height ?? 50))
            
            textfield?.leftView = paddingView
            textfield?.leftViewMode = .always
            
        }
        
    }
}
