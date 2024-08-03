//
//  ProductsInfoHeader.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 19/03/24.
//

import UIKit

class ProductsInfoHeader: UITableViewHeaderFooterView {

    @IBOutlet var lblSample: UILabel!
    
    @IBOutlet var lblRCPA: UILabel!
    @IBOutlet var lblRxQty: UILabel!
    var call: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard let call = call else {return}
        
        switch call {
        case is DoctorFencing:
            lblRxQty.isHidden = isDoctorProductRXneeded ? false : true
            lblRCPA.isHidden =  isDoctorRCPAneeded ? false : true
            lblSample.isHidden = isDoctorProductSampleNeeded ? false : true
        case is Chemist:
            lblRxQty.isHidden = isChemistProductRXneeded ? false : true
            lblRCPA.isHidden =  isChemistRCPAneeded ? false : true
            lblSample.isHidden = isChemistProductSampleNeeded ? false : true
        case is Stockist:
            lblRxQty.isHidden = isStockistProductRXneeded ? false : true
            lblRCPA.isHidden =   true
            lblSample.isHidden = isStockistProductSampleNeeded ? false : true
        case is UnListedDoctor:
            lblRxQty.isHidden = isUnListedDoctorProductRXneeded ? false : true
            lblRCPA.isHidden =  isUnListedDoctorRCPAneeded ? false : true
            lblSample.isHidden = false
        default:
            print("Yet to")
            
        }
    }

}
