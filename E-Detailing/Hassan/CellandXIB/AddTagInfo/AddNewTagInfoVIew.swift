//
//  AddNewTagInfoVIew.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 14/05/24.
//

import Foundation
import UIKit
class AddNewTagInfoVIew: UIView{
  
    @IBOutlet var lblTaginfo: UILabel!
    
    @IBOutlet var lblLatitude: UILabel!
    
    @IBOutlet var lblLongitude: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var viewCancel: UIView!
    
    @IBOutlet var viewConfirm: UIView!
    
    @IBOutlet var lblCance: UILabel!
    
    @IBOutlet var lblConfirm: UILabel!
    
    
    var callVM: CallViewModel?
    
    weak var delegate: addedSubViewsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
    func setupUI(vm: CallViewModel) {
        viewCancel.layer.cornerRadius = 5
        viewConfirm.layer.cornerRadius = 5
        viewCancel.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        viewCancel.layer.borderWidth = 1
        viewCancel.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        viewConfirm.backgroundColor = .appTextColor
        
        lblCance.setFont(font: .bold(size: .BODY))
        
        lblConfirm.setFont(font: .bold(size: .BODY))
        
        
        lblCance.textColor = .appTextColor
        
        lblConfirm.textColor = .appWhiteColor
        
        
        
        lblTaginfo.setFont(font: .bold(size: .BODY))
        
        lblTaginfo.textColor = .appLightPink
        
        lblLatitude.setFont(font: .bold(size: .BODY))
        
        
        lblLongitude.setFont(font: .bold(size: .BODY))
        
        lblAddress.setFont(font: .medium(size: .BODY))
        
        self.callVM = vm
        viewCancel.addTap {
            self.delegate?.didClose()
        }
        
        
        viewConfirm.addTap {
            guard let vm = self.callVM else {return}
            self.delegate?.didUpdateCustomerCheckin(dcrCall: vm)
        }
    }
}
