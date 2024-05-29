//
//  Speciality + Extension.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 05/07/23.
//

import Foundation
import CoreData


extension Speciality {
    func setValues(fromDictionary dictionary: [String:Any]){
        if let codeValue = dictionary["Code"] as? Int{
            code = "\(codeValue)"
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let doctorSpecialNameValue = dictionary["Doc_Special_Name"] as? String{
            doctorSpecialName = doctorSpecialNameValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
    }
}

extension Departs {
    func setValues(fromDictionary dictionary: [String:Any]){
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let userNameValue = dictionary["User_Name"] as? String{
            userName = userNameValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
    }
}

extension DoctorClass {
    func setValues(fromDictionary dictionary: [String:Any]){
        if let codeValue = dictionary["Code"] as? Int{
            code = "\(codeValue)"
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let doctorClassNameValue = dictionary["Doc_ClsName"] as? String{
            doctorClassName = doctorClassNameValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
    }
}

extension DoctorCategory {
    func setValues(fromDictionary dictionary: [String:Any]){
        if let codeValue = dictionary["Code"] as? Int{
            code = "\(codeValue)"
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let doctorCategoryNameValue = dictionary["Doc_Cat_Name"] as? String{
            doctorCategoryName = doctorCategoryNameValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
    }
}

extension Qualifications {
    func setValues(fromDictionary dictionary: [String:Any]){
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let divisionCodeValue = dictionary["Division_Code"] as? String{
            divisionCode = divisionCodeValue
        }
        if let doctorQualificationNameValue = dictionary["Doc_QuaSName"] as? String{
            doctorQualificationName = doctorQualificationNameValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
    }
}
