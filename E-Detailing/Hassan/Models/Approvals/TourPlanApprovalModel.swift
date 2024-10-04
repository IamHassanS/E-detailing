//
//  TourPlanApprovalModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/07/24.
//

import Foundation
// MARK: - Temperature
class TourPlanApprovalModel: Codable {
    let sfCode, sfName, mn, mnth: String
    let yr: String
    let divisionCode: Int

    enum CodingKeys: String, CodingKey {
        case sfCode = "Sf_Code"
        case sfName = "SFName"
        case mn = "Mn"
        case mnth = "Mnth"
        case yr = "Yr"
        case divisionCode = "Division_Code"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.mn = container.safeDecodeValue(forKey: .mn)
        self.mnth = container.safeDecodeValue(forKey: .mnth)
        self.yr = container.safeDecodeValue(forKey: .yr)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
    }
}
// MARK: - Temperature
class TourPlanApprovalDetailModel: Codable {
    var isExtended: Bool
    let sfCode: String
    let sfName: String
    let div, mnth, yr, dayno: String
    let changeStatus, rejectionReason, tpDt, wtCode: String
    let wtCode2, wtCode3, wtName: String
    let wtName2: String
    let wtName3: String
    let clusterCode, clusterCode2, clusterCode3: String
    let clusterName: String
    let clusterName2: String
    let clusterName3: String
    let clusterSFS: String
    let clusterSFNms: String
    let jwCodes, jwNames: String
    let jwCodes2: String
    let jwNames2: String
    let jwCodes3, jwNames3: String
    let drCode: String
    let drName: String
    let drTwoCode: String
    let drTwoName: String
    let drThreeCode, drThreeName: String
    let chemCode: String
    let chemName: String
    let chemTwoCode: String
    let chemTwoName: String
    let chemThreeCode, chemThreeName: String
    let stockistCode: String
    let stockistName: String
    let stockistTwoCode: String
    let stockistTwoName: String
    let stockistThreeCode, stockistThreeName, day: String
    let tourMonth, tourYear: Int
    let tpmonth: String
    let tpday: String
    let dayRemarks: String
    let dayRemarks2: String
    let dayRemarks3, access, eFlag: String
    let fwFlg: String
    let fwFlg2, fwFlg3: String
    let hqCodes: String
    let hqNames: String
    let hqCodes2: String
    let hqNames2: String
    let hqCodes3: String
    let hqNames3: String
    let submittedTime: DateInfo
    let entryMode: String
    let sfTPActiveDt: String

    enum CodingKeys: String, CodingKey {
        case sfCode = "SFCode"
        case sfName = "SFName"
        case div = "Div"
        case mnth = "Mnth"
        case yr = "Yr"
        case dayno
        case changeStatus = "Change_Status"
        case rejectionReason = "Rejection_Reason"
        case tpDt = "TPDt"
        case wtCode = "WTCode"
        case wtCode2 = "WTCode2"
        case wtCode3 = "WTCode3"
        case wtName = "WTName"
        case wtName2 = "WTName2"
        case wtName3 = "WTName3"
        case clusterCode = "ClusterCode"
        case clusterCode2 = "ClusterCode2"
        case clusterCode3 = "ClusterCode3"
        case clusterName = "ClusterName"
        case clusterName2 = "ClusterName2"
        case clusterName3 = "ClusterName3"
        case clusterSFS = "ClusterSFs"
        case clusterSFNms = "ClusterSFNms"
        case jwCodes = "JWCodes"
        case jwNames = "JWNames"
        case jwCodes2 = "JWCodes2"
        case jwNames2 = "JWNames2"
        case jwCodes3 = "JWCodes3"
        case jwNames3 = "JWNames3"
        case drCode = "Dr_Code"
        case drName = "Dr_Name"
        case drTwoCode = "Dr_two_code"
        case drTwoName = "Dr_two_name"
        case drThreeCode = "Dr_three_code"
        case drThreeName = "Dr_three_name"
        case chemCode = "Chem_Code"
        case chemName = "Chem_Name"
        case chemTwoCode = "Chem_two_code"
        case chemTwoName = "Chem_two_name"
        case chemThreeCode = "Chem_three_code"
        case chemThreeName = "Chem_three_name"
        case stockistCode = "Stockist_Code"
        case stockistName = "Stockist_Name"
        case stockistTwoCode = "Stockist_two_code"
        case stockistTwoName = "Stockist_two_name"
        case stockistThreeCode = "Stockist_three_code"
        case stockistThreeName = "Stockist_three_name"
        case day = "Day"
        case tourMonth = "Tour_Month"
        case tourYear = "Tour_Year"
        case tpmonth, tpday
        case dayRemarks = "DayRemarks"
        case dayRemarks2 = "DayRemarks2"
        case dayRemarks3 = "DayRemarks3"
        case access
        case eFlag = "EFlag"
        case fwFlg = "FWFlg"
        case fwFlg2 = "FWFlg2"
        case fwFlg3 = "FWFlg3"
        case hqCodes = "HQCodes"
        case hqNames = "HQNames"
        case hqCodes2 = "HQCodes2"
        case hqNames2 = "HQNames2"
        case hqCodes3 = "HQCodes3"
        case hqNames3 = "HQNames3"
        case submittedTime = "submitted_time"
        case entryMode = "Entry_mode"
        case sfTPActiveDt = "sf_TP_Active_Dt"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.div = container.safeDecodeValue(forKey: .div)
        self.mnth = container.safeDecodeValue(forKey: .mnth)
        self.yr = container.safeDecodeValue(forKey: .yr)
        self.dayno = container.safeDecodeValue(forKey: .dayno)
        self.changeStatus = container.safeDecodeValue(forKey: .changeStatus)
        self.rejectionReason = container.safeDecodeValue(forKey: .rejectionReason)
        self.tpDt = container.safeDecodeValue(forKey: .tpDt)
        self.wtCode = container.safeDecodeValue(forKey: .wtCode)
        self.wtCode2 = container.safeDecodeValue(forKey: .wtCode2)
        self.wtCode3 = container.safeDecodeValue(forKey: .wtCode3)
        self.wtName = container.safeDecodeValue(forKey: .wtName)
        self.wtName2 = container.safeDecodeValue(forKey: .wtName2)
        self.wtName3 = container.safeDecodeValue(forKey: .wtName3)
        self.clusterCode = container.safeDecodeValue(forKey: .clusterCode)
        self.clusterCode2 = container.safeDecodeValue(forKey: .clusterCode2)
        self.clusterCode3 = container.safeDecodeValue(forKey: .clusterCode3)
        self.clusterName = container.safeDecodeValue(forKey: .clusterName)
        self.clusterName2 = container.safeDecodeValue(forKey: .clusterName2)
        self.clusterName3 = container.safeDecodeValue(forKey: .clusterName3)
        self.clusterSFS = container.safeDecodeValue(forKey: .clusterSFS)
        self.clusterSFNms = container.safeDecodeValue(forKey: .clusterSFNms)
        self.jwCodes = container.safeDecodeValue(forKey: .jwCodes)
        self.jwNames = container.safeDecodeValue(forKey: .jwNames)
        self.jwCodes2 = container.safeDecodeValue(forKey: .jwCodes2)
        self.jwNames2 = container.safeDecodeValue(forKey: .jwNames2)
        self.jwCodes3 = container.safeDecodeValue(forKey: .jwCodes3)
        self.jwNames3 = container.safeDecodeValue(forKey: .jwNames3)
        self.drCode = container.safeDecodeValue(forKey: .drCode)
        self.drName = container.safeDecodeValue(forKey: .drName)
        self.drTwoCode = container.safeDecodeValue(forKey: .drTwoCode)
        self.drTwoName = container.safeDecodeValue(forKey: .drTwoName)
        self.drThreeCode = container.safeDecodeValue(forKey: .drThreeCode)
        self.drThreeName = container.safeDecodeValue(forKey: .drThreeName)
        self.chemCode = container.safeDecodeValue(forKey: .chemCode)
        self.chemName = container.safeDecodeValue(forKey: .chemName)
        self.chemTwoCode = container.safeDecodeValue(forKey: .chemTwoCode)
        self.chemTwoName = container.safeDecodeValue(forKey: .chemTwoName)
        self.chemThreeCode = container.safeDecodeValue(forKey: .chemThreeCode)
        self.chemThreeName = container.safeDecodeValue(forKey: .chemThreeName)
        self.stockistCode = container.safeDecodeValue(forKey: .stockistCode)
        self.stockistName = container.safeDecodeValue(forKey: .stockistName)
        self.stockistTwoCode = container.safeDecodeValue(forKey: .stockistTwoCode)
        self.stockistTwoName = container.safeDecodeValue(forKey: .stockistTwoName)
        self.stockistThreeCode = container.safeDecodeValue(forKey: .stockistThreeCode)
        self.stockistThreeName = container.safeDecodeValue(forKey: .stockistThreeName)
        self.day = container.safeDecodeValue(forKey: .day)
        self.tourMonth = container.safeDecodeValue(forKey: .tourMonth)
        self.tourYear = container.safeDecodeValue(forKey: .tourYear)
        self.tpmonth = container.safeDecodeValue(forKey: .tpmonth)
        self.tpday = container.safeDecodeValue(forKey: .tpday)
        self.dayRemarks = container.safeDecodeValue(forKey: .dayRemarks)
        self.dayRemarks2 = container.safeDecodeValue(forKey: .dayRemarks2)
        self.dayRemarks3 = container.safeDecodeValue(forKey: .dayRemarks3)
        self.access = container.safeDecodeValue(forKey: .access)
        self.eFlag = container.safeDecodeValue(forKey: .eFlag)
        self.fwFlg = container.safeDecodeValue(forKey: .fwFlg)
        self.fwFlg2 = container.safeDecodeValue(forKey: .fwFlg2)
        self.fwFlg3 = container.safeDecodeValue(forKey: .fwFlg3)
        self.hqCodes = container.safeDecodeValue(forKey: .hqCodes)
        self.hqNames = container.safeDecodeValue(forKey: .hqNames)
        self.hqCodes2 = container.safeDecodeValue(forKey: .hqCodes2)
        self.hqNames2 = container.safeDecodeValue(forKey: .hqNames2)
        self.hqCodes3 = container.safeDecodeValue(forKey: .hqCodes3)
        self.hqNames3 = container.safeDecodeValue(forKey: .hqNames3)
        self.submittedTime = try container.decode(DateInfo.self, forKey: .submittedTime)
        self.entryMode = container.safeDecodeValue(forKey: .entryMode)
        self.sfTPActiveDt = container.safeDecodeValue(forKey: .sfTPActiveDt)
        self.isExtended = false
    }
}
