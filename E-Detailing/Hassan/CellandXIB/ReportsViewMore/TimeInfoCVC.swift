//
//  TimeInfoCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

class TimeInfoCVC: UICollectionViewCell {
    @IBOutlet var checkINLbl: UILabel!
    
    
    @IBOutlet var checkOUTlLbl: UILabel!
    
    
    @IBOutlet var checkINinfoLbl: UILabel!
    
    
    @IBOutlet var checkOUTinfoLbl: UILabel!
    @IBOutlet var checkINaddrLbl: UILabel!
    
    @IBOutlet var checkOUTaddrLbl: UILabel!
    
    @IBOutlet var checkINviewLbl: UILabel!
    
    @IBOutlet var checkOUTviewLbl: UILabel!
    
    @IBOutlet var inandOutSeperator: UIView!
    @IBOutlet var checkoutLocationStack: UIStackView!
    
    @IBOutlet var chckinLocationStack: UIStackView!
    @IBOutlet var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    func toPopulateCell(model: ReportsModel) {
        checkINinfoLbl.text =  model.intime == "" ? "" :  model.intime
       // checkINinfoLbl.textAlignment =  model.intime == "" ? .center :  .left
        
        checkOUTinfoLbl.text = model.outtime == "" ? "" :  model.outtime
      //  checkOUTinfoLbl.textAlignment =  model.outtime == "" ? .center :  .left
        
        checkINaddrLbl.text =  model.inaddress == "" ? "" :  model.inaddress
        checkINaddrLbl.textAlignment =  model.inaddress == "" ? .center :  .left
        
        checkOUTaddrLbl.text = model.outaddress == "" ? "" :  model.outaddress
        checkOUTaddrLbl.textAlignment =  model.outaddress == "" ? .center :  .left
        
        chckinLocationStack.isHidden = model.inaddress == "" ? true : false
        checkoutLocationStack.isHidden = model.outaddress == "" ? true : false
    }
    
    func setupUI() {
        inandOutSeperator.backgroundColor = .appSelectionColor
        seperatorView.backgroundColor = .appSelectionColor
        let titLbls : [UILabel] = [checkINLbl, checkOUTlLbl]
        
        titLbls.forEach { label in
            label.textColor = .appLightTextColor
            label.setFont(font: .medium(size: .BODY))
        }
        
        let descLbls : [UILabel] = [ checkINinfoLbl, checkOUTinfoLbl, checkINaddrLbl, checkOUTaddrLbl, checkINviewLbl, checkOUTviewLbl]
        
        descLbls.forEach { label in
        
                label.setFont(font: .bold(size: .BODY))
            
            
            if label == checkINviewLbl ||  label == checkOUTviewLbl {
                label.textColor = .appLightPink
            } else {
                label.textColor = .appTextColor
            }
            
          
            
        }
    }

}
