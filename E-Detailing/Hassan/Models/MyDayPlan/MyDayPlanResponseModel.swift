//
//  MyDayPlanResponseMOdel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation

class MyDayPlanResponseModel: Codable {
    let SFCode: String
    let TPDt: DateInfo
    let WT: String
    let WTNm: String
    let FWFlg: String
    let SFMem: String
    let HQNm: String
    let Pl: String
    let PlNm: String
    let Rem: String
    let TpVwFlg: String
    let TPDoctor: String
    let TPcluster: String
    let TPworktype: String
    
    enum CodingKeys: String, CodingKey {
        case SFCode
        case TPDt
        case WT
        case WTNm
        case FWFlg
        case SFMem
        case HQNm
        case Pl
        case PlNm
        case Rem
        case TpVwFlg
        case TPDoctor = "TP_Doctor"
        case  TPcluster = "TP_cluster"
        case  TPworktype = "TP_worktype"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        SFCode =  container.safeDecodeValue(forKey: .SFCode)
        TPDt = try container.decode(DateInfo.self, forKey: .TPDt)
        WT =  container.safeDecodeValue(forKey: .WT)
        WTNm =  container.safeDecodeValue(forKey: .WTNm)
        FWFlg =  container.safeDecodeValue(forKey: .FWFlg)
        SFMem =  container.safeDecodeValue(forKey: .SFMem)
        HQNm =  container.safeDecodeValue(forKey: .HQNm)
        Pl =  container.safeDecodeValue(forKey: .Pl)
        PlNm =  container.safeDecodeValue(forKey:.PlNm)
        Rem =  container.safeDecodeValue(forKey: .Rem)
        TpVwFlg =  container.safeDecodeValue(forKey: .TpVwFlg)
        TPDoctor =  container.safeDecodeValue(forKey: .TPDoctor)
        TPcluster =  container.safeDecodeValue(forKey: .TPcluster)
        TPworktype =  container.safeDecodeValue(forKey: .TPworktype)
    }
}
