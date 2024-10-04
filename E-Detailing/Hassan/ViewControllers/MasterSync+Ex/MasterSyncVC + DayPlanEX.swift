//
//  MasterSyncVC + DayPlanEX.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 15/02/24.
//

import Foundation
import CoreData
import UIKit
import Alamofire
protocol MasterSyncVCDelegate: AnyObject {
    func isHQModified(hqDidChanged: Bool)
}



extension MasterSyncVC: MenuResponseProtocol {
     func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        switch type {

        case .headQuater:
            Shared.instance.isFetchingHQ = true
            guard let selectedObject = selectedObject as? Subordinate else {
                Shared.instance.isFetchingHQ = false
                return
            }

           // self.fetchedHQObject = selectedObject
            let aHQobj = HQModel()
            aHQobj.code = selectedObject.id ?? ""
            aHQobj.mapId = selectedObject.mapId ?? ""
            aHQobj.name = selectedObject.name ?? ""
            aHQobj.reportingToSF = selectedObject.reportingToSF ?? ""
            aHQobj.steps = selectedObject.steps ?? ""
            aHQobj.sfHQ = selectedObject.sfHq ?? ""

            
            
            let territories = DBManager.shared.getTerritory(mapID:  selectedObject.id ?? "")
            LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
            if LocalStorage.shared.getBool(key: .isConnectedToNetwork)  {
                //|| territories.isEmpty
           
                let tosyncMasterData : [MasterInfo]  = [.clusters, .doctorFencing, .chemists, .unlistedDoctors, .stockists]
                // Set loading status based on MasterInfo for each element in the array
                tosyncMasterData.forEach { masterInfo in
                    MasterInfoState.loadingStatusDict[masterInfo] = .isLoading
                }
                self.collectionView.reloadData()
            
                masterVM?.fetchMasterData(type: .clusters, sfCode: selectedObject.id ?? "", istoUpdateDCRlist: true, mapID: selectedObject.id ?? "") { response in
                    Shared.instance.isFetchingHQ = false
                    switch response.result {
                    case .success(_):
                        tosyncMasterData.forEach { masterType in
                            MasterInfoState.loadingStatusDict[masterType] = .loaded
                        }
                        self.fetchedHQObject = selectedObject
                        CoreDataManager.shared.removeHQ()
                        CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                          //  LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
                            self.setHQlbl(isTosetDayplanHQ: false)
                            self.isDayPlanSynced = true
                        }
                  
                    case .failure(_):
                        tosyncMasterData.forEach { masterType in
                            MasterInfoState.loadingStatusDict[masterType] = .error
                        }
                        self.collectionView.reloadData()
                    }
                }
            } else {
                let territories = DBManager.shared.getTerritory(mapID:  selectedObject.id ?? "")
                
                if territories.isEmpty {
                    if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                        toSetupAlert(desc: "Clusters not yet synced connect to internet to sync.", istoNavigate: false)
                        Shared.instance.isFetchingHQ = false
                        return
                    }
                }
                self.fetchedHQObject = selectedObject
                CoreDataManager.shared.removeHQ()
                CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                   // LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
                    self.setHQlbl(isTosetDayplanHQ: false)
                }
            }

           
            
        default:
            print("Yet to implement.")
        }
        
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("")
    }
    func routeToView(_ view : UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}

extension MasterSyncVC {

    
    

    

}


extension CoreDataManager {

    
    //SelectedDayPlanHQ
    func fetchSavedDayPlanHQ(completion: ([SelectedDayPlanHQ]) -> () )  {
        do {
            let savedHQ = try  context.fetch(SelectedDayPlanHQ.fetchRequest())
            completion(savedHQ)
            
        } catch {
            print("unable to fetch movies")
        }
        
    }
    
    func removeDayPlanHQ() {
        let fetchRequest: NSFetchRequest<SelectedDayPlanHQ> = NSFetchRequest(entityName: "SelectedDayPlanHQ")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    func toRetriveSavedDayPlanHQ(completion: @escaping ([HQModel]) -> ()) {
        var retrivedHq : [HQModel] = []
        CoreDataManager.shared.fetchSavedDayPlanHQ(completion: { selectedHQArr in
            selectedHQArr.forEach { selectedHQ in
                let aHQ = HQModel()
                aHQ.code                 = selectedHQ.code ?? ""
                aHQ.name               = selectedHQ.name ?? ""
                aHQ.reportingToSF      = selectedHQ.reportingToSF ?? ""
                aHQ.steps                = selectedHQ.steps ?? ""
                aHQ.sfHQ                = selectedHQ.sfHq ?? ""
                aHQ.mapId               = selectedHQ.mapId ?? ""
                retrivedHq.append(aHQ)
            }
            completion(retrivedHq)
        })
    }
    
    func saveToDayplanHQCoreData(hqModel: HQModel  , completion: (Bool) -> ()) {
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context) {
            let savedCDHq = SelectedDayPlanHQ(entity: entityDescription, insertInto: context)
            
            // Convert properties
            savedCDHq.code                  = hqModel.code
            savedCDHq.name                 = hqModel.name
            savedCDHq.reportingToSF       = hqModel.reportingToSF
            savedCDHq.steps                 = hqModel.steps
            savedCDHq.sfHq                   = hqModel.sfHQ
            savedCDHq.mapId                  = hqModel.mapId
            // Convert and add groupedBrandsSlideModel
            // Save to Core Data
            do {
                try context.save()
                completion(true)
            } catch {
                print("Failed to save to Core Data: \(error)")
                completion(false)
            }
        }
        
    }
    
    
    //SelectedHQ
    func fetchSavedHQ(completion: ([SelectedHQ]) -> () )  {
        do {
            let savedHQ = try  context.fetch(SelectedHQ.fetchRequest())
            completion(savedHQ)
            
        } catch {
            print("unable to fetch movies")
        }
        
    }
    
    
    func toRetriveSavedHQ(completion: @escaping ([HQModel]) -> ()) {
        var retrivedHq : [HQModel] = []
        CoreDataManager.shared.fetchSavedHQ(completion: { selectedHQArr in
            selectedHQArr.forEach { selectedHQ in
                let aHQ = HQModel()
                aHQ.code                 = selectedHQ.code ?? ""
                aHQ.name               = selectedHQ.name ?? ""
                aHQ.reportingToSF      = selectedHQ.reportingToSF ?? ""
                aHQ.steps                = selectedHQ.steps ?? ""
                aHQ.sfHQ                = selectedHQ.sfHq ?? ""
                aHQ.mapId               = selectedHQ.mapId ?? ""
                retrivedHq.append(aHQ)
            }
            completion(retrivedHq)
        })
    }
    
    func removeHQ() {
        let fetchRequest: NSFetchRequest<SelectedHQ> = NSFetchRequest(entityName: "SelectedHQ")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    func removeUnsyncedHomeData() {
        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = NSFetchRequest(entityName: "UnsyncedHomeData")

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    

    
    
    func saveToHQCoreData(hqModel: HQModel  , completion: (Bool) -> ()) {
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context) {
            let savedCDHq = SelectedHQ(entity: entityDescription, insertInto: context)
            
            // Convert properties
            savedCDHq.code                  = hqModel.code
            savedCDHq.name                 = hqModel.name
            savedCDHq.reportingToSF       = hqModel.reportingToSF
            savedCDHq.steps                 = hqModel.steps
            savedCDHq.sfHq                   = hqModel.sfHQ
            savedCDHq.mapId                  = hqModel.mapId
            // Convert and add groupedBrandsSlideModel
            // Save to Core Data
            do {
                try context.save()
                completion(true)
            } catch {
                print("Failed to save to Core Data: \(error)")
                completion(false)
            }
        }
        
    }
    
    
    
    
    func fetchEachDayPlan(completion: ([EachDayPlan]) -> () )  {
        do {
            let savedDayPlan = try  context.fetch(EachDayPlan.fetchRequest())
            completion(savedDayPlan)
            
        } catch {
            print("unable to fetch movies")
        }
        
    }
    
    func fetchEachDayPlan(byDate: Date, completion: ([EachDayPlan]) -> () ) {
        // Date formatter to convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Format: "June 04, 2024"
        
        let formattedDate = dateFormatter.string(from: byDate)
        
        let fetchRequest: NSFetchRequest<EachDayPlan> = EachDayPlan.fetchRequest()
        
        do {
            let savedDayPlans = try context.fetch(fetchRequest)
            
            // Filter the results by comparing formatted dates
            let filteredPlans = savedDayPlans.filter { dayPlan in
                let planDateString = dateFormatter.string(from: dayPlan.planDate ?? Date())
                return planDateString == formattedDate
            }
            
            completion(filteredPlans)
        } catch {
            print("Unable to fetch plans for the date \(formattedDate): \(error)")
            completion([]) // Return an empty array in case of an error
        }
    }
    
    func toCheckDayPlanExistence(_ planDate: Date, completion: (Bool) -> ()) {
        
        // Date formatter to convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Format: "June 04, 2024"
        let formattedDate = dateFormatter.string(from: planDate)
        
        let fetchRequest: NSFetchRequest<EachDayPlan> = EachDayPlan.fetchRequest()
        do {
           
            let savedDayPlans = try context.fetch(fetchRequest)
            // Filter the results by comparing formatted dates
            let filteredPlans = savedDayPlans.filter { dayPlan in
                let planDateString = dateFormatter.string(from: dayPlan.planDate ?? Date())
                return planDateString == formattedDate
            }
            
            if filteredPlans.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    
    func getSubordinate(hqCode: String) -> Subordinate? {
        let hqArr = DBManager.shared.getSubordinate()
        var aSubordinateobj = NSManagedObject()
        hqArr.forEach { aSubordinate in
            if aSubordinate.id == hqCode {
                aSubordinateobj = aSubordinate
            }
                
        }
        return aSubordinateobj as? Subordinate
    }
    
    
    func toUpdateDCR(mapID: String,  completion: @escaping (Bool) -> ()) {
        
        Shared.instance.showLoaderInWindow()
        let masterSyncVM = MasterSyncVM()
        masterSyncVM.fetchMasterData(type: .clusters, sfCode: mapID, istoUpdateDCRlist: false, mapID: mapID) { _  in
            
           // guard let welf = self else {return}
            completion(true)
            Shared.instance.removeLoaderInWindow()
          //  welf.toCreateToast("Clusters synced successfully")
            
        }
    }

    private func convertEachDyPlan(_ eachDayPlan : DayPlan, context: NSManagedObjectContext) -> NSSet {
        
        //let dispatchGroup = DispatchGroup()
        
        var aDaysessions : [Sessions] = []
        
        let cdDayPlans = NSMutableSet()
        
     
        let headQuatersArr =  DBManager.shared.getSubordinate()
        let workTypeArr = DBManager.shared.getWorkType()
        
        
        
        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context),
         let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
        let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }

        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        if eachDayPlan.fwFlg != "" || eachDayPlan.wtCode != "" || eachDayPlan.townCode != "" || eachDayPlan.location != ""  {
            let clusterArr = DBManager.shared.getTerritory(mapID: eachDayPlan.rsf)
            var selectedterritories: [Territory]?
            var selectedheadQuarters : SelectedDayPlanHQ?
            var selectedWorkTypes: WorkType?
            let codes = eachDayPlan.townCode
            let codesArray = codes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            

            
            let filteredTerritories = clusterArr.filter { aTerritory in
                // Check if any code in codesArray is contained in aTerritory
                return codesArray.contains { code in
                    return aTerritory.code?.contains(code) ?? false
                }
            }
            selectedterritories = filteredTerritories
            
            workTypeArr.forEach { aWorkType in
                if aWorkType.code == eachDayPlan.wtCode  {
                    selectedWorkTypes = aWorkType
                }
            }
            
            headQuatersArr.forEach { aheadQuater in
                if aheadQuater.id == eachDayPlan.rsf  {
                    
                 let hqModel =   HQModel()
                    hqModel.code = aheadQuater.id ?? ""
                    hqModel.name = aheadQuater.name ?? ""
                    hqModel.reportingToSF = aheadQuater.reportingToSF ?? ""
                    hqModel.steps = aheadQuater.steps ?? ""
                    hqModel.sfHQ = aheadQuater.sfHq ?? ""
                    hqModel.mapId = aheadQuater.mapId ?? ""
                    

                    
                    guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context)
               
                    else {
                        fatalError("Entity not found")
                    }

                    let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
           
                    temporaryselectedHqobj.code                  = aheadQuater.id
                    temporaryselectedHqobj.name                 = aheadQuater.name
                    temporaryselectedHqobj.reportingToSF       = aheadQuater.reportingToSF
                    temporaryselectedHqobj.steps                 = aheadQuater.steps
                    temporaryselectedHqobj.sfHq                   = aheadQuater.sfHq
                    temporaryselectedHqobj.mapId                  = aheadQuater.mapId
                    selectedheadQuarters = temporaryselectedHqobj
                }
                
            }
            

            
            let tempSession = Sessions(cluster: selectedterritories ?? [temporaryselectedClusterobj], workType: selectedWorkTypes ?? temporaryselectedWTobj, headQuarters: selectedheadQuarters ?? temporaryselectedHqobj, isRetrived: eachDayPlan.isRetrived, isRejected: eachDayPlan.isRejected, isSynced: eachDayPlan.isSynced)
          
            aDaysessions.append(tempSession)
        }
        
        if eachDayPlan.fwFlg2 != "" || eachDayPlan.wtCode2 != "" || eachDayPlan.townCode2 != "" || eachDayPlan.location2 != ""  {
            let clusterArr = DBManager.shared.getTerritory(mapID: eachDayPlan.rsf2)
            var selectedterritories: [Territory]?
            var selectedheadQuarters : SelectedDayPlanHQ?
            var selectedWorkTypes: WorkType?
            let codes = eachDayPlan.townCode2
            let codesArray = codes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            
            let filteredTerritories = clusterArr.filter { aTerritory in
                // Check if any code in codesArray is contained in aTerritory
                return codesArray.contains { code in
                    return aTerritory.code?.contains(code) ?? false
                }
            }
            selectedterritories = filteredTerritories
            
            workTypeArr.forEach { aWorkType in
                if aWorkType.code == eachDayPlan.wtCode2  {
                    selectedWorkTypes = aWorkType
                }
            }
            
            headQuatersArr.forEach { aheadQuater in
                if aheadQuater.id == eachDayPlan.rsf2  {
                    
                 let hqModel =   HQModel()
                    hqModel.code = aheadQuater.id ?? ""
                    hqModel.name = aheadQuater.name ?? ""
                    hqModel.reportingToSF = aheadQuater.reportingToSF ?? ""
                    hqModel.steps = aheadQuater.steps ?? ""
                    hqModel.sfHQ = aheadQuater.sfHq ?? ""
                    hqModel.mapId = aheadQuater.mapId ?? ""
                    

                    guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context)
               
                    else {
                        fatalError("Entity not found")
                    }

                    let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
           
                    temporaryselectedHqobj.code                  = aheadQuater.id
                    temporaryselectedHqobj.name                 = aheadQuater.name
                    temporaryselectedHqobj.reportingToSF       = aheadQuater.reportingToSF
                    temporaryselectedHqobj.steps                 = aheadQuater.steps
                    temporaryselectedHqobj.sfHq                   = aheadQuater.sfHq
                    temporaryselectedHqobj.mapId                  = aheadQuater.mapId
                    selectedheadQuarters = temporaryselectedHqobj
                    
                    
                 
                }
                
            }

            
            let tempSession = Sessions(cluster: selectedterritories ?? [temporaryselectedClusterobj], workType: selectedWorkTypes ?? temporaryselectedWTobj, headQuarters: selectedheadQuarters ?? temporaryselectedHqobj, isRetrived: eachDayPlan.isRetrived2, isRejected: eachDayPlan.isRejected, isSynced: eachDayPlan.isSynced)
          //selectedheadQuarters ?? SelectedHQ()
            aDaysessions.append(tempSession)
        }
        
        
        aDaysessions.enumerated().forEach { index, eachDayPlan in
            if let entityDescription = NSEntityDescription.entity(forEntityName: "EachPlan", in: context) {
                let entitydayPlan = EachPlan(entity: entityDescription, insertInto: context)
                
                entitydayPlan.isRetrived = eachDayPlan.isRetrived ?? false
                
                entitydayPlan.wortTypeCode = eachDayPlan.workType?.code

                entitydayPlan.townCodes = eachDayPlan.cluster?.map { $0.code ?? "" }.joined(separator: ", ")
         
                entitydayPlan.rsfID = eachDayPlan.headQuarters?.code
                // Add to set
                cdDayPlans.add(entitydayPlan)
                
            }
        }
        
        
        
        return cdDayPlans
    }
    
    private func convertHeadQuartersToCDM(_ headQuarters: SelectedDayPlanHQ, context: NSManagedObjectContext) -> SelectedDayPlanHQ {
        
      
            let cdHeadQuarters = SelectedDayPlanHQ(context: context)
            // Convert properties of Subordinate
            cdHeadQuarters.code = headQuarters.code
            cdHeadQuarters.name = headQuarters.name
            cdHeadQuarters.mapId = headQuarters.mapId
            cdHeadQuarters.reportingToSF = headQuarters.reportingToSF
            cdHeadQuarters.sfHq = headQuarters.sfHq
            cdHeadQuarters.steps = headQuarters.steps
          
          
        
        return cdHeadQuarters
    }
    
    public func convertHeadQuartersToSubordinate(_ headQuarters: SelectedDayPlanHQ, context: NSManagedObjectContext) ->  Subordinate{
        
      
            let cdHeadQuarters = Subordinate(context: context)
            // Convert properties of Subordinate
            cdHeadQuarters.id = headQuarters.code
            cdHeadQuarters.name = headQuarters.name
            cdHeadQuarters.mapId = headQuarters.mapId
            cdHeadQuarters.reportingToSF = headQuarters.reportingToSF
            cdHeadQuarters.sfHq = headQuarters.sfHq
            cdHeadQuarters.steps = headQuarters.steps
          
          
        
        return cdHeadQuarters
    }
    
    
    public func convertHeadQuartersToSubordinate(_ headQuarters: SelectedHQ, context: NSManagedObjectContext) ->  Subordinate{
        
      
            let cdHeadQuarters = Subordinate(context: context)
            // Convert properties of Subordinate
            cdHeadQuarters.id = headQuarters.code
            cdHeadQuarters.name = headQuarters.name
            cdHeadQuarters.mapId = headQuarters.mapId
            cdHeadQuarters.reportingToSF = headQuarters.reportingToSF
            cdHeadQuarters.sfHq = headQuarters.sfHq
            cdHeadQuarters.steps = headQuarters.steps
          
          
        
        return cdHeadQuarters
    }
    
    private func convertWorkTypeToCDM(_ workType: WorkType, context: NSManagedObjectContext) -> WorkType {
        let cdWorkType = WorkType(context: context)

        // Convert properties of WorkType
        cdWorkType.code = workType.code
        cdWorkType.eTabs = workType.eTabs
        cdWorkType.fwFlg = workType.fwFlg
        cdWorkType.index = workType.index
        cdWorkType.name = workType.name
        cdWorkType.sfCode = workType.sfCode
        cdWorkType.terrslFlg = workType.terrslFlg
        cdWorkType.tpDCR = workType.tpDCR
        // Convert other properties...

        return cdWorkType
    }

    public func convertClustersToCDM(_ clusters: [Territory], context: NSManagedObjectContext) -> NSSet {
        let cdTerritortModels = NSMutableSet()
        
        for cluster in clusters {
            if let entityDescription = NSEntityDescription.entity(forEntityName: "Territory", in: context) {
                let cdTerritoryModel = Territory(entity: entityDescription, insertInto: context)
                
                // Convert properties of SlidesModel
                cdTerritoryModel.code = cluster.code
                cdTerritoryModel.index = cluster.index
                cdTerritoryModel.lat = cluster.lat
                cdTerritoryModel.long = cluster.long
                cdTerritoryModel.mapId = cluster.mapId
                cdTerritoryModel.name = cluster.name
                cdTerritoryModel.sfCode = cluster.sfCode
                // Convert other properties...
                
                // Add to set
                cdTerritortModels.add(cdTerritoryModel)
                
            }
        }
        
        return cdTerritortModels
    }
    
    
    
    func toSaveDayPlan(isSynced: Bool, aDayPlan: DayPlan, date: Date, completion: @escaping (Bool) -> ()) {
        toCheckDayPlanExistence(date) { isExists in
            if !isExists {
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "EachDayPlan", in: context) {
                    let entityDayPlan = EachDayPlan(entity: entityDescription, insertInto: context)
                    
                    // Convert properties
                    entityDayPlan.uuid = aDayPlan.uuid
                    entityDayPlan.planDate = aDayPlan.tpDt.toDate()
                    entityDayPlan.isRejected = aDayPlan.isRejected
                    entityDayPlan.isSynced = isSynced
                    entityDayPlan.eachPlan = convertEachDyPlan(aDayPlan , context: context)
                    
                    // Save to Core Data
                    do {
                        try context.save()
                        completion(true)
                    } catch {
                        print("Failed to save to Core Data: \(error)")
                        completion(false)
                    }
                }
            } else {
                updateExistingManagedObjects(isSynced: isSynced, with: aDayPlan, for: date) {
                    isUpdated in
                    completion(isUpdated)
                }

            }
        }
    }
    
    
    func updateExistingManagedObjects(isSynced: Bool, with aDayPlan: DayPlan, for date: Date, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<EachDayPlan> = EachDayPlan.fetchRequest()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Format: "June 04, 2024"

        let formattedDate = dateFormatter.string(from: date)
        
        do {
            let savedDayPlans = try self.context.fetch(fetchRequest)
            let filteredPlans = filterPlans(savedDayPlans, by: formattedDate, using: dateFormatter)
            
            // Delete existing plans
            deleteFilteredPlans(filteredPlans)
            
            // Add new plan
            aDayPlan.isSynced = isSynced
            addNewPlan(aDayPlan, for: date)
            
            // Save the changes
            try self.context.save()
            completion(true) // Assuming completion handler for success
        } catch {
            print("Failed to fetch or update Core Data: \(error)")
            completion(false)
        }
    }

    private func filterPlans(_ savedDayPlans: [EachDayPlan], by formattedDate: String, using dateFormatter: DateFormatter) -> [EachDayPlan] {
        return savedDayPlans.filter { dayPlan in
            let planDateString = dateFormatter.string(from: dayPlan.planDate ?? Date())
            return planDateString == formattedDate
        }
    }

    private func deleteFilteredPlans(_ filteredPlans: [EachDayPlan]) {
        for plan in filteredPlans {
            self.context.delete(plan)
        }
    }

    private func addNewPlan(_ aDayPlan: DayPlan, for date: Date) {
        let newPlan = EachDayPlan(context: self.context)
        newPlan.uuid = aDayPlan.uuid
        newPlan.planDate = aDayPlan.tpDt.toDate()
        newPlan.isRejected = aDayPlan.isRejected
        newPlan.isSynced = aDayPlan.isSynced
        newPlan.eachPlan = convertEachDyPlan(aDayPlan, context: context)
    }
    
    func retriveSavedDayPlans(byDate: Date, completion: @escaping ([DayPlan] ) -> ()) {
        let userConfig = AppDefaults.shared.getAppSetUp()
        var retrivedPlansArr = [DayPlan]()
      //  let dispatchGroup = DispatchGroup()
        CoreDataManager.shared.fetchEachDayPlan(byDate: byDate) { eachDayPlanArr in
            eachDayPlanArr.forEach { eachDayPlan in
                let aDayPlan = DayPlan()
                //  aDayPlan.uuid = eachDayPlan.uuid ?? UUID()
                aDayPlan.tpDt = eachDayPlan.planDate?.toString(format: "yyyy-MM-dd HH:mm:ss") ?? ""
                aDayPlan.tableName = "dayplan"
                aDayPlan.sfcode = userConfig.sfCode ?? ""
                aDayPlan.divisionCode = userConfig.divisionCode ?? ""
               // aDayPlan.rsf =
                //userConfig.sfCode
                aDayPlan.sfType = "\(userConfig.sfType!)"
                aDayPlan.designation = userConfig.desig ?? ""
                aDayPlan.stateCode =  "\(userConfig.stateCode!)"
                aDayPlan.subdivisionCode = userConfig.subDivisionCode ?? ""
              
                aDayPlan.remarks = eachDayPlan.remarks ?? ""
                aDayPlan.isRejected = eachDayPlan.isRejected
                aDayPlan.rejectionReason = eachDayPlan.rejectionReason ?? String()
                
                aDayPlan.insMode = "0"
                aDayPlan.appver = ""
                aDayPlan.mod = ""
                
                aDayPlan.tpVwFlg = ""
                aDayPlan.tpCluster = ""
                aDayPlan.tpWorkType = ""
                aDayPlan.isSynced = eachDayPlan.isSynced
           
                if let  eachDayPlansSet = eachDayPlan.eachPlan as? Set<EachPlan>  {
                    let eachDayPlansArray = Array(eachDayPlansSet)
                    eachDayPlansArray.enumerated().forEach { index, eachPlan in
                      //  dispatchGroup.enter()
                        // let agroupedSlide = SlidesModel()
                        switch index {
                        case 0 :
                            aDayPlan.isRetrived = eachPlan.isRetrived
                            aDayPlan.rsf = eachPlan.rsfID ?? ""
                            aDayPlan.wtCode = eachPlan.wortTypeCode ?? ""
                            let workType = DBManager.shared.getWorkType()
                            let filetedworkType = workType.filter{$0.code ==  aDayPlan.wtCode}
                            aDayPlan.wtName = filetedworkType.first?.name ?? ""
                            aDayPlan.fwFlg = filetedworkType.first?.fwFlg ?? ""
                            aDayPlan.location = ""
                         
                            aDayPlan.townCode = eachPlan.townCodes ?? ""
                            let territories =  DBManager.shared.getTerritory(mapID: eachPlan.rsfID ?? "")
                            let territoryCodes =   aDayPlan.townCode.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                            
                          
                            
                            if territories.isEmpty {

                            } else {
                                // Filter territories based on codes
                                let filteredTerritories = territories.filter { territory in
                                    return territoryCodes.contains(territory.code ?? "")
                                }
                                // Extract names as a comma-separated string
                                aDayPlan.townName = filteredTerritories.map { $0.name ?? "" }.joined(separator: ", ")
                   
                            }
                            
                            retrivedPlansArr.append(aDayPlan)
                            
                        case 1:
                            aDayPlan.isRetrived2 = eachPlan.isRetrived
                            aDayPlan.rsf2 = eachPlan.rsfID ?? ""
                            aDayPlan.wtCode2 = eachPlan.wortTypeCode ?? ""
                            let workType = DBManager.shared.getWorkType()
                            let filetedworkType = workType.filter{$0.code ==  aDayPlan.wtCode2}
                            aDayPlan.wtName2 = filetedworkType.first?.name ?? ""
                            aDayPlan.fwFlg2 = filetedworkType.first?.fwFlg ?? ""
                            aDayPlan.location2 = ""
                            aDayPlan.townCode2 = eachPlan.townCodes ?? ""
                            let territories =  DBManager.shared.getTerritory(mapID: eachPlan.rsfID ?? "")
                            let territoryCodes =   aDayPlan.townCode.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                            
                            if territories.isEmpty {
                            } else {
                                // Filter territories based on codes
                                let filteredTerritories = territories.filter { territory in
                                    return territoryCodes.contains(territory.code ?? "")
                                }
                                // Extract names as a comma-separated string
                                aDayPlan.townName2 = filteredTerritories.map { $0.name ?? "" }.joined(separator: ", ")
                              //  dispatchGroup.leave()
                            }
                            
                            
                            retrivedPlansArr.append(aDayPlan)

     
                            
                        default:
                            print("Yet to implement")
                        }
                        
                    }
                }
                
         
            }
            completion(retrivedPlansArr)
        }
        

         

        
       
    }
    
    
    
    func removeAdayPlans(planDate: Date) {
        
        // Date formatter to convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Format: "June 04, 2024"
        
        let formattedDate = dateFormatter.string(from: planDate)
        
        let fetchRequest: NSFetchRequest<EachDayPlan> = EachDayPlan.fetchRequest()

        do {
            var savedDayPlans = try context.fetch(fetchRequest)
            // Filter the results by comparing formatted dates
   
            let filteredPlans = savedDayPlans.filter { $0.planDate?.toString(format: "MMMM dd, yyyy") != formattedDate }
            // Remove filtered plans using NSBatchDeleteRequest for performance
            savedDayPlans = filteredPlans
            // Remove filtered plans from Core Data context
              for plan in filteredPlans {
                  context.delete(plan)
              }
            
            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
    func removeUnsyncedDayPlans() {
        let fetchRequest: NSFetchRequest<EachDayPlan> = NSFetchRequest(entityName: "EachDayPlan")

        do {
            let eachDayPlans = try context.fetch(fetchRequest)
            for eachDayPlan in eachDayPlans {
                if let unsyncedPlan = eachDayPlan.eachPlan as? Set<EachPlan> {
                    let plansToDelete = unsyncedPlan.filter { !$0.isRetrived }
                    for plan in plansToDelete {
                        context.delete(plan)
                    }
                }
                context.delete(eachDayPlan)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    func removeAllDayPlans() {
        let fetchRequest: NSFetchRequest<EachDayPlan> = NSFetchRequest(entityName: "EachDayPlan")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
//    func removeAllDayPlans() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = EachDayPlan.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//            // completion()
//        } catch {
//            print("Error deleting slide brands: \(error)")
//            //  completion()
//        }
//    }
    func saveSessionAsEachDayPlan(isSynced: Bool, planDate: Date, session: [Sessions], completion: @escaping (Bool) -> ()) {
        let context = self.context

        // Define the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yy-dd"

        // Format the planDate to the desired format
        let formattedPlanDate = dateFormatter.string(from: planDate)

        // Define the fetch request to get all EachDayPlans
        let fetchRequest: NSFetchRequest<EachDayPlan> = EachDayPlan.fetchRequest()

        do {
            // Fetch all existing EachDayPlans
            let existingPlans = try context.fetch(fetchRequest)
            
            // Filter the fetched plans to find matches based on the formatted date
            let matchedPlans = existingPlans.filter { eachDayPlan in
                if let planDate = eachDayPlan.planDate {
                    let formattedExistingDate = dateFormatter.string(from: planDate)
                    return formattedExistingDate == formattedPlanDate
                }
                return false
            }

            
                    guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context),
                     let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
                    let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
                    else {
                        fatalError("Entity not found")
                    }
            
                    let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                    let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
                    let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
            
            
            // Update all matched plans
            for eachDayPlan in matchedPlans {
                updateEachDayPlan(isSynced, eachDayPlan, planDate, with: session, temporaryObjects: (temporaryselectedHqobj, temporaryselectedWTobj, temporaryselectedClusterobj), context: context)
            }

            // If no matched plans found, create a new one
            if matchedPlans.isEmpty {
                guard let eachDayPlanEntity = NSEntityDescription.entity(forEntityName: "EachDayPlan", in: context) else {
                    fatalError("EachDayPlan entity not found")
                }
                let newEachDayPlan = EachDayPlan(entity: eachDayPlanEntity, insertInto: context)
                updateEachDayPlan(isSynced, newEachDayPlan, planDate, with: session, temporaryObjects: (temporaryselectedHqobj, temporaryselectedWTobj, temporaryselectedClusterobj), context: context)
            }

            // Save to Core Data
            try context.save()
            completion(true)
        } catch {
            print("Failed to fetch or save EachDayPlan to Core Data: \(error)")
            completion(false)
        }
    }
    private func updateEachDayPlan(_ isSynced: Bool, _ eachDayPlan: EachDayPlan, _ planDate: Date, with session: [Sessions], temporaryObjects: (NSManagedObject, NSManagedObject, NSManagedObject), context: NSManagedObjectContext) {
        let (temporaryselectedHqobj, temporaryselectedWTobj, temporaryselectedClusterobj) = temporaryObjects
        
        eachDayPlan.planDate = planDate // or keep the existing date if needed
        eachDayPlan.uuid = UUID()
        eachDayPlan.remarks = session.first?.remarks ?? ""
        eachDayPlan.isRejected = session.first?.isRejected ?? false
        eachDayPlan.rejectionReason = session.first?.rejectionReason
        eachDayPlan.isSynced = isSynced
        let eachPlanSet = NSMutableSet()

        session.enumerated().forEach { index, aSession in
            guard let planEntity = NSEntityDescription.entity(forEntityName: "EachPlan", in: context) else {
                fatalError("EachPlan entity not found")
            }

            let eachPlan = EachPlan(entity: planEntity, insertInto: context)
            eachPlan.planDate = aSession.planDate ?? Date()
            eachPlan.isRetrived = aSession.isRetrived ?? false

            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                eachPlan.rsfID = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
            } else {
                eachPlan.rsfID = convertHeadQuartersToCDM(aSession.headQuarters ?? temporaryselectedHqobj as! SelectedDayPlanHQ, context: context).code
            }

            eachPlan.wortTypeCode = convertWorkTypeToCDM(aSession.workType ?? temporaryselectedWTobj as! WorkType, context: context).code
            let selectedTerritories = convertClustersToCDM(aSession.cluster ?? [temporaryselectedClusterobj as! Territory], context: context)
            
            if let territoryArray = selectedTerritories.allObjects as? [Territory] {
                let territoryCodes = territoryArray.map { $0.code ?? "" }.joined(separator: ", ")
                eachPlan.townCodes = territoryCodes
            } else {
                print("Failed to convert NSSet to [Territory]")
            }

            eachPlanSet.add(eachPlan)
        }

        eachDayPlan.eachPlan = eachPlanSet
    }
    
//    func saveSessionAsEachDayPlan(planDate: Date, session: [Sessions], completion: @escaping (Bool) -> ()) {
//      
//        let context = self.context
//
//        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context),
//         let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
//        let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
//        else {
//            fatalError("Entity not found")
//        }
//
//        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
//        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
//        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
//
//        guard let eachDayPlanEntity = NSEntityDescription.entity(forEntityName: "EachDayPlan", in: context) else {
//            fatalError("Entity not found")
//        }
//
//        let eachDayPlan = EachDayPlan(entity: eachDayPlanEntity, insertInto: context)
//        eachDayPlan.planDate = Date() // Set the planDate as needed
//
//        // Set other properties based on the session
//        eachDayPlan.uuid = UUID()
//        eachDayPlan.remarks = session[0].remarks ?? ""
//        eachDayPlan.isRejected = session[0].isRejected ?? false
//        eachDayPlan.rejectionReason = session[0].rejectionReason
//        eachDayPlan.planDate =  planDate
//        //session[0].planDate ?? Date()
//        // Convert and add EachPlan objects
//        
//        
//        
//  
//        
//        
//        let eachPlanSet = NSMutableSet()
//        // Add EachPlan for the first index
//      //  let firstEachPlan = EachPlan(context: context)
//        
//        guard let firstPlanEntity = NSEntityDescription.entity(forEntityName: "EachPlan", in: context) else {
//            fatalError("Entity not found")
//        }
//        let firstEachPlan = EachPlan(entity: firstPlanEntity, insertInto: context)
//
//        
//        
//        guard let secondPlanEntity = NSEntityDescription.entity(forEntityName: "EachPlan", in: context) else {
//            fatalError("Entity not found")
//        }
//        let secondEachPlan = EachPlan(entity: secondPlanEntity, insertInto: context)
//
// 
//      //  CoreDataManager.shared.removeSessionTerrioriesFromCoreData()
//        session.enumerated().forEach { index, aSession in
//            
//            switch index {
//            case 0:
//                firstEachPlan.planDate = session[index].planDate ?? Date()
//                firstEachPlan.isRetrived = session[index].isRetrived ?? false
//                // Set properties based on session or adjust as needed
//                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
//                    firstEachPlan.rsfID =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
//                } else {
//                    firstEachPlan.rsfID =  convertHeadQuartersToCDM(session[index].headQuarters ?? temporaryselectedHqobj, context: self.context).code
//                }
//           
//                firstEachPlan.wortTypeCode = convertWorkTypeToCDM(session[index].workType ?? temporaryselectedWTobj, context: self.context).code
//                let SelectedTerritories = convertClustersToCDM(session[index].cluster ?? [temporaryselectedClusterobj], context: self.context)
//                
//                if let territoryArray = SelectedTerritories.allObjects as? [Territory] {
//                    // Now territoryArray contains your Territory core data objects
//                    // Use this array as needed
//                    let territoryCodes = territoryArray.map { $0.code ?? "" }.joined(separator: ", ")
//                    firstEachPlan.townCodes = territoryCodes
//                } else {
//                    print("Failed to convert NSSet to [Territory]")
//                }
//                
//                eachPlanSet.add(firstEachPlan)
//               
//            case 1:
//                secondEachPlan.planDate =  session[index].planDate ?? Date()
//                secondEachPlan.isRetrived = session[index].isRetrived ?? false
//                // Set properties based on session or adjust as needed
//                secondEachPlan.isRetrived = session[index].isRetrived ?? false
//                // Set properties based on session or adjust as needed
//                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
//                    secondEachPlan.rsfID =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
//                } else {
//                    secondEachPlan.rsfID =  convertHeadQuartersToCDM(session[index].headQuarters ?? temporaryselectedHqobj, context: self.context).code
//                }
//                secondEachPlan.wortTypeCode = convertWorkTypeToCDM(session[index].workType ?? temporaryselectedWTobj, context: self.context).code
//                let SelectedTerritories = convertClustersToCDM(session[index].cluster ?? [temporaryselectedClusterobj], context: self.context)
//                
//                if let territoryArray = SelectedTerritories.allObjects as? [Territory] {
//                    // Now territoryArray contains your Territory core data objects
//                    // Use this array as needed
//                    let territoryCodes = territoryArray.map { $0.code ?? "" }.joined(separator: ", ")
//                    secondEachPlan.townCodes = territoryCodes
//                } else {
//                    print("Failed to convert NSSet to [Territory]")
//                }
//         
//                eachPlanSet.add(secondEachPlan)
//                
//
//            default:
//                print("Yet to implement")
//            }
//        }
//        
//
//            eachDayPlan.eachPlan = eachPlanSet
//        
//
//        // Save to Core Data
//        do {
//            try context.save()
//            completion(true)
//        } catch {
//            print("Failed to save EachDayPlan to Core Data: \(error)")
//            completion(false)
//        }
//
//    }
}
    

