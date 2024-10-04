//
//  SelectPresentationCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import UIKit
import PDFKit

class SelectPresentationCVC: UICollectionViewCell {
    
    
    enum CellType {
        case pdf
        case image
        case video
        case zip
    }
    
    @IBOutlet var selectedVxVIew: UIVisualEffectView!
    @IBOutlet var selectionImage: UIImageView!
    @IBOutlet var selectionView: UIView!
    @IBOutlet var presentationIV: UIImageView!
    @IBOutlet var contentsHolderView: UIView!
   
    //var player = AVPlayer()
    var type : CellType = .image
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        presentationIV.contentMode = .scaleAspectFill
        contentsHolderView.layer.cornerRadius = 5
        contentsHolderView.layer.borderColor = UIColor.appTextColor.cgColor
        contentsHolderView.layer.borderWidth = 1
        selectionView.layer.cornerRadius = selectionView.height / 2
        selectionView.backgroundColor = .appWhiteColor
        selectionImage.tintColor = .appGreen
        selectionImage.image = UIImage(systemName: "checkmark.circle.fill")
        
        
    }
 
    func setupVIews() {
        
    }
    
    
    
    func toPopulateCell(_ model: SlidesModel) {
    
     //   let data =  model.slideData
    //    let utType = model.utType
        //presentationIV.toSetImageFromData(utType: utType, data: data)
//        ObjectFormatter.shared.loadImageInBackground(utType: utType, data: data, presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//        
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                 
//                }
        presentationIV.image = UIImage(data: model.imageData)
        
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()

        presentationIV.image = nil

    }
    }
