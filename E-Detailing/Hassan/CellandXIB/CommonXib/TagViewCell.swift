//
//  TagViewCell.swift
//  SAN ZEN
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
           
            guard let distance = Double(visitDetail.meter) else { 
                
                self.lblMeter.text = String(format: "%.2f Meter", visitDetail.address)
                return
            }
                    
                    
            if distance >= 1000 {
                let kmValue = distance / 1000
                      self.lblMeter.text = String(format: "%.2f KM", kmValue)
            } else {
                self.lblMeter.text = String(format: "%.2f Meter", distance)
            }
            
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
