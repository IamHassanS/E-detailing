//
//  AddCompetitorsView.swift
//  E-Detailing
//
//  Created by San eforce on 26/06/24.
//

import Foundation
import UIKit
import CoreData

extension AddCompetitorsView:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ensure the current text is non-nil
        guard let text = textField.text as NSString? else { return false }
        
        // Determine the updated text after the replacement
        let updatedText = text.replacingCharacters(in: range, with: string)
        
        // Print the updated text for debugging
        print("New text: \(updatedText)")
        
        // Check if the updated text starts with a space
        if updatedText.first == " " {
            return false
        }
        
        // Split the updated text by spaces
        let components = updatedText.split(separator: " ")
        
        // If there are more than one space between words, the split count will be different
        if updatedText.contains("  ") {
            return false
        }
        
        // Ensure each component between spaces is non-empty
        for component in components {
            if component.isEmpty {
                return false
            }
        }

        
        checkButtonStatus()
        return true
    }
    
}

class AddCompetitorsView: UIView {
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var productTitleLbl: UILabel!
    
    @IBOutlet var productTFholderVIew: UIView!
    
    @IBOutlet var productTitleTF: UITextField!
    
    @IBOutlet var companyTitleLbl: UILabel!
    
    @IBOutlet var companyTFholderView: UIView!
    
    @IBOutlet var companyTitleTF: UITextField!
    
    
    @IBOutlet var btnClear: UIButton!
    
    @IBOutlet var btnAdd: ShadowButton!
    
    @IBOutlet var closeIV: UIImageView!
    
    var delegate: addedSubViewsDelegate?
    
    var ourProductCode = ""
    
    var ourProductName = ""
    
    func initTaps() {
        closeIV.addTap {
            self.delegate?.didClose()
        }
    }
    
    func checkButtonStatus() {
        guard   let companyTitle = companyTitleTF.text, let productTitle = productTitleTF.text else {
            btnAdd.alpha = 0.5
            btnAdd.isUserInteractionEnabled = false
            return}
        if !companyTitle.isEmpty && !productTitle.isEmpty  {
            btnAdd.alpha = 1
            btnAdd.isUserInteractionEnabled = true
        } else {
            btnAdd.alpha = 0.5
            btnAdd.isUserInteractionEnabled = false
        }
            
            
            
    }
    
    
    @IBAction func didTapAddCompetitor(_ sender: Any) {
        
  
        
        addNewCompetitor()
        
      
    }
    
    func addNewCompetitor() {
        
        let contextNew = DBManager.shared.managedContext()
        let masterData = DBManager.shared.getMasterData()
        if  let competitorEntity = NSEntityDescription.entity(forEntityName: "MapCompDet", in: contextNew) {
            let competitorObj = MapCompDet(entity: competitorEntity, insertInto: contextNew)
            
            let compProductSlNo = "-\(generateRandomFourDigitNumber())"
            let compProductName = productTitleTF.text ?? ""
            let compSlNo = "-\(generateRandomFourDigitNumber())"
            let compName = companyTitleTF.text ?? ""
          
             let competitorProductBulk = "\(compProductSlNo)#\(compProductName)~\(compSlNo)$\(compName)/"
            competitorObj.competitorProductBulk = competitorProductBulk
            
            competitorObj.index = Int16(DBManager.shared.getCompetitor().count + 1)
            
            competitorObj.ourProductCode = Shared.instance.selectedProductCode
            
            competitorObj.ourProductName = Shared.instance.selectedProductName
            
            var mapCompDetArray = [MapCompDet]()
            mapCompDetArray.append(competitorObj)
            
            mapCompDetArray.forEach{ (type) in
                masterData.addToMapCompDet(type)
            }
            DBManager.shared.saveContext()
            
            self.delegate?.didUpdate()
        }
  
            
        func generateRandomFourDigitNumber() -> String {
            let randomNumber = Int.random(in: 1000...9999)
            return String(randomNumber)
        }
        
        
    }
    
    @IBAction func didTapClearCompetitor(_ sender: Any) {
        
        
      //  updatePassword()
        
        self.companyTitleTF.text = ""
        self.productTitleTF.text = ""
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      

    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
    func setupUI() {
        checkButtonStatus()
        initTaps()
        companyTitleTF.delegate = self
        productTitleTF.delegate = self
        self.layer.cornerRadius = 5
        btnClear.layer.cornerRadius = 5
        btnClear.layer.borderWidth = 1
        btnClear.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnClear.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        btnAdd.layer.cornerRadius = 5
        
        
        productTFholderVIew.layer.cornerRadius = 5
        productTFholderVIew.layer.borderWidth = 1
        productTFholderVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        companyTFholderView.layer.cornerRadius = 5
        companyTFholderView.layer.borderWidth = 1
        companyTFholderView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        titleLbl.setFont(font: .bold(size: .BODY))
        
        productTitleLbl.setFont(font: .bold(size: .BODY))
        
        productTitleLbl.textColor = .appLightTextColor
        
        companyTitleLbl.setFont(font: .bold(size: .BODY))
        
        
        companyTitleLbl.textColor = .appLightTextColor
        
        
    }
}
