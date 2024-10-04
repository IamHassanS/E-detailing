//
//  Doctor + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/12/23.
//

import Foundation
import CoreData



extension DoctorFencing {
    
    func setValues(fromDictionary dictionary: [String:Any],id : String)    {
        if let mProdValue = dictionary["MProd"] as? String{
            mProd = mProdValue
        }
        
        if let addrsValue = dictionary["Addrs"] as? String{
            addrs = addrsValue
        }
        if let categoryValue = dictionary["Category"] as? String{
            category = categoryValue
        }
        if let categoryCodeValue = dictionary["CategoryCode"] as? String{
            categoryCode = categoryCodeValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let dobValue = dictionary["DOB"] as? String{
            dob = dobValue
        }
        if let dowValue = dictionary["DOW"] as? String{
            dow = dowValue
        }
        if let docDesigValue = dictionary["DrDesig"] as? String{
            docDesig = docDesigValue
        }
        if let docEmailValue = dictionary["DrEmail"] as? String{
            docEmail = docEmailValue
        }
        if let geoTagCntValue = dictionary["GEOTagCnt"] as? String{
            geoTagCnt = geoTagCntValue
        }
        if let hosAddrValue = dictionary["HosAddr"] as? String{
            hosAddr = hosAddrValue
        }
        if let latValue = dictionary["Lat"] as? String{
            lat = latValue
        }
        if let longValue = dictionary["Long"] as? String{
            long = longValue
        }
        if let mappProductsValue = dictionary["MappProds"] as? String{
            mappProducts = mappProductsValue
        }
        if let maxGeoMapValue = dictionary["MaxGeoMap"] as? String{
            maxGeoMap = maxGeoMapValue
        }
        if let mobileValue = dictionary["Mobile"] as? String{
            mobile = mobileValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let phoneValue = dictionary["Phone"] as? String{
            phone = phoneValue
        }
        if let plcyAcptFlValue = dictionary["PlcyAcptFl"] as? String{
            plcyAcptFl = plcyAcptFlValue
        }
        if let productCodeValue = dictionary["Product_Code"] as? String{
            productCode = productCodeValue
        }
        if let resAddrValue = dictionary["ResAddr"] as? String{
            resAddr = resAddrValue
        }
        if let sfCodeValue = dictionary["SF_Code"] as? String{
            sfCode = sfCodeValue
        }
        if let specialityValue = dictionary["Specialty"] as? String{
            speciality = specialityValue
        }
        if let specialityCodeValue = dictionary["SpecialtyCode"] as? String{
            specialityCode = specialityCodeValue
        }
        if let townCodeValue = dictionary["Town_Code"] as? String{
            townCode = townCodeValue
        }
        if let townNameValue = dictionary["Town_Name"] as? String{
            townName = townNameValue
        }
        if let uRwIdValue = dictionary["uRwID"] as? String{
            uRwId = uRwIdValue
        }
        
        if let genderValue = dictionary["ListedDr_Sex"] as? String{
            drSex = genderValue
        }
        
        if let taggedImage = dictionary["img_name"] as? String{
            imageName = taggedImage
        }
     //   doctorClassName
        if let className = dictionary["Doc_Class_ShortName"] as? String{
            doctorClassName = className
        }
        
        //doctorClassCode
        if let classCode = dictionary["Doc_ClsCode"] as? String{
            doctorClassCode = classCode
        }
        mapId = id
    }
    
    
}
