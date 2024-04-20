//
//  DcrTagTitleCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 30/08/23.
//

import Foundation
import UIKit


class DcrTagTitleCell : UICollectionViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var viewTitle: UIView!
    
    
    @IBOutlet weak var widthLblNameConstraint: NSLayoutConstraint! {
        didSet {
            widthLblNameConstraint.isActive = false
        }
    }
    
    
//    var nameWidth : CGFloat? = nil {
//        didSet {
//            guard nameWidth != nil else {
//                widthLblNameConstraint.isActive = true
//                widthLblNameConstraint.constant = nameWidth!
//                return
//            }
//        }
//    }
    
    
    var title : TagTitleViewModel! {
        didSet {
            self.lblName.text = title.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
 
