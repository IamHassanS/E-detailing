//
//  AddadditionalProductsFooter.swift
//  E-Detailing
//
//  Created by San eforce on 22/03/24.
//

import UIKit

class AddadditionalProductsFooter: UITableViewHeaderFooterView {

    @IBOutlet var btnAddtype: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        btnAddtype.layer.cornerRadius = 5
        btnAddtype.layer.borderWidth = 1
        btnAddtype.layer.borderColor = UIColor.appGreen.cgColor
    }


    
}
