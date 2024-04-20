//
//  AnalysisCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 24/07/23.
//

import UIKit


class AnalysisCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    
    @IBOutlet weak var viewAnalysis: ShadowView!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
