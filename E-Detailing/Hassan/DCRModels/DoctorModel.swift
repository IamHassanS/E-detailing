//
//  DoctorModel.swift
//  SAN ZEN
//
//  Created by San eforce on 26/09/24.
//

import Foundation

class DoctorModel : Codable {

        let code, name, dob, dow: String
        let townCode, townName, category, specialty: String
        let categoryCode, specialtyCode, sfCode, lat: String
        let long, addrs, drDesig, drEmail: String
        let mobile, phone, hosAddr, resAddr: String
        let mappProds, mProd: String
        let docClsCode: Int
        let docClassShortName: String
        let plcyAcptFL, maxGeoMap, geoTagCnt: Int
        let uRwID, imgName: String
        let tlvst: Int
        let listedDRSex: String

        enum CodingKeys: String, CodingKey {
            case code = "Code"
            case name = "Name"
            case dob = "DOB"
            case dow = "DOW"
            case townCode = "Town_Code"
            case townName = "Town_Name"
            case category = "Category"
            case specialty = "Specialty"
            case categoryCode = "CategoryCode"
            case specialtyCode = "SpecialtyCode"
            case sfCode = "SF_Code"
            case lat = "Lat"
            case long = "Long"
            case addrs = "Addrs"
            case drDesig = "DrDesig"
            case drEmail = "DrEmail"
            case mobile = "Mobile"
            case phone = "Phone"
            case hosAddr = "HosAddr"
            case resAddr = "ResAddr"
            case mappProds = "MappProds"
            case mProd = "MProd"
            case docClsCode = "Doc_ClsCode"
            case docClassShortName = "Doc_Class_ShortName"
            case plcyAcptFL = "PlcyAcptFl"
            case maxGeoMap = "MaxGeoMap"
            case geoTagCnt = "GEOTagCnt"
            case uRwID
            case imgName = "img_name"
            case tlvst = "Tlvst"
            case listedDRSex = "ListedDr_Sex"
        }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.dob = try container.decode(String.self, forKey: .dob)
        self.dow = try container.decode(String.self, forKey: .dow)
        self.townCode = try container.decode(String.self, forKey: .townCode)
        self.townName = try container.decode(String.self, forKey: .townName)
        self.category = try container.decode(String.self, forKey: .category)
        self.specialty = try container.decode(String.self, forKey: .specialty)
        self.categoryCode = try container.decode(String.self, forKey: .categoryCode)
        self.specialtyCode = try container.decode(String.self, forKey: .specialtyCode)
        self.sfCode = try container.decode(String.self, forKey: .sfCode)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.long = try container.decode(String.self, forKey: .long)
        self.addrs = try container.decode(String.self, forKey: .addrs)
        self.drDesig = try container.decode(String.self, forKey: .drDesig)
        self.drEmail = try container.decode(String.self, forKey: .drEmail)
        self.mobile = try container.decode(String.self, forKey: .mobile)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.hosAddr = try container.decode(String.self, forKey: .hosAddr)
        self.resAddr = try container.decode(String.self, forKey: .resAddr)
        self.mappProds = try container.decode(String.self, forKey: .mappProds)
        self.mProd = try container.decode(String.self, forKey: .mProd)
        self.docClsCode = try container.decode(Int.self, forKey: .docClsCode)
        self.docClassShortName = try container.decode(String.self, forKey: .docClassShortName)
        self.plcyAcptFL = try container.decode(Int.self, forKey: .plcyAcptFL)
        self.maxGeoMap = try container.decode(Int.self, forKey: .maxGeoMap)
        self.geoTagCnt = try container.decode(Int.self, forKey: .geoTagCnt)
        self.uRwID = try container.decode(String.self, forKey: .uRwID)
        self.imgName = try container.decode(String.self, forKey: .imgName)
        self.tlvst = try container.decode(Int.self, forKey: .tlvst)
        self.listedDRSex = try container.decode(String.self, forKey: .listedDRSex)
    }
    
}
