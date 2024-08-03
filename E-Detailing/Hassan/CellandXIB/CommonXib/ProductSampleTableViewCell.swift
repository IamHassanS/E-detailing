//
//  ProductSampleTableViewCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 11/04/24.
//

import UIKit




class ProductSampleTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
   
    @IBOutlet weak var txtProductCount: UITextField!
    
    @IBOutlet weak var txtSampleQty: UITextField!
    @IBOutlet weak var txtRxQty: UITextField!
    @IBOutlet weak var txtRcpaQty: UITextField!
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnDeviation: UIButton!
    
    
    
    @IBOutlet weak var viewStock: UIView!
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var viewRxQty: UIView!
    @IBOutlet weak var viewRcpa: UIView!
    
    @IBOutlet weak var viewDeviation: UIView!
    var call: AnyObject?
    
    
    
    var productSample : ProductViewModel! {
        didSet {
            self.lblName.text = productSample.name
            self.txtSampleQty.text = productSample.sampleCount
            self.txtRxQty.text = productSample.rxCount
            self.txtRcpaQty.text = productSample.rcpaCount
            self.txtProductCount.text = productSample.availableCount
            self.btnDeviation.isSelected = productSample.isDetailed

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        txtProductCount.backgroundColor = .appLightTextColor.withAlphaComponent(0.3)
        [txtSampleQty,txtRxQty,txtRcpaQty, txtProductCount].forEach { textfield in
            if textfield != txtProductCount {
                textfield?.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1.5
          
            }
            textfield?.layer.cornerRadius = 5
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textfield?.frame.height ?? 50))
            
            textfield?.leftView = paddingView
            textfield?.leftViewMode = .always
            
        }
     
        guard let call = call else {return}
        
        switch call {
        case is DoctorFencing:
            viewRxQty.isHidden = isDoctorProductRXneeded ? false : true
            viewRcpa.isHidden =  isDoctorRCPAneeded ? false : true
            viewSample.isHidden = isDoctorProductSampleNeeded ? false : true
        case is Chemist:
            viewRxQty.isHidden = isChemistProductRXneeded ? false : true
            viewRcpa.isHidden =  isChemistRCPAneeded ? false : true
            viewSample.isHidden = isChemistProductSampleNeeded ? false : true
        case is Stockist:
            viewRxQty.isHidden = isStockistProductRXneeded ? false : true
            viewRcpa.isHidden =   true
            viewSample.isHidden = isStockistProductSampleNeeded ? false : true
        case is UnListedDoctor:
            viewRxQty.isHidden = isUnListedDoctorProductRXneeded ? false : true
            viewRcpa.isHidden =  isUnListedDoctorRCPAneeded ? false : true
            viewSample.isHidden = false
        default:
            print("Yet to")
            
        }
        
    }
}
