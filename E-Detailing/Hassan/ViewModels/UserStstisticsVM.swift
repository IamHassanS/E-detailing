//
//  UserStstisticsVM.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation

public enum UserStatisticsError: String, Error {
case unableConnect = "An issue occured data will be saved to device"
    case failedTocheckin = "Failed to checkin please try again later"
    case failedToupdatePassword = "Failed to update password please try again later"
}

class UserStatisticsVM {
    
 
    func updateUserPassword(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            switch api {
            case .updatePassword:
                result(.failure(UserStatisticsError.failedToupdatePassword))
            default:
                result(.failure(UserStatisticsError.unableConnect))
            }
          
        })
    }
    
    
    func registerCheckin(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[GeneralResponseModal],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [GeneralResponseModal].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            switch api {
            case .checkin:
                result(.failure(UserStatisticsError.failedTocheckin))
            default:
                result(.failure(UserStatisticsError.unableConnect))
            }
          
        })
    }
    
    
    func getTodayCallsData(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[TodayCallsModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [TodayCallsModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    
    func saveDCRdata(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<DCRCallesponseModel,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: DCRCallesponseModel.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    
    func saveMyDayPlan(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    //getTodayCalls
    func getPrecalls(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[PrecallsModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [PrecallsModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
}




