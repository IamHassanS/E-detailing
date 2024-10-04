//
//  ChemistModel.swift
//  SAN ZEN
//
//  Created by San eforce on 26/09/24.
//

import Foundation



class ChemistModel: Codable {
    let code, name, addr, townCode: String
    let townName, chemistsPhone, chemistsMobile, chemistsFax: String
    let chemistsEmail, chmCat, chemistsContact, sfCode: String
    let lat, long: String
    let maxGeoMap, geoTagCnt: Int
    let imgName, addrs: String

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
        case addr = "Addr"
        case townCode = "Town_Code"
        case townName = "Town_Name"
        case chemistsPhone = "Chemists_Phone"
        case chemistsMobile = "Chemists_Mobile"
        case chemistsFax = "Chemists_Fax"
        case chemistsEmail = "Chemists_Email"
        case chmCat = "Chm_cat"
        case chemistsContact = "Chemists_Contact"
        case sfCode = "SF_Code"
        case lat, long
        case maxGeoMap = "MaxGeoMap"
        case geoTagCnt = "GEOTagCnt"
        case imgName = "img_name"
        case addrs
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.addr = try container.decode(String.self, forKey: .addr)
        self.townCode = try container.decode(String.self, forKey: .townCode)
        self.townName = try container.decode(String.self, forKey: .townName)
        self.chemistsPhone = try container.decode(String.self, forKey: .chemistsPhone)
        self.chemistsMobile = try container.decode(String.self, forKey: .chemistsMobile)
        self.chemistsFax = try container.decode(String.self, forKey: .chemistsFax)
        self.chemistsEmail = try container.decode(String.self, forKey: .chemistsEmail)
        self.chmCat = try container.decode(String.self, forKey: .chmCat)
        self.chemistsContact = try container.decode(String.self, forKey: .chemistsContact)
        self.sfCode = try container.decode(String.self, forKey: .sfCode)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.long = try container.decode(String.self, forKey: .long)
        self.maxGeoMap = try container.decode(Int.self, forKey: .maxGeoMap)
        self.geoTagCnt = try container.decode(Int.self, forKey: .geoTagCnt)
        self.imgName = try container.decode(String.self, forKey: .imgName)
        self.addrs = try container.decode(String.self, forKey: .addrs)
    }
}
