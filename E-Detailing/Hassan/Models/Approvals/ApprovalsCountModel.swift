//
//  ApprovalsCountModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/07/24.
//

import Foundation


import Foundation

// MARK: - Temperatures
struct ApprovalsCountModel: Codable {
    let apprCount: [ApprCount]
}

// MARK: - ApprCount
class ApprCount: Codable {
    let dcrapprCount, leaveapprCount, tpapprCount, devapprCount: String?
    let geotagCount: String?

    enum CodingKeys: String, CodingKey {
        case dcrapprCount = "dcrappr_count"
        case leaveapprCount = "leaveappr_count"
        case tpapprCount = "tpappr_count"
        case devapprCount = "devappr_count"
        case geotagCount = "geotag_count"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dcrapprCount = container.safeDecodeValue(forKey: .dcrapprCount)
        self.leaveapprCount = container.safeDecodeValue(forKey: .leaveapprCount)
        self.tpapprCount = container.safeDecodeValue(forKey: .tpapprCount)
        self.devapprCount = container.safeDecodeValue(forKey: .devapprCount)
        self.geotagCount = container.safeDecodeValue(forKey: .geotagCount)
    }
}



class ApprovalsListModel: Codable {
    let planName, transSlNo, sfCode, fieldWorkIndicator: String
    let workTypeName, sfName, activityDate, submissionDate: String
    let reportingToSF, remarks, hlfday, additionalTempDetails: String

    enum CodingKeys: String, CodingKey {
        case planName = "Plan_Name"
        case transSlNo = "Trans_SlNo"
        case sfCode = "Sf_Code"
        case fieldWorkIndicator = "FieldWork_Indicator"
        case workTypeName = "WorkType_Name"
        case sfName = "Sf_Name"
        case activityDate = "Activity_Date"
        case submissionDate = "Submission_Date"
        case reportingToSF = "Reporting_To_SF"
        case remarks = "Remarks"
        case hlfday = "Hlfday"
        case additionalTempDetails = "Additional_Temp_Details"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.planName = container.safeDecodeValue(forKey: .planName)
        self.transSlNo = container.safeDecodeValue(forKey: .transSlNo)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.fieldWorkIndicator = container.safeDecodeValue(forKey: .fieldWorkIndicator)
        self.workTypeName = container.safeDecodeValue(forKey: .workTypeName)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.activityDate = container.safeDecodeValue(forKey: .activityDate)
        self.submissionDate = container.safeDecodeValue(forKey: .submissionDate)
        self.reportingToSF = container.safeDecodeValue(forKey: .reportingToSF)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.hlfday = container.safeDecodeValue(forKey: .hlfday)
        self.additionalTempDetails = container.safeDecodeValue(forKey: .additionalTempDetails)
    }
}



// MARK: - Temperature
class ApprovalDetailsModel: Codable {
    let transSlNo, transDetailSlno, type, transDetailInfoType: String
    let transDetailName, transDetailInfoCode, sdpName, products: String
    let gifts, remarks, jointwrk: String
    let pob: Int
    let callFeedback, visitTime, modTime, promotedProduct: String

    enum CodingKeys: String, CodingKey {
        case transSlNo = "Trans_SlNo"
        case transDetailSlno = "Trans_Detail_Slno"
        case type = "Type"
        case transDetailInfoType = "Trans_Detail_Info_Type"
        case transDetailName = "Trans_Detail_Name"
        case transDetailInfoCode = "Trans_Detail_Info_Code"
        case sdpName = "SDP_Name"
        case products, gifts, remarks, jointwrk, pob
        case callFeedback = "Call_Feedback"
        case visitTime
        case modTime = "ModTime"
        case promotedProduct = "promoted_product"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transSlNo = container.safeDecodeValue(forKey: .transSlNo)
        self.transDetailSlno = container.safeDecodeValue(forKey: .transDetailSlno)
        self.type = container.safeDecodeValue(forKey: .type)
        self.transDetailInfoType = container.safeDecodeValue(forKey: .transDetailInfoType)
        self.transDetailName = container.safeDecodeValue(forKey: .transDetailName)
        self.transDetailInfoCode = container.safeDecodeValue(forKey: .transDetailInfoCode)
        self.sdpName = container.safeDecodeValue(forKey: .sdpName)
        self.products = container.safeDecodeValue(forKey: .products)
        self.gifts = container.safeDecodeValue(forKey: .gifts)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.jointwrk = container.safeDecodeValue(forKey: .jointwrk)
        self.pob = container.safeDecodeValue(forKey: .pob)
        self.callFeedback = container.safeDecodeValue(forKey: .callFeedback)
        self.visitTime = container.safeDecodeValue(forKey: .visitTime)
        self.modTime = container.safeDecodeValue(forKey: .modTime)
        self.promotedProduct = container.safeDecodeValue(forKey: .promotedProduct)
    }
}


class LeaveApprovalDetail: Codable {
    let lvID, sfCode, sfName: String
    let fromDate, toDate: DateInfo
    let fDate, tDate, sfEmpID, noOfDays: String
    let lAvail, reason, address, lType: String

    enum CodingKeys: String, CodingKey {
        case lvID = "LvID"
        case sfCode = "Sf_Code"
        case sfName = "SFName"
        case fromDate = "From_Date"
        case toDate = "To_Date"
        case fDate = "FDate"
        case tDate = "TDate"
        case sfEmpID = "Sf_Emp_Id"
        case noOfDays = "No_of_Days"
        case lAvail = "LAvail"
        case reason = "Reason"
        case address = "Address"
        case lType = "LType"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lvID = try container.decode(String.self, forKey: .lvID)
        self.sfCode = try container.decode(String.self, forKey: .sfCode)
        self.sfName = try container.decode(String.self, forKey: .sfName)
        self.fromDate = try container.decode(DateInfo.self, forKey: .fromDate)
        self.toDate = try container.decode(DateInfo.self, forKey: .toDate)
        self.fDate = try container.decode(String.self, forKey: .fDate)
        self.tDate = try container.decode(String.self, forKey: .tDate)
        self.sfEmpID = try container.decode(String.self, forKey: .sfEmpID)
        self.noOfDays = try container.decode(String.self, forKey: .noOfDays)
        self.lAvail = try container.decode(String.self, forKey: .lAvail)
        self.reason = try container.decode(String.self, forKey: .reason)
        self.address = try container.decode(String.self, forKey: .address)
        self.lType = try container.decode(String.self, forKey: .lType)
    }
}
