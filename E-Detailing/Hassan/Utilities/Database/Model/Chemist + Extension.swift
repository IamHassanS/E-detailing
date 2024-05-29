//
//  Chemist + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/12/23.
//

import Foundation
import CoreData


extension Chemist {
    
    func setValues(fromDictionary dictionary: [String:Any],id : String)    {
        if let addrValue = dictionary["Addr"] as? String{
            addr = addrValue
        }
        if let chemistContactValue = dictionary["Chemists_Contact"] as? String{
            chemistContact = chemistContactValue
        }
        if let chemistEmailValue = dictionary["Chemists_Email"] as? String{
            chemistEmail = chemistEmailValue
        }
        if let chemistFaxValue = dictionary["Chemists_Fax"] as? String{
            chemistFax = chemistFaxValue
        }
        if let chemistMobileValue = dictionary["Chemists_Mobile"] as? String{
            chemistMobile = chemistMobileValue
        }
        if let chemistPhoneValue = dictionary["Chemists_Phone"] as? String{
            chemistPhone = chemistPhoneValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
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
        if let sfCodeValue = dictionary["SF_Code"] as? String{
            sfCode = sfCodeValue
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
        
        if let taggedImage = dictionary["img_name"] as? String{
            imgName = taggedImage
        }
        mapId = id
    }
}
