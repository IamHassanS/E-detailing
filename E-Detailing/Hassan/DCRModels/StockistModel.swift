//
//  StockistModel.swift
//  SAN ZEN
//
//  Created by San eforce on 26/09/24.
//

import Foundation


class StockistModel: Codable {
    
    let code, name, townCode, townName: String
    let addr, stockiestPhone, stockiestMobile, stockiestEmail: String
    let stockiestContDesig, stoCreditDays, stoCreditLimit, divisionCode: String
    let sfCode: String
    let maxGeoMap, geoTagCnt: Int
    let uRwID, lat, long, imgName: String
    let addrs: String

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
        case townCode = "Town_Code"
        case townName = "Town_Name"
        case addr = "Addr"
        case stockiestPhone = "Stockiest_Phone"
        case stockiestMobile = "Stockiest_Mobile"
        case stockiestEmail = "Stockiest_Email"
        case stockiestContDesig = "Stockiest_Cont_Desig"
        case stoCreditDays = "Sto_Credit_Days"
        case stoCreditLimit = "Sto_Credit_Limit"
        case divisionCode = "Division_Code"
        case sfCode = "SF_code"
        case maxGeoMap = "MaxGeoMap"
        case geoTagCnt = "GEOTagCnt"
        case uRwID, lat, long
        case imgName = "img_name"
        case addrs
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.townCode = try container.decode(String.self, forKey: .townCode)
        self.townName = try container.decode(String.self, forKey: .townName)
        self.addr = try container.decode(String.self, forKey: .addr)
        self.stockiestPhone = try container.decode(String.self, forKey: .stockiestPhone)
        self.stockiestMobile = try container.decode(String.self, forKey: .stockiestMobile)
        self.stockiestEmail = try container.decode(String.self, forKey: .stockiestEmail)
        self.stockiestContDesig = try container.decode(String.self, forKey: .stockiestContDesig)
        self.stoCreditDays = try container.decode(String.self, forKey: .stoCreditDays)
        self.stoCreditLimit = try container.decode(String.self, forKey: .stoCreditLimit)
        self.divisionCode = try container.decode(String.self, forKey: .divisionCode)
        self.sfCode = try container.decode(String.self, forKey: .sfCode)
        self.maxGeoMap = try container.decode(Int.self, forKey: .maxGeoMap)
        self.geoTagCnt = try container.decode(Int.self, forKey: .geoTagCnt)
        self.uRwID = try container.decode(String.self, forKey: .uRwID)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.long = try container.decode(String.self, forKey: .long)
        self.imgName = try container.decode(String.self, forKey: .imgName)
        self.addrs = try container.decode(String.self, forKey: .addrs)
    }
}
