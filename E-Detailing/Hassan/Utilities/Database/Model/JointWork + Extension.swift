//
//  JointWork + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 04/07/24.
//

import Foundation
import CoreData



extension JointWork {
    func setValues(fromDictionary dictionary: [String:Any],id : String)    {
        if let actFlgValue = dictionary["ActFlg"] as? String{
            actFlg = actFlgValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let desigValue = dictionary["Desig"] as? String{
            desig = desigValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let ownDivValue = dictionary["OwnDiv"] as? String{
            ownDiv = ownDivValue
        }
        if let reportingToSFValue = dictionary["Reporting_To_SF"] as? String{
            reportingToSF = reportingToSFValue
        }
        if let sfStatusValue = dictionary["SF_Status"] as? String{
            sfStatus = sfStatusValue
        }
        if let sfNameValue = dictionary["SfName"] as? String{
            sfName = sfNameValue
        }
        if let usrDfdUserNameValue = dictionary["UsrDfd_UserName"] as? String{
            usrDfdUserName = usrDfdUserNameValue
        }
        if let sfTypeValue = dictionary["sf_type"] as? String{
            sfType = sfTypeValue
        }
        if let stepsValue = dictionary["steps"] as? String{
            steps = stepsValue
        }
        
        mapId = id
        
    }
}
