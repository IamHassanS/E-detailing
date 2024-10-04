//
//  ProductsInfoHeader.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 19/03/24.
//

import UIKit
import Foundation
class ProductsInfoHeader: UITableViewHeaderFooterView {
    let appSetup = AppDefaults.shared.getAppSetUp()
    @IBOutlet var productNameLbl: UILabel!
    @IBOutlet var lblSample: UILabel!
    @IBOutlet var lblRCPA: UILabel!
    @IBOutlet var lblRxQty: UILabel!
    @IBOutlet var viewRCPA: UIView!
    @IBOutlet var viewRX: UIView!
    @IBOutlet var viewSamples: UIView!
    @IBOutlet var viewStock: UIView!
    
    @IBOutlet var viewPromoted: UIView!
    var call: AnyObject! {
        didSet {
            switch call {
            case is DoctorFencing:
                
                if !LocalStorage.shared.getBool(key: .isDoctorProductSampleNeeded) {
                    viewSamples.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isDoctorProductRXneeded) {
                    viewRX.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isDoctorRCPAneeded) {
                    viewRCPA.isHidden = true
                }
                
                productNameLbl.text =  appSetup.docProductCaption ?? "Products"
                lblRxQty.text = appSetup.docRxQCap
                lblSample.text = appSetup.docSampleQCap
                lblRxQty.isHidden = isDoctorProductRXneeded ? false : true
                lblRCPA.isHidden =  isDoctorRCPAneeded ? false : true
                lblSample.isHidden = isDoctorProductSampleNeeded ? false : true
                
            case is Chemist:
                
                
                if !LocalStorage.shared.getBool(key: .isChemistProductSampleNeeded) {
                    viewSamples.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isChemistProductRXneeded) {
                    viewRX.isHidden = true
                }
                
                viewRCPA.isHidden = true
               
                
                
                
                productNameLbl.text =  appSetup.chmProductCaption ?? "Products"
                lblRxQty.text = appSetup.chmQcap ?? "Rx Qty"
                lblSample.text = appSetup.chmSampleCap ?? "Sample"
                lblRxQty.isHidden = isChemistProductRXneeded ? false : true
                lblRCPA.isHidden =  isChemistRCPAneeded ? false : true
                lblSample.isHidden = isChemistProductSampleNeeded ? false : true
                viewPromoted.isHidden = true
            case is Stockist:
                
                
                
                if !LocalStorage.shared.getBool(key: .isStockistProductSampleNeeded) {
                    viewSamples.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isStockistProductRXneeded) {
                    viewRX.isHidden = true
                }
                
            
                viewRCPA.isHidden = true
                
                productNameLbl.text =  appSetup.stkProductCaption ?? "Products"
                lblRxQty.text = appSetup.stkQCap ?? "Rx Qty"
                lblSample.text =  "Sample"
                
                lblRxQty.isHidden = isStockistProductRXneeded ? false : true
                lblRCPA.isHidden =   true
                lblSample.isHidden = isStockistProductSampleNeeded ? false : true
                viewPromoted.isHidden = true
            case is UnListedDoctor:
                
                
                if !LocalStorage.shared.getBool(key: .isUnListedDoctorProductSampleNeeded) {
                    viewSamples.isHidden = true
                }
                
                if !LocalStorage.shared.getBool(key: .isUnListedDoctorProductRXneeded) {
                    viewRX.isHidden = true
                }
         
            
                viewRCPA.isHidden = true
                
                productNameLbl.text =  appSetup.ulProductCaption ?? "Products"
                lblRxQty.text = appSetup.nlRxQCap ?? "Rx Qty"
                lblSample.text = appSetup.nlSampleQCap ?? "Sample"
                
                lblRxQty.isHidden = isUnListedDoctorProductRXneeded ? false : true
                lblRCPA.isHidden =  isUnListedDoctorRCPAneeded ? false : true
                lblSample.isHidden = false
            default:
                print("Yet to")
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewStock.isHidden = true
        // Initialization code
     //   guard let call = call else {return}
        

    }

}
