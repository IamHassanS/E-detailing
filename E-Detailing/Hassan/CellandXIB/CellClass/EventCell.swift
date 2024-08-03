//
//  EventCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/04/23.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_event: UILabel!
    @IBOutlet weak var width_lbl: NSLayoutConstraint! {
        didSet {
            
            width_lbl.isActive = false
        }
    }
    
    var width1: CGFloat? = nil {
        didSet {
            guard width1 != nil else {
                
                width_lbl.isActive = true
                width_lbl.constant = width1!
                return
            }
        }
    }
    
    override func awakeFromNib() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
