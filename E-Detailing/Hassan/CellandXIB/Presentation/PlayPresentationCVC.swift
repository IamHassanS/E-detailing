//
//  PlayPresentationCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import UIKit
import PDFKit
import AVFoundation

class PlayPresentationCVC: UICollectionViewCell {
    @IBOutlet var holderIV: UIView!
    @IBOutlet var formatIV: UIImageView!
    @IBOutlet var formatVIew: UIView!
    
    @IBOutlet var presentationIV: UIImageView!
    @IBOutlet var holderViewWidth: NSLayoutConstraint!
    @IBOutlet var holderViewHeight: NSLayoutConstraint!
    let pdfView = PDFView()
//    var isCellSelected {
//        didSet {
//
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        presentationIV.contentMode = .scaleAspectFill
        holderIV.backgroundColor = .clear
        formatVIew.isHidden = true
        formatVIew.layer.cornerRadius = formatVIew.height / 2
    }
    
    func toPopulateCell(_ model: SlidesModel) {
        
         //   let data =  model.slideData
         //   let utType = model.utType
            //presentationIV.toSetImageFromData(utType: utType, data: data)
      
        
//        ObjectFormatter.shared.loadImageInBackground(utType: utType, data: data, presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        
        self.presentationIV.image = UIImage(data: model.imageData)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        presentationIV.image = nil
   
    }

}
