//
//  PlayLoadedPresentationCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import UIKit

class PlayLoadedPresentationCVC: UICollectionViewCell {

    @IBOutlet var holderVIew: UIView!
    
    @IBOutlet var presentationIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populateCell(model: SlidesModel) {

           // let data =  model.slideData
           // let utType = model.utType
            //presentationIV.toSetImageFromData(utType: utType, data: data)
        presentationIV.contentMode = .scaleAspectFit
//        ObjectFormatter.shared.loadImageInBackground(utType: utType, data: data, presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        
      presentationIV.image = UIImage(data: model.slideData)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
       
     //   presentationIV.image = nil
   
    }
    
}
