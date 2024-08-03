//
//  TagViewCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 30/04/24.
//

import Foundation
import UIKit


class TagViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMeter: UILabel!
    
    
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var btnVisit: UIButton!
    
    
    
    var visitDetail : VisitViewModel! {
        didSet {
            self.lblName.text = visitDetail.name
            self.lblAddress.text = visitDetail.address
            self.lblMeter.text = visitDetail.meter + "  Meter"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.setFont(font: .bold(size: .SUBHEADER))
        lblAddress.setFont(font: .medium(size: .BODY))
        lblMeter.setFont(font: .bold(size: .BODY))
        
        
        lblMeter.textColor = .appLightPink
        lblName.textColor = .appTextColor
        lblAddress.textColor = .appTextColor
    }
    
    
}
