//
//  PrecallsModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/03/24.
//

import Foundation
class PrecallsModel: Codable {
    var visitDate: DateInfo
    
    var sampleProduct: String
    var productDetail: String
    var inputs: String
    var feedbackCD: String
    var feedback: String
    var remarks: String
    var amslNO : String
    
    enum CodingKeys: String, CodingKey {
        case visitDate = "Vst_Date"
        case sampleProduct =  "Prod_Samp"
        case productDetail = "Prod_Det"
        case inputs = "Inputs"
        case feedbackCD = "FeedbkCd"
        case feedback = "Feedbk"
        case remarks = "Remks"
        case amslNO = "AMSLNo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.visitDate = try container.decode(DateInfo.self, forKey: .visitDate)
        self.sampleProduct = container.safeDecodeValue(forKey: .sampleProduct)
        self.productDetail = container.safeDecodeValue(forKey: .productDetail)
        self.inputs = container.safeDecodeValue(forKey: .inputs)
        self.feedbackCD = container.safeDecodeValue(forKey: .feedbackCD)
        self.feedback = container.safeDecodeValue(forKey: .feedback)
        self.remarks = container.safeDecodeValue(forKey: .remarks)
        
        self.amslNO = container.safeDecodeValue(forKey: .amslNO)
    }
    
    

    
    init() {

    visitDate = DateInfo()
    sampleProduct = String()
    productDetail = String()
    inputs = String()
    feedbackCD = String()
    feedback = String()
    remarks = String()
        amslNO  = String()
        
        
        
    }
    
}
