//
//  RCPASectionReusableView.swift
//  SAN ZEN
//
//  Created by San eforce on 29/05/24.
//

import Foundation
import UIKit
class RCPASectionReusableView: UICollectionReusableView {

    var pagetitle: String = ""
 
    let sectionHolderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .appTextColor
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.backgroundColor = .clear
        label.setFont(font: .medium(size: .BODY))
        return label
    }()
    
    let sectionImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.tintColor = .appTextColor
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sectionTitle.text = pagetitle
       

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sectionTitle.text = pagetitle
       
    }
    
    override func layoutSubviews()  {
        sectionHolderView.frame = CGRect(x: 15, y: 5, width: self.width - 30, height: self.height - 10)
        sectionTitle.frame = CGRect(x: 15, y: (sectionHolderView.height / 2) - (sectionHolderView.height / 2)   , width: sectionHolderView.width - 100, height: sectionHolderView.height)
        sectionImage.frame = CGRect(x: sectionHolderView.width - 50, y: sectionHolderView.height - (sectionHolderView.height/2) - 25, width: 50, height: 50)
        
        self.addSubview(sectionHolderView)
        sectionHolderView.addSubview(sectionTitle)
        sectionHolderView.addSubview(sectionImage)
        
    }
    
}
