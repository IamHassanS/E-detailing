//
//  LeaveModels.swift
//  E-Detailing
//
//  Created by San eforce on 20/05/24.
//

import Foundation

class LeaveResponse: Codable {
    var qry: String?
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case qry = "Qry"
        case success = "success"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qry = try container.decodeIfPresent(String.self, forKey: .qry)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    }

    init() {
        qry = ""
        success = false
    }
}

class LeaveAvailability: Codable {
    var flag: String?
    var message: String?
    var attachment: String?
    var calcLeaveDate: String?

    enum CodingKeys: String, CodingKey {
        case flag = "Flg"
        case message = "Msg"
        case attachment = "attchment"
        case calcLeaveDate = "CalcLeaveDate"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.flag = container.safeDecodeValue(forKey: .flag)
        self.message = container.safeDecodeValue(forKey: .message)
        self.attachment = container.safeDecodeValue(forKey: .attachment)
        self.calcLeaveDate = container.safeDecodeValue(forKey: .calcLeaveDate)
    }

    init() {
        flag = ""
        message = ""
        attachment = ""
        calcLeaveDate = ""
    }
}


class LeaveStatus: Codable{
    
    var available : String?
    var eligibility : String?
    var leaveTypeCode : String?
    var leaveCode : String?
    var taken : String?
    
    enum CodingKeys: String, CodingKey {
        case available = "Avail"
        case eligibility = "Elig"
        case leaveTypeCode = "Leave_Type_Code"
        case leaveCode = "Leave_code"
        case taken = "Taken"


    }
    

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.available = container.safeDecodeValue(forKey: .available)
        self.eligibility = container.safeDecodeValue(forKey: .eligibility)
        self.leaveTypeCode = container.safeDecodeValue(forKey: .leaveTypeCode)
        self.leaveCode = container.safeDecodeValue(forKey: .leaveCode)
        self.taken = container.safeDecodeValue(forKey: .taken)
    }
    
    init() {
        available = ""
        eligibility = ""
        leaveTypeCode = ""
        leaveCode = ""
        taken = ""
    }
    

}
