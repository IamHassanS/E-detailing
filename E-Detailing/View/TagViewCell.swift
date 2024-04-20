//
//  TagViewCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 30/08/23.
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
    }
    
    
}
