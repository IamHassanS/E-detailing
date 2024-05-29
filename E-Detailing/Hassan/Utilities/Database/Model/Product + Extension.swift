//
//  Product + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 05/07/23.
//

import Foundation
import CoreData


extension Product {
    func setValues(fromDictionary dictionary: [String:Any],id : String)    {
        if let actFlgValue = dictionary["ActFlg"] as? String{
            actFlg = actFlgValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let dRateValue = dictionary["DRate"] as? String{
            dRate = dRateValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let noOfSamplesValue = dictionary["NoofSamples"] as? String{
            noOfSamples = noOfSamplesValue
        }
        if let cateIdValue = dictionary["cateid"] as? String{
            cateId = cateIdValue
        }
        if let pSlNoValue = dictionary["pSlNo"] as? String{
            pSlNo = pSlNoValue
        }
        if let productModeValue = dictionary["Product_Mode"] as? String{
            productMode = productModeValue
        }
        mapId = id
    }
}

extension Input {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext,id : String)    {
        
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        
        if let effFData = dictionary["EffF"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: effFData)
            effF = effItem
        }
        
        if let effTData = dictionary["EffT"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: effTData)
            effT = effItem
        }
        mapId = id
    }
}

extension Brand {
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
    }
}

extension Competitor {
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let compNameValue = dictionary["Comp_Name"] as? String{
            compName = compNameValue
        }
        if let compProductSlNoValue = dictionary["Comp_Prd_Sl_No"] as? String{
            compProductSlNo = compProductSlNoValue
        }
        if let compProductNameValue = dictionary["Comp_Prd_name"] as? String{
            compProductName = compProductNameValue
        }
        if let compSlNoValue = dictionary["Comp_Sl_No"] as? String{
            compSlNo = compSlNoValue
        }
        if let ourProductCodeValue = dictionary["Our_prd_code"] as? String{
            ourProductCode = ourProductCodeValue
        }
        if let ourProductNameValue = dictionary["Our_prd_name"] as? String{
            ourProductName = ourProductNameValue
        }
    }
}


extension Feedback {
    func setValues(fromDictionary dictionary: [String:Any]) {
        if let idValue = dictionary["id"] as? String{
            id = idValue
        }
        if let nameValue = dictionary["name"] as? String{
            name = nameValue
        }
    }
}
