//
//  ProductSlide + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import Foundation
import CoreData


extension ProductSlides {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)    {
        if let campValue = dictionary["Camp"] as? String{
            camp = campValue
        }
        if let categoryCodeValue = dictionary["Category_Code"] as? String{
            categoryCode = categoryCodeValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let filePathValue = dictionary["FilePath"] as? String{
            filePath = filePathValue
        }
        if let fileTypValue = dictionary["FileTyp"] as? String{
            fileType = fileTypValue
        }
        
        if let groupValue = dictionary["Group"] as? String{
            group = groupValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let noOfSamplesValue = dictionary["NoofSamples"] as? String{
            noOfSamples = noOfSamplesValue
        }
        
        if let orderNoValue = dictionary["OrdNo"] as? String{
            orderNo = orderNoValue
        }
        if let priorityValue = dictionary["Priority"] as? String{
            priority = priorityValue
        }
        if let productDetailCodeValue = dictionary["Product_Detail_Code"] as? String{
            productDetailCode = productDetailCodeValue
        }
        if let slideIdValue = dictionary["SlideId"] as? String{
            slideId = slideIdValue
        }
        if let specialityCodeValue = dictionary["Speciality_Code"] as? String{
            specialityCode = specialityCodeValue
        }
        
        
        if let toData = dictionary["EffTo"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: toData)
            effTo = effItem
        }
        
        
        if let fromData = dictionary["Eff_from"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: fromData)
            effFrom = effItem
        }
        
    }
}

extension SlideTheraptic {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)    {
        if let divisionCodeValue = dictionary["Name"] as? String{
            name = divisionCodeValue
        }
        if let idValue = dictionary["Code"] as? String{
            code = idValue
        }

    }
}

extension SlideBrand {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)    {
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let idValue = dictionary["ID"] as? String{
            id = idValue
        }
        if let priorityValue = dictionary["Priority"] as? String{
            priority = priorityValue
        }
        if let productBrandCodeValue = dictionary["Product_Brd_Code"] as? String{
            productBrandCode = productBrandCodeValue
        }
        if let subDivisionCodeValue = dictionary["Subdivision_Code"] as? String{
            subDivisionCode = subDivisionCodeValue
        }
        
        if let createdData = dictionary["Created_Date"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: createdData)
          //  createdDate = effItem
        }
        
        if let updetedData = dictionary["Updated_Date"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: updetedData)
          //  updatedDate = effItem
        }
    }
}

extension SlideSpeciality {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext)    {
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let doctorSpecialCodeValue = dictionary["Doc_Special_Code"] as? String{
            doctorSpecialCode = doctorSpecialCodeValue
        }
        if let idValue = dictionary["ID"] as? String{
            id = idValue
        }
        if let priorityValue = dictionary["Priority"] as? String{
            priority = priorityValue
        }
        if let productBrandCodeValue = dictionary["Product_Brd_Code"] as? String{
            productBrandCode = productBrandCodeValue
        }
        
        if let subDivisionCodeValue = dictionary["Subdivision_Code"] as? String{
            subDivisionCode = subDivisionCodeValue
        }
        
        
        if let createdData = dictionary["Created_Date"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: createdData)
            createdDate = effItem
        }
        
        if let updetedData = dictionary["Updated_Date"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: updetedData)
            updatedDate = effItem
        }
    }
}

extension Efff{
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let dateValue = dictionary["date"] as? String{
            date = dateValue
        }
        if let timezoneValue = dictionary["timezone"] as? String{
            timeZone = timezoneValue
        }
        if let timezoneTypeValue = dictionary["timezone_type"] as? Int{
            timeZoneType = Int16(timezoneTypeValue)
        }
    }
}


