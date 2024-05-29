//
//  MyDayPlan + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/12/23.
//

import Foundation
import CoreData


extension MyDayPlan {
    
    func setValues(fromDictionary dictionary: [String:Any], context: NSManagedObjectContext ) {
        if let fwFlgValue = dictionary["FWFlg"] as? String{
            fwFlg = fwFlgValue
        }
        if let hqNameValue = dictionary["HQNm"] as? String{
            hqName = hqNameValue
        }
        if let planValue = dictionary["Pl"] as? String{
            plan = planValue
        }
        if let planNameValue = dictionary["PlNm"] as? String{
            planName = planNameValue
        }
        if let remarksValue = dictionary["Rem"] as? String{
            remarks = remarksValue
        }
        if let sfCodeValue = dictionary["SFCode"] as? String{
            sfCode = sfCodeValue
        }
        if let sfMemValue = dictionary["SFMem"] as? String{
            sfMem = sfMemValue
        }
        
        if let dobData = dictionary["TPDt"] as? [String:Any]{
            let dateEntity = NSEntityDescription.entity(forEntityName: "Efff", in: context)
            let effItem = Efff(entity: dateEntity!, insertInto: context)
            effItem.setValues(fromDictionary: dobData)
            tpdt = effItem
        }
        
        if let tpDoctorValue = dictionary["TP_Doctor"] as? String{
            tpDoctor = tpDoctorValue
        }
        if let tpClusterValue = dictionary["TP_cluster"] as? String{
            tpCluster = tpClusterValue
        }
        if let tpWorktypeValue = dictionary["TP_worktype"] as? String{
            tpWorktype = tpWorktypeValue
        }
        if let tpVwFlgValue = dictionary["TpVwFlg"] as? String{
            tpVwFlg = tpVwFlgValue
        }
        if let workTypeValue = dictionary["WT"] as? String{
            workType = workTypeValue
        }
        if let workTypeNameValue = dictionary["WTNm"] as? String{
            workTypeName = workTypeNameValue
        }
    }
}
