//
//  MasterSyncCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved.03/12/23.
//

import UIKit


class MasterSyncCell : UICollectionViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet var loaderImage: UIImageView!
    
    
    @IBOutlet weak var btnSync: UIButton!
    
    @IBOutlet var loaderView: UIView!
    
    
    
    
    var isRotationEnabled = true
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  stopRotation()
    }
    
    func loadGIF() {
        // Replace "your_gif_name" with the name of your GIF file (without extension)
        Shared.instance.showLoader(in: loaderView, loaderType: .mastersync)
    }
    
    func rotateImage() {
        guard isRotationEnabled else {
            return
        }

        // Reset the transform to the identity transform
        loaderImage.transform = .identity

        // Perform an infinite rotation animation
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear, .repeat], animations: {
            self.loaderImage.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
    }

    // Call this function to stop the rotation
    func stopRotation() {
        
        loaderImage.transform = .identity
        loaderImage.image = nil
        isRotationEnabled = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loaderImage.image = nil
        lblName.setFont(font: .bold(size: .BODY))
        lblName.textColor = .appTextColor
        
        lblCount.setFont(font: .bold(size: .BODY))
        lblCount.textColor = .appLightTextColor
        btnSync.backgroundColor = .appTextColor
    }
    
}
