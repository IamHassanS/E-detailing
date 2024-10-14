//
//  DBManager.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 19/12/23.
//

import Foundation
import CoreData
import UIKit


enum EntityName: String {
    case masterData = "MasterData"
    case workType // This can be used if needed for different cases

    func returnDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.rawValue, in: context)
    }
    
}

class DBManager {
    
    static let shared = DBManager()
    let queue = DispatchQueue(label: "com.home.dispatchQueue", qos: .userInteractive)
    let dataBaseLock = NSLock()
    var existingDates = [String]()
    var  weeklyOff : [Weeklyoff]?
    var  holidays : [Holidays]?
    
    // MARK: - Core Data Saving support

    func saveContext() {
        let context = self.managedContext() // Get the current managed context
        
        if context.hasChanges {
            do {
                try context.save() // Attempt to save the context if there are changes
                print("Context saved successfully.")
            } catch let error as NSError {
                // Handle and log the error
                print("Failed to save context: \(error), \(error.userInfo)")
            }
        } else {
            print("No changes to save.")
        }
    }
    
    func managedContext() -> NSManagedObjectContext {
        // Ensure this is called on the main thread
        if Thread.isMainThread {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // You can log or handle the case where it's called from a background thread
            print("Warning: managedContext() should be called from the main thread.")
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    func saveSubordinate( Values : [[String :Any]] ,id : String,  completion: @escaping () -> ()) {
        self.saveSubordinateData(values: Values, id: id) {
            completion()
        }
    }
    
    func saveMasterData(type : MasterInfo, Values : [[String :Any]],id : String) {
        queue.async(flags: .barrier) {
           // self.dataBaseLock.lock()
            switch type {
            
            case .worktype:
                self.saveWorkTypeData(values: Values)
            case .headquartes:
                break
    //        case .competitors:
    //            self.saveCompetitorData(values: Values)
            case .inputs:
                self.saveInputData(values: Values, id: id)
            case .slideBrand:
                self.saveSlideBrandData(values: Values)
            case .slideTheraptic:
                self.saveSlideTherapticData(values: Values)
            case .products:
                self.saveProductData(values: Values, id: id)
            case .slides:
                self.saveSlidesData(values: Values)
            case .brands:
                self.saveBrandData(values: Values)
    //        case .departments:
    //            self.saveDepartsData(values: Values)
            case .speciality:
                self.saveSpecialityData(values: Values)
            case .category:
                self.saveCategoryData(values: Values)
            case .chemistCategory:
                self.saveChemistCategoryData(values: Values)
            case .qualifications:
                self.saveQualificationData(values: Values)
            case .doctorClass:
                self.saveDoctorClassData(values: Values)
            case .docTypes:
                break
            case .ratingDetails:
                break
            case .ratingFeedbacks:
                break
            case .speakerList:
                break
            case .participantList:
                break
            case .indicationList:
                break
            case .setups:
                break
            case .clusters:
                self.saveTerritoryData(values: Values, id: id)
            case .doctors:
                self.saveDoctorFencingData(values: Values, id: id)
            case .chemists:
                self.saveChemistData(values: Values, id: id)
            case .stockists:
                self.saveStockistData(values: Values, id: id)
            case .unlistedDoctors:
                self.saveUnListedDoctorData(values: Values, id: id)
            case .institutions:
                break
            case .jointWork:
                self.saveJointWorkData(values: Values, id: id)
            case .subordinate:
                self.saveSubordinateData(values: Values, id: id){}
    //        case .subordinateMGR:
    //            self.saveSubordainateMgrData(values: Values, id: id)
            case .doctorFencing:
                self.saveDoctorFencingData(values: Values, id: id)
            case .myDayPlan:
                self.saveMyDayPlanData(values: Values)
            case .syncAll:
                break
            case .slideSpeciality:
                self.saveSlideSpecialityData(values: Values)
            case .docFeedback:
                self.saveFeedbackData(values: Values)
    //        case .customSetup:
    //            break
            case .leaveType:
                self.saveLeaveTypeData(values: Values)
            case .tourPlanStatus:
                break
            case .visitControl:
                self.saveVisitControlData(values: Values)
    //        case .stockBalance:
    //            self.saveStockBalance(values: Values)
            case .mappedCompetitors:
                self.saveMapCompDetData(values: Values)
            case .empty:
                break
            case .tourPlanSetup:
                self.saveTPSetup(values: Values)
            case .weeklyOff:
                self.saveWeeklyoff(values: Values)
            case .holidays:
                self.saveHolidays(values: Values)
            case .homeSetup:
                self.saveHomeData(values: Values)
           
            default:
                return
            }
          //  self.dataBaseLock.unlock()
        }

    }
    
    
    func getMasterData() -> MasterData {
        var masterArray:[MasterData] = []
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MasterData")
        
        do {
            masterArray = try self.managedContext().fetch(fetch) as! [MasterData]
        }
        catch {
            print("error",error.localizedDescription)
        }
        guard let master = masterArray.first else{
            let mContext = self.managedContext()
            let masterEntity = NSEntityDescription.entity(forEntityName: "MasterData", in: mContext)
            let masterData = MasterData(entity: masterEntity!, insertInto: mContext)
            return masterData
        }
        return master
    }
    
    func deleteAllRecords() {
        let context = self.managedContext()
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MasterData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
        do {
            try context.execute(deleteRequest)
            try context.save()
        }catch {
            
        }
    }
    
    
    func saveSlidesData(values: [[String: Any]]) {
        
        deleteEntityInfo("ProductSlides") { isReomoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                // Create an array to hold the new ProductSlides objects
                var slideArray = [ProductSlides]()
                
                // Iterate through the input values to create ProductSlides entities
                for (index, slide) in values.enumerated() {
                    if let slideEntity = NSEntityDescription.entity(forEntityName: "ProductSlides", in: context) {
                        let slideItem = ProductSlides(entity: slideEntity, insertInto: context)
                        slideItem.setValues(fromDictionary: slide, context: context)
                        slideItem.index = Int16(index)
                        slideArray.append(slideItem)
                    }
                }
                
                // Remove existing ProductSlides objects from masterData
                if let existingSlides = masterData.slides?.allObjects as? [ProductSlides] {
                    existingSlides.forEach { masterData.removeFromSlides($0) }
                }
                
                // Add the new ProductSlides objects to masterData
                slideArray.forEach { masterData.addToSlides($0) }
                
                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    

    
    func saveSlideBrandData(values: [[String: Any]]) {
        // Get the managed context and master data
        deleteEntityInfo("SlideBrand") { isRemoved in
            
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                // Create an array to hold the new SlideBrand objects
                var slideBrandArray = [SlideBrand]()
                
                // Iterate through the input values to create SlideBrand entities
                for (index, brand) in values.enumerated() {
                    if let slideBrandEntity = NSEntityDescription.entity(forEntityName: "SlideBrand", in: context) {
                        let slideBrandItem = SlideBrand(entity: slideBrandEntity, insertInto: context)
                        slideBrandItem.setValues(fromDictionary: brand, context: context)
                        slideBrandItem.index = Int16(index)
                        slideBrandArray.append(slideBrandItem)
                    }
                }

                // Remove existing SlideBrand objects from masterData
                if let existingBrands = masterData.slideBrand?.allObjects as? [SlideBrand] {
                    existingBrands.forEach { masterData.removeFromSlideBrand($0) }
                }

                // Add the new SlideBrand objects to masterData
                slideBrandArray.forEach { masterData.addToSlideBrand($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }

    }

    
    func saveSlideTherapticData(values: [[String: Any]]) {
        
        
        deleteEntityInfo("SlideTheraptic") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data
            
            context.perform {
                // Create an array to hold the new SlideTheraptic objects
                var slideTherapticArray = [SlideTheraptic]()
                
                // Iterate through the input values to create SlideTheraptic entities
                for (index, theraptic) in values.enumerated() {
                    if let slideTherapticEntity = NSEntityDescription.entity(forEntityName: "SlideTheraptic", in: context) {
                        let slideTherapticItem = SlideTheraptic(entity: slideTherapticEntity, insertInto: context)
                        slideTherapticItem.setValues(fromDictionary: theraptic, context: context)
                        slideTherapticItem.index = Int16(index)
                        slideTherapticArray.append(slideTherapticItem)
                    }
                }

                // Remove existing SlideTheraptic objects from masterData
                if let existingTherapics = masterData.theraptic?.allObjects as? [SlideTheraptic] {
                    existingTherapics.forEach { masterData.removeFromTheraptic($0) }
                }

                // Add the new SlideTheraptic objects to masterData
                slideTherapticArray.forEach { masterData.addToTheraptic($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }

    }

    
    
    

    
    func saveSlideSpecialityData(values: [[String: Any]]) {
        deleteEntityInfo("SlideSpeciality") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data
            
            context.perform {
                // Create an array to hold the new SlideSpeciality objects
                var slideSpecialityArray = [SlideSpeciality]()
                
                // Iterate through the input values to create SlideSpeciality entities
                for (index, speciality) in values.enumerated() {
                    if let slideSpecialityEntity = NSEntityDescription.entity(forEntityName: "SlideSpeciality", in: context) {
                        let slideSpecialityItem = SlideSpeciality(entity: slideSpecialityEntity, insertInto: context)
                        slideSpecialityItem.setValues(fromDictionary: speciality, context: context)
                        slideSpecialityItem.index = Int16(index)
                        slideSpecialityArray.append(slideSpecialityItem)
                    }
                }

                // Remove existing SlideSpeciality objects from masterData
                if let existingSlideSpecialities = masterData.slideSpeciality?.allObjects as? [SlideSpeciality] {
                    existingSlideSpecialities.forEach { masterData.removeFromSlideSpeciality($0) }
                }

                // Add the new SlideSpeciality objects to masterData
                slideSpecialityArray.forEach { masterData.addToSlideSpeciality($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    
    
    func deleteDoctorData(id: String, completion: @escaping () -> Void) {
        let masterData = self.getMasterData()
        let dispatchGroup = DispatchGroup()

        if let prevList = masterData.doctorFencing?.allObjects as? [DoctorFencing] {
            // Filter the doctors to be deleted based on the provided id
            let doctorsToDelete = prevList.filter { $0.mapId == id }
            
            doctorsToDelete.forEach { doctor in
                // Enter the dispatch group for each deletion
                dispatchGroup.enter()
                
                // Perform deletion
                self.managedContext().delete(doctor)
                
                // Leave the dispatch group after deletion
                dispatchGroup.leave()
            }
        }

        // Notify once all deletions are completed
        dispatchGroup.notify(queue: .main) {
            // Save context after all deletions are complete
            self.saveContext()

            // Call completion after saving context
            completion()
        }
    }

    

    
    func deleteChemistData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        self.managedContext().perform {
            let masterData = self.getMasterData()
            
            if let prevList = masterData.chemist?.allObjects as? [Chemist] {
                // Filter the chemists to be deleted based on the provided id
                let chemistsToDelete = prevList.filter { $0.mapId == id }
                
                chemistsToDelete.forEach { chemist in
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()
                    
                    // Perform deletion
                    self.managedContext().delete(chemist)
                    
                    // Leave the dispatch group after deletion
                    dispatchGroup.leave()
                }
            }

            // Notify once all deletions are completed
            dispatchGroup.notify(queue: .main) {
                // Save context after all deletions are complete
                self.saveContext()

                // Call completion after saving context
                completion()
            }
        }
    }
    
    
    func deleteStockistData(id: String, completion: @escaping () -> Void) {
        let masterData = self.getMasterData()
        let dispatchGroup = DispatchGroup()

        if let prevList = masterData.stockist?.allObjects as? [Stockist] {
            let data = prevList.filter { $0.mapId == id }

            data.forEach { stockist in
                // Enter the dispatch group for each deletion
                dispatchGroup.enter()
                
                // Perform deletion
                self.managedContext().delete(stockist)
                
                // Leave the dispatch group after deletion
                dispatchGroup.leave()
            }
        }

        // Notify when all deletions are done
        dispatchGroup.notify(queue: .main) {
            // Save context after all deletions are complete
            self.saveContext()

            // Call completion after context save
            completion()
        }
    }
    
    
    func deleteUnListedDoctorData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        // Use perform to ensure that operations are on the managed context's queue
        self.managedContext().perform {
            let masterData = self.getMasterData()
            
            if let prevList = masterData.unListedDoc?.allObjects as? [UnListedDoctor] {
                // Filter the unlisted doctors to be deleted based on the provided id
                let doctorsToDelete = prevList.filter { $0.mapId == id }
                
                doctorsToDelete.forEach { doctor in
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()
                    
                    // Perform deletion
                    self.managedContext().delete(doctor)
                    
                    // Leave the dispatch group after deletion
                    dispatchGroup.leave()
                }
            }

            // Notify once all deletions are completed
            dispatchGroup.notify(queue: .main) {
                // Save context after all deletions are complete
                self.saveContext()

                // Call completion after saving context
                completion()
            }
        }
    }

    
    

    
    

    
    
    func saveWorkTypeData(values: [[String: Any]]) {
        // Get the managed context and master data
        deleteEntityInfo("WorkType") { isRemoved in
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                // Create an array to hold the new WorkType objects
                var workTypeArray = [WorkType]()
                
                // Iterate through the input values to create WorkType entities
                for (index, workType) in values.enumerated() {
                    if let workTypeEntity = NSEntityDescription.entity(forEntityName: "WorkType", in: context) {
                        let workTypeItem = WorkType(entity: workTypeEntity, insertInto: context)
                        workTypeItem.setValues(fromDictionary: workType)
                        workTypeItem.index = Int16(index)
                        workTypeArray.append(workTypeItem)
                    }
                }

                // Remove existing WorkType objects from masterData
                if let existingWorkTypes = masterData.workType?.allObjects as? [WorkType] {
                    existingWorkTypes.forEach { masterData.removeFromWorkType($0) }
                }

                // Add the new WorkType objects to masterData
                workTypeArray.forEach { masterData.addToWorkType($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }

    }

    
    
    func saveTPSetup(values: [[String: Any]]) {
        deleteEntityInfo("TableSetup") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var tableSetupArray = [TableSetup]()

                // Iterate through the input values to create TableSetup entities
                for (index, workType) in values.enumerated() {
                    if let workTypeEntity = NSEntityDescription.entity(forEntityName: "TableSetup", in: context) {
                        let tableSetupItem = TableSetup(entity: workTypeEntity, insertInto: context)
                        tableSetupItem.setValues(fromDictionary: workType)
                        tableSetupItem.index = Int16(index)
                        tableSetupArray.append(tableSetupItem)
                    }
                }

                // Remove existing TableSetup objects from masterData
                if let existingTableSetup = masterData.tableSetup?.allObjects as? [TableSetup] {
                    existingTableSetup.forEach { masterData.removeFromTableSetup($0) }
                }

                // Add the new TableSetup objects to masterData
                tableSetupArray.forEach { masterData.addToTableSetup($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    
    
    func saveWeeklyoff(values: [[String: Any]]) {
        deleteEntityInfo("Weeklyoff") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var weeklyoffArray = [Weeklyoff]()

                // Iterate through the input values to create Weeklyoff entities
                for (index, workType) in values.enumerated() {
                    if let workTypeEntity = NSEntityDescription.entity(forEntityName: "Weeklyoff", in: context) {
                        let weeklyoffItem = Weeklyoff(entity: workTypeEntity, insertInto: context)
                        weeklyoffItem.setValues(fromDictionary: workType)
                        weeklyoffItem.index = Int16(index)
                        weeklyoffArray.append(weeklyoffItem)
                    }
                }

                // Remove existing Weeklyoff objects from masterData
                if let existingWeeklyoff = masterData.weeklyoff?.allObjects as? [Weeklyoff] {
                    existingWeeklyoff.forEach { masterData.removeFromWeeklyoff($0) }
                }

                // Add the new Weeklyoff objects to masterData
                weeklyoffArray.forEach { masterData.addToWeeklyoff($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    
    
    func saveHolidays(values: [[String: Any]]) {
        deleteEntityInfo("Holidays") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var holidaysArray = [Holidays]()

                // Iterate through the input values to create Holidays entities
                for (index, holiday) in values.enumerated() {
                    if let holidayEntity = NSEntityDescription.entity(forEntityName: "Holidays", in: context) {
                        let holidayItem = Holidays(entity: holidayEntity, insertInto: context)
                        holidayItem.setValues(fromDictionary: holiday)
                        holidayItem.index = Int16(index)
                        holidaysArray.append(holidayItem)
                    }
                }

                // Remove existing Holidays objects from masterData
                if let existingHolidays = masterData.holidays?.allObjects as? [Holidays] {
                    existingHolidays.forEach { masterData.removeFromHolidays($0) }
                }

                // Add the new Holidays objects to masterData
                holidaysArray.forEach { masterData.addToHolidays($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    
    func saveHomeData(values: [[String: Any]]) {
        deleteEntityInfo("HomeData") { isRemoved in
            // Get the managed context and master data
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var homeDataSetupArray = [HomeData]()

                // Iterate through the input values to create HomeData entities
                for (index, homeData) in values.enumerated() {
                    if let homeDataEntity = NSEntityDescription.entity(forEntityName: "HomeData", in: context) {
                        let homeDataSetupItem = HomeData(entity: homeDataEntity, insertInto: context)
                        homeDataSetupItem.setValues(fromDictionary: homeData)
                        homeDataSetupItem.index = Int16(index)
                        homeDataSetupArray.append(homeDataSetupItem)
                    }
                }

                // Remove existing HomeData objects from masterData
                if let existingHomeData = masterData.homeData?.allObjects as? [HomeData] {
                    existingHomeData.forEach { masterData.removeFromHomeData($0) }
                }

                // Add the new HomeData objects to masterData
                homeDataSetupArray.forEach { masterData.addToHomeData($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }



    

    
    
    
    func deleteTerritoryData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        // Use perform to ensure that operations are on the managed context's queue
        self.managedContext().perform {
            let masterData = self.getMasterData()

            if let territories = masterData.territory?.allObjects as? [Territory] {
                // Filter territories to delete
                let territoriesToDelete = territories.filter { $0.mapId == id }

                for territory in territoriesToDelete {
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()
                   
                    // Perform deletion
                    self.managedContext().delete(territory)

                    // Leave the dispatch group after deletion
                    dispatchGroup.leave()
                }
            }

            // Notify once all deletions are completed
            dispatchGroup.notify(queue: .main) {
                // Save context after all deletions are complete
                self.saveContext()

                // Call completion after saving context
                completion()
            }
        }
    }

    func saveMyDayPlanData(values: [[String: Any]]) {
        deleteEntityInfo("MyDayPlan") {  isRemoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var myDayPlanArray = [MyDayPlan]()

                // Iterate through the input values to create MyDayPlan entities
                for (index, myDayPlan) in values.enumerated() {
                    if let myDayPlanEntity = NSEntityDescription.entity(forEntityName: "MyDayPlan", in: context) {
                        let myDayPlanItem = MyDayPlan(entity: myDayPlanEntity, insertInto: context)
                        myDayPlanItem.setValues(fromDictionary: myDayPlan, context: context)
                        myDayPlanItem.index = Int16(index)
                        myDayPlanArray.append(myDayPlanItem)
                    }
                }

                // Remove existing MyDayPlan objects from masterData
                if let existingDayPlans = masterData.myDayPlan?.allObjects as? [MyDayPlan] {
                    existingDayPlans.forEach { masterData.removeFromMyDayPlan($0) }
                }

                // Add the new MyDayPlan objects to masterData
                myDayPlanArray.forEach { masterData.addToMyDayPlan($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
            
        }
        

    }

    



    
    func deleteJointWorkData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        // Use perform to ensure that operations are on the managed context's queue
        self.managedContext().perform {
            let masterData = self.getMasterData()
            
            if let prevList = masterData.jointWork?.allObjects as? [JointWork] {
                // Filter joint work items to delete
                let dataToDelete = prevList.filter { $0.mapId == id }

                for jointWork in dataToDelete {
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()

                    // Perform deletion
                    self.managedContext().delete(jointWork)

                    // Leave the dispatch group after deletion
                    dispatchGroup.leave()
                }
            }

            // Notify once all deletions are completed
            dispatchGroup.notify(queue: .main) {
                // Save context after all deletions are complete
                self.saveContext()

                // Call completion after saving context
                completion()
            }
        }
    }

    

    func deleteProductData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        // Use perform to ensure that operations are on the managed context's queue
        self.managedContext().perform {
            let masterData = self.getMasterData()
            
            if let prevList = masterData.product?.allObjects as? [Product] {
                // Filter products to delete by id
                let productsToDelete = prevList.filter { $0.mapId == id }

                for product in productsToDelete {
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()

                    // Perform deletion
                    self.managedContext().delete(product)

                    // Leave the dispatch group after deletion
                    dispatchGroup.leave()
                }
            }

            // Notify once all deletions are completed
            dispatchGroup.notify(queue: .main) {
                // Save context after all deletions are complete
                self.saveContext()

                // Call completion after saving context
                completion()
            }
        }
    }

    

    


    func saveBrandData(values: [[String: Any]]) {
        
        deleteEntityInfo("Brand") { isReomoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var brandArray = [Brand]()

                // Iterate through the input values to create Brand entities
                for (index, brand) in values.enumerated() {
                    if let brandEntity = NSEntityDescription.entity(forEntityName: "Brand", in: context) {
                        let brandItem = Brand(entity: brandEntity, insertInto: context)
                        brandItem.setValues(fromDictionary: brand)
                        brandItem.index = Int16(index)
                        brandArray.append(brandItem)
                    }
                }

                // Remove existing Brand objects from masterData
                if let existingBrands = masterData.brand?.allObjects as? [Brand] {
                    existingBrands.forEach { masterData.removeFromBrand($0) }
                }

                // Add the new Brand objects to masterData
                brandArray.forEach { masterData.addToBrand($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
            
        }
        

    }

    

    
    func saveCompetitorData(values: [[String: Any]]) {
        // Obtain the managed context for Core Data operations
        let context = self.managedContext()
        let masterData = self.getMasterData() // Fetch the master data

        context.perform {
            var competitorArray = [Competitor]()

            // Iterate through the input values to create Competitor entities
            for (index, competitor) in values.enumerated() {
                if let competitorEntity = NSEntityDescription.entity(forEntityName: "Competitor", in: context) {
                    let competitorItem = Competitor(entity: competitorEntity, insertInto: context)
                    competitorItem.setValues(fromDictionary: competitor)
                    competitorItem.index = Int16(index)
                    competitorArray.append(competitorItem)
                }
            }

            // Remove existing Competitor objects from masterData
            if let existingCompetitors = masterData.competitor?.allObjects as? [Competitor] {
                existingCompetitors.forEach { masterData.removeFromCompetitor($0) }
            }

            // Add the new Competitor objects to masterData
            competitorArray.forEach { masterData.addToCompetitor($0) }

            // Save the context using the reusable saveContext method
            self.saveContext()
        }
    }

    

    
    func saveSpecialityData(values: [[String: Any]]) {
        
        deleteEntityInfo("Speciality") { isReomoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var specialityArray = [Speciality]()

                // Iterate through the input values to create Speciality entities
                for (index, speciality) in values.enumerated() {
                    if let specialityEntity = NSEntityDescription.entity(forEntityName: "Speciality", in: context) {
                        let specialityItem = Speciality(entity: specialityEntity, insertInto: context)
                        specialityItem.setValues(fromDictionary: speciality)
                        specialityItem.index = Int16(index)
                        specialityArray.append(specialityItem)
                    }
                }

                // Remove existing Speciality objects from masterData
                if let existingSpecialities = masterData.speciality?.allObjects as? [Speciality] {
                    existingSpecialities.forEach { masterData.removeFromSpeciality($0) }
                }

                // Add the new Speciality objects to masterData
                specialityArray.forEach { masterData.addToSpeciality($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }

    }

    


    func saveQualificationData(values: [[String: Any]]) {
        deleteEntityInfo("Qualifications") { isReomoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var qualificationArray = [Qualifications]()

                // Iterate through the input values to create Qualifications entities
                for (index, qualification) in values.enumerated() {
                    if let qualificationEntity = NSEntityDescription.entity(forEntityName: "Qualifications", in: context) {
                        let qualificationItem = Qualifications(entity: qualificationEntity, insertInto: context)
                        qualificationItem.setValues(fromDictionary: qualification)
                        qualificationItem.index = Int16(index)
                        qualificationArray.append(qualificationItem)
                    }
                }

                // Remove existing Qualifications objects from masterData
                if let existingQualifications = masterData.qualification?.allObjects as? [Qualifications] {
                    existingQualifications.forEach { masterData.removeFromQualification($0) }
                }

                // Add the new Qualifications objects to masterData
                qualificationArray.forEach { masterData.addToQualification($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    



    
    func saveChemistCategoryData(values: [[String: Any]]) {
        deleteEntityInfo("ChemistCategory") { isReomoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data

            context.perform {
                var categoryArray = [ChemistCategory]()

                // Iterate through the input values to create ChemistCategory entities
                for (index, category) in values.enumerated() {
                    if let categoryEntity = NSEntityDescription.entity(forEntityName: "ChemistCategory", in: context) {
                        let categoryItem = ChemistCategory(entity: categoryEntity, insertInto: context)
                        categoryItem.setValues(fromDictionary: category)
                        categoryItem.index = Int16(index)
                        categoryArray.append(categoryItem)
                    }
                }

                // Remove existing ChemistCategory objects from masterData
                if let existingCategories = masterData.chemistCategory?.allObjects as? [ChemistCategory] {
                    existingCategories.forEach { masterData.removeFromChemistCategory($0) }
                }

                // Add the new ChemistCategory objects to masterData
                categoryArray.forEach { masterData.addToChemistCategory($0) }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
            
        }
        

    }

    


    func saveCategoryData(values: [[String: Any]]) {
        deleteEntityInfo("DoctorCategory") { isReomoved in
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data
            
            context.perform {
                var categoryArray = [DoctorCategory]()
                
                // Iterate through the input values to create DoctorCategory entities
                for (index, category) in values.enumerated() {
                    if let categoryEntity = NSEntityDescription.entity(forEntityName: "DoctorCategory", in: context) {
                        let categoryItem = DoctorCategory(entity: categoryEntity, insertInto: context)
                        categoryItem.setValues(fromDictionary: category)
                        categoryItem.index = Int16(index)
                        categoryArray.append(categoryItem)
                    }
                }
                
                // Remove existing DoctorCategory objects from masterData
                if let existingCategories = masterData.category?.allObjects as? [DoctorCategory] {
                    existingCategories.forEach { masterData.removeFromCategory($0) }
                }
                
                // Add the new DoctorCategory objects to masterData
                categoryArray.forEach { masterData.addToCategory($0) }
                
                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    


    
    func saveDoctorClassData(values: [[String: Any]]) {
        deleteEntityInfo("DoctorClass") { isReomoved in
            
            // Obtain the managed context for Core Data operations
            let context = self.managedContext()
            let masterData = self.getMasterData() // Fetch the master data
            
            context.perform {
                var classArray = [DoctorClass]()
                
                // Iterate through the input values to create DoctorClass entities
                for (index, cls) in values.enumerated() {
                    if let classEntity = NSEntityDescription.entity(forEntityName: "DoctorClass", in: context) {
                        let classItem = DoctorClass(entity: classEntity, insertInto: context)
                        classItem.setValues(fromDictionary: cls)
                        classItem.index = Int16(index)
                        classArray.append(classItem)
                    }
                }
                
                // Remove existing DoctorClass objects from masterData
                if let existingClasses = masterData.doctorClass?.allObjects as? [DoctorClass] {
                    existingClasses.forEach { masterData.removeFromDoctorClass($0) }
                }
                
                // Add the new DoctorClass objects to masterData
                classArray.forEach { masterData.addToDoctorClass($0) }
                
                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    

    
    func saveDepartsData(values: [[String: Any]]) {
        // Use the managed context for Core Data operations
        let context = self.managedContext()
        let masterData = self.getMasterData() // Fetch the master data

        context.perform {
            var departArray = [Departs]()
            
            // Iterate through the input values to create Departs entities
            for (index, departDict) in values.enumerated() {
                if let departEntity = NSEntityDescription.entity(forEntityName: "Departs", in: context) {
                    let departItem = Departs(entity: departEntity, insertInto: context)
                    departItem.setValues(fromDictionary: departDict)
                    departItem.index = Int16(index)
                    departArray.append(departItem)
                }
            }
            
            // Remove existing Departs objects from masterData
            if let existingDeparts = masterData.departs?.allObjects as? [Departs] {
                existingDeparts.forEach { masterData.removeFromDeparts($0) }
            }
            
            // Add the new Departs objects to masterData
            departArray.forEach { masterData.addToDeparts($0) }
            
            // Save the context using the reusable saveContext method
            self.saveContext()
        }
    }

    


    
    func saveFeedbackData(values: [[String: Any]]) {
        deleteEntityInfo("Feedback") { isRemoved in
            let context = self.managedContext() // Get the current managed context
            let masterData = self.getMasterData() // Get the master data

            context.perform {
                var feedbackArray = [Feedback]()
                
                // Loop through the values and create Feedback entities
                for (index, feedbackDict) in values.enumerated() {
                    // Skip feedback items where the "name" field is empty
                    guard let name = feedbackDict["name"] as? String, !name.isEmpty else {
                        continue
                    }

                    if let feedbackEntity = NSEntityDescription.entity(forEntityName: "Feedback", in: context) {
                        let feedbackItem = Feedback(entity: feedbackEntity, insertInto: context)
                        feedbackItem.setValues(fromDictionary: feedbackDict)
                        feedbackItem.index = Int16(index)
                        feedbackArray.append(feedbackItem)
                    }
                }

                // Remove existing Feedback objects from masterData
                if let existingFeedbacks = masterData.feedback?.allObjects as? [Feedback] {
                    existingFeedbacks.forEach { masterData.removeFromFeedback($0) }
                }

                // Add the new Feedback objects to masterData
                feedbackArray.forEach { feedbackItem in
                    masterData.addToFeedback(feedbackItem)
                }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }

    


    
    func saveLeaveTypeData(values: [[String: Any]]) {
        deleteEntityInfo("LeaveType") { isRemoved in
            let context = self.managedContext() // Get the current managed context
            let masterData = self.getMasterData() // Get the master data

            context.perform {
                var leaveArray = [LeaveType]()
                
                // Loop through the values and create LeaveType entities
                for (index, leaveTypeDict) in values.enumerated() {
                    if let leaveTypeEntity = NSEntityDescription.entity(forEntityName: "LeaveType", in: context) {
                        let leaveTypeItem = LeaveType(entity: leaveTypeEntity, insertInto: context)
                        leaveTypeItem.setValues(fromDictionary: leaveTypeDict, context: context)
                        leaveTypeItem.index = Int16(index)
                        leaveArray.append(leaveTypeItem)
                    }
                }

                // Remove existing LeaveType objects from masterData
                if let existingLeaveTypes = masterData.leaveType?.allObjects as? [LeaveType] {
                    existingLeaveTypes.forEach { masterData.removeFromLeaveType($0) }
                }

                // Add the new LeaveType objects to masterData
                leaveArray.forEach { leaveTypeItem in
                    masterData.addToLeaveType(leaveTypeItem)
                }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }

    }

    


 
    func saveVisitControlData(values: [[String: Any]]) {
        deleteEntityInfo("VisitControl") { isRemoved in
            let context = self.managedContext() // Get the current managed context
            let masterData = self.getMasterData() // Get the master data

            context.perform {
                var visitControlArray = [VisitControl]()
                
                // Loop through the values and create VisitControl entities
                for (index, visitControlDict) in values.enumerated() {
                    if let visitControlEntity = NSEntityDescription.entity(forEntityName: "VisitControl", in: context) {
                        let visitControlItem = VisitControl(entity: visitControlEntity, insertInto: context)
                        visitControlItem.setValues(fromDictionary: visitControlDict)
                        visitControlItem.index = Int16(index)
                        visitControlArray.append(visitControlItem)
                    }
                }

                // Remove existing VisitControl objects from masterData
                if let existingVisitControls = masterData.visitControl?.allObjects as? [VisitControl] {
                    existingVisitControls.forEach { masterData.removeFromVisitControl($0) }
                }

                // Add the new VisitControl objects to masterData
                visitControlArray.forEach { visitControlItem in
                    masterData.addToVisitControl(visitControlItem)
                }

                // Save the context using the reusable saveContext method
                self.saveContext()
            }
        }
        

    }


    func saveStockBalance(values: [[String: Any]]) {
        
        deleteEntityInfo("StockBalance") { isRemoved in
            // Ensure there is at least one stock value in the array
            guard let stock = values.first else {
                return
            }
            
            let context = self.managedContext() // Get the current managed context
            let masterData = self.getMasterData() // Get the master data

            context.perform {
                // Create a new StockBalance entity and set values
                if let stockEntity = NSEntityDescription.entity(forEntityName: "StockBalance", in: context) {
                    let stockItem = StockBalance(entity: stockEntity, insertInto: context)
                    stockItem.setValues(fromDictionary: stock, context: context)
                    
                    // Assign the stock balance to the masterData object
                    masterData.stockBalance = stockItem
                    
                    // Save the context using the reusable saveContext method
                    self.saveContext()
                }
            }
        }
        

    }

    


    
    func saveMapCompDetData(values: [[String: Any]]) {
        
        deleteEntityInfo("MapCompDet") { isRemoved in
            let context = self.managedContext() // Get the current managed context
            let masterData = self.getMasterData() // Get master data
            // Perform context operations on the managed context queue
            context.perform {
                var mapCompDetArray = [MapCompDet]() // Create an array to hold the new MapCompDet objects
                
                // Iterate over the values to create and set up MapCompDet objects
                for (index, map) in values.enumerated() {
                    if let mapCompDetEntity = NSEntityDescription.entity(forEntityName: "MapCompDet", in: context) {
                        let mapCompDetItem = MapCompDet(entity: mapCompDetEntity, insertInto: context)
                        mapCompDetItem.setValues(fromDictionary: map)
                        mapCompDetItem.index = Int16(index)
                        mapCompDetArray.append(mapCompDetItem)
                    }
                }
                
                
                // Remove existing MapCompDet objects from masterData
                if let existingList = masterData.mapCompDet?.allObjects as? [MapCompDet] {
                    existingList.forEach { masterData.removeFromMapCompDet($0) }
                }
                
                // Add new MapCompDet objects to masterData
                mapCompDetArray.forEach { masterData.addToMapCompDet($0) }
                
                // Save the context using the reusable saveContext function
                self.saveContext()
            }
        }
        
        
    }
    


    
    func getSlide() -> [ProductSlides] {
        let masterData = self.getMasterData()
        guard let slideArray = masterData.slides?.allObjects as? [ProductSlides] else{
            return [ProductSlides]()
        }
        let array = slideArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideBrand() -> [SlideBrand]{
        let masterData = self.getMasterData()
        guard let slideBrandArray = masterData.slideBrand?.allObjects as? [SlideBrand] else{
            return [SlideBrand]()
        }
        let array = slideBrandArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideTheraptic() -> [SlideTheraptic]{
        let masterData = self.getMasterData()
        guard let slideBrandArray = masterData.theraptic?.allObjects as? [SlideTheraptic] else{
            return [SlideTheraptic]()
        }
        let array = slideBrandArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideSpeciality() -> [SlideSpeciality]{
        let masterData = self.getMasterData()
        guard let slideSpecialityArray = masterData.slideSpeciality?.allObjects as? [SlideSpeciality] else{
            return [SlideSpeciality]()
        }
        let array = slideSpecialityArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSubordinate() -> [Subordinate] {
        let masterData = self.getMasterData()
        guard let subordinateArray = masterData.subordinate?.allObjects as? [Subordinate] else{
            return [Subordinate]()
        }
        let array = subordinateArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSubordinateMGR() -> [Subordinate] {
        let masterData = self.getMasterData()
        
        guard let subordinateMgrArray = masterData.subordinateMgr?.allObjects as? [Subordinate] else{
            return [Subordinate]()
        }
        
        let array = subordinateMgrArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getDoctor() -> [DoctorFencing]{
        let masterData = self.getMasterData()
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return [DoctorFencing]()
        }
        let array = doctorArray.sorted{ (item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    
    func getDoctorByTerritory(townCodes: [String]) -> [DoctorFencing] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [DoctorFencing]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getDoctor(mapID: String) -> [DoctorFencing] {
        let masterData = self.getMasterData()
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return []
        }

        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [DoctorFencing]()

        for doctor in doctorArray {
            if doctor.mapId == mapID && !uniqueCodes.contains(doctor.code ?? "") {
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "")
            }
        }

        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getChemist(mapID: String) -> [Chemist]{
        let masterData = self.getMasterData()
        guard let chemistArray = masterData.chemist?.allObjects as? [Chemist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [Chemist]()
        
        for chemist in chemistArray {
            if chemist.mapId == mapID && !uniqueCodes.contains(chemist.code ?? "") {
                filteredArray.append(chemist)
                uniqueCodes.insert(chemist.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getChemistByTerritory(townCodes: [String]) -> [Chemist] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.chemist?.allObjects as? [Chemist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [Chemist]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    
    
    func getChemist() -> [Chemist]{
        let masterData = self.getMasterData()
        guard let chemistArray = masterData.chemist?.allObjects as? [Chemist] else {
            return [Chemist]()
        }
        let array = chemistArray.sorted{ (item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getStockist(mapID: String) -> [Stockist]{
        let masterData = self.getMasterData()
        guard let stockiststArray = masterData.stockist?.allObjects as? [Stockist] else {
            return []
        }
        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [Stockist]()
        
        for stockistst in stockiststArray {
            if stockistst.mapId == mapID && !uniqueCodes.contains(stockistst.code ?? "") {
                filteredArray.append(stockistst)
                uniqueCodes.insert(stockistst.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getStockistByTerritory(townCodes: [String]) -> [Stockist] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.stockist?.allObjects as? [Stockist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [Stockist]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    
    func getStockist() -> [Stockist]{
        let masterData = self.getMasterData()
        guard let stockistArray = masterData.stockist?.allObjects as? [Stockist] else{
            return [Stockist]()
        }
        let array = stockistArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getUnListedDoctor() -> [UnListedDoctor]{
        let masterData = self.getMasterData()
        guard let unlistedDoctorArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return [UnListedDoctor]()
        }
        let array = unlistedDoctorArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getUnListedDoctor(mapID: String) -> [UnListedDoctor]{
        let masterData = self.getMasterData()
        guard let unlistedDocArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return []
        }

        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [UnListedDoctor]()
        
        for unlistedDoc in unlistedDocArray {
            if unlistedDoc.mapId == mapID && !uniqueCodes.contains(unlistedDoc.code ?? "") {
                filteredArray.append(unlistedDoc)
                uniqueCodes.insert(unlistedDoc.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getUnlistedDocByTerritory(townCodes: [String]) -> [UnListedDoctor] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [UnListedDoctor]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getWorkType() -> [WorkType]{
        let masterData = self.getMasterData()
        guard let workTypeArray = masterData.workType?.allObjects as? [WorkType] else{
            return [WorkType]()
        }
        let array = workTypeArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getTableSetUp() -> [TableSetup]{
        let masterData = self.getMasterData()
        guard let TableSetupArray = masterData.tableSetup?.allObjects as? [TableSetup] else{
            return [TableSetup]()
        }
        let array = TableSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getWeeklyOff() -> [Weeklyoff]{
        let masterData = self.getMasterData()
        guard var WeeklyoffSetupArray = masterData.weeklyoff?.allObjects as? [Weeklyoff] else{
            return [Weeklyoff]()
        }
        
        var uniqueHolidayModes = Set<String>()
        WeeklyoffSetupArray = WeeklyoffSetupArray.filter { aWeeklyoff in
            guard !uniqueHolidayModes.contains(aWeeklyoff.holiday_Mode ?? "0") else {
                return false
            }
            uniqueHolidayModes.insert(aWeeklyoff.holiday_Mode ?? "0")
            return true
        }
        
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func geUnsyncedtHomeData() -> [UnsyncedHomeData]? {
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.unsyncedHomeData?.allObjects else{
            return [UnsyncedHomeData]()
        }
//        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
//            return item1.index < item2.index
//        }
        return WeeklyoffSetupArray as? [UnsyncedHomeData] ?? nil
    }
    
    func getHomeData() -> [HomeData]{
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.homeData?.allObjects as? [HomeData] else{
            return [HomeData]()
        }
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getHolidays() -> [Holidays]{
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.holidays?.allObjects as? [Holidays] else{
            return [Holidays]()
        }
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getTerritory() -> [Territory]{
        let masterData = self.getMasterData()
        
        guard let territoryArray = masterData.territory?.allObjects as? [Territory] else{
            return [Territory]()
        }
        let array = territoryArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getTerritory(mapID: String) -> [Territory] {
        let masterData = self.getMasterData()

        guard let territoryArray = masterData.territory?.allObjects as? [Territory] else {
            return []
        }

        let filteredArray = territoryArray.filter { $0.mapId == mapID }

        let sortedArray = filteredArray.sorted { $0.index < $1.index }

        return sortedArray
    }
    
    func getMyDayPlan() -> [MyDayPlan]{
        let masterData = self.getMasterData()
        guard let mydayplanArray = masterData.myDayPlan?.allObjects as? [MyDayPlan] else{
            return [MyDayPlan]()
        }
        let array = mydayplanArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getJointWork() -> [JointWork]{
        let masterData = self.getMasterData()
        guard let jointWorkArray = masterData.jointWork?.allObjects as? [JointWork] else{
            return [JointWork]()
        }
        let array = jointWorkArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }

    func getProduct() -> [Product] {
        let masterData = self.getMasterData()
        guard let productArray = masterData.product?.allObjects as? [Product] else{
            return [Product]()
        }
        let array = productArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }

    func getInput() -> [Input]{
        let masterData = self.getMasterData()
        guard let inputArray = masterData.input?.allObjects as? [Input] else{
            return [Input]()
        }
        let array = inputArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getBrands() -> [Brand]{
        let masterData = self.getMasterData()
        guard let brandArray = masterData.brand?.allObjects as? [Brand] else{
            return [Brand]()
        }
        let array = brandArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getCompetitor() -> [Competitor]{
        let masterData = self.getMasterData()
        guard let competitorArray = masterData.competitor?.allObjects as? [Competitor] else{
            return [Competitor]()
        }
        let array = competitorArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSpeciality() -> [Speciality]{
        let masterData = self.getMasterData()
        guard let specialityArray = masterData.speciality?.allObjects as? [Speciality] else{
            return [Speciality]()
        }
        let array = specialityArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getDoctorClass() -> [DoctorClass]{
        let masterData = self.getMasterData()
        guard let classArray = masterData.doctorClass?.allObjects as? [DoctorClass] else{
            return [DoctorClass]()
        }
        let array = classArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getDeparts() -> [Departs]{
        let masterData = self.getMasterData()
        guard let departArray = masterData.departs?.allObjects as? [Departs] else{
            return [Departs]()
        }
        let array = departArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getCategory() -> [DoctorCategory] {
        let masterData = self.getMasterData()
        guard let categoryArray = masterData.category?.allObjects as? [DoctorCategory] else{
            return [DoctorCategory]()
        }
        let array = categoryArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
  
    func getQualification() -> [Qualifications]{
        let masterData = self.getMasterData()
        guard let qualiArray = masterData.qualification?.allObjects as? [Qualifications] else{
            return [Qualifications]()
        }
        let array = qualiArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getLeaveType() -> [LeaveType]{
        let masterData = self.getMasterData()
        guard let leaveArray = masterData.leaveType?.allObjects as? [LeaveType] else{
            return [LeaveType]()
        }
        let array = leaveArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getVisitControl() -> [VisitControl]{
        let masterData = self.getMasterData()
        guard let visitArray = masterData.visitControl?.allObjects as? [VisitControl] else{
            return [VisitControl]()
        }
        let array = visitArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getMapCompDet() -> [MapCompDet]{
        let masterData = self.getMasterData()
        guard let mapArray = masterData.mapCompDet?.allObjects as? [MapCompDet] else{
            return [MapCompDet]()
        }
        let array = mapArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getFeedback() -> [Feedback]{
        let masterData = self.getMasterData()
        guard let feedbackArray = masterData.feedback?.allObjects as? [Feedback] else{
            return [Feedback]()
        }
        let array = feedbackArray.sorted { (item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getStockBalance() -> StockBalance? {
        let masterData = self.getMasterData()
        return masterData.stockBalance
    }
    
    
    func getChemistCategory() -> [ChemistCategory] {
        let masterData = self.getMasterData()
        guard let categoryArray = masterData.chemistCategory?.allObjects as? [ChemistCategory] else{
            return [ChemistCategory]()
        }
        let array = categoryArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
}

