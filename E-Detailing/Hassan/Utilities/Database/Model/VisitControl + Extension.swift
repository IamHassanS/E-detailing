//
//  VisitControl + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 11/07/24.
//

import Foundation
import CoreData


extension VisitControl {
    
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let custCodeValue = dictionary["CustCode"] as? String{
            custCode = custCodeValue
        }
        if let custNameValue = dictionary["CustName"] as? String{
            custName = custNameValue
        }
        if let custTypeValue = dictionary["CustType"] as? String{
            custType = custTypeValue
        }
        if let dcrDtValue = dictionary["Dcr_dt"] as? String{
            dcrDt = dcrDtValue
        }
        if let dcrFlagValue = dictionary["Dcr_flag"] as? String{
            dcrFlag = dcrFlagValue
        }
        if let monthValue = dictionary["Mnth"] as? String{
            month = monthValue
        }
        if let yearValue = dictionary["Yr"] as? String{
            year = yearValue
        }
        if let townCodeValue = dictionary["town_code"] as? String{
            townCode = townCodeValue
        }
        if let townNameValue = dictionary["town_name"] as? String{
            townName = townNameValue
        }
    }
}


extension MapCompDet{
    
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let competitorProductBulkValue = dictionary["Competitor_Prd_bulk"] as? String{
            competitorProductBulk = competitorProductBulkValue
        }
        if let ourProductCodeValue = dictionary["Our_prd_code"] as? String{
            ourProductCode = ourProductCodeValue
        }
        if let ourProductNameValue = dictionary["Our_prd_name"] as? String{
            ourProductName = ourProductNameValue
        }
    }
}
