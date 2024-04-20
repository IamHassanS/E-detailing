//
//  ChangePasswordView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/02/24.
//

public protocol addedSubViewsDelegate: AnyObject {
    func didClose()
    func didUpdate()
    func didUpdateCustomerCheckin(dcrCall: CallViewModel)
    func showAlert()
    func didUpdateFilters(filteredObjects: [NSManagedObject])
}

//extension addedSubViewsDelegate {
//    func didFilersUpdate()
//}

import Foundation
import UIKit
import CoreData
extension ChangePasswordView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let userPassword = appsetup.sfPassword
        
        guard let text = textField.text as NSString? else {
            return true
        }
        
        let updatedText = text.replacingCharacters(in: range, with: string)
        
        switch textField {
        case oldPasswordTF:
            if updatedText == userPassword {
                passwordValidationLbl.isHidden = true
                isOldePasswordVerified = true
                newPasswordTF.isUserInteractionEnabled = true
                repeatPasswordTF.isUserInteractionEnabled = true
                checkButtonStatus()
            } else {
                passwordValidationLbl.isHidden = false
                passwordValidationLbl.text = "Entered Password is incorrect"
                isOldePasswordVerified = false
                newPasswordTF.isUserInteractionEnabled = false
                repeatPasswordTF.isUserInteractionEnabled = false
                checkButtonStatus()
            }
            
        case newPasswordTF:
            if newpasswordStr != updatedText {
                repeatPasswordTF.text = ""
                isRepeatPasswordVerified = false
            }
            
            if updatedText.count >= 3 {
                //&& updatedText.containsSpecialCharacter
                newpasswordStr = updatedText
                passwordValidationLbl.isHidden = true
                isNewPasswordVerified = true
                checkButtonStatus()
            } else {
                passwordValidationLbl.isHidden = false
                passwordValidationLbl.text = "Password should be minimum 3 characters."
                //"Password should be alphanumeric, special character, min 8 char, combination upper case."
                isNewPasswordVerified = false
                checkButtonStatus()
            }
            
        case repeatPasswordTF:
            if updatedText == newPasswordTF.text {
                passwordValidationLbl.isHidden = true
                isRepeatPasswordVerified = true
                checkButtonStatus()
            } else {
                passwordValidationLbl.isHidden = false
                passwordValidationLbl.text = "Repeated password is incorrect"
                isRepeatPasswordVerified = false
                checkButtonStatus()
            }
            
        default:
            viewnewPasswordIV.alpha = 1
            viewrepeatPasswordIV.alpha = 1
            viewoldPasswordIV.alpha = 1
        }
        
        return true
    }

}


class ChangePasswordView: UIView {
    func checkButtonStatus() {
        if isOldePasswordVerified && isNewPasswordVerified && isRepeatPasswordVerified {
            btnUpdate.alpha = 1
            btnUpdate.isUserInteractionEnabled = true
        } else {
            btnUpdate.alpha = 0.5
            btnUpdate.isUserInteractionEnabled = false
        }
            
            
            
    }
    
    func initTaps() {
        viewnewPasswordIV.addTap { [weak self] in
            guard let welf = self else {return}
            welf.newPasswordTF.isSecureTextEntry =  welf.newPasswordTF.isSecureTextEntry == true ? false : true
            welf.setEyeimage()
          
        }
        
        viewoldPasswordIV.addTap {[weak self] in
            guard let welf = self else {return}
            welf.oldPasswordTF.isSecureTextEntry =  welf.oldPasswordTF.isSecureTextEntry == true ? false : true
            welf.setEyeimage()
            
        }
        
        viewrepeatPasswordIV.addTap {[weak self] in
            guard let welf = self else {return}
            welf.repeatPasswordTF.isSecureTextEntry =  welf.repeatPasswordTF.isSecureTextEntry == true ? false : true
            welf.setEyeimage()
        }
    }
    
    enum TextFields {
        case oldPasswordTF
        case newPasswordTF
        case repeatPasswordTF
    }
    
    
    func setTextfiledDelegates() {
        oldPasswordTF.isSecureTextEntry = true
        newPasswordTF.isSecureTextEntry = true
        repeatPasswordTF.isSecureTextEntry = true
        oldPasswordTF.delegate = self
        newPasswordTF.delegate = self
        repeatPasswordTF.delegate = self
        
    }
    var newpasswordStr = ""
    var selectedTF : TextFields = .oldPasswordTF
    var isOldePasswordVerified = false
    var isNewPasswordVerified = false
    var isRepeatPasswordVerified = false
    var userStatisticsVM: UserStatisticsVM?
    var appsetup : AppSetUp?
    @IBOutlet var passwordValidationLbl: UILabel!
    @IBOutlet var lblChangePassword: UILabel!
    
    @IBOutlet var closeIV: UIImageView!
    
    @IBOutlet var lblOldPassword: UILabel!
    
    @IBOutlet var oldPasswordTF: UITextField!
    
    @IBOutlet var viewoldPasswordIV: UIImageView!
    
    @IBOutlet var lblNewPassword: UILabel!
    
    @IBOutlet var oldPasswordTFholderStack: UIStackView!
    
    
    @IBOutlet var newPasswordTFholderStack: UIStackView!
    
    @IBOutlet var newPasswordTF: UITextField!
    
    @IBOutlet var viewnewPasswordIV: UIImageView!
    
    
    
    @IBOutlet var lblRepeatPassword: UILabel!
    @IBOutlet var repeatPasswordTFholderStack: UIStackView!
    
    @IBOutlet var repeatPasswordTF: UITextField!
    
    @IBOutlet var viewrepeatPasswordIV: UIImageView!
    
    @IBOutlet var btnUpdate: UIButton!
    
    
    var delegate: addedSubViewsDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
      

    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    

    @IBAction func didTapupdate(_ sender: Any) {
        
        
        updatePassword()
        
      
    }
    
    func updatePassword() {
        guard let appsetup = self.appsetup else {return}
         
     //  {"tableName":"savechpwd","txOPW":"123","txNPW":"1234","txCPW":"1234","sfcode":"MR0026","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,"}
        var param: [String: Any] = [:]
        param["tableName"] = "savechpwd"
        param["txOPW"] = oldPasswordTF.text ?? ""
        param["txNPW"] = newPasswordTF.text ?? ""
        param["txCPW"] =  repeatPasswordTF.text ?? ""
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["Designation"] = appsetup.desig
        param["sf_type"] = appsetup.sfType
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
  

        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        print(param)
        
        
        
        
        userStatisticsVM?.updateUserPassword(params: toSendData, api: .updatePassword, paramData: param) {result in
            
            switch result {
                
            case .success(let response):
               
               
                if response.isSuccess ?? false {
                    self.toCreateToast(response.checkinMasg ?? "Password updated successfully.")
                    self.delegate?.didUpdate()
                } else {
                    self.toCreateToast(response.checkinMasg ?? "Password updation failed.")
                  //  self.delegate?.didUpdate()
                }
            case .failure(let error):
               // self.delegate?.didUpdate()
                self.toCreateToast(error.rawValue)
                
            }
        }
    }
    

    func setEyeimage() {
        
        viewnewPasswordIV.image = newPasswordTF.isSecureTextEntry == true ? UIImage(systemName: "eye") :  UIImage(systemName: "eye.slash")
        
        viewnewPasswordIV.alpha =  viewnewPasswordIV.image == UIImage(systemName: "eye") ? 0.3 : 1
        
        viewrepeatPasswordIV.image = repeatPasswordTF.isSecureTextEntry == true ? UIImage(systemName: "eye") :  UIImage(systemName: "eye.slash")
        
        viewrepeatPasswordIV.alpha =  viewrepeatPasswordIV.image == UIImage(systemName: "eye") ? 0.3 : 1
        
        viewoldPasswordIV.image = oldPasswordTF.isSecureTextEntry == true ? UIImage(systemName: "eye") :  UIImage(systemName: "eye.slash")
        
        
        viewoldPasswordIV.alpha =  viewoldPasswordIV.image == UIImage(systemName: "eye") ? 0.3 : 1
    }
    
    
    func setupUI() {
        setTextfiledDelegates()
        
        setEyeimage()
        
        initTaps()
        passwordValidationLbl.setFont(font: .medium(size: .SMALL))
        passwordValidationLbl.textColor = .appLightPink
        lblChangePassword.setFont(font: .bold(size:  .BODY))
        lblNewPassword.setFont(font: .bold(size:  .BODY))
        lblOldPassword.setFont(font: .bold(size:  .BODY))
        lblChangePassword.setFont(font: .bold(size:  .BODY))
        
        lblRepeatPassword.setFont(font: .bold(size:  .BODY))
        
        
        self.layer.cornerRadius = 5
        btnUpdate.layer.cornerRadius = 5
        oldPasswordTFholderStack.layer.borderColor = UIColor.appGreyColor.cgColor
        oldPasswordTFholderStack.layer.borderWidth = 1
        oldPasswordTFholderStack.layer.cornerRadius = 5
        
        newPasswordTFholderStack.layer.borderColor = UIColor.appGreyColor.cgColor
        newPasswordTFholderStack.layer.borderWidth = 1
        newPasswordTFholderStack.layer.cornerRadius = 5
        
        repeatPasswordTFholderStack.layer.borderColor = UIColor.appGreyColor.cgColor
        repeatPasswordTFholderStack.layer.borderWidth = 1
        repeatPasswordTFholderStack.layer.cornerRadius = 5
        checkButtonStatus()
        newPasswordTF.isUserInteractionEnabled = false
        repeatPasswordTF.isUserInteractionEnabled = false
        passwordValidationLbl.isHidden = true
        closeIV.addTap {
            self.delegate?.didClose()
        }
    }

    
}
