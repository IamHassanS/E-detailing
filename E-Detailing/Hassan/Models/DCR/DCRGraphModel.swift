//
//  DCRGraphModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 04/01/24.
//

import Foundation
class DCRCallesponseModel: Codable {
    let adcd: String?
    let acd : String?
    let success : String?
    let msg : String?
    let isSuccess: Bool?
    enum CodingKeys: String, CodingKey {
        case acd = "ACD"
        case adcd = "ADCD"
        case success = "success"
        case msg = "msg"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success =  container.safeDecodeValue(forKey: .success)
        self.msg =  container.safeDecodeValue(forKey: .msg)
        self.isSuccess = success ==  "false" ? false : true
        self.acd =  container.safeDecodeValue(forKey: .acd)
        self.adcd =  container.safeDecodeValue(forKey: .adcd)
    }
    
    
    init() {
        success = ""
        msg = ""
        self.isSuccess = false
        adcd = ""
        acd = ""
    }
}


