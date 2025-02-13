//
//  UserStstisticsVM.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation
import UIKit

public enum UserStatisticsError: String, Error {
    case unableConnect = "An issue occured"
    case failedToLOG = "Not connected to active network. Data will be saved to device"
    case failedToupdatePassword = "Failed to update password please try again later"
    case failedTouploadImage = "Failed to upload captured events"
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
                result(.failure(UserStatisticsError.failedToupdatePassword))
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
                result(.failure(UserStatisticsError.failedToLOG))
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
    
    //Delete Added Call
  //  {"sfcode":"MGR0941","division_code":"63,","Rsf":"MR5990","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,","amc":"DP3-1344","CusType":"1","sample_validation":"0","input_validation":"0"}
    
    func deleteAddedcalls(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<JSON,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData).responseJSON() { json in
            result(.success(json))
            dump(json)
        }.responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
 
    }
    
    
    
    func toEditAddedCall(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<EditCallinfoModel,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: EditCallinfoModel.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    
    func toUploadCapturedImage(params: JSON, uploadType: ConnectionHandler.UploadType,  api : APIEnums, image: [UIImage], imageName:  [String], paramData: Data,  custCode: String, _ result : @escaping (Result<JSON,UserStatisticsError>) -> Void) {
        let urlString = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageUploadURL) + api.rawValue
        ConnectionHandler.shared.imageUploadService( urlString: urlString, uploadType: uploadType, parameters: params, image: image, imageName:  imageName, custCode: custCode, paramData: paramData) { response in
            dump(response)
            result(.success(response))
        } onError: { err in
            dump(err)
            result(.failure(UserStatisticsError.failedTouploadImage))
        }

        
    }
    
    
    func toUploadTaggedInfo(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    func toGetLeaveStatus(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[LeaveStatus],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [LeaveStatus].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    func toCheckLeaveAvailability(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[LeaveAvailability],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [LeaveAvailability].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    func toSubmitLeave(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<LeaveResponse,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: LeaveResponse.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }

    func finalSubmit(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    func getArrovalCounts(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<ApprovalsCountModel,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: ApprovalsCountModel.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    func getArrovalList(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[ApprovalsListModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [ApprovalsListModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    func getArrovalDetail(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[ApprovalDetailsModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [ApprovalDetailsModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    
    func getLeaveArrovalDetail(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[LeaveApprovalDetail],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [LeaveApprovalDetail].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    func approveDCR(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    func getTPapprovals(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[TourPlanApprovalModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [TourPlanApprovalModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    func getTPapprovalDetail(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[TourPlanApprovalDetailModel],UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [TourPlanApprovalDetailModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
    func approveTP(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<GeneralResponseModal,UserStatisticsError>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: GeneralResponseModal.self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(UserStatisticsError.unableConnect))
        })
    }
    
    
}




