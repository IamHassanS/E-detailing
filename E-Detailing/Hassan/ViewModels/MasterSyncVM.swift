//
//  MasterSyncVM.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation
import Alamofire
import SSZipArchive

struct UnzippedDataInfo {
    var videofiles: [Videoinfo]
    var imagefiles: [Imageinfo]
    var htmlfiles: [HTMLinfo]
    
    init() {
        self.videofiles = [Videoinfo]()
        self.imagefiles = [Imageinfo]()
        self.htmlfiles = [HTMLinfo]()
    }
}

struct Videoinfo {

    var fileData:  Data?
    var filetype: String?
    init() {

        self.fileData = Data()
        self.filetype = String()
    }
}


struct Imageinfo {

    var fileData:  Data?
    var filetype: String?
    init() {

        self.fileData = Data()
        self.filetype = String()
    }
}

struct HTMLinfo {
    var htmlString: String?
    var htmlFileURL: URL?
    var fileData:  Data?
    var fileName: String?
    init() {
        self.htmlString = String()
        self.htmlFileURL = URL(string: "")
        self.fileData = Data()
        self.fileName = String()
    }
}

enum MasterSyncErrors: String, Error {
case unableConnect = "An issue occured try again later."
}

class MasterSyncVM {
    var extractedFileName: String?
    var isUpdated: [MasterInfo] = []
    var isUpdating: Bool = false
    var isSyncCompleted: Bool = false
    let appsetup = AppDefaults.shared.getAppSetUp()
    var getRSF: String? {
    
        let selectedRSF = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        let rsfIDPlan1 = LocalStorage.shared.getString(key: LocalStorage.LocalValue.rsfIDPlan1)
        let rsfIDPlan2 = LocalStorage.shared.getString(key: LocalStorage.LocalValue.rsfIDPlan2)

        if !selectedRSF.isEmpty {
            return selectedRSF
        } else if !rsfIDPlan1.isEmpty {
            return rsfIDPlan1
        } else if !rsfIDPlan2.isEmpty {
            return rsfIDPlan2
        } else {
            return "\(appsetup.sfCode!)"
        }
    }
    
    var mapID: String?
    
    func toGetMyDayPlan(type: MasterInfo, isToloadDB: Bool, date: Date = Date(), isFromDCR: Bool? = false, completion: @escaping (Result<[MyDayPlanResponseModel],MasterSyncErrors>) -> ()) {
        
 
        let date = date.toString(format: "yyyy-MM-dd HH:mm:ss")
        var param = [String: Any]()
        
        
//    http://edetailing.sanffa.info/iOSServer/db_api.php/?axn=table/dcrmasterdata
//    {"tableName":"getmydayplan","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,","ReqDt":"2024-02-15 15:27:16"}
        
        
       // {"tableName":"gettodaydcr","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,","ReqDt":"2024-02-12 15:27:16"}
        
        param["tableName"] = isFromDCR ?? false ? "gettodaydcr" : "getmydayplan"
        param["ReqDt"] = date
        param["sfcode"] = "\(appsetup.sfCode!)"
        param["division_code"] = "\(appsetup.divisionCode!)"

       // let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.rsfIDPlan1)
        param["Rsf"] =  isFromDCR ?? false ? appsetup.sfCode! : getRSF
        param["sf_type"] = "\(appsetup.sfType!)"
        param["Designation"] = "\(appsetup.dsName!)"
        param["state_code"] = "\(appsetup.stateCode!)"
        param["subdivision_code"] = "\(appsetup.subDivisionCode!)"
         
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        
        self.getTodayPlans(params: toSendData, api: .masterData, paramData: param, {[weak self] result in
          
            guard let welf = self else {return}
            switch result {
                
            case .success(let model):
                dump(model)
                if isToloadDB {
                    welf.toUpdateDataBase(aDayplan: welf.toConvertResponseToDayPlan(model: model)) {_ in
                        
                        completion(result)
                    }
                    
                } else {
                    completion(result)
                }
         
                
            case .failure(let error):
                print(error)
                completion(result)
            }
            
          
        })
        
    }
    
    func toUpdateDataBase(aDayplan: DayPlan, completion: @escaping (Bool) -> ()) {
        CoreDataManager.shared.removeAllDayPlans()
        CoreDataManager.shared.toSaveDayPlan(aDayPlan: aDayplan) { isComleted in
            
            completion(true)
            
//            if isComleted {
//               // self.toCreateToast("Saved successfully")
//
//                CoreDataManager.shared.retriveSavedDayPlans() { dayplans in
//                    dump(dayplans)
//                }
//            
//              
//            } 
        }
    }
    
    func toConvertResponseToDayPlan(model: [MyDayPlanResponseModel]) -> DayPlan  {
        let aDayPlan = DayPlan()
        let userConfig = AppDefaults.shared.getAppSetUp()
        aDayPlan.tableName = "gettodaytpnew"
        aDayPlan.uuid = UUID()
        aDayPlan.divisionCode = userConfig.divisionCode ?? ""
        aDayPlan.sfType = "\(userConfig.sfType!)"
        aDayPlan.designation = "\(userConfig.desig!)"
        aDayPlan.stateCode = "\(userConfig.stateCode!)"
        aDayPlan.subdivisionCode = userConfig.subDivisionCode ?? ""
     
        model.enumerated().forEach {index, aMyDayPlanResponseModel in
            switch index {
            case 0:
                aDayPlan.tpDt = aMyDayPlanResponseModel.TPDt.date //2024-02-03 00:00:00
                aDayPlan.isRetrived  =  true
                aDayPlan.sfcode = aMyDayPlanResponseModel.SFCode
                aDayPlan.rsf = aMyDayPlanResponseModel.SFMem
                LocalStorage.shared.setSting(LocalStorage.LocalValue.rsfIDPlan1, text: aMyDayPlanResponseModel.SFMem)
                LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aMyDayPlanResponseModel.SFMem)
                aDayPlan.wtCode = aMyDayPlanResponseModel.WT
                aDayPlan.wtName = aMyDayPlanResponseModel.WTNm
                aDayPlan.fwFlg = aMyDayPlanResponseModel.FWFlg
                aDayPlan.townCode = aMyDayPlanResponseModel.Pl
                aDayPlan.townName = aMyDayPlanResponseModel.PlNm
            case 1:
                aDayPlan.tpDt = aMyDayPlanResponseModel.TPDt.date //2024-02-03 00:00:00
                aDayPlan.isRetrived2  =  true
                aDayPlan.sfcode = aMyDayPlanResponseModel.SFCode
                aDayPlan.rsf2 = aMyDayPlanResponseModel.SFMem
                LocalStorage.shared.setSting(LocalStorage.LocalValue.rsfIDPlan2, text: aMyDayPlanResponseModel.SFMem)
                LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aMyDayPlanResponseModel.SFMem)
                aDayPlan.wtCode2 = aMyDayPlanResponseModel.WT
                aDayPlan.wtName2 = aMyDayPlanResponseModel.WTNm
                aDayPlan.fwFlg2 = aMyDayPlanResponseModel.FWFlg
                aDayPlan.townCode2 = aMyDayPlanResponseModel.Pl
                aDayPlan.townName2 = aMyDayPlanResponseModel.PlNm
                
                
            default:
                print("Yet to implement")
            }
        }
        

      
        return aDayPlan
        
    }
    
    
    
    
    func fetchMasterData(type: MasterInfo, sfCode: String, istoUpdateDCRlist: Bool, mapID: String, completionHandler: @escaping (AFDataResponse<Data>) -> Void) {
        dump(type.getUrl)
        dump(type.getParams)

        AF.request(type.getUrl, method: .post, parameters: type.getParams).responseData { [weak self] (response) in
            guard let welf = self else { return }

            switch response.result {
            case .success(_):
                guard let apiResponse = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [[String: Any]] else {
                    print("Unable to serialize")
                    completionHandler(response)
                    return
                }

                print(apiResponse)
                // Save to Core Data or perform any other actions
                DBManager.shared.saveMasterData(type: type, Values: apiResponse, id: mapID)

                if istoUpdateDCRlist && !welf.isUpdating {
                    welf.updateDCRLists(mapID: mapID) { _ in
                        completionHandler(response)
                    }
                } else   {
                    completionHandler(response)
                }

            case .failure(let error):
                completionHandler(response)
                print(error)
            }
        }
    }
    

    func updateDCRLists(mapID: String, completion: @escaping (Bool) -> ()) {
        let dispatchgroup = DispatchGroup()
        isUpdating = true
        let dcrEntries : [MasterInfo] = [.doctorFencing, .chemists, .unlistedDoctors, .stockists]
        
        
        //Doctor,Chemist,Stokiest,Unlistered,Cip,Hospital,Cluste
     
        fetchDCR(index: 0, dcrEntries: dcrEntries, mapID: mapID) { _ in
            completion(true)
        }
        
//        dcrEntries.forEach { aMasterInfo in
//            dispatchgroup.enter()
//            
//            fetchMasterData(type: aMasterInfo, sfCode: getRSF ?? "", istoUpdateDCRlist: true, mapID: mapID) { _ in
//                print("Syncing \(aMasterInfo.rawValue)")
//               
//               dispatchgroup.leave()
//                
//            }
//        }
//        
//        dispatchgroup.notify(queue: .main) {
//            // All async tasks are completed
//            self.isUpdating = false
//            self.isSyncCompleted = true
//            print("DCR list sync completed")
//            completion(true)
//       
//        }
        
    }
    
    
    func fetchDCR(index: Int, dcrEntries : [MasterInfo], mapID: String, completion: @escaping (Bool) -> ()) {
        if index >= dcrEntries.count {
            self.isUpdating = false
            self.isSyncCompleted = true
            print("DCR list sync completed")
            completion(true)
            return
        }
        
        let aMasterInfo = dcrEntries[index]
        fetchMasterData(type: aMasterInfo, sfCode: getRSF ?? "", istoUpdateDCRlist: true, mapID: mapID) { _ in
            print("Syncing \(aMasterInfo.rawValue)")
            self.fetchDCR(index: index + 1, dcrEntries: dcrEntries, mapID: mapID, completion: completion)
            
        }
        
        
    }
    
    func getTodayPlans(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[MyDayPlanResponseModel],MasterSyncErrors>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [MyDayPlanResponseModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(MasterSyncErrors.unableConnect))
        })
    }
    
    func getDCRdates(params: JSON, api : APIEnums, paramData: JSON, _ result : @escaping (Result<[DCRdatesModel],MasterSyncErrors>) -> Void) {
        ConnectionHandler.shared.uploadRequest(for: api, params: params, data: paramData)
            .responseDecode(to: [DCRdatesModel].self, { (json) in
            result(.success(json))
            dump(json)
        }).responseFailure({ (error) in
            print(error.description)
            result(.failure(MasterSyncErrors.unableConnect))
        })
    }
    
    
    func tofetchDcrdates(completion: @escaping (Result<([DCRdatesModel]), MasterSyncErrors>) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        

        var param = [String: Any]()
        param["tableName"] = "getdcrdate"
        param["sfcode"] = "\(appsetup.sfCode!)"
        param["division_code"] = "\(appsetup.divisionCode!)"
        param["Rsf"] = "\(appsetup.sfCode!)"
        param["sf_type"] = "\(appsetup.sfType!)"
        param["Designation"] = "\(appsetup.dsName!)"
        param["state_code"] = "\(appsetup.stateCode!)"
        param["subdivision_code"] = "\(appsetup.subDivisionCode!)"
        param["ReqDt"] = date
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
 
       self.getDCRdates(params: toSendData, api: .home, paramData: param) { result in
            
            switch result {
                
            case .success(let respnse):
                completion(result)
                
                dump(respnse)
          
                
            case .failure(_):
                completion(result)
            }
             
        }
 
    }
    

}
