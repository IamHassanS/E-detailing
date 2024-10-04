//
//  Stockist + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/12/23.
//

import Foundation
import CoreData


extension Stockist {
    
    func setValues(fromDictionary dictionary: [String:Any],id : String)    {
        if let addrValue = dictionary["Addr"] as? String{
            addr = addrValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let geoTagCntValue = dictionary["GEOTagCnt"] as? String{
            geoTagCnt = geoTagCntValue
        }
        if let maxGeoMapValue = dictionary["MaxGeoMap"] as? String{
            maxGeoMap = maxGeoMapValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let sfCodeValue = dictionary["SF_code"] as? String{
            sfCode = sfCodeValue
        }
        if let stkCreditDaysValue = dictionary["Sto_Credit_Days"] as? String{
            stkCreditDays = stkCreditDaysValue
        }
        if let stkCreditLimitValue = dictionary["Sto_Credit_Limit"] as? String{
            stkCreditLimit = stkCreditLimitValue
        }
        if let stkContDesigValue = dictionary["Stockiest_Cont_Desig"] as? String{
            stkContDesig = stkContDesigValue
        }
        if let stkEmailValue = dictionary["Stockiest_Email"] as? String{
            stkEmail = stkEmailValue
        }
        if let stkMobileValue = dictionary["Stockiest_Mobile"] as? String{
            stkMobile = stkMobileValue
        }
        if let stkPhoneValue = dictionary["Stockiest_Phone"] as? String{
            stkPhone = stkPhoneValue
        }
        if let townCodeValue = dictionary["Town_Code"] as? String{
            townCode = townCodeValue
        }
        if let townNameValue = dictionary["Town_Name"] as? String{
            townName = townNameValue
        }
        if let latValue = dictionary["lat"] as? String{
            lat = latValue
        }
        if let longValue = dictionary["long"] as? String{
            long = longValue
        }
        if let uRwIdValue = dictionary["uRwID"] as? String{
            uRwId = uRwIdValue
        }
        
        if let taggedImage = dictionary["img_name"] as? String{
            imgName = taggedImage
        }
        
        mapId = id
    }
}
