//
//  QuickLinkCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 22/07/23.
//

import UIKit



class QuickLinkCell: UICollectionViewCell {
    
    
    @IBOutlet var vxView: UIVisualEffectView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var viewCell: UIView!
    
    
    var link : QuicKLink!{
        didSet{
            vxView.backgroundColor = link.color
            self.imgLogo.image = link.image.withRenderingMode(.alwaysTemplate)
            self.imgLogo.tintColor = link.color
            self.lblName.text = link.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 5
        viewCell.layer.cornerRadius = 5
        lblName.setFont(font: .medium(size: .BODY))
    }
    
    
}
