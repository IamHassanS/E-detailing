//
//  BrandsPreviewCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/02/24.
//

import UIKit
import PDFKit
import AVFoundation

class BrandsPreviewCVC: UICollectionViewCell {
    
    @IBOutlet var holderView: UIView!
    
    @IBOutlet var optionsHolderView: UIView!
    @IBOutlet var slideDescriptionLbl: UILabel!
    @IBOutlet var slideTitleLbl: UILabel!
    @IBOutlet var presentationIV: UIImageView!
    
    @IBOutlet var bottomContentsHolder: UIView!
    @IBOutlet var optionsIV: UIImageView!
    let objectFormatter =  ObjectFormatter.shared
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        holderView.backgroundColor = .appWhiteColor
        bottomContentsHolder.backgroundColor = .appTextColor
        holderView.layer.cornerRadius = 5
        holderView.layer.borderColor = UIColor.appGreyColor.cgColor
        holderView.layer.borderWidth = 1
        bottomContentsHolder.backgroundColor = .appTextColor
        slideTitleLbl.setFont(font: .bold(size: .BODY))
        slideTitleLbl.textColor = .appWhiteColor
        slideDescriptionLbl.setFont(font: .medium(size: .SMALL))
        slideDescriptionLbl.textColor = .appWhiteColor
        //optionsIV.transform =  optionsIV.transform.rotated(by: .pi  * 1.5)
        optionsIV.backgroundColor = .appGreen
        optionsIV.tintColor = .appWhiteColor
        optionsIV.layer.cornerRadius =  optionsIV.height / 2
    }
    
    func toPopulateCell(_ model: GroupedBrandsSlideModel) {
        if !model.groupedSlide.isEmpty {
            slideTitleLbl.text = model.groupedSlide[0].name
        }
        
        slideDescriptionLbl.text = "\(model.groupedSlide.count) Asserts"
        
        let aslide = model.groupedSlide.first
        
//        let data =  aslide?.slideData ?? Data()
//        let utType = aslide?.utType ?? ""
//        objectFormatter.loadImageInBackground(utType: utType, data: data, presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        
        presentationIV.image = UIImage(data: aslide?.imageData ?? Data())
    }
    
    func toPopulateCell(model: SavedPresentation) {
        var slidesModel = [SlidesModel]()
        model.groupedBrandsSlideModel.forEach { aGroupedBrandsSlideModel in
          let aslidesModel = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                aSlidesModel.isSelected
            }
            slidesModel.append(contentsOf: aslidesModel)
        }
        

            slideDescriptionLbl.text = "\(slidesModel.count) Asserts"
        
        
        slideTitleLbl.text = model.name
       // let groupedBrandsSlideElement = model.groupedBrandsSlideModel.last
        
        
        
        let slideElement = slidesModel.first
      //  let imageDatatype = slideElement?.utType ?? ""
       // self.presentationIV.toSetImageFromData(utType: imageDatatype, data: slideElement?.slideData ?? Data())
        
//        ObjectFormatter.shared.loadImageInBackground(utType: imageDatatype, data: slideElement?.slideData ?? Data(), presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        
        presentationIV.image = UIImage(data: slideElement?.imageData ?? Data())
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset or clear properties, images, or resources
        slideTitleLbl.text = nil
        slideDescriptionLbl.text = nil
        presentationIV.image = nil
    }
    
}


