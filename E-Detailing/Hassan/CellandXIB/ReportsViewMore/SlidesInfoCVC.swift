//
//  SlidesInfoCVC.swift
//  E-Detailing
//
//  Created by San eforce on 30/05/24.
//

import UIKit

class SlidesInfoCVC: UICollectionViewCell {

    @IBOutlet var hilderview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hilderview.layer.cornerRadius = 3
        hilderview.backgroundColor = UIColor.appLightTextColor.withAlphaComponent(0.2)
    }

}
