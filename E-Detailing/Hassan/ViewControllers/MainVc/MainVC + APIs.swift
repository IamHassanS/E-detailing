//
//  MainVC + APIs.swift
//  SAN ZEN
//
//  Created by San eforce on 29/06/24.
//

import Foundation
extension MainVC {
    
    func uploadDCRcallsSequentially(dates: [String], index: Int = 0, completion: @escaping() -> ()) {
        // Base case: if the index is equal to the count of dates, we are done
        
        guard index < dates.count else {
            print("All dates have been processed")
            completion()
            return
        }

        // Get the current date to process
        let currentDate = dates[index]
        
        // Call the API for the current date
        self.toretryDCRupload(date: currentDate) {[weak self] success in
            guard let welf = self else {return}
            // Move to the next date
            welf.uploadDCRcallsSequentially(dates: dates, index: index + 1, completion: completion)
        }
    }
    
    func uploadDayPlansSequentially(dates: [String], index: Int = 0, completion: @escaping() -> ()) {
        guard index < dates.count else {
            print("All dates have been processed")
            completion()
            return
        }
        // Get the current date to process
        let currentDate = dates[index]
        
        self.toPostDayplan(byDate: currentDate.toDate(format: "yyyy-MM-dd" ), istoupdateUI: self.selectedDate != nil) { [weak self] in
            guard let welf = self else {return}
            // Move to the next date
            welf.uploadDayPlansSequentially(dates: dates, index: index + 1, completion: completion)
                
        }
        
    }
    
    func syncAllCalls() {
        if obj_sections.isEmpty {
            return
        }
        
        let unSyncedDates : [String] = obj_sections.map { aSection in
           return aSection.date
        }

        Shared.instance.showLoaderInWindow()
        
        uploadDCRcallsSequentially(dates: unSyncedDates) {  [weak self] in
            
            guard let welf = self else {return}
          
            welf.toUploadUnsyncedImage() {
                
                welf.uploadDayPlansSequentially(dates: unSyncedDates) {
                    
                    welf.toUploadWindups() {_ in 
                      
                        welf.refreshDashboard(date: Shared.instance.selectedDate) {
                            Shared.instance.removeLoaderInWindow()
                        }
                    }
                }
         
   
            }
            
  
            
        }

    }
    
    func toUploadWindups(date : Date? = nil, completion: @escaping (Bool) -> ()) {
        let dispatchGroup = DispatchGroup()
        
        CoreDataManager.shared.toFetchAllDayStatus { fetchedeachDayStatus in
            var eachDayStatus : [EachDayStatus] = fetchedeachDayStatus.filter { $0.didUserWindup == true }
            if let date = date {
                eachDayStatus = eachDayStatus.filter { $0.statusDate?.toString(format: "yyyy-MM-dd") == date.toString(format: "yyyy-MM-dd") }
            }
            
            
            for aEachDayStatus in eachDayStatus {
                dispatchGroup.enter()
                
                var tosendData = [String: Any]()
                tosendData["data"] = aEachDayStatus.param
                let param = ObjectFormatter.shared.convertDataToJson(data: aEachDayStatus.param ?? Data())
                
                userststisticsVM?.finalSubmit(params: tosendData, api: .finalSubmit, paramData: param ?? JSON()) { [weak self] result in
                    guard let welf = self else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    switch result {
                    case .success(let response):
                        if response.isSuccess ?? false {
                            welf.toCreateToast(response.msg ?? "Day completed successfully...")
                            welf.handleWindups(date: date, isSynced: true, didUserWindup: true, paramData: aEachDayStatus.param ?? Data()) { isSaved in
                               // welf.toCreateToast("Saved log offline")
                                dispatchGroup.leave()
                            }
                        } else {
                            welf.handleWindups(date: date, isSynced: false, didUserWindup: true, paramData: aEachDayStatus.param ?? Data()) { isSaved in
                                welf.toCreateToast("Saved log offline")
                                dispatchGroup.leave()
                            }
                        }
                        
                    case .failure(let error):
                        welf.toCreateToast(error.rawValue)
                        
                        welf.handleWindups(date: date, isSynced: false, didUserWindup: true, paramData: aEachDayStatus.param ?? Data()) { isSaved in
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(true)
            }
        }
    }
    
    func callSavePlanAPI(byDate: Date, istoupdateUI: Bool, completion: @escaping (Bool) -> Void) {
        var dayEntities : [DayPlan] = []
        CoreDataManager.shared.retriveSavedDayPlans(byDate: byDate) { dayplan in
            
            dayEntities = dayplan
            
            let aDayplan = dayEntities.first
            guard let  aDayplan = aDayplan else  {
                //  !aDayplan.isSynced
                completion(true)
                return
            }
             do {
                 let encoder = JSONEncoder()
                 let jsonData = try encoder.encode(aDayplan)
                 

                 if var jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                     print("JSON Dictionary: \(jsonObject)")
                     jsonObject["InsMode"] = "0"
                     jsonObject["day_flag"] = "0"
                     var toSendData = [String: Any]()
                     
                     let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: jsonObject)
                     
                     toSendData["data"] = jsonDatum
                     
                     
                     self.userststisticsVM?.saveMyDayPlan(params: toSendData, api: .myDayPlan, paramData: jsonObject, { [ weak self ] result in
                         guard let welf = self else {return}
                         switch result {
                             
                         case .success(let response):
                             dump(response)
                             
                             LocalStorage.shared.setBool(LocalStorage.LocalValue.istoUploadDayplans, value: false)
                            
//                             if !istoupdateUI {
//                                 completion(true)
//                                 welf.toCreateToast(response.msg ?? "")
//                                 return
//                             }
                             welf.masterVM?.toGetMyDayPlan(type: .myDayPlan, isToloadDB: true, date: Shared.instance.selectedDate) {_ in
 
                                 completion(true)
                                 welf.toCreateToast(response.msg ?? "")
                             }
                         case .failure(let error):
                             completion(false)
                             welf.toCreateToast(error.rawValue)
                         }
                         
                     })
                     
                     
                     
                 } else {
                     print("Failed to convert data to JSON dictionary")
                 }
                 
                 
                 // jsonData now contains the JSON representation of yourObject
             } catch {
                 print("Error encoding object to JSON: \(error)")
             }
        }
    }
    
    func toretryDCRupload(dcrCall: [TodayCallsModel]? = nil,  date: String, completion: @escaping (Bool) -> Void) {
 
    
        if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            showAlert(desc: "Internet connection is required to sync calls.")
            return
        }
        guard let dcrCall = dcrCall else {
            completion(false)
            return
        }
        toReturnOutboxParam(dcrCall: dcrCall) { [weak self] jsonArr in
            guard let welf = self, !jsonArr.isEmpty else {
                let dispatchGroup = DispatchGroup()
                dcrCall.forEach {call in
                    dispatchGroup.enter()
                    var param: [String: Any] = [:]
                    param["CustCode"] = call.custCode
                    self?.toRemoveOutboxandDefaultParams(refreshDate:  date.toDate(format: "yyyy-MM-dd"), param: param) { isRemoved in
                        dispatchGroup.leave()
                    
                    }
                   
                }
                dispatchGroup.notify(queue: .main) {
                    completion(false)
                }

                return}
            welf.toSendParamsToAPISerially(refreshDate: date.toDate(format: "yyyy-MM-dd"), index: 0, items: jsonArr) { _ in
                completion(true)
            }
        }


        }
        
    func toReturnOutboxParam(dcrCall: [TodayCallsModel], completion: @escaping ([JSON]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var addcallParams = [JSON]()
        
        dcrCall.forEach { todayCallsModel in
            let callType = toReturnCallType(dcrCall: todayCallsModel)
            guard let call = callType?.call, let type = callType?.type else {
                print("Error: Invalid call type for \(todayCallsModel)")
                completion(addcallParams)
                return
            }
            
            dispatchGroup.enter()
            dcrCallObjectParser.toReturnModelobjects(call: call, type: type) { [weak self] outboxModel in
                guard let welf = self else { return }
                welf.dcrCallObjectParser.toSetDCRParam(outboxModel: outboxModel) { json in
                    guard let json = json else {
                        print("Error: JSON is nil for outboxModel: \(outboxModel)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    var param: [String: Any] = json
                    param["CustCode"] = todayCallsModel.custCode
                    addcallParams.append(param)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(addcallParams)
        }
    }
    
    func toReturnEachParam(dcrCall: [TodayCallsModel], completion: @escaping (Bool) -> () ) {
        
        
    }
    
    func toSendParamsToAPISerially(refreshDate: Date, index: Int, items: [JSON], completion: @escaping (Bool) -> Void) {
      guard index < items.count else {
        completion(true) // All items processed, signal completion
        return
      }

      let currentItem = items[index]
       dump(currentItem)
        
        if currentItem.isEmpty {
            let nextIndex = index + 1
            self.toSendParamsToAPISerially(refreshDate: refreshDate, index: nextIndex, items: items, completion: completion)
        }
      // Attempt to convert JSON to Data
//      guard let jsonData = try? JSONSerialization.data(withJSONObject: currentItem, options: []) else {
//        completion(false) // Error converting JSON, signal failure
//        return
//      }
        
        let jsonData = ObjectFormatter.shared.convertJson2Data(json: currentItem)

      // Prepare data for API request
      let toSendData = ["data": jsonData]

      // Send API request
        sendAPIrequest(refreshDate: refreshDate, toSendData, paramData: currentItem) { callStatus in
        let nextIndex = index + 1
            self.toSendParamsToAPISerially(refreshDate: refreshDate, index: nextIndex, items: items, completion: completion)
      }
    }
    
    /// My day plan API call
    /// - Parameters:
    ///   - date: Date for with day plan to be fetched
    ///   - isFromDCRDates: Boolean
    ///   - completion: empty completion
    func callDayPLanAPI(date: Date, isFromDCRDates: Bool, completion: @escaping () -> ()) {
       // Shared.instance.showLoaderInWindow()
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            masterVM?.toGetMyDayPlan(type: .myDayPlan, isToloadDB: true, date: date, isFromDCR: isFromDCRDates) {[weak self] result in
                guard let welf = self else {return}
                switch result {
                case .success(_):
                        completion()
                case .failure(let error):
                  welf.toCreateToast(error.rawValue)
                    completion()
                }
              
            }
        } else {
            completion()
        }
    }
    
}
