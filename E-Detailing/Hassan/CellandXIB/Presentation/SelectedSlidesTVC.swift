//
//  SelectedSlidesTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import UIKit

class SelectedSlidesTVC: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    
    
    @IBOutlet var deleteoptionView: UIView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var presentationIV: UIImageView!
    @IBOutlet var rearrangeView: UIView!
    @IBOutlet var contentsHolderVIew: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        presentationIV.contentMode = .scaleAspectFill
        presentationIV.layer.cornerRadius = 5
        contentsHolderVIew.layer.cornerRadius = 5
        contentsHolderVIew.backgroundColor = .appGreyColor
        //rearrangeView
        titleLbl.setFont(font: .bold(size: .BODY))
        descriptionLbl.setFont(font: .medium(size: .SMALL))
        titleLbl.textColor = .appTextColor
        showsReorderControl = false
        descriptionLbl.textColor = .appLightTextColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toPopulateCell(model: SlidesModel) {
        titleLbl.text = model.name
        if model.utType == "text/html" {
            descriptionLbl.text = model.fileName
        } else {
            descriptionLbl.text = model.filePath
        }
       

//       // descriptionLbl.text = model.filePath
//        let data =  model.slideData
//        let utType = model.utType
//        ObjectFormatter.shared.loadImageInBackground(utType: utType, data: data, presentationIV: presentationIV) { [weak self] displayImage in
//                    guard let welf = self else { return }
//                    welf.presentationIV.image = displayImage ?? UIImage()
//                }
        presentationIV.image = UIImage(data: model.imageData)
        
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        presentationIV.image = nil
   
    }

}
