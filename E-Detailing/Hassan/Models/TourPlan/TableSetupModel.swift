//
//  TableSetupModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 25/01/24.
//

import Foundation

//class TableSetupModel: Codable {
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("TableSetupModel")
//
//    let SF_code : String
//    let AddsessionNeed : String
//    let AddsessionCount : String
//    let DrNeed : String
//    let ChmNeed : String
//    let JWNeed : String
//    let ClusterNeed : String
//    let clustertype : String
//    let div : String
//    let StkNeed : String
//    let Cip_Need : String
//    let HospNeed : String
//    let FW_meetup_mandatory : String
//    let max_doc : String
//    let tp_objective : String
//    let Holiday_Editable : String
//    let Weeklyoff_Editable : String
//    let UnDrNeed : Int
//
//    enum Key: String, CodingKey {
//       case SF_code
//       case AddsessionNeed
//       case AddsessionCount
//       case DrNeed
//       case ChmNeed
//       case JWNeed
//       case ClusterNeed
//       case clustertype
//       case div
//       case StkNeed
//       case Cip_Need
//       case HospNeed
//       case FW_meetup_mandatory
//       case max_doc
//       case tp_objective
//       case Holiday_Editable
//       case Weeklyoff_Editable
//       case UnDrNeed
//    }
//
//    public func encode(with coder: NSCoder) {
//        coder.encode(SF_code, forKey: Key.SF_code.rawValue)
//        coder.encode(AddsessionNeed, forKey: Key.AddsessionNeed.rawValue)
//        coder.encode(AddsessionCount, forKey: Key.AddsessionCount.rawValue)
//        coder.encode(DrNeed, forKey: Key.DrNeed.rawValue)
//        coder.encode(ChmNeed, forKey: Key.ChmNeed.rawValue)
//        coder.encode(JWNeed, forKey: Key.JWNeed.rawValue)
//        coder.encode(ClusterNeed, forKey: Key.ClusterNeed.rawValue)
//        coder.encode(clustertype, forKey: Key.clustertype.rawValue)
//        coder.encode(div, forKey: Key.div.rawValue)
//        coder.encode(StkNeed, forKey: Key.StkNeed.rawValue)
//        coder.encode(Cip_Need, forKey: Key.Cip_Need.rawValue)
//        coder.encode(HospNeed, forKey: Key.HospNeed.rawValue)
//        coder.encode(FW_meetup_mandatory, forKey: Key.FW_meetup_mandatory.rawValue)
//        coder.encode(max_doc, forKey: Key.max_doc.rawValue)
//        coder.encode(tp_objective, forKey: Key.tp_objective.rawValue)
//        coder.encode(Holiday_Editable, forKey: Key.Holiday_Editable.rawValue)
//        coder.encode(Weeklyoff_Editable, forKey: Key.Weeklyoff_Editable.rawValue)
//        coder.encode(UnDrNeed, forKey: Key.UnDrNeed.rawValue)
//    }
//
//
//    public required convenience init?(coder decoder: NSCoder) {
//        let mSF_code =   decoder.decodeObject(forKey: Key.SF_code.rawValue) as! String
//        let mAddsessionNeed =   decoder.decodeObject(forKey: Key.AddsessionNeed.rawValue) as! String
//        let mAddsessionCount =   decoder.decodeObject(forKey: Key.AddsessionCount.rawValue) as! String
//        let mDrNeed =   decoder.decodeObject(forKey: Key.DrNeed.rawValue) as! String
//        let mChmNeed =   decoder.decodeObject(forKey: Key.ChmNeed.rawValue) as! String
//        let mJWNeed =   decoder.decodeObject(forKey: Key.JWNeed.rawValue) as! String
//        let mClusterNeed =   decoder.decodeObject(forKey: Key.ClusterNeed.rawValue) as! String
//        let mclustertype =   decoder.decodeObject(forKey: Key.clustertype.rawValue) as! String
//        let mdiv =   decoder.decodeObject(forKey: Key.div.rawValue) as! String
//        let mStkNeed =   decoder.decodeObject(forKey: Key.StkNeed.rawValue) as! String
//        let mCip_Need =   decoder.decodeObject(forKey: Key.Cip_Need.rawValue) as! String
//        let mHospNeed =   decoder.decodeObject(forKey: Key.HospNeed.rawValue) as! String
//        let mFW_meetup_mandatory =   decoder.decodeObject(forKey: Key.FW_meetup_mandatory.rawValue) as! String
//        let mmax_doc =   decoder.decodeObject(forKey: Key.max_doc.rawValue) as! String
//        let mtp_objective =   decoder.decodeObject(forKey: Key.tp_objective.rawValue) as! String
//        let mHoliday_Editable =   decoder.decodeObject(forKey: Key.Holiday_Editable.rawValue) as! String
//        let mWeeklyoff_Editable =   decoder.decodeObject(forKey: Key.Weeklyoff_Editable.rawValue) as! String
//        let mUnDrNeed =   decoder.decodeObject(forKey: Key.UnDrNeed.rawValue) as! Int
//
//
//
//
//        self.init(SF_code: mSF_code, AddsessionNeed: mAddsessionNeed, AddsessionCount: mAddsessionCount, DrNeed: mDrNeed, ChmNeed: mChmNeed, JWNeed: mJWNeed, ClusterNeed: mClusterNeed, clustertype: mclustertype, div: mdiv, StkNeed: mStkNeed, Cip_Need: mCip_Need, HospNeed: mHospNeed, FW_meetup_mandatory: mFW_meetup_mandatory, max_doc: mmax_doc, tp_objective: mtp_objective, Holiday_Editable: mHoliday_Editable, Weeklyoff_Editable: mWeeklyoff_Editable, UnDrNeed: mUnDrNeed)
//    }
//
//    init(
//        SF_code: String,
//        AddsessionNeed: String,
//        AddsessionCount: String,
//        DrNeed: String,
//        ChmNeed: String,
//        JWNeed: String,
//        ClusterNeed: String,
//        clustertype: String,
//        div: String,
//        StkNeed: String,
//        Cip_Need: String,
//        HospNeed: String,
//        FW_meetup_mandatory: String,
//        max_doc: String,
//        tp_objective: String,
//        Holiday_Editable: String,
//        Weeklyoff_Editable: String,
//        UnDrNeed: Int
//    ) {
//        self.SF_code = SF_code
//        self.AddsessionNeed = AddsessionNeed
//        self.AddsessionCount = AddsessionCount
//        self.DrNeed = DrNeed
//        self.ChmNeed = ChmNeed
//        self.JWNeed = JWNeed
//        self.ClusterNeed = ClusterNeed
//        self.clustertype = clustertype
//        self.div = div
//        self.StkNeed = StkNeed
//        self.Cip_Need = Cip_Need
//        self.HospNeed = HospNeed
//        self.FW_meetup_mandatory = FW_meetup_mandatory
//        self.max_doc = max_doc
//        self.tp_objective = tp_objective
//        self.Holiday_Editable = Holiday_Editable
//        self.Weeklyoff_Editable = Weeklyoff_Editable
//        self.UnDrNeed = UnDrNeed
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case SF_code
//        case AddsessionNeed
//        case AddsessionCount
//        case DrNeed
//        case ChmNeed
//        case JWNeed
//        case ClusterNeed
//        case clustertype
//        case div
//        case StkNeed
//        case Cip_Need
//        case HospNeed
//        case FW_meetup_mandatory
//        case max_doc
//        case tp_objective
//        case Holiday_Editable
//        case Weeklyoff_Editable
//        case UnDrNeed
//    }
//
//    required init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.SF_code = container.safeDecodeValue(forKey: .SF_code)
//        self.AddsessionNeed = container.safeDecodeValue(forKey: .AddsessionNeed)
//        self.AddsessionCount = container.safeDecodeValue(forKey: .AddsessionCount)
//        self.DrNeed = container.safeDecodeValue(forKey: .DrNeed)
//        self.ChmNeed = container.safeDecodeValue(forKey: .ChmNeed)
//        self.JWNeed = container.safeDecodeValue(forKey: .JWNeed)
//        self.ClusterNeed = container.safeDecodeValue(forKey: .ClusterNeed)
//        self.clustertype = container.safeDecodeValue(forKey: .clustertype)
//        self.div = container.safeDecodeValue(forKey: .div)
//        self.StkNeed = container.safeDecodeValue(forKey: .StkNeed)
//        self.Cip_Need = container.safeDecodeValue(forKey: .Cip_Need)
//        self.HospNeed = container.safeDecodeValue(forKey: .HospNeed)
//        self.FW_meetup_mandatory = container.safeDecodeValue(forKey: .FW_meetup_mandatory)
//        self.max_doc = container.safeDecodeValue(forKey: .max_doc)
//        self.tp_objective = container.safeDecodeValue(forKey: .tp_objective)
//        self.Holiday_Editable = container.safeDecodeValue(forKey: .Holiday_Editable)
//        self.Weeklyoff_Editable = container.safeDecodeValue(forKey: .Weeklyoff_Editable)
//        self.UnDrNeed = container.safeDecodeValue(forKey: .UnDrNeed)
//    }
//
//    init() {
//        SF_code = ""
//         AddsessionNeed = "0"
//         AddsessionCount = "3"
//         DrNeed = "0"
//         ChmNeed = "0"
//         JWNeed = "0"
//         ClusterNeed = "1"
//         clustertype = "1"
//         div = "63"
//         StkNeed = "0"
//         Cip_Need = "0"
//         HospNeed = "1"
//         FW_meetup_mandatory = "0"
//         max_doc = "0"
//         tp_objective = "1"
//         Holiday_Editable = "0"
//         Weeklyoff_Editable = "0"
//         UnDrNeed = 0
//    }
//
//}


class SaveTPresponseModel: Codable {
    
        var success: Bool?
        var sf_code: String?
        var TPDt : String?
    enum CodingKeys: String, CodingKey {
        case success
        case sf_code
        case TPDt
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = container.safeDecodeValue(forKey: .success)
        self.sf_code = container.safeDecodeValue(forKey: .sf_code)
        self.TPDt = container.safeDecodeValue(forKey: .TPDt)
    }
    init() {
        success = false
        sf_code = ""
        TPDt = ""
    }
    
}
