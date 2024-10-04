//
//  DcrTagTitleCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 30/04/24.
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
        lblName.setFont(font: .bold(size: .BODY))
    }
}
 
