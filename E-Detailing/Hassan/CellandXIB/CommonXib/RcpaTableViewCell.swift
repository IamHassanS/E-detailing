//
//  RcpaTableViewCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 04/04/24.
//

import Foundation
import UIKit



class RcpaTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblProduct: UILabel!
    
    
    @IBOutlet weak var lblCompetitorCompany: UILabel!
    @IBOutlet weak var lblCompetitorBrand: UILabel!
    
    
    @IBOutlet weak var btnCompetitorCompany: UIButton!
    @IBOutlet weak var btnCompetitorBrand: UIButton!
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var txtRcpaQty: UITextField!
    @IBOutlet weak var txtRcpaRate: UITextField!
    @IBOutlet weak var txtRcpaTotal: UITextField!
    
    
    @IBOutlet weak var txtViewRemarks: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
