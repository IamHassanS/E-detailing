//
//  RCPASectionheader.swift
//  E-Detailing
//
//  Created by San eforce on 26/03/24.
//

import UIKit
import CoreData
class RCPASectionheader: UITableViewHeaderFooterView {
    
    @IBOutlet var summonedTotal: UILabel!
    
    @IBOutlet var holderStack: UIStackView!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var deleteView: UIView!
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDelete.isUserInteractionEnabled = false
    }
    

    
    
}
