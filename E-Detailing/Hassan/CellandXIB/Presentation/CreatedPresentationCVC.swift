//
//  CreatedPresentationCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/01/24.
//

import UIKit
import PDFKit
import AVFoundation

class CreatedPresentationCVC: UICollectionViewCell {

    @IBOutlet var holderView: UIView!
    
    @IBOutlet var optionsHolderView: UIView!
    @IBOutlet var slideDescriptionLbl: UILabel!
    @IBOutlet var slideTitleLbl: UILabel!
    @IBOutlet var presentationIV: UIImageView!
    
    @IBOutlet var bottomContentsHolder: UIView!
    @IBOutlet var optionsIV: UIImageView!
    let pdfView = PDFView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        presentationIV.contentMode = .scaleAspectFill
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
        optionsIV.transform =  optionsIV.transform.rotated(by: .pi  * 1.5)
        optionsIV.tintColor = .appWhiteColor
    }
    
    func populateCell(model: SavedPresentation) {
        
        
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
        let imageDatatype = slideElement?.utType ?? ""
       // self.presentationIV.toSetImageFromData(utType: imageDatatype, data: slideElement?.slideData ?? Data())
        
//        ObjectFormatter.shared.loadImageInBackground(utType: imageDatatype, data: slideElement?.slideData ?? Data(), presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        
        presentationIV.image = UIImage(data: slideElement?.imageData ?? Data())
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        slideDescriptionLbl.text = nil
        presentationIV.image = nil
        slideTitleLbl.text = nil
    }

}
