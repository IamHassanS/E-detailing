//
//  EditCallinfoModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/05/24.
//

import Foundation

class DigitalDet: Codable {
    var slideType: String
    var ddslNo: String
    var slideName: String
    var startTime: TimeInfo
    var endTime: TimeInfo
    var rating: Int
    var feedback: String
    var userLike: String
    var detSlNo: String?
    var startTimeString: String
    var endTimeString: String
    
    enum CodingKeys: String, CodingKey {
        case slideType = "SlideType"
        case ddslNo = "DDSl_No"
        case slideName = "SlideName"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case rating = "Rating"
        case feedback = "Feedbk"
        case userLike = "usrLike"
        case detSlNo = "DetSlNo"
        case startTimeString = "stm"
        case endTimeString = "etm"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.slideType = container.safeDecodeValue(forKey: .slideType)
        self.ddslNo = container.safeDecodeValue(forKey: .ddslNo)
        self.slideName = container.safeDecodeValue(forKey: .slideName)
        self.startTime = try container.decode(TimeInfo.self, forKey: .startTime)
        self.endTime = try container.decode(TimeInfo.self, forKey: .endTime)
        self.rating = container.safeDecodeValue(forKey:.rating)
        self.feedback = container.safeDecodeValue(forKey: .feedback)
        self.userLike = container.safeDecodeValue(forKey: .userLike)
        self.detSlNo = container.safeDecodeValue(forKey: .detSlNo)
        self.startTimeString = container.safeDecodeValue(forKey: .startTimeString)
        self.endTimeString = container.safeDecodeValue(forKey: .endTimeString)
    }
    

}

class RCPADet: Codable {
    var fkPKID: String
    var compCode: String
    var compName: String
    var compPCode: String
    var compPName: String
    var cpQty: Int
    var cpRate: Int
    var cpValue: Int
    var cpRemarks: String
    var chemName: String
    var chemCode: String
    
    enum CodingKeys: String, CodingKey {
        case fkPKID = "FK_PK_ID"
        case compCode = "CompCode"
        case compName = "CompName"
        case compPCode = "CompPCode"
        case compPName = "CompPName"
        case cpQty = "CPQty"
        case cpRate = "CPRate"
        case cpValue = "CPValue"
        case cpRemarks = "CPRemarks"
        case chemName = "Chemname"
        case chemCode = "Chemcode"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fkPKID = container.safeDecodeValue(forKey: .fkPKID)
        self.compCode = container.safeDecodeValue(forKey: .compCode)
        self.compName = container.safeDecodeValue(forKey: .compName)
        self.compPCode = container.safeDecodeValue(forKey: .compPCode)
        self.compPName = container.safeDecodeValue(forKey: .compPName)
        self.cpQty = container.safeDecodeValue(forKey:.cpQty)
        self.cpRate = container.safeDecodeValue(forKey:.cpRate)
        self.cpValue = container.safeDecodeValue(forKey:.cpValue)
        self.cpRemarks = container.safeDecodeValue(forKey: .cpRemarks)
        self.chemName = container.safeDecodeValue(forKey: .chemName)
        self.chemCode = container.safeDecodeValue(forKey: .chemCode)
    }
}

class RCPAHead: Codable {
    var pkID: String
    var sfCode: String
    var sfName: String
    var rcpaDate: TimeInfo
    var drCode: String
    var drName: String
    var chmCode: String
    var chmName: String
    var opCode: String
    var opName: String
    var opQty: Int
    var opRate: Int
    var opValue: Int
    var arCode: String
    var armslCode: String
    var updatedOn: TimeInfo
    var eid: String
    var opUnit: String
    var rcpaDet : [RCPADet]
    
    enum CodingKeys: String, CodingKey {
        case pkID = "PK_ID"
        case sfCode = "SF_Code"
        case sfName = "SF_Name"
        case rcpaDate = "RCPA_Date"
        case drCode = "DrCode"
        case drName = "DrName"
        case chmCode = "ChmCode"
        case chmName = "ChmName"
        case opCode = "OPCode"
        case opName = "OPName"
        case opQty = "OPQty"
        case opRate = "OPRate"
        case opValue = "OPValue"
        case arCode = "AR_Code"
        case armslCode = "ARMSL_Code"
        case updatedOn = "UpdatedOn"
        case eid = "EID"
        case opUnit = "OPUnit"
        case rcpaDet = "RCPADet"
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pkID = container.safeDecodeValue(forKey: .pkID)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.rcpaDate = try container.decode(TimeInfo.self, forKey: .rcpaDate)
        self.drCode = container.safeDecodeValue(forKey: .drCode)
        self.drName = container.safeDecodeValue(forKey: .drName)
        self.chmCode = container.safeDecodeValue(forKey: .chmCode)
        self.chmName = container.safeDecodeValue(forKey: .chmName)
        self.opCode = container.safeDecodeValue(forKey: .opCode)
        self.opName = container.safeDecodeValue(forKey: .opName)
        self.opQty = container.safeDecodeValue(forKey:.opQty)
        self.opRate = container.safeDecodeValue(forKey:.opRate)
        self.opValue = container.safeDecodeValue(forKey:.opValue)
        self.arCode = container.safeDecodeValue(forKey: .arCode)
        self.armslCode = container.safeDecodeValue(forKey: .armslCode)
        self.updatedOn = try container.decode(TimeInfo.self, forKey: .updatedOn)
        self.eid = container.safeDecodeValue(forKey: .eid)
        self.opUnit = container.safeDecodeValue(forKey: .opUnit)
        self.rcpaDet = try container.decode([RCPADet].self, forKey: .rcpaDet)
    }

}

class DigitalHead: Codable {
    var ddslNo: String
    var activityReportCode: String
    var mslCode: String
    var productCode: String
    var productName: String
    var groupID: String
    var rating: Int
    var startTime: TimeInfo
    var endTime: TimeInfo
    var feedbackStatus: String
    var signImage: String
    var startTimeString: String
    var endTimeString: String
    var digitalDet: [DigitalDet]
    enum CodingKeys: String, CodingKey {
        case ddslNo = "DDSl_No"
        case activityReportCode = "Activity_Report_code"
        case mslCode = "MSL_code"
        case productCode = "Product_Code"
        case productName = "Product_Name"
        case groupID = "GroupID"
        case rating = "Rating"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case feedbackStatus = "Feedbk_Status"
        case signImage = "SignImg"
        case startTimeString = "stm"
        case endTimeString = "etm"
        case digitalDet = "DigitalDet"
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ddslNo = container.safeDecodeValue(forKey: .ddslNo)
        self.activityReportCode = container.safeDecodeValue(forKey: .activityReportCode)
        self.mslCode = container.safeDecodeValue(forKey: .mslCode)
        self.productCode = container.safeDecodeValue(forKey: .productCode)
        self.productName = container.safeDecodeValue(forKey: .productName)
        self.groupID = container.safeDecodeValue(forKey: .groupID)
        self.rating = container.safeDecodeValue(forKey:.rating)
        self.startTime = try container.decode(TimeInfo.self, forKey: .startTime)
        self.endTime = try container.decode(TimeInfo.self, forKey: .endTime)
        self.feedbackStatus = container.safeDecodeValue(forKey: .feedbackStatus)
        self.signImage = container.safeDecodeValue(forKey: .signImage)
        self.startTimeString = container.safeDecodeValue(forKey: .startTimeString)
        self.endTimeString = container.safeDecodeValue(forKey: .endTimeString)
        self.digitalDet = try container.decode([DigitalDet].self, forKey: .digitalDet)
    }

}


class EventCaptureResponse: Codable {
    var transactionSerialNumber: String
    var transactionDetailSerialNumber: String
    var imageUrl: String
    var divisionCode: String
    var sfCode: String
    var title: String
    var remarks: String
    var imageData : Data
    
    enum CodingKeys: String, CodingKey {
        case transactionSerialNumber = "Trans_SlNo"
        case transactionDetailSerialNumber = "Trans_Detail_Slno"
        case imageUrl = "imgurl"
        case divisionCode = "Division_Code"
        case sfCode = "sf_code"
        case title
        case remarks
        case imageData
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionSerialNumber = container.safeDecodeValue(forKey: .transactionSerialNumber)
        self.transactionDetailSerialNumber = container.safeDecodeValue(forKey: .transactionDetailSerialNumber)
        self.imageUrl = container.safeDecodeValue(forKey: .imageUrl)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.title = container.safeDecodeValue(forKey: .title)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.imageData = Data()
    }
}

class DCRDetail: Codable {
    var transactionSerialNumber: String
    var transactionDetailSerialNumber: String
    var sfCode: String
    var transactionDetailInfoType: String
    var transactionDetailInfoCode: String
    var session: String
    var sessionCode: String
    var tm: String
    var time: String
    var minutes: String
    var seconds: String
    var pob: Int
    var workedWithCode: String
    var workedWithName: String
    var productCode: String
    var productDetail: String
    var additionalProductCode: String
    var additionalProductDetails: String
  //  var callFeedback: String
    var promotedProduct: String
    var giftCode: String
    var giftName: String
    var giftQty: String
    var additionalGiftCode: String
    var additionalGiftDetail: String
    var pobValue: Int?
    var sdp: String
    var activityRemarks: String
    var divisionCode: String
    var transactionDetailName: String
    var sdpName: String
    var rx: String
    var drCallFeedbackCode: String
    var modTime: TimeInfo
    var lati: String
    var long: String
    var entryMode: String
    var dataSF: String
    var geoAddress: String
    var nextVisitDate: String
    var hospitalCode: String
    var hospitalName: String
    var productStockist: String
    var callFeedback: String
    var activityNames: String
    var lineOfAction: String
    var activityIds: String
    
    enum CodingKeys: String, CodingKey {
        case transactionSerialNumber = "Trans_SlNo"
        case transactionDetailSerialNumber = "Trans_Detail_Slno"
        case sfCode = "sf_code"
        case transactionDetailInfoType = "Trans_Detail_Info_Type"
        case transactionDetailInfoCode = "Trans_Detail_Info_Code"
        case session = "Session"
        case sessionCode = "Session_Code"
        case tm
        case time = "Time"
        case minutes = "Minutes"
        case seconds = "Seconds"
        case pob = "POB"
        case workedWithCode = "Worked_with_Code"
        case workedWithName = "Worked_with_Name"
        case productCode = "Product_Code"
        case productDetail = "Product_Detail"
        case additionalProductCode = "Additional_Prod_Code"
        case additionalProductDetails = "Additional_Prod_Dtls"
      // case callFeedback = "Call_Fdback"
        case promotedProduct = "promoted_product"
        case giftCode = "Gift_Code"
        case giftName = "Gift_Name"
        case giftQty = "Gift_Qty"
        case additionalGiftCode = "Additional_Gift_Code"
        case additionalGiftDetail = "Additional_Gift_Dtl"
        case pobValue = "POB_Value"
        case sdp = "SDP"
        case activityRemarks = "Activity_Remarks"
        case divisionCode = "Division_Code"
        case transactionDetailName = "Trans_Detail_Name"
        case sdpName = "SDP_Name"
        case rx = "Rx"
        case drCallFeedbackCode = "Drcallfeedbackcode"
        case modTime = "ModTime"
        case lati
        case long
        case entryMode = "Entry_Mode"
        case dataSF = "DataSF"
        case geoAddress = "GeoAddrs"
        case nextVisitDate = "NextVstDate"
        case hospitalCode = "hospital_code"
        case hospitalName = "hospital_name"
        case productStockist = "Product_Stockist"
        case callFeedback = "call_feedback"
        case activityNames = "activity_names"
        case lineOfAction = "line_of_action"
        case activityIds = "activity_ids"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionSerialNumber = container.safeDecodeValue(forKey: .transactionSerialNumber)
        self.transactionDetailSerialNumber = container.safeDecodeValue(forKey: .transactionDetailSerialNumber)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.transactionDetailInfoType = container.safeDecodeValue(forKey: .transactionDetailInfoType)
        self.transactionDetailInfoCode = container.safeDecodeValue(forKey: .transactionDetailInfoCode)
        self.session = container.safeDecodeValue(forKey: .session)
        self.sessionCode = container.safeDecodeValue(forKey: .sessionCode)
        self.tm = container.safeDecodeValue(forKey: .tm)
        self.time = container.safeDecodeValue(forKey: .time)
        self.minutes = container.safeDecodeValue(forKey: .minutes)
        self.seconds = container.safeDecodeValue(forKey: .seconds)
        self.pob = container.safeDecodeValue(forKey: .pob)
        self.workedWithCode = container.safeDecodeValue(forKey: .workedWithCode)
        self.workedWithName = container.safeDecodeValue(forKey: .workedWithName)
        self.productCode = container.safeDecodeValue(forKey: .productCode)
        self.productDetail = container.safeDecodeValue(forKey: .productDetail)
        self.additionalProductCode = container.safeDecodeValue(forKey: .additionalProductCode)
        self.additionalProductDetails = container.safeDecodeValue(forKey: .additionalProductDetails)
        self.promotedProduct = container.safeDecodeValue(forKey: .promotedProduct)
        self.giftCode = container.safeDecodeValue(forKey: .giftCode)
        self.giftName = container.safeDecodeValue(forKey: .giftName)
        self.giftQty = container.safeDecodeValue(forKey: .giftQty)
        self.additionalGiftCode = container.safeDecodeValue(forKey: .additionalGiftCode)
        self.additionalGiftDetail = container.safeDecodeValue(forKey: .additionalGiftDetail)
        self.pobValue = container.safeDecodeValue(forKey: .pobValue)
        self.sdp = container.safeDecodeValue(forKey: .sdp)
        self.activityRemarks = container.safeDecodeValue(forKey: .activityRemarks)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
        self.transactionDetailName = container.safeDecodeValue(forKey: .transactionDetailName)
        self.sdpName = container.safeDecodeValue(forKey: .sdpName)
        self.rx = container.safeDecodeValue(forKey: .rx)
        self.drCallFeedbackCode = container.safeDecodeValue(forKey: .drCallFeedbackCode)
        self.modTime = try container.decode(TimeInfo.self, forKey: .modTime)
        self.lati = container.safeDecodeValue(forKey: .lati)
        self.long = container.safeDecodeValue(forKey: .long)
        self.entryMode = container.safeDecodeValue(forKey: .entryMode)
        self.dataSF = container.safeDecodeValue(forKey: .dataSF)
        self.geoAddress = container.safeDecodeValue(forKey: .geoAddress)
        self.nextVisitDate = container.safeDecodeValue(forKey: .nextVisitDate)
        self.hospitalCode = container.safeDecodeValue(forKey: .hospitalCode)
        self.hospitalName = container.safeDecodeValue(forKey: .hospitalName)
        self.productStockist = container.safeDecodeValue(forKey: .productStockist)
        self.callFeedback = container.safeDecodeValue(forKey: .callFeedback)
        self.activityNames = container.safeDecodeValue(forKey: .activityNames)
        self.lineOfAction = container.safeDecodeValue(forKey: .lineOfAction)
        self.activityIds = container.safeDecodeValue(forKey: .activityIds)
    }
    

}


class DCRMain: Codable {
    var transactionSerialNumber: String
    var sfCode: String
    var sfName: String
    var activityDate : TimeInfo
    var submissionDate : TimeInfo
    var workType: String
    var planNumber: String
    var planName: String
    var halfDayFW: String
    var startTime: TimeInfo
    var endTime: TimeInfo
    var divisionCode: String
    var remarks: String
    var confirmed: String
    var employeeId: String
    var workTypeName: String
    var entryMode: String
    var typ: String
    var fwFlg: String
    
    enum CodingKeys: String, CodingKey {
        case transactionSerialNumber = "Trans_SlNo"
        case sfCode = "Sf_Code"
        case sfName = "Sf_Name"
        case activityDate = "Activity_Date"
        case submissionDate = "Submission_Date"
        case workType = "Work_Type"
        case planNumber = "Plan_No"
        case planName = "Plan_Name"
        case halfDayFW = "Half_Day_FW"
        case startTime = "Start_Time"
        case endTime = "End_Time"
        case divisionCode = "Division_Code"
        case remarks = "Remarks"
        case confirmed = "Confirmed"
        case employeeId = "Emp_Id"
        case workTypeName = "WorkType_Name"
        case entryMode = "Entry_Mode"
        case typ = "Typ"
        case fwFlg = "FWFlg"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionSerialNumber = container.safeDecodeValue(forKey: .transactionSerialNumber)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.activityDate = try container.decode(TimeInfo.self, forKey: .activityDate)
        self.submissionDate = try container.decode(TimeInfo.self, forKey: .submissionDate)
        self.workType = container.safeDecodeValue(forKey: .workType)
        self.planNumber = container.safeDecodeValue(forKey: .planNumber)
        self.planName = container.safeDecodeValue(forKey: .planName)
        self.halfDayFW = container.safeDecodeValue(forKey: .halfDayFW)
        self.startTime = try container.decode(TimeInfo.self, forKey: .startTime)
        self.endTime = try container.decode(TimeInfo.self, forKey: .endTime)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.confirmed = container.safeDecodeValue(forKey: .confirmed)
        self.employeeId = container.safeDecodeValue(forKey: .employeeId)
        self.workTypeName = container.safeDecodeValue(forKey: .workTypeName)
        self.entryMode = container.safeDecodeValue(forKey: .entryMode)
        self.typ = container.safeDecodeValue(forKey: .typ)
        self.fwFlg = container.safeDecodeValue(forKey: .fwFlg)
    }
    
    
}

class EditCallinfoModel : Codable {
    
    var dcrMainArr: [DCRMain]
    var dcrDetailArr: [DCRDetail]
    var eventCaptureArr: [EventCaptureResponse]
    var digitalHeadArr: [DigitalHead]
    var rcpaHeadArr: [RCPAHead]?
    
    
    enum CodingKeys: String, CodingKey {
        case dcrMainArr = "DCRMain"
        case dcrDetailArr = "DCRDetail"
        case eventCaptureArr = "event_capture"
        case digitalHeadArr = "DigitalHead"
        case rcpaHeadArr = "RCPAHead"
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dcrMainArr = try container.decode([DCRMain].self, forKey: .dcrMainArr)
        self.dcrDetailArr = try container.decode([DCRDetail].self, forKey: .dcrDetailArr)
        self.eventCaptureArr = try container.decode([EventCaptureResponse].self, forKey: .eventCaptureArr)
        self.digitalHeadArr = try container.decode([DigitalHead].self, forKey: .digitalHeadArr)
        if Shared.instance.selectedDCRtype == .Doctor || Shared.instance.selectedDCRtype == .Chemist {
            self.rcpaHeadArr = try container.decode([RCPAHead].self, forKey: .rcpaHeadArr)
        }
     
    }
    
}

