//
//  DCRdetailViewEditView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 06/03/24.
//

import Foundation
import UIKit
import CoreData
import GoogleMaps


extension DCRdetailViewEditView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Select DOB"
            textView.textColor = UIColor.lightGray
        }

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      //  self.remarks = textView.text == "Type here.." ? "" : textView.text
     
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Select DOB"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
      
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}

extension DCRdetailViewEditView: MenuResponseProtocol {
    func passProductsAndInputs(product: ProductSelectedListViewModel, additioncall: AdditionalCallsListViewModel,index: Int) {
        print("Yet to implement")
    }
    
    func routeToView(_ view: UIViewController) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        switch type {

        case .qualification:
            let aQualification: Qualifications = selectedObject  as? Qualifications ?? Qualifications()
            
            qualificationInputLbl.text = aQualification.name ?? ""
            
        case .category:
            let acategory: DoctorCategory = selectedObject  as? DoctorCategory ?? DoctorCategory()
            
            categoryInputLbl.text = acategory.name ?? ""
            
        case .speciality:
            let aspeciality: Speciality = selectedObject  as? Speciality ?? Speciality()
            
            specialityInputLbl.text = aspeciality.name ?? ""
            
        default:
            print("Yet to implement")
        }
    }
    
    
}

class DCRdetailViewEditView: BaseView, UITextFieldDelegate {
    
    enum Gender {
        case male
        case female
    }
    
    func setGender(gender: Gender) {
        switch gender {
        case .male:
            maleIV.image = UIImage(named: "checkBoxSelected")
            
            
            femaleIV.image = UIImage(named: "checkBoxEmpty")
            
            
        case .female:
            femaleIV.image = UIImage(named: "checkBoxSelected")
            
            maleIV.image = UIImage(named: "checkBoxEmpty")
            
        }
    }
    
    var dcrdetailViewEditVc : DCRdetailViewEditVC!
   
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var lblGender: UILabel!
    
    @IBOutlet var maleTapView: UIView!
    
    @IBOutlet var lblMale: UILabel!
    @IBOutlet var femaleTapView: UIView!
    
    @IBOutlet var lblFemale: UILabel!
    
    @IBOutlet var qualificationLbl: UILabel!
    
    @IBOutlet var qualificationInputLbl : UILabel!
    @IBOutlet var specialityShadowStack: UIStackView!
    
    @IBOutlet var specialityInputLbl: UILabel!
    
    @IBOutlet var specialityLbl: UILabel!
    @IBOutlet var qualificationShadowStack: UIStackView!
    
    
    @IBOutlet var categoryLbl: UILabel!
    
    @IBOutlet var categoryShadowStack: UIStackView!
    
    @IBOutlet var categoryInputLbl: UILabel!
    
    
    @IBOutlet var dobLbl: UILabel!
    
    @IBOutlet var dobShadowStack: UIStackView!
    
    @IBOutlet var dobTF: UITextField!
    
    @IBOutlet var dowLbl: UILabel!
    
    
    @IBOutlet var dowShadoeStack: UIStackView!
    
    
    @IBOutlet var dowTF: UITextField!
    
    @IBOutlet var districtLbl: UILabel!
    
    
    @IBOutlet var districtShadowStack: UIStackView!
    
    @IBOutlet var districtTF: UITextField!
    
    @IBOutlet var cityLbl: UILabel!
    
    
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var cityShadowStack: UIStackView!
    
    
    
    @IBOutlet var addressTitle: UILabel!
    
    
    @IBOutlet var mainAddressLbl: UILabel!
    
    
    @IBOutlet var mainAddressShadowView: UIView!
    @IBOutlet var mainAddressTV: UITextView!
    
    
    @IBOutlet var mobileLbl: UILabel!
    
    
    @IBOutlet var mobilenumberShadoeView: UIView!
    
    @IBOutlet var mobileTF: UITextField!
    
    @IBOutlet var phoneLbl: UILabel!
    
    
    @IBOutlet var phoneNumberShadowView: UIView!
    
    
    @IBOutlet var phoneNumberTF: UITextField!
    
    
    @IBOutlet var emailLbl: UILabel!
    
    @IBOutlet var emailShadowView: UIView!
    
    
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var clearLbl: UILabel!
    @IBOutlet var clearVIew: UIView!
    
    
    @IBOutlet var submitView: UIView!
    
    
    @IBOutlet var submitLbl: UILabel!
    
    @IBOutlet var doctorInfoVIew: UIView!
    
    @IBOutlet var backHolderVIew: UIView!
    
    @IBOutlet var contactsInfoView: UIView!
    @IBOutlet var contentsHolder: UIView!
    
    @IBOutlet var gmsMapHolderView: UIView!
    @IBOutlet var addrressDetailRightStach: UIStackView!
    @IBOutlet var addressDetailLeftStack: UIStackView!
    @IBOutlet var maleIV: UIImageView!
    
    @IBOutlet var btnAddGeoTag: UIButton!
    @IBAction func didTapGeoTag(_ sender: Any) {
    }
    @IBOutlet var femaleIV: UIImageView!
    var stockist: Stockist?
    var listedDoctor: DoctorFencing?
    var unlistedDoctor: UnListedDoctor?
    var chemist: Chemist?
    var pickertype: PickerType = .DOB
    var category: [DoctorCategory]?
    var qualifications: [Qualifications]?
    let datePicker = UIDatePicker()
    var gmsMapView = GMSMapView()
    
    enum PickerType {
        case DOB
        case DOW
    }
    
    func setupUI() {
    
        let mainTitles : [UILabel] = [titleLbl, addressTitle, clearLbl, submitLbl]
        
        doctorInfoVIew.backgroundColor = .appWhiteColor
        contactsInfoView.backgroundColor = .clear
        addrressDetailRightStach.layer.cornerRadius = 5
        addrressDetailRightStach.backgroundColor = .appWhiteColor
        
        addressDetailLeftStack.layer.cornerRadius = 5
        addressDetailLeftStack.backgroundColor = .appWhiteColor
        
        doctorInfoVIew.layer.cornerRadius = 5
        contactsInfoView.layer.cornerRadius = 5
    
     
        contentsHolder.backgroundColor = .appGreyColor
        mainTitles.forEach {
            $0.setFont(font: .bold(size: .BODY))
            $0.textColor = .appTextColor
        }
        submitLbl.textColor = .appWhiteColor
        titleLbl.textColor = .appWhiteColor
        clearVIew.layer.cornerRadius = 5
        clearVIew.layer.borderColor = UIColor.appLightTextColor.cgColor
        clearVIew.layer.borderWidth = 1
        clearVIew.layer.cornerRadius = 5
        
        
        submitView.layer.cornerRadius = 5
        submitView.backgroundColor = .appTextColor
        
        let subtitles: [UILabel] = [lblGender, qualificationLbl, specialityLbl, categoryLbl, dobLbl, dowLbl, districtLbl, cityLbl, mainAddressLbl, mobileLbl, phoneLbl, emailLbl]
        
        subtitles.forEach {
            $0.setFont(font: .bold(size: .BODY))
            $0.textColor = .appTextColor
        }
        
        let shadowViews: [UIView] = [qualificationShadowStack, specialityShadowStack, categoryShadowStack, dobShadowStack, dowShadoeStack, districtShadowStack, cityShadowStack, mainAddressShadowView, mobilenumberShadoeView, phoneNumberShadowView, emailShadowView]
        
        
        shadowViews.forEach {
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.appSelectionColor.cgColor
            
        }
        
        
        let textFields: [UITextField] = [dowTF, dobTF, districtTF, cityTF, mobileTF, phoneNumberTF, emailTF]
        
        textFields.forEach {
            $0.font = UIFont(name: "Satoshi-Medium", size: 14)
        }
        
       // mainAddressTV.font = UIFont(name: "Satoshi-Medium", size: 14)
        
        
        mainAddressTV.textColor = .appTextColor
        mainAddressTV.font = UIFont(name: "Satoshi-Medium", size: 14)
        
        lblMale.setFont(font: .medium(size: .BODY))
        lblFemale.setFont(font: .medium(size: .BODY))
        
        qualificationInputLbl.setFont(font: .medium(size: .BODY))
        specialityInputLbl.setFont(font: .medium(size: .BODY))
        categoryInputLbl.setFont(font: .medium(size: .BODY))
        btnAddGeoTag.layer.cornerRadius = 5
        btnAddGeoTag.layer.borderWidth = 2
        btnAddGeoTag.layer.borderColor = UIColor.appLightPink.cgColor
        
        
        gmsMapView.layer.cornerRadius = 5
        gmsMapView.clipsToBounds = true
        
        dobTF.delegate = self
        dowTF.delegate = self
    }
    
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        self.dcrdetailViewEditVc = baseVC as? DCRdetailViewEditVC
        
        

        gmsMapView.frame = gmsMapHolderView.bounds
        
    }
    
    func addMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        

   
        
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
     //   marker.title = "Marker Title"
     //   marker.snippet = "Marker Snippet"
        marker.map = gmsMapView
        
        self.gmsMapHolderView.addSubview(gmsMapView)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dowTF {
            // 'dowTF' was tapped
            self.pickertype = .DOW
        } else if textField == dobTF {
            // 'dobTF' was tapped
            self.pickertype = .DOB
        }
    }
    
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.dcrdetailViewEditVc = baseVC as? DCRdetailViewEditVC
        setupUI()
        dcrdetailViewEditVc.setupModel()
        initTaps()
  
    }
    
    func initTaps() {
        
        showDatePicker()
        
        femaleTapView.addTap {
            self.setGender(gender: .female)
        }
        
        maleTapView.addTap {
            self.setGender(gender: .male)
        }
        
        backHolderVIew.addTap {
            self.dcrdetailViewEditVc.dismiss(animated: true)
        }
        
        qualificationShadowStack.addTap { [weak self] in
            guard let welf = self else {return}
            welf.showMenu(type: .qualification)
        }
        
        
        specialityShadowStack.addTap {[weak self] in
            guard let welf = self else {return}
            welf.showMenu(type: .speciality)
            
        }
        
        
        categoryShadowStack.addTap {[weak self] in
            guard let welf = self else {return}
            welf.showMenu(type: .category)
        }
        

        
        
        
    }
    
    func showMenu(type: MenuView.CellType) {
        
        let vc = SpecifiedMenuVC.initWithStory(self, celltype: type)
        dcrdetailViewEditVc.modalPresentationStyle = .custom
        dcrdetailViewEditVc.present(vc, animated: false)
        
    }
    
    func showDatePicker(){
      //Formate Date
      datePicker.datePickerMode = .date
        datePicker.tintColor = .appTextColor
   
     //ToolBar
     let toolbar = UIToolbar();
     toolbar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donedatePicker));
       doneButton.tintColor = .appTextColor
      //  let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker));
        cancelButton.tintColor = .appLightPink
        toolbar.setItems([doneButton,cancelButton], animated: true)
//spaceButton,
        dowTF.inputAccessoryView = toolbar
        dowTF.inputView = datePicker
        
        
        dobTF.inputAccessoryView = toolbar
        dobTF.inputView = datePicker
        
        
        

   }
    
    
    
    @objc func cancelDatePicker(){
       self.endEditing(true)
     }
    
    @objc func donedatePicker(){

        switch self.pickertype {
        case .DOB:
            dobTF.text = datePicker.date.toString(format: "dd - MMM")
        case .DOW:
            dowTF.text = datePicker.date.toString(format: "dd - MMM")
        }
        
    
 
     self.endEditing(true)
   }
    
    func toPopulateVIew() {
        

        switch dcrdetailViewEditVc.pageType {
        case .doctor:
            guard let model = listedDoctor else {return}
            self.titleLbl.text = model.name
            qualificationInputLbl.text   = model.docDesig == "" ? "Select Qualification" :  model.docDesig
            
            qualificationInputLbl.textColor   = model.docDesig == "" ? UIColor.appGreyColor :  UIColor.appTextColor
            
            specialityInputLbl.text = model.speciality == "" ? "Select Speciality" :  model.speciality
            
            specialityInputLbl.textColor   = model.speciality == "" ? UIColor.appGreyColor :  UIColor.appTextColor
            
            categoryInputLbl.text = model.category == "" ? "Select Category" :  model.category
            
            categoryInputLbl.textColor   = model.category == "" ? UIColor.appGreyColor :  UIColor.appTextColor
            
            dobTF.text = model.dob  == "" ?  "Please select DOB":   model.dob
            dowTF.text = model.dow  == "" ?  "Please select DOW":   model.dow
            
            dobTF.textColor = model.dob  == "" ? UIColor.lightGray :  UIColor.appTextColor
            
            dowTF.textColor = model.dow  == "" ? UIColor.lightGray :  UIColor.appTextColor
            
            districtTF.text =  "-"
            //model.addrs
            cityTF.text =  "-"
            //model.addrs
            //mainAddressTV.textColor = model.addrs
            //== "" ? UIColor.appGreyColor :  UIColor.appTextColor
            
            
            mainAddressTV.text = model.addrs 
            //== "" ?  "Enter main address":   model.addrs
     
            
            mobileTF.text = model.mobile
            phoneNumberTF.text = model.phone
            emailTF.text = model.docEmail
            if let genderVal = model.drSex, genderVal != "" {
                self.setGender(gender: genderVal == "M" ? .male : .female)
            }
            
            if let lat = model.lat, let long = model.long, lat != "", long != "" {
                
                addMarker(latitude: Double(lat) ?? Double() , longitude: Double(long) ?? Double())
            }
          
        case .chemist:
            print("Yet to implement")
        case .stockist:
            print("Yet to implement")
        case .unlistedDoctor:
            print("Yet to implement")
        case .cip:
            print("Yet to implement")
        case .hospital:
            print("Yet to implement")
        }
    }
    
    func didEnableSave(_ istoenadble: Bool) {
        
    }
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.dcrdetailViewEditVc = baseVC as? DCRdetailViewEditVC
       // specialityTF
       // qualificationShadowStack
    }
    
}
