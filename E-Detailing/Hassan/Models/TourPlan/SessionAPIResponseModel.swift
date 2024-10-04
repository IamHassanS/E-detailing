//
//  SessionAPIResponseModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/01/24.
//

import Foundation





class GeneralResponseModal : Codable {
    let success : String?
    let msg : String?
    let checkinMasg: String?
    
    var isSuccess: Bool? = false
    
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case msg = "Msg"
        case checkinMasg = "msg"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success =  container.safeDecodeValue(forKey: .success)
        self.msg =  container.safeDecodeValue(forKey: .msg)
        self.checkinMasg =  container.safeDecodeValue(forKey: .checkinMasg)
        if msg != "" || checkinMasg != "" {
            self.isSuccess =  self.msg == "1" ? true  : self.checkinMasg == "1" ? true : false
        }
        
        if success != "" {
            self.isSuccess = success ==  "false" ? false : true
        }
      
    }
    
    
    init() {
        success = ""
        msg = ""
        self.isSuccess = false
        self.checkinMasg = ""
    }
}

//class SessionResponseModel: Codable {
//
//}


enum ApprovalStatus: String {
    case planning = "planning"
    case notsubmitted = "not submitted"
    case submitted = "Planning completed / waiting for approval."
    case rejected = "Tour plan rejected"
    case approved = "Tour plan approved"
}


class SentToApprovalModelArr : NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
          return true
      }
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("SentToApprovalModelArr")
    var sentToApprovalModelArr : [SentToApprovalModel]
    
    enum Key: String, CodingKey {
        case sentToApprovalModelArr
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(sentToApprovalModelArr, forKey: Key.sentToApprovalModelArr.rawValue)
        
    }
    public required convenience init?(coder decoder: NSCoder) {
        let msentToApprovalModelArr =   decoder.decodeObject(forKey: Key.sentToApprovalModelArr.rawValue) as! [SentToApprovalModel]
        self.init(sentToApprovalModelArr: msentToApprovalModelArr)
    }
    
    init(sentToApprovalModelArr : [SentToApprovalModel]) {
        self.sentToApprovalModelArr = sentToApprovalModelArr
    }
    override init() {
        self.sentToApprovalModelArr = [SentToApprovalModel]()
    }
}

class SentToApprovalModel: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
          return true
      }
    
    

    
    var date: String!
    var rawDate: Date!
    var approvalStatus: String!

    
    enum Key: String, CodingKey {
        case date
        case rawDate
        case approvalStatus

    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: Key.date.rawValue)
        coder.encode(rawDate, forKey: Key.rawDate.rawValue)
        coder.encode(approvalStatus, forKey: Key.approvalStatus.rawValue)

    }
    
    public required convenience init?(coder decoder: NSCoder) {
        let mdate =   decoder.decodeObject(forKey: Key.date.rawValue) as! String
        let mrawDate =   decoder.decodeObject(forKey: Key.rawDate.rawValue) as! Date
        let mapprovalStatus =   decoder.decodeObject(forKey: Key.approvalStatus.rawValue) as! String
       
 
        self.init(date: mdate, rawDate: mrawDate, approvalStatus: mapprovalStatus)
    }
    
    init(date: String, rawDate: Date, approvalStatus: String) {
        
        self.date = date
        self.rawDate = rawDate
        self.approvalStatus = approvalStatus
 
        
    }
    
    override init() {
        self.date = String()
        self.rawDate = Date()
        self.approvalStatus = String()

        
    }
    
}

class SessionResponseModel: Codable {
    let previous, current, next: [SessionDetails]
   // let next: [JSONAny]
    
    enum CodingKeys: String, CodingKey {
        case previous
        case current
        case next
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.previous = try container.decode([SessionDetails].self, forKey: .previous)
        self.current = try container.decode([SessionDetails].self, forKey: .current)
        self.next = try container.decode([SessionDetails].self, forKey: .next)
    }
    
}

class SessionDetails: Codable {
    let sfCode: String
    let sfName: String
    let div, mnth, yr, dayno: String
    let changeStatus, rejectionReason, dt: String
    let tpDt: TimeInfo
    let wtCode, wtCode2, wtCode3: String
    let wtName: String
    let wtName2: String
    let wtName3, clusterCode, clusterCode2, clusterCode3: String
    let clusterName, clusterName2, clusterName3: String
    let clusterSFS: String
    let clusterSFNms: String
    let jwCodes, jwNames, jwCodes2, jwNames2: String
    let jwCodes3, jwNames3, drCode, drName: String
    let drTwoCode, drTwoName, drThreeCode, drThreeName: String
    let chemCode, chemName, chemTwoCode, chemTwoName: String
    let chemThreeCode, chemThreeName, stockistCode, stockistName: String
    let stockistTwoCode, stockistTwoName, stockistThreeCode, stockistThreeName: String
    let day: String
    let tourMonth, tourYear: String
    let tpmonth: String
    let tpday: String
    let dayRemarks: String
    let dayRemarks2: String
    let dayRemarks3, access, eFlag: String
    let fwFlg, fwFlg2: String
    let fwFlg3: String
    let hqCodes: String
    let hqNames: String
    let hqCodes2, hqNames2, hqCodes3, hqNames3: String
    let submittedTimeDt: String
    let submittedTime: TimeInfo
    let entryMode: String


    
    enum CodingKeys: String, CodingKey {
        case sfCode = "SFCode"
        case sfName = "SFName"
        case div = "Div"
        case mnth = "Mnth"
        case yr = "Yr"
        case dayno
        case changeStatus = "Change_Status"
        case rejectionReason = "Rejection_Reason"
        case dt
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
        case submittedTimeDt = "submitted_time_dt"
        case submittedTime = "submitted_time"
        case entryMode = "Entry_mode"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.div = container.safeDecodeValue(forKey: .div)
        self.mnth = container.safeDecodeValue(forKey: .mnth)
        self.yr = container.safeDecodeValue(forKey: .yr)
        self.dayno = container.safeDecodeValue(forKey: .dayno)
        self.changeStatus = container.safeDecodeValue(forKey: .changeStatus)
        self.rejectionReason = container.safeDecodeValue(forKey: .rejectionReason)
        self.dt = container.safeDecodeValue(forKey: .dt)
        self.tpDt = try container.decode(TimeInfo.self, forKey: .tpDt)
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
        self.tourYear =  container.safeDecodeValue(forKey: .tourYear)
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
        self.submittedTimeDt = container.safeDecodeValue(forKey: .submittedTimeDt)
        self.submittedTime = try container.decode(TimeInfo.self, forKey: .submittedTime)
        self.entryMode = container.safeDecodeValue(forKey: .entryMode)
    }
    
    init() {
        self.sfCode = String()
        self.sfName = String()
        self.div =  String()
        self.mnth =  String()
        self.yr =  String()
        self.dayno = String()
        self.changeStatus = String()
        self.rejectionReason = String()
        self.clusterCode = String()
        self.clusterCode2 = String()
        self.clusterCode3 = String()
        self.clusterName2 = String()
        self.clusterName3 = String()
        self.jwNames = String()
        self.jwCodes2 = String()
        self.jwNames2 = String()
        self.jwNames3 = String()
        self.drCode = String()
        self.drName = String()
        self.drTwoName = String()
        self.drThreeCode = String()
        self.drThreeName = String()
        self.chemName = String()
        self.chemTwoCode = String()
        self.chemTwoName = String()
        self.chemThreeName = String()
        self.stockistCode = String()
        self.stockistName = String()
        self.stockistTwoName = String()
        self.stockistThreeCode = String()
        self.stockistThreeName = String()
        self.wtCode2 = String()
        self.wtCode3 = String()
        self.access = String()
        self.eFlag = String()
        self.hqNames2 = String()
        self.hqCodes3 = String()
        self.hqNames3 = String()
        self.dt = String()
        self.tpDt  = TimeInfo()
        self.wtCode = String()
        self.wtName = String()
        self.wtName2 = String()
        self.wtName3 = String()
        self.clusterName = String()
        self.clusterSFS = String()
        self.clusterSFNms = String()
        self.jwCodes = String()
        self.jwCodes3 = String()
        self.drTwoCode = String()
        self.chemCode = String()
        self.chemThreeCode = String()
        self.stockistTwoCode = String()
        self.fwFlg2  = String()
        self.tourMonth = String()
        self.tourYear = String()
        self.day = String()
       
        self.tpmonth = String()
        self.tpday = String()
        self.dayRemarks = String()
        self.dayRemarks2 = String()
        self.dayRemarks3 = String()
        self.fwFlg = String()
        self.fwFlg3 = String()
        self.hqCodes = String()
        self.hqNames = String()
        self.hqCodes2 = String()
        self.submittedTimeDt = String()
        self.submittedTime = TimeInfo()
        self.entryMode = String()
    }
}



class TimeInfo: Codable {
    let date : String
    let timezone : String
    let timezone_type : Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case timezone
        case timezone_type
    }
     
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = container.safeDecodeValue(forKey: .date)
        self.timezone = container.safeDecodeValue(forKey: .timezone)
        self.timezone_type = container.safeDecodeValue(forKey: .timezone_type)
    }
    
    init() {
        
        date = ""
        timezone = ""
        timezone_type = Int()
    }
    
    
}

