//
//  ProductSampleTableViewCell.swift
//  SAN ZEN
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
    var call: AnyObject! {
        didSet {
            switch call {
            case is DoctorFencing:
//                viewRxQty.isHidden = isDoctorProductRXneeded ? false : true
//                viewRcpa.isHidden =  isDoctorRCPAneeded ? false : true
//                viewSample.isHidden = isDoctorProductSampleNeeded ? false : true
                
                
                if !LocalStorage.shared.getBool(key: .isDoctorProductSampleNeeded) {
                    viewSample.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isDoctorProductRXneeded) {
                    viewRxQty.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isDoctorRCPAneeded) {
                    viewRcpa.isHidden = true
                }
                
            case is Chemist:

                if !LocalStorage.shared.getBool(key: .isChemistProductSampleNeeded) {
                    viewSample.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isChemistProductRXneeded) {
                    viewRxQty.isHidden = true
                }
                
                viewRcpa.isHidden = true
                viewDeviation.isHidden = true
                
            case is Stockist:
//                viewRxQty.isHidden = isStockistProductRXneeded ? false : true
//                viewRcpa.isHidden =   true
//                viewSample.isHidden = isStockistProductSampleNeeded ? false : true
                
                
                if !LocalStorage.shared.getBool(key: .isStockistProductSampleNeeded) {
                    viewSample.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isStockistProductRXneeded) {
                    viewRxQty.isHidden = true
                }
                
            
                viewRcpa.isHidden = true
                viewDeviation.isHidden = true
                
            case is UnListedDoctor:
//                viewRxQty.isHidden = isUnListedDoctorProductRXneeded ? false : true
//                viewRcpa.isHidden =  isUnListedDoctorRCPAneeded ? false : true
//                viewSample.isHidden = false
                
                if !LocalStorage.shared.getBool(key: .isUnListedDoctorProductSampleNeeded) {
                    viewSample.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isUnListedDoctorProductRXneeded) {
                    viewRxQty.isHidden = true
                }
         
            
                viewRcpa.isHidden = true
                
            default:
                print("Yet to")
                
            }
        }
    }
    
    
    
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
     
        viewStock.isHidden = true
        

        
    }
}
