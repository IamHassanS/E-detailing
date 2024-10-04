//
//  LeaveType + Extension.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 11/07/24.
//

import Foundation
import CoreData

extension LeaveType {
    
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext ) {
        if let activeFlagValue = dictionary["Active_Flag"] as? String{
            activeFlag = activeFlagValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let leaveNameValue = dictionary["Leave_Name"] as? String{
            leaveName = leaveNameValue
        }
        if let leaveSNameValue = dictionary["Leave_SName"] as? String{
            leaveSName = leaveSNameValue
        }
        if let leaveCodeValue = dictionary["Leave_code"] as? String{
            leaveCode = leaveCodeValue
        }
        
        if let createdDateData = dictionary["Created_Date"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: createdDateData)
            createdDate = effItem
        }
        
     
    }
    
}
