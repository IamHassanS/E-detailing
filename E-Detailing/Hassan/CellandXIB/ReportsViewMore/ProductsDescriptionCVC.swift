//
//  ProductsDescriptionCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

class ProductsDescriptionCVC: UICollectionViewCell {

    @IBOutlet var seperatorView: UIView!
    @IBOutlet var holderVoew: UIStackView!
    
    @IBOutlet var rcpaLbl: UILabel!
    @IBOutlet var rxQTYlbl: UILabel!
    @IBOutlet var samplesLbl: UILabel!
    @IBOutlet var promoterLbl: UILabel!
    @IBOutlet var productLbl: UILabel!
    var productsArr : [SampleProduct] = []
    
    func topopulateCell(modelStr: SampleProduct){
        //SECREMET 1 MG ( 0 ), )
//        let productDescArr = modelStr.components(separatedBy: " ")
//        self.productLbl.text = productDescArr[0]
//        self.promoterLbl.text = "Yes"
//        samplesLbl.text =
        
        self.productLbl.text = modelStr.prodName == "-" ? "No products" :  modelStr.prodName

        let tickIconString = "\u{2713}"
        print(tickIconString) // This will print: ✓
        if let promoted = modelStr.isPromoted {
            let promotedIcon =  promoted ? tickIconString : "x"
           // isPromoted = promotedIcon
            self.promoterLbl.text =  promotedIcon
            self.promoterLbl.textColor = promoted ? .appGreen : .appTextColor
        } else {
            self.promoterLbl.text = ""
        }
       
        
        self.samplesLbl.text = modelStr.noOfSamples == "" ? "-" :  String(modelStr.noOfSamples.dropLast())
        self.rxQTYlbl.text = modelStr.rxQTY == "" ? "-" :   String(modelStr.rxQTY.dropLast())
        self.rcpaLbl.text = modelStr.rcpa == "" ? "-" :  String(modelStr.rcpa.dropLast()) 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let titleLbls : [UILabel] = [rcpaLbl, rxQTYlbl, samplesLbl, promoterLbl, productLbl]
        
        titleLbls.forEach { label in
            label.textColor = .appTextColor
            label.setFont(font: .medium(size: .BODY))
        }
        
        seperatorView.backgroundColor = .appSelectionColor
    }

}
