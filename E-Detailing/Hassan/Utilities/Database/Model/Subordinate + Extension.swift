//
//  Subordinate + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/07/24.
//

import Foundation
import CoreData

extension Subordinate{

    func setValues(fromDictionary dictionary: [String:Any],context: NSManagedObjectContext,id1: String)    {
        if let idValue = dictionary["id"] as? String{
            id = idValue
        }
        if let nameValue = dictionary["name"] as? String{
            name = nameValue
        }
        if let reportingToSFValue = dictionary["Reporting_To_SF"] as? String{
            reportingToSF = reportingToSFValue
        }
        if let stepsValue = dictionary["steps"] as? String{
            steps = stepsValue
        }
        
        if let sfHqValue = dictionary["SF_HQ"] as? String{
            sfHq = sfHqValue
        }
        
        mapId = id1
        
        if let tPDtData = dictionary["SF_DOB"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: tPDtData)
            sfDob = effItem
        }
        
        
        if let tPDtData = dictionary["SF_DOW"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: tPDtData)
            sfDow = effItem
        }
        
    }
}
