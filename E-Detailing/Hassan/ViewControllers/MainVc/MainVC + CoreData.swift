//
//  MainVC + CoreData.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/06/24.
//


import Foundation
import CoreData
extension MainVC {
    
    func saveHQentitiesToCoreData(aHQobj: HQModel, completion: (Bool) -> Void) {
        CoreDataManager.shared.removeHQ()
        CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) {  _ in
            
            completion(true)
        }
    }
    
    func fetchCheckins(checkin: CheckinInfo, completion: @escaping (CheckinInfo) -> ()) {
        CoreDataManager.shared.fetchCheckininfo() { saveCheckins  in
            
            guard let aCheckin = saveCheckins.first else {
                
                self.checkinAction()
                
                return}
            
            var tempCheckin = checkin
            tempCheckin.checkinDateTime = aCheckin.checkinDateTime
            tempCheckin.checkinTime = aCheckin.checkinTime
            completion(tempCheckin)
        }
    }
    
    func showAlertToremoveEvents(desc: String, event: UnsyncedEventCaptureModel) {
  
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok",cancelAction: "cancel")
        commonAlert.addAdditionalCancelAction {
            
            print("no action")
        }
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("yes action")
            self.toRemoveEvent(event: event)

            
        }
    }
    
    func toRemoveEvent(event: UnsyncedEventCaptureModel) {
        guard let custCode = event.custCode, let date = event.eventcaptureDate  else {return}

        CoreDataManager.shared.removeUnsyncedEventCaptures(date: date, withCustCode: custCode) {[weak self] _  in
            guard let welf = self else {return}
            welf.toLoadOutboxTable()
            
            
            CoreDataManager.shared.tofetchaSavedCalls(editDate: date, callID: custCode) { addedDCRcall in
                
                let context = welf.context
             
                guard let addedDCRcalls = addedDCRcall else {
                    welf.toCreateToast("Unable to delete selected event")
                    return
                }
                
                var filteredcalls: [AddedDCRCall] = []
                
                addedDCRcalls.forEach { aAddedDCRCall in
                    let dcrCalldate = aAddedDCRCall.callDate
                    let dateStr = dcrCalldate?.toString(format: "yyyy-MM-dd")
                    let editDate = date
                    let editDateStr = editDate.toString(format: "yyyy-MM-dd")
                    if dateStr == editDateStr {
                        filteredcalls.append(aAddedDCRCall)
                    }
                }
                
                let ftchedDCRcall = filteredcalls.first
               guard (ftchedDCRcall != nil) else {return}
                
                ftchedDCRcall?.capturedEvents = nil
                do {
                    welf.showAlertToFilldates(description: "captured Events deleted sucessfully")
                    try context.save()
                    
                } catch {
                    
                    print("unable to delete")
                }
             
            }
            
        }

    }
    
    func didTapEventcaptureDelete(event: UnsyncedEventCaptureModel) {
        
        self.showAlertToremoveEvents(desc: "Are you sure about removing events", event: event)
        
        


    }
    
    func upDateplansToDB(isSynced: Bool, planDate: Date, model: [MyDayPlanResponseModel], completion: @escaping () -> ()) {
        masterVM?.toUpdateDataBase(isSynced: isSynced, planDate: planDate, aDayplan: masterVM?.toConvertResponseToDayPlan(isSynced: isSynced, model: model) ?? DayPlan()) {[weak self] _ in
            guard let welf = self else {return}
           // welf.toConfigureMydayPlan(planDate: planDate) {
                completion()
           // }
           
        }
    }
    
    func toSaveaParamData(jsonDatum: Data, completion: @escaping () -> ()) {
        let managedObjectContext = DBManager.shared.managedContext() // Assuming DBManager.shared.managedContext() returns the managed object context
        
        // Fetch existing OutBoxParam entities and delete them
        let fetchRequest: NSFetchRequest<OutBoxParam> = OutBoxParam.fetchRequest()
        do {
            let existingParams = try managedObjectContext.fetch(fetchRequest)
            for param in existingParams {
                managedObjectContext.delete(param)
            }
        } catch {
            print("Failed to fetch existing OutBoxParam entities: \(error)")
            // Handle error
            completion()
            return
        }
        
        // Create a new OutBoxParam entity and assign the jsonDatum
        if let entityDescription = NSEntityDescription.entity(forEntityName: "OutBoxParam", in: managedObjectContext) {
            let outBoxParam = OutBoxParam(entity: entityDescription, insertInto: managedObjectContext)
            outBoxParam.unSyncedParams = jsonDatum
            
            // Save to Core Data
            do {
                try managedObjectContext.save()
                completion()
            } catch {
                print("Failed to save to Core Data: \(error)")
                // Handle error
            }
        } else {
            print("Entity description not found.")
            // Handle error
        }
    }
    
    
    func toRemoveOutboxandDefaultParams(refreshDate: Date, param: JSON, completion: @escaping (Bool) -> ()) {

        //to remove object from Local array and core data
        
        let filteredValues =  self.outBoxDataArr?.filter({ outBoxCallModel in
            outBoxCallModel.custCode != param["CustCode"] as! String
        })
        
        self.outBoxDataArr = filteredValues
        
        
        unsyncedhomeDataArr.removeAll { aHomeData in
            let aHomeDataDCRDate =  aHomeData.dcr_dt?.toDate()
            let aHomeDataDCRDateStr = aHomeDataDCRDate?.toString(format: "MMM d, yyyy")
            let refreshDateStr = refreshDate.toString(format: "MMM d, yyyy")
            return aHomeData.custCode == param["CustCode"] as? String &&  aHomeDataDCRDateStr == refreshDateStr
        }
        let identifier = param["CustCode"] as? String // Assuming "identifier" is a unique identifier in HomeData

        let context = DBManager.shared.managedContext()

        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = UnsyncedHomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", identifier ?? "")

        do  {
            let results = try context.fetch(fetchRequest)
            if let existingObject = results.first {
                let dateSting = existingObject.dcr_dt
                let dcrDate = dateSting?.toDate(format: "yyyy-MM-dd HH:mm:ss")
                let dcrDateString = dcrDate?.toString(format: "MMM d, yyyy")
                let currentDateStr = refreshDate.toString(format: "MMM d, yyyy")
                
                if dcrDateString == currentDateStr {
                    context.delete(existingObject)
                }
                
                DBManager.shared.saveContext()
            }
        } catch {
            // Handle fetch error
        }
        

        self.removeAllAddedCall(id: identifier ?? "", refreshDate: refreshDate)
        
        
        CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
            guard let aoutboxCDM = outboxCDMs.first else {
                completion(false)
                return
            }
            
            let coreparamDatum = aoutboxCDM.unSyncedParams
            
            guard let paramData = coreparamDatum else {
                completion(false)
                return}
            var localParamArr = [String: [[String: Any]]]()
            do {
                localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
                dump(localParamArr)
            } catch {
                self.toCreateToast("unable to retrive")
            }
            
            
            let custCodeToRemove = param["CustCode"] as! String
            
            // Iterate through the dictionary and filter out elements with the specified CustCode
            localParamArr = localParamArr.mapValues { callsArray in
                return callsArray.filter { call in
                    if let custCode = call["CustCode"] as? String {
                        let dateSting = call["vstTime"] as! String
                        let dcrDate = dateSting.toDate(format: "yyyy-MM-dd HH:mm:ss")
                        let dcrDateString = dcrDate.toString(format: "MMM d, yyyy")
                        let currentDateStr = refreshDate.toString(format: "MMM d, yyyy")
                        if custCode == custCodeToRemove && dcrDateString == currentDateStr {
                            print("Removing element with CustCode: \(custCode)")
                            return false
                        }
                    }
                    return true
                }
            }
            // Remove entries where the filtered array is empty
            localParamArr = localParamArr.filter { _, callsArray in
                return !callsArray.isEmpty
            }
            
            let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
            

            toSaveaParamData(jsonDatum: jsonDatum) {
                
                
                // Create a new array with modified sections
                let updatedSections = obj_sections.map { section -> Section in
                    var updatedSection = section
                    
                    // Filter items in the section
                    updatedSection.items = section.items.filter { call in
                        // Assuming custCode is not an optional type
                        return call.custCode != custCodeToRemove
                    }
                    
                    // Keep the section if it still has items after filtering
                    return updatedSection
                }
                // Assign the updated array back to obj_sections
                obj_sections = updatedSections.filter({ section in
                    !section.items.isEmpty
                })
                
                print(obj_sections)
                
                self.dcrcallsAdded()
                
                completion(true)
                
            }

        }
        

        
        

        
        
    }
}
