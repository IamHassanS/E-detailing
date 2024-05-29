//
//  DCRdatesMode.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/02/24.
//

import Foundation

class DCRdatesModel: Codable {
    let sfCode: String
    let dt: Dt
    let flg: Int
    let tbname: String
    let editFlag : String

    enum CodingKeys: String, CodingKey {
        case sfCode = "Sf_Code"
        case dt, flg, tbname
        case editFlag = "edit_flag"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue( forKey: .sfCode)
        self.dt = try container.decode(Dt.self, forKey: .dt)
        self.flg = container.safeDecodeValue(forKey: .flg)
        self.tbname = container.safeDecodeValue(forKey: .tbname)
        self.editFlag = container.safeDecodeValue(forKey: .editFlag)
    }
}

// MARK: - Dt
class Dt: Codable {
    let date: String
    let timezoneType: Int
    let timezone: String

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
