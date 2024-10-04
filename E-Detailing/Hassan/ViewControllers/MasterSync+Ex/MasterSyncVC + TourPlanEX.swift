//
//  MasterSyncVC + TourPlanEX.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. *02/02/1995*.
//

import Foundation
extension MasterSyncVC {
    func getAllPlansData(_ param: [String: Any], paramData: JSON, completion: @escaping (Result<SessionResponseModel,Error>) -> Void){
        let tourPlanVM = TourPlanVM()
        tourPlanVM.getTourPlanData(params: param, api: .getAllPlansData, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(.success(response))
                dump(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                
                completion(.failure(error))
            }
        }
    }
    
    func toSetParams(_ arrOfPlan: [SessionDetailsArr], completion: @escaping (Result<SaveTPresponseModel, TPErrors>) -> ())  {
        let appdefaultSetup = AppDefaults.shared.getAppSetUp()

        
        
        var param = [String: Any]()
        param["SFCode"] = appdefaultSetup.sfCode
        param["SFName"] = appdefaultSetup.sfName
        param["Div"] = appdefaultSetup.divisionCode


        // tourPlanArr.arrOfPlan?.enumerated().forEach { index, allDayPlans in
        
        var sessions = [JSON]()
        
        arrOfPlan.enumerated().forEach { index, allDayPlans in
            allDayPlans.sessionDetails?.enumerated().forEach { sessionIndex, session in
                _ = [String: Any]()
                var index = String()
                if sessionIndex == 0 {
                    index = ""
                } else {
                    index = "\(sessionIndex + 1)"
                }
                
                var drIndex = String()
                if sessionIndex == 0 {
                    drIndex = "_"
                } else if sessionIndex == 1{
                    drIndex = "_two_"
                } else if sessionIndex == 2 {
                    drIndex = "_three_"
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                let date =  dateFormatter.string(from:  allDayPlans.rawDate)
                let dateArr = date.components(separatedBy: " ") //"1 Nov 2023"
                dateFormatter.dateFormat = "EEEE"
                let day = dateFormatter.string(from: allDayPlans.rawDate)
                param["Yr"] = dateArr[2]//2023
               // param["Day"] =  dateArr[0]//1
               // param["Tour_Year"] = dateArr[2] // 2023
               // param["tpmonth"] = dateArr[1]// Nov
                param["tpday"] = day// Wednesday
                
                
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let dayNo = dateFormatter.string(from: allDayPlans.rawDate)
                let anotherDateArr = dayNo.components(separatedBy: "/") // MM/dd/yyyy - 09/12/2018
                param["dayno"] = anotherDateArr[1] // 11
              //  param["Tour_Month"] = anotherDateArr[0]// 11
                param["Mnth"] = anotherDateArr[0]
                
                let tpDtDate = dayNo.replacingOccurrences(of: "/", with: "-")
                param["TPDt"] =  tpDtDate//2023-11-01 00:00:00
                param["FWFlg\(index)"] = session.FWFlg
                param["HQCodes\(index)"] = session.HQCodes
                param["HQNames\(index)"] = session.HQNames
                param["WTCode\(index)"] = session.WTCode
                param["WTName\(index)"] = session.WTName
                param["chem\(drIndex)code"] = session.chemCode
                param["chem\(drIndex)name"] = session.chemName
                param["ClusterCode\(index)"] = session.clusterCode
                param["ClusterName\(index)"] = session.clusterName
                param["Dr\(drIndex)Code"] = session.drCode
                param["Dr\(drIndex)Name"] = session.drName
                param["jwCodes\(index)"] = session.jwCode
                param["jwNames\(index)"] = session.jwName
                
                if sessionIndex == 0 {
                    param["Stockist\(drIndex)Name"] = session.stockistName
                    param["Stockist\(drIndex)Code"] = session.stockistCode
                } else  {
                    param["Stockist\(drIndex)code"] = session.stockistCode
                    param["StockistName\(index)"] = session.stockistName
                }
              
                param["DayRemarks\(index)"] = session.remarks
            }
            param["Change_Status"] = "1"
            param["submittedTime"] = "\(Date())"
            param["Mode"] = "Android-App"
            param["Entry_mode"] = "Apps"
            param["Approve_mode"] = ""
            param["Approved_time"] = ""
            param["app_version"] = LocalStorage.shared.getString(key: .AppVersion)
            sessions.append(param)
        }
        dump(sessions)
        
        makeAPICalls(sessions: sessions, currentIndex: 0) { result in
            
            completion(result)
            self.setLoader(pageType: .loaded)
        }
      
        
//        let jsonDatum = ObjectFormatter.shared.convertJsonArr2Data(json: sessions)
//    
//        var toSendData = [String: Any]()
//        toSendData["data"] = jsonDatum
//        let tourPlanVM = TourPlanVM()
//        tourPlanVM.uploadTPmultipartFormData(params: toSendData, api: .saveTP, paramData: param) { result in
//            switch result {
//            case .success(let response):
//                dump(response)
//                completion(.success(response))
//                self.setLoader(pageType: .loaded)
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                
//                completion(.failure(error))
//                self.setLoader(pageType: .loaded)
//            }
//        }
    }
    
    
    func makeAPICalls(sessions: [JSON], currentIndex: Int = 0, completion: @escaping (Result<SaveTPresponseModel,TPErrors>) -> Void) {
        var  responseModel: SaveTPresponseModel?
        guard currentIndex < sessions.count else {
            // Base case: all API calls have been made
            completion(.success(responseModel ?? SaveTPresponseModel()))
            return
        }
        
        let json = sessions[currentIndex]
        let jsonDatum = ObjectFormatter.shared.convertJsonArr2Data(json: [json])
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        let tourPlanVM = TourPlanVM()
        tourPlanVM.uploadTPmultipartFormData(params: toSendData, api: .saveTP, paramData: sessions[currentIndex]) { result in
            switch result {
            case .success(let response):
                dump(response)
               // completion(.success(response))
                // Continue to the next API call recursively
               // responseModel = response
                self.makeAPICalls(sessions: sessions, currentIndex: currentIndex + 1, completion: completion)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
    func toSendUnsavedObjects(unSavedPlans : [SessionDetailsArr], unsentIndices: [Int], isFromFirstLoad : Bool, completion: @escaping (Bool) -> ()) {
        if unSavedPlans.count > 0 {
            toSetParams(unSavedPlans ) {
                responseResult in
                switch responseResult {
                case .success(let responseJSON):
                    dump(responseJSON)
                    
                    var temptpArray = [TourPlanArr]()
                    
                    AppDefaults.shared.eachDatePlan.tourPlanArr?.forEach {  eachDayPlan in
                        temptpArray.append(eachDayPlan)
                    }
                    
                    var temparrOfplan = [SessionDetailsArr]()
                    
                    temptpArray.forEach({ tpArr in
                        temparrOfplan = tpArr.arrOfPlan
                        //unSavedPlans//self.arrOfPlan
                    })
                    
                    var apiSentPlans = temparrOfplan.filter { ASessionDetailsArr in
                        ASessionDetailsArr.isDataSentToApi == true
                    }
                    
                    apiSentPlans.append(contentsOf: unSavedPlans)
                    
                    temparrOfplan = apiSentPlans
                    
                    temparrOfplan.forEach { plans in
                        plans.isDataSentToApi = true
                    }
                    
                    temptpArray.forEach({ tpArr in
                        tpArr.arrOfPlan = temparrOfplan
                        //unSavedPlans//self.arrOfPlan
                    })
                    
                    
                    
                    AppDefaults.shared.eachDatePlan.tourPlanArr = temptpArray
//                    let savefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
//                    if !savefinish {
//                        print("Error")
//                    }
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
                        try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
                        print("Save successful")
                    } catch {
                        print("Unable to save: \(error)")
                    }
                    
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: true)
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print(error)
                }
            }
        } else {
            //  self.initialSetups()
            //  self.toCreateToast("Already this month plans are submited for approval.")
        }
        
    }
    
    func toPostDataToserver(type : MasterInfo, completion: @escaping (Bool) -> ()) {

        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            completion(false)
            return
        }
        
       // AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()

        do {
            // Read the data from the file URL
            let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                
                if let aPlan = eachDatePlan as? EachDatePlan {
                    AppDefaults.shared.eachDatePlan = aPlan
                } else {
                    print("unable to convert to EachDatePlan")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                AppDefaults.shared.eachDatePlan = EachDatePlan()
            }
        } catch {
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
            AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
        }
        dump(AppDefaults.shared.eachDatePlan)
        
        var  arrOfPlan = [SessionDetailsArr]()
        var tpArray =  [TourPlanArr]()

        AppDefaults.shared.eachDatePlan.tourPlanArr?.enumerated().forEach { index, eachDayPlan in
            tpArray.append(eachDayPlan)
        }
        tpArray.forEach({ tpArr in
            arrOfPlan = tpArr.arrOfPlan
        })
        
        
        let nonWeekoff = arrOfPlan.filter({ toFilterSessionsArr in
            toFilterSessionsArr.isForWeekoff == false
        })
        
        
        var unSavedPlans = [SessionDetailsArr]()
        
        if nonWeekoff.isEmpty {
            unSavedPlans = arrOfPlan.filter({ toFilterSessionsArr in
                   toFilterSessionsArr.isDataSentToApi == false &&  toFilterSessionsArr.isForWeekoff == false
               })
        } else {
            unSavedPlans = arrOfPlan.filter({ toFilterSessionsArr in
                   toFilterSessionsArr.isDataSentToApi == false
               })
        }

        var unsentIndices = [Int]()

        dump(unSavedPlans)
        if !(unSavedPlans.isEmpty ) {
            unsentIndices = unSavedPlans.indices.filter { unSavedPlans[$0].isDataSentToApi == false  }
        }
//&&  !unSavedPlans[$0].isForWeekoff

        dump(unsentIndices)

        if unSavedPlans.count > 0 {
            toSendUnsavedObjects(unSavedPlans: unSavedPlans, unsentIndices: unsentIndices, isFromFirstLoad: true) {isCompleted in
                
            completion(isCompleted)
            }
        } else {

            let toSendData = type.getParams

             getAllPlansData(toSendData, paramData: JSON()) { result in
                 switch result{
                 case .success(let respnse):
                     dump(respnse)
                     DBManager.shared.saveTPtoMasterData(modal: respnse) { isCompleted in
                         if isCompleted {
                             let date = Date().toString(format: "dd MMM yyyy hh:mm a")
                             self.lblSyncStatus.text = "Last Sync: " + date
                         }
                     }
                     self.setLoader(pageType: .loaded)
                     completion(true)
                 case .failure( let error):
                  dump(error)
                     completion(false)
                     self.setLoader(pageType: .loaded)
                    //self.toCreateToast("Failed connecting to server!")
                 }
             }
        }

    }
}
