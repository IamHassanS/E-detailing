//
//  ProductsDescriptionTVC.swift
//  E-Detailing
//
//  Created by San eforce on 18/03/24.
//

import UIKit

class ProductsDescriptionTVC: UITableViewCell {

    @IBOutlet var rcpaLbl: UILabel!
    @IBOutlet var rxQTYlbl: UILabel!
    @IBOutlet var samplesLbl: UILabel!
    @IBOutlet var promoterLbl: UILabel!
    @IBOutlet var productLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func topopulateCell(modelStr: SampleProduct){
        //SECREMET 1 MG ( 0 ), )
//        let productDescArr = modelStr.components(separatedBy: " ")
//        self.productLbl.text = productDescArr[0]
//        self.promoterLbl.text = "Yes"
//        samplesLbl.text =
        
        self.productLbl.text = modelStr.prodName
        if modelStr.isDemoProductCell {
            self.promoterLbl.text = modelStr.isPromoted ? "Yes" : ""
        } else {
            self.promoterLbl.text = modelStr.isPromoted ? "Yes" : "No"
        }
        
        self.samplesLbl.text = modelStr.noOfSamples == "" ? "-" :  String(modelStr.noOfSamples.dropLast())
        self.rxQTYlbl.text = modelStr.rxQTY == "" ? "-" :   String(modelStr.rxQTY.dropLast())
        self.rcpaLbl.text = modelStr.rcpa == "" ? "-" :  String(modelStr.rcpa.dropLast())
    }
    
}
