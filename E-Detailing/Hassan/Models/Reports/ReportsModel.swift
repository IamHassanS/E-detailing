//
//  ReportsModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/12/23.
//

import Foundation


//class ReportsModelArr: Codable {
//    let reportsModelArr : [ReportsModel]
//
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.reportsModelArr = try container.decode([ReportsModel].self, forKey: .reportsModelArr)
//    }
//
//    init() {
//        self.reportsModelArr = [ReportsModel]()
//    }
//}

class ReportsModel: Codable {
    let aCode, adate, rptdate: String
    let typ: Int
    let sfCode, sfName: String
    let activityDate: TimeInfo
    let wtype, fwFlg: String
    let drs, chm, stk, udr: Int
    let hos, cip: Int
    let intime, outtime, inaddress, outaddress: String
    let desigCode, halfDayFWType, remarks: String
    let rmdr: Int
    let terrWrk: String
    let confirmed: Int
    let additionalWorktype : String
    
    init() {
        self.aCode = String()
        self.adate = String()
        self.rptdate = String()
        self.typ = Int()
        self.sfCode = String()
        self.sfName = String()
        self.activityDate = TimeInfo()
        self.wtype = String()
        self.fwFlg = String()
        self.drs = Int()
        self.chm = Int()
        self.stk = Int()
        self.udr = Int()
        self.hos = Int()
        self.cip = Int()
        self.intime = String()
        self.outtime = String()
        self.inaddress = String()
        self.outaddress = String()
        self.desigCode = String()
        self.halfDayFWType = String()
        self.remarks = String()
        self.rmdr = Int()
        self.terrWrk = String()
        self.confirmed = Int()
        additionalWorktype = String()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.aCode = container.safeDecodeValue(forKey: .aCode)
        self.adate = container.safeDecodeValue(forKey: .adate)
        self.rptdate = container.safeDecodeValue(forKey: .rptdate)
        self.typ = container.safeDecodeValue(forKey: .typ)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.activityDate = try container.decode(TimeInfo.self, forKey: .activityDate)
        self.wtype = container.safeDecodeValue(forKey: .wtype)
        self.fwFlg = container.safeDecodeValue(forKey: .fwFlg)
        self.drs = container.safeDecodeValue(forKey: .drs)
        self.chm = container.safeDecodeValue(forKey: .chm)
        self.stk = container.safeDecodeValue(forKey: .stk)
        self.udr = container.safeDecodeValue(forKey: .udr)
        self.hos = container.safeDecodeValue(forKey: .hos)
        self.cip = container.safeDecodeValue(forKey: .cip)
        self.intime = container.safeDecodeValue(forKey: .intime)
        self.outtime = container.safeDecodeValue(forKey: .outtime)
        self.inaddress = container.safeDecodeValue(forKey: .inaddress)
        self.outaddress = container.safeDecodeValue(forKey: .outaddress)
        self.desigCode = container.safeDecodeValue(forKey: .desigCode)
        self.halfDayFWType = container.safeDecodeValue(forKey: .halfDayFWType)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.rmdr = container.safeDecodeValue(forKey: .rmdr)
        self.terrWrk = container.safeDecodeValue(forKey: .terrWrk)
        self.confirmed = container.safeDecodeValue(forKey: .confirmed)
        self.additionalWorktype = container.safeDecodeValue(forKey: .additionalWorktype)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case aCode = "ACode"
        case adate = "Adate"
        case rptdate
        case typ = "Typ"
        case sfCode = "SF_Code"
        case sfName = "SF_Name"
        case activityDate = "Activity_Date"
        case wtype
        case fwFlg = "FWFlg"
        case drs = "Drs"
        case chm = "Chm"
        case stk = "Stk"
        case udr = "Udr"
        case hos = "Hos"
        case cip = "Cip"
        case intime, outtime, inaddress, outaddress
        case desigCode = "Desig_Code"
        case halfDayFWType = "HalfDay_FW_Type"
        case remarks
        case rmdr = "Rmdr"
        case terrWrk = "TerrWrk"
        case confirmed = "Confirmed"
        case additionalWorktype = "Additional_Temp_Details"
    }
}


class DetailedReportsModel: Codable {

    let name: String
    let code: String
    let territory: String
    let wWith: String
    let dcrDt: String
    let nextVstDate: String
    let callFdback: String
    let products: String
    let gifts: String
    let pobValue: Int
    let remarks: String
    let visitTime: String
    let modTime: String
    let transDetailSlno: String
    let checkout: String
    let checkin: String
    let vstloc: String
    let dcrAddr: String
    var isRCPAExtended: Bool
    var isEventsExtended: Bool
    var isSlidesExtended: Bool
    var isCellExtended: Bool
    var promotedProducts: String
    var rcpaCount: Int
    var slidesCount: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = container.safeDecodeValue(forKey: .name)
        self.code = container.safeDecodeValue(forKey: .code)
        self.territory = container.safeDecodeValue(forKey: .territory)
        self.wWith = container.safeDecodeValue(forKey: .wWith)
        self.dcrDt = container.safeDecodeValue(forKey: .dcrDt)
        self.nextVstDate = container.safeDecodeValue(forKey: .nextVstDate)
        self.callFdback = container.safeDecodeValue(forKey: .callFdback)
        self.products = container.safeDecodeValue(forKey: .products)
        self.gifts = container.safeDecodeValue(forKey: .gifts)
        self.pobValue = container.safeDecodeValue(forKey: .pobValue)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.visitTime = container.safeDecodeValue(forKey: .visitTime)
        self.modTime = container.safeDecodeValue(forKey: .modTime)
        self.transDetailSlno = container.safeDecodeValue(forKey: .transDetailSlno)
        self.checkout = container.safeDecodeValue(forKey: .checkout)
        self.checkin = container.safeDecodeValue(forKey: .checkin)
        self.vstloc = container.safeDecodeValue(forKey: .vstloc)
        self.dcrAddr = container.safeDecodeValue(forKey: .dcrAddr)
        self.promotedProducts = container.safeDecodeValue(forKey: .promotedProducts)
        isRCPAExtended = false
        isCellExtended = false
        isEventsExtended = false
        isSlidesExtended = false
        rcpaCount = Int()
        slidesCount = Int()
        
    }
    

        enum CodingKeys: String, CodingKey {
            case name, code
            case territory = "Territory"
            case wWith = "WWith"
            case dcrDt = "dcr_dt"
            case nextVstDate = "NextVstDate"
            case callFdback = "Call_Fdback"
            case products, gifts
            case pobValue = "pob_value"
            case remarks, visitTime
            case modTime = "ModTime"
            case transDetailSlno = "Trans_Detail_Slno"
            case checkout, checkin, vstloc
            case dcrAddr = "Dcr_addr"
            case promotedProducts = "promoted_product"
        }
    
    init() {
        self.isRCPAExtended = false
        self.isCellExtended = false
        isEventsExtended = false
        isSlidesExtended = false
        self.name = String()
        self.code = String()
        self.territory = String()
        self.wWith = String()
        self.dcrDt = String()
        self.nextVstDate = String()
        self.callFdback = String()
        self.products = String()
        self.gifts = String()
        self.pobValue = Int()
        self.remarks = String()
        self.visitTime = String()
        self.modTime = String()
        self.transDetailSlno = String()
        self.checkout = String()
        self.checkin = String()
        self.vstloc = String()
        self.dcrAddr = String()
        self.promotedProducts  = String()
        rcpaCount = Int()
        slidesCount = Int()
    }
    
}



class RCPAresonseModel: Codable {
    
    let name: String
    let code: String
    let territory: String
    let wWith: String
    let dcrDt: String
    let nextVstDate: String
    let callFdback: String
    let products: String
    let gifts: String
    let pobValue: Int
    let remarks: String
    let visitTime: String
    let modTime: String
    let transDetailSlno: String
    let checkout: String
    let checkin: String
    let vstloc: String
    let dcrAddr: String
    var isRCPAExtended: Bool
    var isEventsExtended: Bool
    var isSlidesExtended: Bool
    var isCellExtended: Bool
    var promotedProducts: String
    
    // Additional Fields from the provided dictionary
    var drName: String
    var chmName: String
    var opName: String
    var opQty: Int
    var opUnit: String
    var compName: String
    var compPName: String
    var cpQty: Int
    var cpUnit: String
    var opRate: Double
    var opValue: Double
    var cpRate: Double
    var cpValue: Double
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = container.safeDecodeValue(forKey: .name)
        self.code = container.safeDecodeValue(forKey: .code)
        self.territory = container.safeDecodeValue(forKey: .territory)
        self.wWith = container.safeDecodeValue(forKey: .wWith)
        self.dcrDt = container.safeDecodeValue(forKey: .dcrDt)
        self.nextVstDate = container.safeDecodeValue(forKey: .nextVstDate)
        self.callFdback = container.safeDecodeValue(forKey: .callFdback)
        self.products = container.safeDecodeValue(forKey: .products)
        self.gifts = container.safeDecodeValue(forKey: .gifts)
        self.pobValue = container.safeDecodeValue(forKey: .pobValue)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        self.visitTime = container.safeDecodeValue(forKey: .visitTime)
        self.modTime = container.safeDecodeValue(forKey: .modTime)
        self.transDetailSlno = container.safeDecodeValue(forKey: .transDetailSlno)
        self.checkout = container.safeDecodeValue(forKey: .checkout)
        self.checkin = container.safeDecodeValue(forKey: .checkin)
        self.vstloc = container.safeDecodeValue(forKey: .vstloc)
        self.dcrAddr = container.safeDecodeValue(forKey: .dcrAddr)
        self.promotedProducts = container.safeDecodeValue(forKey: .promotedProducts)
        self.isRCPAExtended = false
        self.isCellExtended = false
        self.isEventsExtended = false
        self.isSlidesExtended = false
        
        // Decoding additional fields
        self.drName = container.safeDecodeValue(forKey: .drName)
        self.chmName = container.safeDecodeValue(forKey: .chmName)
        self.opName = container.safeDecodeValue(forKey: .opName)
        self.opQty = container.safeDecodeValue(forKey: .opQty)
        self.opUnit = container.safeDecodeValue(forKey: .opUnit)
        self.compName = container.safeDecodeValue(forKey: .compName)
        self.compPName = container.safeDecodeValue(forKey: .compPName)
        self.cpQty = container.safeDecodeValue(forKey: .cpQty)
        self.cpUnit = container.safeDecodeValue(forKey: .cpUnit)
        self.opRate = container.safeDecodeValue(forKey: .opRate)
        self.opValue = container.safeDecodeValue(forKey: .opValue)
        self.cpRate = container.safeDecodeValue(forKey: .cpRate)
        self.cpValue = container.safeDecodeValue(forKey: .cpValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, code
        case territory = "Territory"
        case wWith = "WWith"
        case dcrDt = "dcr_dt"
        case nextVstDate = "NextVstDate"
        case callFdback = "Call_Fdback"
        case products, gifts
        case pobValue = "pob_value"
        case remarks, visitTime
        case modTime = "ModTime"
        case transDetailSlno = "Trans_Detail_Slno"
        case checkout, checkin, vstloc
        case dcrAddr = "Dcr_addr"
        case promotedProducts = "promoted_product"
        case drName = "DrName"
        case chmName = "ChmName"
        case opName = "OPName"
        case opQty = "OPQty"
        case opUnit = "OPUnit"
        case compName = "CompName"
        case compPName = "CompPName"
        case cpQty = "CPQty"
        case cpUnit = "CPUnit"
        case opRate = "OPRate"
        case opValue = "OPValue"
        case cpRate = "CPRate"
        case cpValue = "CPValue"
    }
    
    init() {
        self.isRCPAExtended = false
        self.isCellExtended = false
        isEventsExtended = false
        isSlidesExtended = false
        self.name = String()
        self.code = String()
        self.territory = String()
        self.wWith = String()
        self.dcrDt = String()
        self.nextVstDate = String()
        self.callFdback = String()
        self.products = String()
        self.gifts = String()
        self.pobValue = Int()
        self.remarks = String()
        self.visitTime = String()
        self.modTime = String()
        self.transDetailSlno = String()
        self.checkout = String()
        self.checkin = String()
        self.vstloc = String()
        self.dcrAddr = String()
        self.promotedProducts = String()
        
        // Initializing additional fields
        self.drName = String()
        self.chmName = String()
        self.opName = String()
        self.opQty = 0
        self.opUnit = String()
        self.compName = String()
        self.compPName = String()
        self.cpQty = 0
        self.cpUnit = String()
        self.opRate = 0.0
        self.opValue = 0.0
        self.cpRate = 0.0
        self.cpValue = 0.0
    }
}
class EventResponse: Codable {
    let sfCode: String
    let eventImg: String
    let title: String
    let remarks: String
    var imageData: Data
    enum CodingKeys: String, CodingKey {
        case sfCode = "sf_code"
        case eventImg = "Eventimg"
        case title
        case remarks
        case imageData
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sfCode = container.safeDecodeValue(forKey:  .sfCode)
        self.eventImg = container.safeDecodeValue(forKey: .eventImg)
        self.title = container.safeDecodeValue(forKey:  .title)
        self.remarks = container.safeDecodeValue(forKey:  .remarks)
        self.imageData = Data()
    }
    
    init(){
        
    sfCode = String()
    eventImg = String()
    title = String()
    remarks = String()
        imageData = Data()
        
        
        
    }
}


struct SlideDetailsResponse: Codable {
    let activityReportCode: String
    let mslCode: String
    let productCode: String
    let productName: String
    let startTime: String
    let endTime: String
    let fileType: String
    let ddsSlNo: String
    let rating: Int
    let feedback: String

    enum CodingKeys: String, CodingKey {
        case activityReportCode = "Activity_Report_code"
        case mslCode = "MSL_code"
        case productCode = "Product_Code"
        case productName = "Product_Name"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case fileType = "file_type"
        case ddsSlNo = "DDSl_No"
        case rating = "Rating"
        case feedback = "Feedbk"
    }

    // Custom initializer with safe decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.activityReportCode = container.safeDecodeValue(forKey: .activityReportCode)
        self.mslCode = container.safeDecodeValue(forKey: .mslCode)
        self.productCode = container.safeDecodeValue(forKey:  .productCode)
        self.productName = container.safeDecodeValue(forKey:  .productName)
        self.startTime = container.safeDecodeValue(forKey: .startTime)
        self.endTime = container.safeDecodeValue(forKey:  .endTime)
        self.fileType = container.safeDecodeValue(forKey:  .fileType)
        self.ddsSlNo = container.safeDecodeValue(forKey:  .ddsSlNo)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.feedback = container.safeDecodeValue(forKey:  .feedback)
    }

    // Default initializer
    init() {
        self.activityReportCode = ""
        self.mslCode = ""
        self.productCode = ""
        self.productName = ""
        self.startTime = ""
        self.endTime = ""
        self.fileType = ""
        self.ddsSlNo = ""
        self.rating = 0
        self.feedback = ""
    }
}

