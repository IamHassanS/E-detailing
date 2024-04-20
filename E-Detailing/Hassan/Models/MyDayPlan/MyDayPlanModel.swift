//
//  MyDayPlanModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation


class DayPlan: Codable {
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tableName = container.safeDecodeValue(forKey: .tableName)
        self.sfcode = container.safeDecodeValue(forKey: .sfcode)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
        self.rsf = container.safeDecodeValue(forKey: .rsf)
        self.rsf2 = container.safeDecodeValue(forKey: .rsf2)
        self.sfType = container.safeDecodeValue(forKey: .sfType)
        self.designation = container.safeDecodeValue(forKey: .designation)
        self.stateCode = container.safeDecodeValue(forKey: .stateCode)
        self.subdivisionCode = container.safeDecodeValue(forKey: .subdivisionCode)
        self.townCode = container.safeDecodeValue(forKey: .townCode)
        self.townName = container.safeDecodeValue(forKey: .townName)
        self.wtCode = container.safeDecodeValue(forKey: .wtCode)
        self.wtName = container.safeDecodeValue(forKey: .wtName)
        self.fwFlg = container.safeDecodeValue(forKey: .fwFlg)
        self.townCode2 = container.safeDecodeValue(forKey: .townCode2)
        self.townName2 = container.safeDecodeValue(forKey: .townName2)
        self.wtCode2 = container.safeDecodeValue(forKey: .wtCode2)
        self.wtName2 = container.safeDecodeValue(forKey: .wtName2)
        self.fwFlg2 = container.safeDecodeValue(forKey: .fwFlg2)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.location = container.safeDecodeValue(forKey: .location)
        self.location2 = container.safeDecodeValue(forKey: .location2)
        self.insMode = container.safeDecodeValue(forKey: .insMode)
        self.appver = container.safeDecodeValue(forKey: .appver)
        self.mod = container.safeDecodeValue(forKey: .mod)
        self.tpDt = container.safeDecodeValue(forKey: .tpDt)
        self.tpVwFlg = container.safeDecodeValue(forKey: .tpVwFlg)
        self.tpCluster = container.safeDecodeValue(forKey: .tpCluster)
        self.tpWorkType = container.safeDecodeValue(forKey: .tpWorkType)
        isRejected = try container.decodeIfPresent(Bool.self, forKey: .isRejected) ?? Bool()
        rejectionReason = try container.decodeIfPresent(String.self, forKey: .rejectionReason) ?? ""
        uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        isRetrived = try container.decodeIfPresent(Bool.self, forKey: .isRetrived) ?? Bool()
        isRetrived2 = try container.decodeIfPresent(Bool.self, forKey: .isRetrived2) ?? Bool()
    }
    
    
   var tableName: String
   var sfcode: String
   var divisionCode: String
   var rsf: String
    var rsf2: String
   var sfType: String
   var designation: String
   var stateCode: String
   var subdivisionCode: String
   var townCode: String
   var townName: String
   var wtCode: String
   var wtName: String
   var fwFlg: String
   var townCode2: String
   var townName2: String
   var wtCode2: String
   var wtName2: String
   var fwFlg2: String
   var remarks: String
   var location: String
   var location2: String
   var insMode: String
   var appver: String
   var mod: String
   var tpDt: String
   var tpVwFlg: String
   var tpCluster: String
   var tpWorkType: String
    var isRejected: Bool
    var rejectionReason: String
    var uuid: UUID
    var isRetrived: Bool
    var isRetrived2: Bool
    enum CodingKeys: String, CodingKey {
        case tableName = "tableName"
        case sfcode = "sfcode"
        case divisionCode = "division_code"
        case rsf = "Rsf"
 case rsf2 = "Rsf2"
        case sfType = "sf_type"
        case designation = "Designation"
        case stateCode = "state_code"
        case subdivisionCode = "subdivision_code"
        case townCode = "town_code"
        case townName = "Town_name"
        case wtCode = "WT_code"
        case wtName = "WTName"
        case fwFlg = "FwFlg"
        case townCode2 = "town_code2"
        case townName2 = "Town_name2"
        case wtCode2 = "WT_code2"
        case wtName2 = "WTName2"
        case fwFlg2 = "FwFlg2"
        case remarks = "Remarks"
        case location = "location"
        case location2 = "location2"
        case insMode = "InsMode"
        case appver = "Appver"
        case mod = "Mod"
        case tpDt = "TPDt"
        case tpVwFlg = "TpVwFlg"
        case tpCluster = "TP_cluster"
        case tpWorkType = "TP_worktype"
        case isRejected
        case rejectionReason
        case uuid
        case isRetrived
        case isRetrived2
    }
    
    init() {
    tableName = String()
    sfcode = String()
    divisionCode = String()
    rsf = String()
    sfType = String()
    designation = String()
    stateCode = String()
    subdivisionCode = String()
    townCode = String()
    townName = String()
    wtCode = String()
    wtName = String()
    fwFlg = String()
    townCode2 = String()
    townName2 = String()
    wtCode2 = String()
    wtName2 = String()
    fwFlg2 = String()
    remarks = String()
    location = String()
    location2 = String()
    insMode = String()
    appver = String()
    mod = String()
    tpDt = String()
    tpVwFlg = String()
    tpCluster = String()
    tpWorkType = String()
        isRejected = Bool()
        rejectionReason = String()
        uuid = UUID()
        rsf2 = String()
        isRetrived = Bool()
        isRetrived2 = Bool()
    }
}
