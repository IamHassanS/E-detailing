//
//  UnListedDoctor + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/12/23.
//

import Foundation
import CoreData


extension UnListedDoctor {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext , id : String ) {
        if let addrsValue = dictionary["Addrs"] as? String{
            addrs = addrsValue
        }
        if let categoryValue = dictionary["CategoryName"] as? String{
            category = categoryValue
        }
        if let categoryCodeValue = dictionary["Category"] as? String{
            categoryCode = categoryCodeValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        
        if let dobData = dictionary["DOB"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: dobData)
            dob = effItem
        }
        
        if let dowData = dictionary["DOW"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: dowData)
            dow = effItem
        }
        
        if let emailValue = dictionary["Email"] as? String{
            email = emailValue
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
        if let qualValue = dictionary["Qual"] as? String{
            qual = qualValue
        }
        if let sfCodeValue = dictionary["SF_Code"] as? String{
            sfCode = sfCodeValue
        }
        if let specialtyValue = dictionary["Specialty"] as? String{
            specialty = specialtyValue
        }
        if let specialtyNameValue = dictionary["SpecialtyName"] as? String{
            specialtyName = specialtyNameValue
        }
        if let townCodeValue = dictionary["Town_Code"] as? String{
            townCode = townCodeValue
        }
        if let townNameValue = dictionary["Town_Name"] as? String{
            townName = townNameValue
        }
        if let docHospCodeValue = dictionary["doc_hospcode"] as? String{
            docHospCode = docHospCodeValue
        }
        if let docHospNameValue = dictionary["doc_hospname"] as? String{
            docHospName = docHospNameValue
        }
        
        if let latValue = dictionary["lat"] as? String{
            lat = latValue
        }
        if let longValue = dictionary["long"] as? String{
            long = longValue
        }
        
        if let taggedCountValue = dictionary["GEOTagCnt"] as? String{
            geoTagCnt = taggedCountValue
        }
        
        
        
        if let maxTagCount = dictionary["MaxGeoMap"] as? String{
            maxGeoMap = maxTagCount
        }
        
        if let taggedImage = dictionary["img_name"] as? String{
            imgName = taggedImage
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
