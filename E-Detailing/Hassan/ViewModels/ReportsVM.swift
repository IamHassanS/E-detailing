//
//  ReportsVM.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation
class ReportsVM {
    
    enum ReportsError: String, Error {
    case unableConnect = "An issue occured data will be saved to device"
    }
    
    func getReportsData(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[ReportsModel],ReportsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [ReportsModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(ReportsError.unableConnect))
        })
    }

    func getDetailedReportsData(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[DetailedReportsModel],ReportsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [DetailedReportsModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(ReportsError.unableConnect))
        })
    }
}
