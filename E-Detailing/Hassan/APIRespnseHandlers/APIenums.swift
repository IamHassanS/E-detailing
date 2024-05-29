//
//  APIenums.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/01/24.
//


import Foundation
import Alamofire

enum APIEnums : String{
    
    case none = ""
    case actionLogin = "action/login"
    case tableSetup = "table/setups"
    case saveTP = "savenew/tp"
    case sendToApproval = "save/tp"
    case getAllPlansData = "get/tp"
    case getReports = "get/reports"
    case getTodayCalls = "table/additionaldcrmasterdata"
    case saveDCR = "save/dcr"
    case masterData = "table/dcrmasterdata"
    case myDayPlan = "edetsave/dayplan"
    case checkin = "save/activity"
    case updatePassword = "save/chpwd"
    case home = "home"
    case saveMAsterData = "save/masterdata"
    case deleteCall = "delete/dcr"
    case editCall = "edit/dcr"
    case imageUpload = "save/image"
    case saveTag = "geodetails"
    case leaveinfo = "get/leave"
    case toSubmitLeave = "save/leavemodule"
}


extension APIEnums{//Return method for API
    var method : HTTPMethod{
        switch self {
        case .actionLogin, .tableSetup, .saveTP, .getAllPlansData, .getReports, .getTodayCalls, .saveDCR:
            return .post
        default:
            return .get
        }
    }

    var cacheAttribute: Bool{
        switch self {
        default:
            return false
        }
    }
}
