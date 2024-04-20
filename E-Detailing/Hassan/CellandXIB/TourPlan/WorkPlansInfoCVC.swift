//
//  WorkPlansInfoCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/11/23.
//

import UIKit

class WorkPlansInfoCVC: UICollectionViewCell {
    
    struct ImageDetail {
        let image: UIImage
        let count : Int
    }

    @IBOutlet var plansIVHolder
    : UIView!
    @IBOutlet var plansIV: UIImageView!
    
    @IBOutlet var countsHolder: UIView!
    @IBOutlet var countsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plansIVHolder.layer.cornerRadius  =  plansIVHolder.height / 2
        countsHolder.layer.cornerRadius =  countsHolder.height / 2
      
        countsLbl.setFont(font: .medium(size: .BODY))
    }
    
    func toPopulateCell(_ session: SessionDetail) {
     
     
//        var headQuartersstr = [String]()
//        var clusterstr  = [String]()
//        var jointcallstr  = [String]()
//        var doctorsstr  = [String]()
//        var chemiststr  = [String]()
//
//        session.sessionDetails.forEach { session in
//            headQuartersstr.append(session.HQCodes)
//            clusterstr.append(session.clusterCode)
//            jointcallstr.append(session.jwCode)
//            doctorsstr.append(session.drCode)
//            chemiststr.append(session.chemCode)
//        }
    }
}
