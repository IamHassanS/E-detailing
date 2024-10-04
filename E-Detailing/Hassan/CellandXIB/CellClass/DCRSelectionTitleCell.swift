//
//  DCRSelectionTitleCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/04/24.
//

import Foundation
import UIKit


class DCRSelectionTitleCell : UICollectionViewCell {
    
    
    
    @IBOutlet weak var lblDoctor: UILabel!
    @IBOutlet weak var lblUnderLine: UILabel!
    
    
    @IBOutlet weak var viewTitle: UIView!
    
    @IBOutlet weak var widthNameConstraint: NSLayoutConstraint! {
        didSet {
            widthNameConstraint.isActive = false
        }
    }
    
    
    func setupUI() {
        lblDoctor.setFont(font: .bold(size: .SUBHEADER))
        lblDoctor.backgroundColor = .appTextColor
        viewTitle.backgroundColor = .appTextColor
    }
    
    var nameWidth : CGFloat? = nil {
        didSet {
            guard nameWidth != nil else {
                widthNameConstraint.isActive = true
                widthNameConstraint.constant = nameWidth!
                return
            }
        }
    }
    
    var title : DcrActivityViewModel! {
        didSet {
            self.lblDoctor.text = title.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
