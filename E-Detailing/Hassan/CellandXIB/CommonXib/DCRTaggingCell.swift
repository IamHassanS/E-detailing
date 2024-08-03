//
//  DCRTaggingCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/04/24.
//

import Foundation
import UIKit



class DCRTaggingCell : UICollectionViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
   // @IBOutlet weak var lblCluster: UILabel!
    
    
    
    @IBOutlet weak var lblTagCount: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    
    @IBOutlet weak var btnCluster: ShadowButton!
    
    
    var customer : CustomerViewModel! {
        didSet {
            self.lblName.text = customer.name
            self.lblCategory.text = customer.category == "" ? "Category" : customer.category
            self.lblSpeciality.text = customer.speciality == "" ? "Speciality" : customer.speciality
           // self.lblCluster.text = customer.townName
            self.lblTagCount.text = (customer.geoCount == "" ? "0" : customer.geoCount) + "/" + (customer.maxCount == "" ? "0" : customer.maxCount)
            
            
            self.btnCluster.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            self.btnCluster.setTitle(customer.townName, for: .normal)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
