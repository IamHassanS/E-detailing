//
//  MastersyncVM + EX.swift
//  SAN ZEN
//
//  Created by San eforce on 26/09/24.
//

import Foundation
extension MasterSyncVM {
    
    func fetchChemists(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<ChemistModel,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: ChemistModel.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
}
