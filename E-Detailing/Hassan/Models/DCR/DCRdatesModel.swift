//
//  DCRdatesMode.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/02/24.
//

import Foundation

class DCRdatesModel: Codable {
    var sfCode: String
    var dt: Dt
    var flg: Int
    var tbname: String
    var editFlag : String
    var reason : String
    init() {
    sfCode = String()
    dt =  Dt()
    flg = Int()
    tbname = String()
    editFlag = String()
        reason = String()
    }
    enum CodingKeys: String, CodingKey {
        case sfCode = "Sf_Code"
        case dt, flg, tbname, reason
        case editFlag = "edit_flag"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue( forKey: .sfCode)
        self.dt = try container.decode(Dt.self, forKey: .dt)
        self.flg = container.safeDecodeValue(forKey: .flg)
        self.tbname = container.safeDecodeValue(forKey: .tbname)
        self.editFlag = container.safeDecodeValue(forKey: .editFlag)
        self.reason = container.safeDecodeValue(forKey: .reason)
    }
}

// MARK: - Dt
class Dt: Codable {
    var date: String
    var timezoneType: Int
    var timezone: String

    init() {
        
    date = String()
    timezoneType = Int()
    timezone = String()
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.timezoneType = try container.decode(Int.self, forKey: .timezoneType)
        self.timezone = try container.decode(String.self, forKey: .timezone)
    }
}
