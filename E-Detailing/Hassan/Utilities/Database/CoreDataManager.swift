//
//  PresentationCoreDataManager.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/01/24.
//



import Foundation
import CoreData
import UIKit




class CoreDataManager {
    static let shared = CoreDataManager()
    // var savedSlideBrand: [SlideBrand]?
    // var savedSlides : [SlidesCDModel]?
   //  var savedGroupedSlides : [GroupedBrandsSlideCDModel]?
    // var savedCDpresentations:[SavedCDPresentation]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - functionalities for presentation flow
    
    /// function to fetch all saved presentation
    /// - Parameter completion: array of type SavedCDPresentation
    func fetchPresentations(completion: ([SavedCDPresentation]) -> () )  {
        do {
           let savedCDpresentations = try  context.fetch(SavedCDPresentation.fetchRequest())
            completion(savedCDpresentations )
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    

    // Method to save changes to the context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    /// function checks for existing object from core data SavedCDPresentation
    /// - Parameters:
    ///   - name: name
    ///   - completion: boolean
    func toCheckExistance(_ name: String, completion: (Bool) -> ()) {
        
        do {
            let request = SavedCDPresentation.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "name == %@", name)
            //LIKE
            request.predicate = pred
           let savedCDPresentations = try context.fetch(request)
            if savedCDPresentations.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    
    
    
    /// function to remove a presentation
    /// - Parameters:
    ///   - id: UUID
    ///   - completion: completion descriptionboolen
    func toRemovePresentation(_ name: String, completion: (Bool) -> ()) {
   

        do {
            let request = SavedCDPresentation.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "name == %@", name)
            request.predicate = pred
           let presentations = try context.fetch(request)
            if presentations.isEmpty {
                completion(false)
            } else {
                let presentationToRemove = presentations[0]
                self.context.delete(presentationToRemove)
                do {
                     try self.context.save()
                    completion(true)
                } catch {
                    completion(false)
                }
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }

    }
    
    func removeAllPresentations() {
        do {
            let request = SavedCDPresentation.fetchRequest() as NSFetchRequest<SavedCDPresentation>
            let presentations = try context.fetch(request)
            for presentation in presentations {
                context.delete(presentation)
            }
            
            do {
                try context.save()
             
            } catch {
                
            }
        } catch {
            print("Unable to fetch")
           
        }
    }
    
    
    ///  function to edit a existing presentation
    /// - Parameters:
    ///   - savedPresentation: SavedPresentation object
    ///   - id: UUID
    ///   - completion: boolean
    func toEditSavedPresentation(savedPresentation: SavedPresentation, name: String, completion: @escaping (Bool) -> Void) {
        do {
            let request = SavedCDPresentation.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "name == %@", name)
            request.predicate = pred
            let presentations = try context.fetch(request)
            for presentation in presentations {
                context.delete(presentation)
            }

            // Create a new entity
                   let newEntity = SavedCDPresentation(context: context)
                   newEntity.name = savedPresentation.name
                   
                   // Convert and add groupedBrandsSlideModel
                   convertToCDGroupedBrandsSlideModel(savedPresentation.groupedBrandsSlideModel, context: context) { groupedBrandsSlideModel in
                       newEntity.groupedBrandsSlideModel = groupedBrandsSlideModel
                       
                       // Save to Core Data
                       do {
                           try self.context.save()
                           completion(true)
                       } catch {
                           print("Failed to save to Core Data: \(error)")
                           completion(false)
                       }
                   }
            
        } catch {
            print("Unable to fetch presentations: \(error)")
            completion(false)
        }
    }
    
    

    

    /// to save object of type SavedPresentation to core data
    /// - Parameters:
    ///   - savedPresentation: SavedPresentation
    ///   - completion: boolean
    func saveToCoreData(savedPresentation: SavedPresentation, completion: @escaping (Bool) -> Void) {
        toCheckExistance(savedPresentation.name) { isExists in
            var tempcompletion: Bool = false
            let dispatchGroup = DispatchGroup()
            if !isExists {
               
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "SavedCDPresentation", in: context) {
                    dispatchGroup.enter()
                    let savedCDPresentation = SavedCDPresentation(entity: entityDescription, insertInto: context)

                    // Convert properties
                 
                    savedCDPresentation.name = savedPresentation.name

                    // Convert and add groupedBrandsSlideModel
                    convertToCDGroupedBrandsSlideModel(savedPresentation.groupedBrandsSlideModel, context: context) { groupedBrandsSlideModel in
                       
                        
                        self.orderBrandsPrioritywise(groupedBrandsSlideModel, context: self.context) { orderedBrandSlides in
                            
                            savedCDPresentation.groupedBrandsSlideModel = groupedBrandsSlideModel
                            
                            do {
                                try context.save()
                                tempcompletion = true
                                dispatchGroup.leave()
                            } catch {
                                print("Failed to save to Core Data: \(error)")
                                tempcompletion = false
                                dispatchGroup.leave()
                            }
                            
                        }
                        // Save to Core Data
          
                    }
                }
            } else {
                tempcompletion = false
            }
            // Notify the completion handler when all tasks in the dispatch group are complete
            dispatchGroup.notify(queue: .main) {
                completion(tempcompletion)
            }
        }
    }
    
    func orderBrandsPrioritywise(_ groupedBrandsSlideModel: NSSet, context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        // Assuming groupedBrandsSlideModel is a set of SlidesModel
        if let slidesModels = groupedBrandsSlideModel.allObjects as? [SlidesModel] {
            // Sort the array based on priority
            let sortedSlidesModels = slidesModels.sorted { $0.priority < $1.priority }
            
            // Convert the sorted array back to NSSet
            let sortedGroupedBrandsSlideModel = NSSet(array: sortedSlidesModels)
            
            // Call the completion handler with the sorted NSSet
            completion(sortedGroupedBrandsSlideModel)
        } else {
            // If conversion fails, pass the original NSSet to completion
            completion(groupedBrandsSlideModel)
        }
    }

    
    
    /// function used to convert codable class objet array to NSset. sincc core data saves object of type NSset
    /// - Parameters:
    ///   - groupedBrandsSlideModels: object of type [GroupedBrandsSlideModel]
    ///   - context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /// - Returns: NSSet
    private func convertToCDGroupedBrandsSlideModel(_ groupedBrandsSlideModels: [GroupedBrandsSlideModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let cdGroupedBrandsSlideModels = NSMutableSet()

        // Create a dispatch group to handle asynchronous tasks
        let dispatchGroup = DispatchGroup()

        // Iterate over each GroupedBrandsSlideModel
        for groupedBrandsSlideModel in groupedBrandsSlideModels {
            dispatchGroup.enter()

            if let entityDescription = NSEntityDescription.entity(forEntityName: "GroupedBrandsSlideCDModel", in: context) {
                let cdGroupedBrandsSlideModel = GroupedBrandsSlideCDModel(entity: entityDescription, insertInto: context)

                // Convert properties of GroupedBrandsSlideModel
                cdGroupedBrandsSlideModel.divisionCode = Int16(groupedBrandsSlideModel.divisionCode)
                cdGroupedBrandsSlideModel.id = Int16(groupedBrandsSlideModel.id)
                cdGroupedBrandsSlideModel.priority = Int16(groupedBrandsSlideModel.priority)
                cdGroupedBrandsSlideModel.productBrdCode = Int16(groupedBrandsSlideModel.productBrdCode)
                cdGroupedBrandsSlideModel.subdivisionCode = Int16(groupedBrandsSlideModel.subdivisionCode)
                cdGroupedBrandsSlideModel.uuid = groupedBrandsSlideModel.uuid
               
                // Convert and add groupedSlide
                let tempSlide =  groupedBrandsSlideModel.groupedSlide.sorted { $0.index < $1.index }
                convertToSavedSlidesCDModel(tempSlide, context: context) { groupedSlide in
                    cdGroupedBrandsSlideModel.groupedSlide = groupedSlide
                    // Leave the dispatch group after converting and adding groupedSlide
                    dispatchGroup.leave()
                }

                // Add to set
                cdGroupedBrandsSlideModels.add(cdGroupedBrandsSlideModel)
            }
        }

        // Notify the completion handler when all tasks in the dispatch group are complete
        dispatchGroup.notify(queue: .main) {
            completion(cdGroupedBrandsSlideModels)
        }
    }
    
    private func convertToSavedSlidesCDModel(_ slidesModels: [SlidesModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let cdSlidesModels = NSMutableSet()
        let groupDispatchGroup = DispatchGroup()
        for slidesModel in slidesModels {
         
            if let entityDescription = NSEntityDescription.entity(forEntityName: "SavedSlidesCDModel", in: context) {
                let cdSlidesModel = SavedSlidesCDModel(entity: entityDescription, insertInto: context)
//                if slidesModel.utType == "video/mp4" || slidesModel.utType == "application/pdf" || slidesModel.utType == "text/html" {
//                    print(slidesModel.index)
//                }
                // Convert properties of SlidesModel
                cdSlidesModel.code = Int16(slidesModel.code)
                cdSlidesModel.filePath = slidesModel.filePath
                cdSlidesModel.code =   Int16(slidesModel.code)
                cdSlidesModel.camp = Int16(slidesModel.camp)
                cdSlidesModel.productDetailCode = slidesModel.productDetailCode
                cdSlidesModel.filePath = slidesModel.filePath
                cdSlidesModel.group = Int16(slidesModel.group)
                cdSlidesModel.specialityCode = slidesModel.specialityCode
                cdSlidesModel.slideId = Int16(slidesModel.slideId)
                cdSlidesModel.fileType = slidesModel.fileType
                // cdSlidesModel.effFrom = effFrom = DateI
                cdSlidesModel.categoryCode = slidesModel.categoryCode
                cdSlidesModel.name = slidesModel.name
                cdSlidesModel.noofSamples = Int16(slidesModel.noofSamples)
                // cdSlidesModel.effTo = effTo = DateI
                cdSlidesModel.ordNo = Int16(slidesModel.ordNo)
                cdSlidesModel.priority = Int16(slidesModel.priority)
                cdSlidesModel.slideData = slidesModel.slideData
                cdSlidesModel.utType = slidesModel.utType
                cdSlidesModel.isSelected = slidesModel.isSelected
                cdSlidesModel.fileName = slidesModel.fileName
                cdSlidesModel.isFailed = slidesModel.isFailed
                cdSlidesModel.isDownloadCompleted = slidesModel.isDownloadCompleted
                cdSlidesModel.index = Int16(slidesModel.index)
                groupDispatchGroup.enter()
                // Convert other properties...
                
                processSlideModel(slidesModel: slidesModel) { imageData in
                    cdSlidesModel.imageData = imageData
                   
                    groupDispatchGroup.leave() // Leave the group after the processing is done
                }
                
                // Add to set
                cdSlidesModels.add(cdSlidesModel)
            }
        }

        groupDispatchGroup.notify(queue: .main) {
            // Completion handler called when all slide models are processed
            completion(cdSlidesModels)
        }
    }
    
 
    
    
    /// function used to convert codable class objet array to NSset. sincc core data saves object of type NSset
    /// - Parameters:
    ///   - slidesModels: object of type [SlidesModel]
    ///   - context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /// - Returns: NSSet
    private func convertToSlidesCDModel(_ slidesModels: [SlidesModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let cdSlidesModels = NSMutableSet()
        let groupDispatchGroup = DispatchGroup()
        
        for slidesModel in slidesModels {
            groupDispatchGroup.enter()
            if let entityDescription = NSEntityDescription.entity(forEntityName: "GroupedSlidesCDModel", in: context) {
                let cdSlidesModel = GroupedSlidesCDModel(entity: entityDescription, insertInto: context)
                
                // Convert properties of SlidesModel
                cdSlidesModel.code = Int16(slidesModel.code)
                cdSlidesModel.filePath = slidesModel.filePath
                cdSlidesModel.code = Int16(slidesModel.code)
                cdSlidesModel.camp = Int16(slidesModel.camp)
                cdSlidesModel.productDetailCode = slidesModel.productDetailCode
                cdSlidesModel.group = Int16(slidesModel.group)
                cdSlidesModel.specialityCode = slidesModel.specialityCode
                cdSlidesModel.slideId = Int16(slidesModel.slideId)
                cdSlidesModel.fileType = slidesModel.fileType
                cdSlidesModel.categoryCode = slidesModel.categoryCode
                cdSlidesModel.name = slidesModel.name
                cdSlidesModel.noofSamples = Int16(slidesModel.noofSamples)
                cdSlidesModel.ordNo = Int16(slidesModel.ordNo)
                cdSlidesModel.priority = Int16(slidesModel.priority)
                cdSlidesModel.slideData = slidesModel.slideData
                cdSlidesModel.utType = slidesModel.utType
                cdSlidesModel.isSelected = slidesModel.isSelected
                cdSlidesModel.fileName = slidesModel.fileName
                cdSlidesModel.isFailed = slidesModel.isFailed
                cdSlidesModel.isDownloadCompleted = slidesModel.isDownloadCompleted
                
                processSlideModel(slidesModel: slidesModel) { imageData in
                    cdSlidesModel.imageData = imageData
                    groupDispatchGroup.leave() // Leave the group after the processing is done
                }
                
                // Add to set
                cdSlidesModels.add(cdSlidesModel)
            }
        }
        
        groupDispatchGroup.notify(queue: .main) {
            // Completion handler called when all slide models are processed
            completion(cdSlidesModels)
        }
    }
    
    

    
    func processSlideModel(slidesModel: SlidesModel, completion: @escaping (Data) -> Void) {
        
        
        // Process each grouped slide model in the inner loop
        let groupDispatchGroup = DispatchGroup()
        
        var imagedata: Data?
       
        
        let data = slidesModel.slideData
        let utType = slidesModel.utType
        
        groupDispatchGroup.enter()
        ObjectFormatter.shared.loadImageDataInBackground(utType: utType, data: data) { data in
            // Update the model with the retrieved image data
            
            imagedata = data
            groupDispatchGroup.leave()
        
        }
        
        groupDispatchGroup.notify(queue: .main) {
            // Move to the next slide model after all inner loop tasks are completed
        
            completion(imagedata ?? data)
        }
    }
    
    
    
    
    
    /// function fetches core data objet and returns as codable objet
    /// - Returns: object of type [SavedPresentation]
    func retriveSavedPresentations(completion: @escaping ([SavedPresentation]) -> ())  {
        //-> [SavedPresentation]
        var savePresentationArr = [SavedPresentation]()
        
        CoreDataManager.shared.fetchPresentations { savedCDPresentationArr in
            savedCDPresentationArr.forEach { aSavedCDPresentation in
                let aSavedPresentation = SavedPresentation()
           
                aSavedPresentation.name = aSavedCDPresentation.name ?? ""
                var groupedBrandsSlideModelArr = [GroupedBrandsSlideModel]()
                
                if let groupedBrandsSlideModelSet = aSavedCDPresentation.groupedBrandsSlideModel as? Set<GroupedBrandsSlideCDModel> {
                       let groupedBrandsSlideModelArray = Array(groupedBrandsSlideModelSet)
                    groupedBrandsSlideModelArray.forEach { aGroupedBrandsSlideCDModel in
                      
                        let groupedBrandsSlideModel = GroupedBrandsSlideModel()
                        groupedBrandsSlideModel.id = Int(aGroupedBrandsSlideCDModel.id)
                        groupedBrandsSlideModel.subdivisionCode = Int(aGroupedBrandsSlideCDModel.subdivisionCode)
                        groupedBrandsSlideModel.productBrdCode = Int(aGroupedBrandsSlideCDModel.productBrdCode)
                        groupedBrandsSlideModel.divisionCode = Int(aGroupedBrandsSlideCDModel.divisionCode)
                        groupedBrandsSlideModel.priority = Int(aGroupedBrandsSlideCDModel.priority)
                        
                        var groupedSlideArr = [SlidesModel]()
                        if let  groupedSlideModelSet = aGroupedBrandsSlideCDModel.groupedSlide as? Set<SavedSlidesCDModel>  {
                            let groupedBrandsSlideModelArray = Array(groupedSlideModelSet)
                            groupedBrandsSlideModelArray.forEach { slidesCDModel in
                                let agroupedSlide = SlidesModel()
                                agroupedSlide.code = Int(slidesCDModel.code)
                                agroupedSlide.camp = Int(slidesCDModel.camp)
                                agroupedSlide.productDetailCode = slidesCDModel.productDetailCode ?? ""
                                agroupedSlide.filePath = slidesCDModel.filePath ?? ""
                                agroupedSlide.group = Int(slidesCDModel.group)
                                agroupedSlide.specialityCode = slidesCDModel.specialityCode ?? ""
                                agroupedSlide.slideId = Int(slidesCDModel.slideId)
                                agroupedSlide.fileType = slidesCDModel.fileType ?? ""
                                agroupedSlide.categoryCode = slidesCDModel.categoryCode ?? ""
                                agroupedSlide.name = slidesCDModel.name ?? ""
                                agroupedSlide.noofSamples = Int(slidesCDModel.noofSamples)
                                agroupedSlide.ordNo = Int(slidesCDModel.ordNo)
                                agroupedSlide.priority = Int(slidesCDModel.priority)
                                agroupedSlide.slideData = slidesCDModel.slideData ?? Data()
                                agroupedSlide.utType = slidesCDModel.utType ?? ""
                                agroupedSlide.isSelected = slidesCDModel.isSelected
                                agroupedSlide.isFailed = slidesCDModel.isFailed
                                agroupedSlide.isDownloadCompleted = slidesCDModel.isDownloadCompleted
                                agroupedSlide.index = Int(slidesCDModel.index)
                                agroupedSlide.imageData = slidesCDModel.imageData ?? Data()
                                groupedSlideArr.append(agroupedSlide)
                            }
                            groupedSlideArr = groupedSlideArr.sorted { $0.priority < $1.priority }
                            groupedBrandsSlideModel.groupedSlide = groupedSlideArr
                            
                        }
                        groupedBrandsSlideModelArr.append(groupedBrandsSlideModel)
                    }
                   }
                groupedBrandsSlideModelArr = groupedBrandsSlideModelArr.sorted {$0.priority < $1.priority }
                aSavedPresentation.groupedBrandsSlideModel = groupedBrandsSlideModelArr
                savePresentationArr.append(aSavedPresentation)
            }
        }
        completion (savePresentationArr)
        //return savePresentationArr
    }
    // MARK: - functionalities for presentation flow Ends
}




extension CoreDataManager {
    

    func fetchGroupedSlides(completion: ([GroupedBrandsSlideCDModel]) -> () )  {
        do {
           let savedGroupedSlides = try  context.fetch(GroupedBrandsSlideCDModel.fetchRequest())
            completion(savedGroupedSlides )
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    
    

    
    
    func retriveGroupedSlides() -> [GroupedBrandsSlideModel] {
        
        var savePresentationArr = [GroupedBrandsSlideModel]()
        
        CoreDataManager.shared.fetchGroupedSlides { groupedBrandsArr in
            groupedBrandsArr.forEach { agroupedBrands in
                let aGroupedBrandsSlideModel = GroupedBrandsSlideModel()
                aGroupedBrandsSlideModel.uuid = agroupedBrands.uuid ?? UUID()
                aGroupedBrandsSlideModel.id = Int(agroupedBrands.id)
                aGroupedBrandsSlideModel.divisionCode = Int(agroupedBrands.divisionCode)
                aGroupedBrandsSlideModel.priority = Int(agroupedBrands.priority)
                aGroupedBrandsSlideModel.productBrdCode = Int(agroupedBrands.productBrdCode)
                aGroupedBrandsSlideModel.subdivisionCode = Int(agroupedBrands.subdivisionCode)

                var groupedSlideArr = [SlidesModel]()
                if let  groupedSlideModelSet = agroupedBrands.groupedSlide as? Set<SlidesCDModel>  {
                    let groupedBrandsSlideModelArray = Array(groupedSlideModelSet)
                    groupedBrandsSlideModelArray.forEach { slidesCDModel in
                        let agroupedSlide = SlidesModel()
                        agroupedSlide.code = Int(slidesCDModel.code)
                        agroupedSlide.camp = Int(slidesCDModel.camp)
                        agroupedSlide.productDetailCode = slidesCDModel.productDetailCode ?? ""
                        agroupedSlide.filePath = slidesCDModel.filePath ?? ""
                        agroupedSlide.group = Int(slidesCDModel.group)
                        agroupedSlide.specialityCode = slidesCDModel.specialityCode ?? ""
                        agroupedSlide.slideId = Int(slidesCDModel.slideId)
                        agroupedSlide.fileType = slidesCDModel.fileType ?? ""
                        agroupedSlide.categoryCode = slidesCDModel.categoryCode ?? ""
                        agroupedSlide.name = slidesCDModel.name ?? ""
                        agroupedSlide.noofSamples = Int(slidesCDModel.noofSamples)
                        agroupedSlide.ordNo = Int(slidesCDModel.ordNo)
                        agroupedSlide.priority = Int(slidesCDModel.priority)
                        agroupedSlide.slideData = slidesCDModel.slideData ?? Data()
                        agroupedSlide.utType = slidesCDModel.utType ?? ""
                        agroupedSlide.isSelected = slidesCDModel.isSelected
                        agroupedSlide.fileName = slidesCDModel.fileName ?? ""
                        agroupedSlide.isFailed = slidesCDModel.isFailed
                        agroupedSlide.isDownloadCompleted = slidesCDModel.isDownloadCompleted
                        groupedSlideArr.append(agroupedSlide)
                    }
                    
                    aGroupedBrandsSlideModel.groupedSlide = groupedSlideArr
                    
                }
                
                savePresentationArr.append(aGroupedBrandsSlideModel)
            }
        }
        
        return savePresentationArr
    }
    
    
    func toCheckGeneralGroupedSlidesExistance(_ productBrdCode: Int, completion: (Bool) -> ()) {
        
        do {
            let request = GeneralSlideGroupsCDModel.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "productBrdCode == '\(productBrdCode)'")
         
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    func toCheckGroupedSlidesExistance(_ id: UUID, completion: (Bool) -> ()) {
        
        do {
            let request = GroupedBrandsSlideCDModel.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "uuid == '\(id)'")
            //LIKE
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }

    func removeAllGroupedSlidesCDModel() {
        let fetchRequest: NSFetchRequest<GroupedSlidesCDModel> = NSFetchRequest(entityName: "GroupedSlidesCDModel")

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
    
    
    func removeAllGroupedSlides() {
        let fetchRequest: NSFetchRequest<GroupedBrandsSlideCDModel> = NSFetchRequest(entityName: "GroupedBrandsSlideCDModel")

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
    
//    
//    func removeAllGroupedSlides() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GroupedBrandsSlideCDModel.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//           // completion()
//        } catch {
//            print("Error deleting slide brands: \(error)")
//          //  completion()
//        }
//    }
    
    func toRemoveAllCacheJointWorks() {
      
        let fetchRequest:  NSFetchRequest<CacheJointworks> = NSFetchRequest(entityName: "CacheJointworks")
       // let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let Jointworks = try context.fetch(fetchRequest)
            for Jointwork in Jointworks {
                context.delete(Jointwork)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
    func removeSpecificJointWork(jointWorkCode: String, completion: @escaping (Bool) -> Void) {
        do {
            let cacheJointWorks = try context.fetch(CacheJointworks.fetchRequest())
            guard let cacheJointWork = cacheJointWorks.first else {
                completion(false)
                return
            }

            if let jointworksSet = cacheJointWork.jointworks as? NSMutableSet {
                // Find the joint work with the specified code
                if let jointWorkToRemove = (jointworksSet.filter { ($0 as? JointWork)?.code == jointWorkCode }).first as? JointWork {
                    jointworksSet.remove(jointWorkToRemove)
                    
                    // Save the context to persist changes
                    try context.save()
                    completion(true)
                } else {
                    completion(false) // Joint work with the specified code not found
                }
            } else {
                completion(false) // Joint works set is nil or of unexpected type
            }
        } catch {
            print("Error removing joint work with code \(jointWorkCode): \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchCacheJointWorks(completion: @escaping([JointWork]?)->()) {
        
        do {
           let cacheJointWorks = try  context.fetch(CacheJointworks.fetchRequest())
            guard let cacheJointWork = cacheJointWorks.first else {
                completion(nil)
                return
            }
            
            if let jointworksSet = cacheJointWork.jointworks,
               let jointworksArray = jointworksSet.allObjects as? [JointWork] {
                completion(jointworksArray)
            } else {
                completion(nil)
            }
          
            
        } catch {
            print("unable to fetch movies")
        }
        
    }
    
    func toSaveJointworks(jointWorks: [JointWork], completion: @escaping(Bool) -> Void) {
   
            let context = self.context
            // Create a new managed object
            if let entityDescription = NSEntityDescription.entity(forEntityName: "CacheJointworks", in: context) {
                let cacheJointworkEntity = CacheJointworks(entity: entityDescription, insertInto: context)
                let cdJointWorksSets = NSMutableSet()
                jointWorks.forEach { aJointWork in
                    
                    if let entityDescription = NSEntityDescription.entity(forEntityName: "JointWork", in: context) {
                        let jointWorkEntity = JointWork(entity: entityDescription, insertInto: context)
                        jointWorkEntity.name =  aJointWork.name
                        jointWorkEntity.code =  aJointWork.code
                        jointWorkEntity.actFlg =  aJointWork.actFlg
                        jointWorkEntity.desig =  aJointWork.desig
                        jointWorkEntity.divisionCode =  aJointWork.divisionCode
                        jointWorkEntity.index =  aJointWork.index
                        jointWorkEntity.mapId =  aJointWork.mapId
                        jointWorkEntity.ownDiv =  aJointWork.ownDiv
                        jointWorkEntity.reportingToSF =  aJointWork.reportingToSF
                        jointWorkEntity.sfName =  aJointWork.sfName
                        jointWorkEntity.sfName =  aJointWork.sfName
                        jointWorkEntity.sfStatus =  aJointWork.sfStatus
                        jointWorkEntity.sfType =  aJointWork.sfType
                        jointWorkEntity.steps =  aJointWork.steps
                        jointWorkEntity.usrDfdUserName =  aJointWork.usrDfdUserName
                        
                        cdJointWorksSets.add(jointWorkEntity)
                        
                    }
                }
                
                cacheJointworkEntity.jointworks = cdJointWorksSets
                
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save to Core Data: \(error)")
                    completion(false)
                }
            }
            
  
    }
    
    
    
    func toSaveGroupedSlidesToCoreData(groupedBrandSlide: GroupedBrandsSlideModel, completion: @escaping (Bool) -> ()) {
        toCheckGroupedSlidesExistance(groupedBrandSlide.uuid) { isExists in
            if !isExists {
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "GroupedBrandsSlideCDModel", in: context) {
                    let GroupedBrandsSlides = GroupedBrandsSlideCDModel(entity: entityDescription, insertInto: context)

                    // Convert properties
                    GroupedBrandsSlides.uuid = groupedBrandSlide.uuid
                    GroupedBrandsSlides.divisionCode = Int16(groupedBrandSlide.divisionCode)
                    GroupedBrandsSlides.priority = Int16(groupedBrandSlide.priority)
                    GroupedBrandsSlides.productBrdCode = Int16(groupedBrandSlide.productBrdCode)
                    GroupedBrandsSlides.subdivisionCode = Int16(groupedBrandSlide.subdivisionCode)

                    // Convert and add groupedBrandsSlideModel
                    convertToSlidesCDModel(groupedBrandSlide.groupedSlide, context: context) { groupedSlide in
                        GroupedBrandsSlides.groupedSlide = groupedSlide

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
            } else {
                completion(false)
            }
        }
    }
}


extension CoreDataManager {
    // MARK: - functionalities for slides flow
    func toCheckSlideExistance(_ id: UUID, completion: (Bool) -> ()) {
        
        do {
            let request = SlidesCDModel.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "uuid == '\(id)'")
            //LIKE
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }

    
    func toCheckBrandExistance(_ productBrdCode: Int, completion: (Bool) -> ()) {
        
        do {
            let request = SlideBrand.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "productBrandCode == '\(productBrdCode)'")
            //LIKE
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }

    
    func fetchBarndSlides(completion: ([SlideBrand]) -> () )  {
        do {
           let savedSlideBrand = try  context.fetch(SlideBrand.fetchRequest())
            completion(savedSlideBrand)
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    func removeAllSlideBrands() {
        let fetchRequest: NSFetchRequest<SlideBrand> = NSFetchRequest(entityName: "SlideBrand")

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
    
//    func removeAllSlideBrands() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SlideBrand.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//           // completion()
//        } catch {
//            print("Error deleting slide brands: \(error)")
//          //  completion()
//        }
//    }
    
    
    func removeAllSavedSlides() {
        let fetchRequest: NSFetchRequest<SavedSlidesCDModel> = NSFetchRequest(entityName: "SavedSlidesCDModel")

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
    
//    func removeAllSavedSlides() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedSlidesCDModel.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//           // completion()
//        } catch {
//            print("Error deleting slide brands: \(error)")
//          //  completion()
//        }
//    }
    
    
    func removeAllSlides(completion: @escaping(Bool) -> Void) {
        let fetchRequest: NSFetchRequest<SlidesCDModel> = NSFetchRequest(entityName: "SlidesCDModel")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
            completion(true)
        } catch {
            print("Error deleting slide brands: \(error)")
            completion(false)
        }
    }
    
//    func removeAllSlides() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SlidesCDModel.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
//           // completion()
//        } catch {
//            print("Error deleting slide brands: \(error)")
//          //  completion()
//        }
//    }
    
    
    
    
    func fetchSlides(completion: ([SlidesCDModel]) -> () )  {
        do {
           let savedSlides = try  context.fetch(SlidesCDModel.fetchRequest())
            completion(savedSlides)
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    func updateSlidesInCoreData(savedSlides: SlidesModel, completion: @escaping (Bool) -> ()) {
        let context = self.context

        // Fetch the existing SlidesCDModel using the uuid
        let fetchRequest: NSFetchRequest<SlidesCDModel> = SlidesCDModel.fetchRequest()
      
        fetchRequest.predicate = NSPredicate(format: "code == %ld", savedSlides.code)

        do {
            if let savedCDSlide = try context.fetch(fetchRequest).first {
                print("SlidesCDModel with name \(savedSlides.name) found will be updated.")
                // Update properties
                savedCDSlide.code              =         Int16(savedSlides.code)
                savedCDSlide.camp              =         Int16(savedSlides.camp)
                savedCDSlide.productDetailCode =         savedSlides.productDetailCode
                savedCDSlide.filePath          =         savedSlides.filePath
                savedCDSlide.group             =         Int16(savedSlides.group)
                savedCDSlide.specialityCode    =         savedSlides.specialityCode
                savedCDSlide.slideId           =         Int16(savedSlides.slideId)
                savedCDSlide.fileType          =         savedSlides.fileType
               // savedCDSlide.effFrom           =         savedSlides.effFrom
                savedCDSlide.categoryCode      =         savedSlides.categoryCode
                savedCDSlide.name              =         savedSlides.name
                savedCDSlide.noofSamples       =         Int16(savedSlides.noofSamples)
               // savedCDSlide.effTo             =         savedSlides.effTo
                savedCDSlide.ordNo             =         Int16(savedSlides.ordNo)
                savedCDSlide.priority          =         Int16(savedSlides.priority)
                savedCDSlide.slideData         =         savedSlides.slideData
                savedCDSlide.utType            =         savedSlides.utType
                savedCDSlide.isSelected        =         savedSlides.isSelected
                savedCDSlide.uuid              =         savedSlides.uuid
                savedCDSlide.fileName = savedSlides.fileName
                savedCDSlide.isDownloadCompleted = savedSlides.isDownloadCompleted
                savedCDSlide.isFailed = savedSlides.isFailed
                // Update other properties...

                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save updated object to Core Data: \(error)")
                    completion(false)
                }
            } else {
                // Handle case when the object with the specified uuid is not found
                print("SlidesCDModel with uuid \(savedSlides.uuid) not found.")
                saveSlidesToCoreData(savedSlides: savedSlides) { completed in
                    completion(completed)
                }
                
            }
        } catch {
            print("Error fetching SlidesCDModel: \(error)")
            completion(false)
        }
    }

    
    func saveSlidesToCoreData(savedSlides: SlidesModel  , completion: (Bool) -> ()) {
        toCheckSlideExistance(savedSlides.uuid) { isExists in
            if !isExists {
                let context = self.context
                
                if let entityDescription = NSEntityDescription.entity(forEntityName: "SlidesCDModel", in: context) {
                    let savedCDSlide = SlidesCDModel(entity: entityDescription, insertInto: context)

                    // Convert properties
         
                    savedCDSlide.code              =         Int16(savedSlides.code)
                    savedCDSlide.camp              =         Int16(savedSlides.camp)
                    savedCDSlide.productDetailCode =         savedSlides.productDetailCode
                    savedCDSlide.filePath          =         savedSlides.filePath
                    savedCDSlide.group             =         Int16(savedSlides.group)
                    savedCDSlide.specialityCode    =         savedSlides.specialityCode
                    savedCDSlide.slideId           =         Int16(savedSlides.slideId)
                    savedCDSlide.fileType          =         savedSlides.fileType
                   // savedCDSlide.effFrom           =         savedSlides.effFrom
                    savedCDSlide.categoryCode      =         savedSlides.categoryCode
                    savedCDSlide.name              =         savedSlides.name
                    savedCDSlide.noofSamples       =         Int16(savedSlides.noofSamples)
                   // savedCDSlide.effTo             =         savedSlides.effTo
                    savedCDSlide.ordNo             =         Int16(savedSlides.ordNo)
                    savedCDSlide.priority          =         Int16(savedSlides.priority)
                    savedCDSlide.slideData         =         savedSlides.slideData
                    savedCDSlide.utType            =         savedSlides.utType
                    savedCDSlide.isSelected        =         savedSlides.isSelected
                    savedCDSlide.uuid              =         savedSlides.uuid
                    savedCDSlide.fileName = savedSlides.fileName
                    savedCDSlide.isDownloadCompleted = savedSlides.isDownloadCompleted
                    savedCDSlide.isFailed = savedSlides.isFailed

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
                
            }
        }
    }
    
    
    
    func saveBrandSlidesToCoreData(savedBrandSlides: BrandSlidesModel  , completion: (Bool) -> ()) {
        toCheckBrandExistance(savedBrandSlides.productBrdCode) { isExists in
            if !isExists {
                let context = self.context
                
                if let entityDescription = NSEntityDescription.entity(forEntityName: "SlideBrand", in: context) {
                    let savedCDSlideBrands = SlideBrand(entity: entityDescription, insertInto: context)

                    // Convert properties
                    savedCDSlideBrands.uuid = savedBrandSlides.uuid
                    savedCDSlideBrands.priority = String(savedBrandSlides.priority)
                    savedCDSlideBrands.divisionCode = String(savedBrandSlides.divisionCode)
                    savedCDSlideBrands.id =  String(savedBrandSlides.id)
                    savedCDSlideBrands.productBrandCode = String(savedBrandSlides.productBrdCode)
                    savedCDSlideBrands.subDivisionCode = String(savedBrandSlides.subdivisionCode)
                

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
                
            }
        }
    }
    
    

    
    func retriveSavedSlides() -> [SlidesModel] {
        
        var saveSlidesArr = [SlidesModel]()
        
        CoreDataManager.shared.fetchSlides { savedCDSlides in
            
            savedCDSlides.forEach { aSavedCDPresentation in
                let asaveSlide = SlidesModel()
                asaveSlide.code              =     Int(aSavedCDPresentation.code)
                asaveSlide.camp              =     Int(aSavedCDPresentation.camp)
                asaveSlide.productDetailCode =     aSavedCDPresentation.productDetailCode ?? ""
                asaveSlide.filePath          =     aSavedCDPresentation.filePath ?? ""
                asaveSlide.group             =     Int(aSavedCDPresentation.group)
                asaveSlide.specialityCode    =     aSavedCDPresentation.specialityCode ?? ""
                asaveSlide.slideId           =     Int(aSavedCDPresentation.slideId)
                asaveSlide.fileType          =     aSavedCDPresentation.fileType ?? ""
               // asaveSliderr.effFrom           =   aSavedCDPresentationides.effFrom
                asaveSlide.categoryCode      =     aSavedCDPresentation.categoryCode ?? ""
                asaveSlide.name              =     aSavedCDPresentation.name ?? ""
                asaveSlide.noofSamples       =     Int(aSavedCDPresentation.noofSamples)
               //asaveSliderr.effTo             =   aSavedCDPresentationides.effTo
                asaveSlide.ordNo             =     Int(aSavedCDPresentation.ordNo)
                asaveSlide.priority          =     Int(aSavedCDPresentation.priority)
                asaveSlide.slideData         =     aSavedCDPresentation.slideData ?? Data()
                asaveSlide.utType            =     aSavedCDPresentation.utType ?? ""
                asaveSlide.isSelected        =     aSavedCDPresentation.isSelected
                asaveSlide.uuid              =     aSavedCDPresentation.uuid ?? UUID()
                asaveSlide.isFailed = aSavedCDPresentation.isFailed
                asaveSlide.isDownloadCompleted = aSavedCDPresentation.isDownloadCompleted
                saveSlidesArr.append(asaveSlide)
                
            }

        }
        
       return saveSlidesArr
    }
    
    
    func retriveSavedBrandSlides() -> [BrandSlidesModel] {
        
        var saveSlidesArr = [BrandSlidesModel]()
        
        CoreDataManager.shared.fetchBarndSlides{ SlideBrands in
            SlideBrands.forEach { aSlideBrand in
                let asaveSlide = BrandSlidesModel()
                asaveSlide.uuid = aSlideBrand.uuid ?? UUID()
                asaveSlide.priority = Int(aSlideBrand.priority ?? "0") ?? 0
                asaveSlide.divisionCode = Int(aSlideBrand.divisionCode ?? "0") ?? 0
                asaveSlide.id =   Int(aSlideBrand.id ?? "0") ?? 0
                asaveSlide.productBrdCode =  Int(aSlideBrand.productBrandCode ?? "0") ?? 0
                asaveSlide.subdivisionCode = Int(aSlideBrand.subDivisionCode ?? "0") ?? 0
                saveSlidesArr.append(asaveSlide)
            }
 
        }
        
       return saveSlidesArr
    }
    // MARK: - functionalities for slides flow Ends
}

extension CoreDataManager {
    func toSaveGeneralGroupedSlidesToCoreData(groupedBrandSlide: GroupedBrandsSlideModel, completion: @escaping (Bool) -> ()) {
        toCheckGeneralGroupedSlidesExistance(groupedBrandSlide.productBrdCode) { isExists in
            if !isExists {
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "GeneralSlideGroupsCDModel", in: context) {
                    let GroupedBrandsSlides = GeneralSlideGroupsCDModel(entity: entityDescription, insertInto: context)
                    
                    // Convert properties
                    GroupedBrandsSlides.uuid = groupedBrandSlide.uuid
                    GroupedBrandsSlides.divisionCode = Int16(groupedBrandSlide.divisionCode)
                    GroupedBrandsSlides.priority = Int16(groupedBrandSlide.priority)
                    GroupedBrandsSlides.productBrdCode = Int16(groupedBrandSlide.productBrdCode)
                    GroupedBrandsSlides.subdivisionCode = Int16(groupedBrandSlide.subdivisionCode)
                    
                    // Convert and add groupedBrandsSlideModel
                    convertToSlidesCDModel(groupedBrandSlide.groupedSlide, context: context) { groupedSlide in
                        GroupedBrandsSlides.groupedSlide = groupedSlide
                        
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
            } else {
                completion(false)
            }
        }
    }
    
    
    func removeAllGeneralGroupedSlides() {
        let fetchRequest: NSFetchRequest<GeneralSlideGroupsCDModel> = NSFetchRequest(entityName: "GeneralSlideGroupsCDModel")

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
    
    
//    func removeAllGeneralGroupedSlides() {
//        //completion: @escaping () -> Void
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GeneralSlideGroupsCDModel.fetchRequest()
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

    func toCheckGeneralGroupedSlidesExistance(_ id: UUID, completion: (Bool) -> ()) {
        
        do {
            let request = GeneralSlideGroupsCDModel.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "uuid == '\(id)'")
            //LIKE
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    
    func retriveSavedGeneralGroupedSlides() -> [GroupedBrandsSlideModel] {
        
        var savePresentationArr = [GroupedBrandsSlideModel]()
        
        CoreDataManager.shared.fetchGeneralGroupedSlides { groupedBrandsArr in
            groupedBrandsArr.forEach { agroupedBrands in
                let aGroupedBrandsSlideModel = GroupedBrandsSlideModel()
                aGroupedBrandsSlideModel.uuid = agroupedBrands.uuid ?? UUID()
                aGroupedBrandsSlideModel.id = Int(agroupedBrands.id)
                aGroupedBrandsSlideModel.divisionCode = Int(agroupedBrands.divisionCode)
                aGroupedBrandsSlideModel.priority = Int(agroupedBrands.priority)
                aGroupedBrandsSlideModel.productBrdCode = Int(agroupedBrands.productBrdCode)
                aGroupedBrandsSlideModel.subdivisionCode = Int(agroupedBrands.subdivisionCode)

                var groupedSlideArr = [SlidesModel]()
                if let  groupedSlideModelSet = agroupedBrands.groupedSlide as? Set<SavedSlidesCDModel>  {
                    let groupedBrandsSlideModelArray = Array(groupedSlideModelSet)
                    groupedBrandsSlideModelArray.forEach { slidesCDModel in
                        let agroupedSlide = SlidesModel()
                        agroupedSlide.code = Int(slidesCDModel.code)
                        agroupedSlide.camp = Int(slidesCDModel.camp)
                        agroupedSlide.productDetailCode = slidesCDModel.productDetailCode ?? ""
                        agroupedSlide.filePath = slidesCDModel.filePath ?? ""
                        agroupedSlide.group = Int(slidesCDModel.group)
                        agroupedSlide.specialityCode = slidesCDModel.specialityCode ?? ""
                        agroupedSlide.slideId = Int(slidesCDModel.slideId)
                        agroupedSlide.fileType = slidesCDModel.fileType ?? ""
                        agroupedSlide.categoryCode = slidesCDModel.categoryCode ?? ""
                        agroupedSlide.name = slidesCDModel.name ?? ""
                        agroupedSlide.noofSamples = Int(slidesCDModel.noofSamples)
                        agroupedSlide.ordNo = Int(slidesCDModel.ordNo)
                        agroupedSlide.priority = Int(slidesCDModel.priority)
                        agroupedSlide.slideData = slidesCDModel.slideData ?? Data()
                        agroupedSlide.utType = slidesCDModel.utType ?? ""
                        agroupedSlide.isSelected = slidesCDModel.isSelected
                        agroupedSlide.fileName = slidesCDModel.fileName ?? ""
                        agroupedSlide.isFailed = slidesCDModel.isFailed
                        agroupedSlide.isDownloadCompleted = slidesCDModel.isDownloadCompleted
                        groupedSlideArr.append(agroupedSlide)
                    }
                    
                    aGroupedBrandsSlideModel.groupedSlide = groupedSlideArr
                    
                }
                
                savePresentationArr.append(aGroupedBrandsSlideModel)
            }
        }
        
        return savePresentationArr
    }
    
    
    
    
    
    func retriveGeneralGroupedSlides() -> [GroupedBrandsSlideModel] {
        
        var savePresentationArr = [GroupedBrandsSlideModel]()
        
        CoreDataManager.shared.fetchGeneralGroupedSlides { groupedBrandsArr in
            groupedBrandsArr.forEach { agroupedBrands in
                let aGroupedBrandsSlideModel = GroupedBrandsSlideModel()
                aGroupedBrandsSlideModel.uuid = agroupedBrands.uuid ?? UUID()
                aGroupedBrandsSlideModel.id = Int(agroupedBrands.id)
                aGroupedBrandsSlideModel.divisionCode = Int(agroupedBrands.divisionCode)
                aGroupedBrandsSlideModel.priority = Int(agroupedBrands.priority)
                aGroupedBrandsSlideModel.productBrdCode = Int(agroupedBrands.productBrdCode)
                aGroupedBrandsSlideModel.subdivisionCode = Int(agroupedBrands.subdivisionCode)

                var groupedSlideArr = [SlidesModel]()
                if let  groupedSlideModelSet = agroupedBrands.groupedSlide as? Set<GroupedSlidesCDModel>  {
                    let groupedBrandsSlideModelArray = Array(groupedSlideModelSet)
                    groupedBrandsSlideModelArray.forEach { slidesCDModel in
                        let agroupedSlide = SlidesModel()
                        agroupedSlide.code = Int(slidesCDModel.code)
                        agroupedSlide.camp = Int(slidesCDModel.camp)
                        agroupedSlide.productDetailCode = slidesCDModel.productDetailCode ?? ""
                        agroupedSlide.filePath = slidesCDModel.filePath ?? ""
                        agroupedSlide.group = Int(slidesCDModel.group)
                        agroupedSlide.specialityCode = slidesCDModel.specialityCode ?? ""
                        agroupedSlide.slideId = Int(slidesCDModel.slideId)
                        agroupedSlide.fileType = slidesCDModel.fileType ?? ""
                        agroupedSlide.categoryCode = slidesCDModel.categoryCode ?? ""
                        agroupedSlide.name = slidesCDModel.name ?? ""
                        agroupedSlide.noofSamples = Int(slidesCDModel.noofSamples)
                        agroupedSlide.ordNo = Int(slidesCDModel.ordNo)
                        agroupedSlide.priority = Int(slidesCDModel.priority)
                        agroupedSlide.slideData = slidesCDModel.slideData ?? Data()
                        agroupedSlide.utType = slidesCDModel.utType ?? ""
                        agroupedSlide.isSelected = slidesCDModel.isSelected
                        agroupedSlide.fileName = slidesCDModel.fileName ?? ""
                        agroupedSlide.isFailed = slidesCDModel.isFailed
                        agroupedSlide.isDownloadCompleted = slidesCDModel.isDownloadCompleted
                        agroupedSlide.imageData = slidesCDModel.imageData ?? Data()
                        groupedSlideArr.append(agroupedSlide)
                    }
                    groupedSlideArr = groupedSlideArr.sorted { $0.priority < $1.priority }
                    aGroupedBrandsSlideModel.groupedSlide = groupedSlideArr
                    
                }
              
                savePresentationArr.append(aGroupedBrandsSlideModel)
            }
        }
        savePresentationArr = savePresentationArr.sorted { $0.priority <  $1.priority }
        return savePresentationArr
    }
    
    func fetchGeneralGroupedSlides(completion: ([GeneralSlideGroupsCDModel]) -> () )  {
        do {
           let savedGroupedSlides = try  context.fetch(GeneralSlideGroupsCDModel.fetchRequest())
            completion(savedGroupedSlides )
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
}
///tosave DCRdates
extension CoreDataManager {
    
    func fetchDcrDates(completion: @escaping ([DcrDates]) -> Void) {
        let fetchRequest: NSFetchRequest<DcrDates> = DcrDates.fetchRequest()

        do {
            let dcrDates = try context.fetch(fetchRequest)
            completion(dcrDates)
        } catch {
            print("Failed to fetch DcrDates: \(error)")
            completion([])
        }
    }
    
    func removeAllDcrDates() {
        let fetchRequest: NSFetchRequest<DcrDates> = NSFetchRequest(entityName: "DcrDates")

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
    
    
//    func removeaDcrDate(date: Date, completion: () -> ()) {
//        let fetchRequest: NSFetchRequest<DcrDates> = NSFetchRequest(entityName: "DcrDates")
//        do {
//            let dcrDates = try context.fetch(fetchRequest)
//            for dcrDate in dcrDates {
//                let cacheDate = dcrDate.date
//                let toRemoveDate = date.toString(format:  "yyyy-MM-dd")
//                
//                if cacheDate == toRemoveDate {
//                    dcrDate.isDateAdded = true
//                }
//            }
//            try context.save()
//            completion()
//        } catch {
//            print("Error deleting dcr Date: \(error)")
//            completion()
//        }
//    }
    
    func removeDcrDate(date: Date, completion: @escaping () -> ()) {
        let fetchRequest: NSFetchRequest<DcrDates> = DcrDates.fetchRequest()
        
        context.perform {
            self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            do {
                let dcrDates = try self.context.fetch(fetchRequest)
               
                for dcrDate in dcrDates {
                    let cacheDate = dcrDate.date
                    let toRemoveDate = date.toString(format:  "yyyy-MM-dd")
                    
                    if cacheDate == toRemoveDate {
                        dcrDate.isDateAdded = true
                    }
                }
                
                try self.context.save()
                completion()
            } catch {
                print("Error deleting dcr Date: \(error)")
                completion()
            }
        }
    }
    
    func saveDatestoCoreData(model: [DCRdatesModel], completion: @escaping () -> ()) {
       // guard let dcrDates = dcrDates else {return}
        CoreDataManager.shared.removeAllDcrDates()
        
        
        let filteredArr = model.filter { $0.flg == 0 || ($0.flg == 1 && $0.tbname != "leave") ||  $0.flg == 2 || $0.flg == 3 }
    
        
        CoreDataManager.shared.saveDCRDates(fromDcrModel: filteredArr) { [weak self] in

            guard let welf = self else {return}
            welf.tpAppendToday() {
                completion()
            }
            
        }
    }
    
    func tpAppendToday(completion : @escaping () -> ()) {

            let todaySyncedDate = DBManager.shared.getHomeData().filter { $0.dcr_dt == Date().toString(format: "yyyy-MM-dd") && $0.dayStatus == "1" }
            let todayUnSyncedDate  = DBManager.shared.geUnsyncedtHomeData()
            var isUnsyncedIsEmpty: Bool = false
            if let todayUnSyncedDate = todayUnSyncedDate {
                
                isUnsyncedIsEmpty =  todayUnSyncedDate.filter { $0.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss").toString(format: "yyyy-MM-dd") == Date().toString(format: "yyyy-MM-dd") && $0.dayStatus == "1" }.count == 0 ? true : false
                
            }
            if todaySyncedDate.isEmpty && isUnsyncedIsEmpty {
                let toDayDCR : DCRdatesModel =  DCRdatesModel()
                let dt: Dt = Dt()
                dt.date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
                dt.timezone = "Asia/Kolkata"
                dt.timezoneType = 3
                toDayDCR.dt = dt
                toDayDCR.editFlag = String()
                toDayDCR.flg = Int()
                toDayDCR.sfCode = String()
                toDayDCR.tbname = String()
                
                self.saveDCRDates(model: toDayDCR) {
                    completion()
                }
                
            } else {
                
                CoreDataManager.shared.fetchDcrDates { dcrDates in
                    if dcrDates.isEmpty {
                        completion()
                        return
                    }
                    let toDayDates = dcrDates.filter {
                        if $0.date?.toDate(format: "yyyy-MM-dd HH:mm:ss").toString(format: "yyyy-MM-dd") ==  Date().toString(format: "yyyy-MM-dd") {
                            return true
                        }
                        return false
                    }
                    
                    CoreDataManager.shared.toFetchAllDayStatus { eachDayStatus in
                        let toDayWndupDates =  eachDayStatus.filter { $0.statusDate?.toString(format: "yyyy-MM-dd") ==  Date().toString(format: "yyyy-MM-dd") && $0.didUserWindup  }
                        
                       if toDayWndupDates.isEmpty {
                            toDayDates.forEach { $0.isDateAdded = false }
                        }
                        CoreDataManager.shared.saveContext()
                    }
                    
                  
                   
                    
                }
                
                completion()
            }
            
            
        
        
    }
    
    func saveDCRDates(fromDcrModel: [DCRdatesModel], completion: @escaping () -> Void) {
       
        iterateSaveDCRDates(fromArray: fromDcrModel, index: 0) {
            completion()
        }
    }

    private func iterateSaveDCRDates(fromArray array: [DCRdatesModel], index: Int, completion: @escaping () -> Void) {
        guard index < array.count else {
            // All dictionaries processed, call completion
            completion()
            return
        }

        saveDCRDates(model: array[index]) {
            // Move to the next dictionary in the array
            self.iterateSaveDCRDates(fromArray: array, index: index + 1, completion: completion)
        }
    }

    func saveDCRDates(model dcrModel: DCRdatesModel, completion: @escaping () -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "DcrDates", in: context) else {
            // Handle the case where entityDescription is nil
            completion()
            return
        }

        
        
        let dcrDates = DcrDates(entity: entityDescription, insertInto: context)

        dcrDates.sfcode = dcrModel.sfCode
        dcrDates.isDateAdded = false
        dcrDates.tbname = dcrModel.tbname
        dcrDates.flag = "\(dcrModel.flg)"
        dcrDates.editFlag = "\(dcrModel.editFlag)"
        dcrDates.reason = dcrModel.reason
        let dateString = dcrModel.dt.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            dcrDates.date = formattedDate
        } else {
            print("Failed to convert string to date.")
        }
        
            
            dcrDates.timeZone = dcrModel.dt.timezone
          
            dcrDates.timezoneType = "\(dcrModel.dt.timezoneType)"
        

        do {
            self.toFetchAllDayStatus { eachDayStatus in
                for aDayStatus in eachDayStatus {
                    let statusDate = aDayStatus.statusDate
                    let statusDateStr = statusDate?.toString(format: "yyyy-MM-dd")
                    
                    if statusDateStr ==  dcrDates.date  {
                        aDayStatus.didUserWindup = false
                        aDayStatus.isFinalSubmitSuccess = false
                        aDayStatus.isSynced = false
                    }
                }
            }
            
            try context.save()
            completion()
        } catch {
            print("Failed to save to Core Data: \(error)")
            completion()
        }
    }
}

//Outbox
extension CoreDataManager {
    
    
    func convertToCompetitorinfoArr(_ additionalCompetiors: [AdditionalCompetitorsInfo], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
       let additionalCompetitorSet = NSMutableSet()

       // Create a dispatch group to handle asynchronous tasks
       let dispatchGroup = DispatchGroup()

       // Iterate over each GroupedBrandsSlideModel
       for additionalCompetior in additionalCompetiors {
           dispatchGroup.enter()

           if let entityDescription = NSEntityDescription.entity(forEntityName: "AdditionalCompetitorsInfoCDModel", in: context) {
               let additionalCompetiorsCDModel = AdditionalCompetitorsInfoCDModel(entity: entityDescription, insertInto: context)
 
               additionalCompetiorsCDModel.qty = additionalCompetior.qty
               additionalCompetiorsCDModel.rate = additionalCompetior.rate
               additionalCompetiorsCDModel.remarks = additionalCompetior.remarks
               additionalCompetiorsCDModel.value = additionalCompetior.value
               
               if let entityDescription = NSEntityDescription.entity(forEntityName: "Competitor", in: context) {
                   let aCompetitor = Competitor(entity: entityDescription, insertInto: context)
                   
                   
                   aCompetitor.compName = additionalCompetior.competitor?.compName
                   aCompetitor.compProductName = additionalCompetior.competitor?.compProductName
                   aCompetitor.compProductSlNo = additionalCompetior.competitor?.compProductSlNo
                   aCompetitor.compSlNo = additionalCompetior.competitor?.compSlNo
                   aCompetitor.index = additionalCompetior.competitor?.index ?? 0
                   aCompetitor.ourProductCode = additionalCompetior.competitor?.ourProductCode
                   aCompetitor.ourProductName = additionalCompetior.competitor?.ourProductName
                   
                   additionalCompetiorsCDModel.competitor = aCompetitor
                   
                   
               }
               
               
               // Add to set
               additionalCompetitorSet.add(additionalCompetiorsCDModel)
               dispatchGroup.leave()
           }
       }

       // Notify the completion handler when all tasks in the dispatch group are complete
       dispatchGroup.notify(queue: .main) {
           completion(additionalCompetitorSet)
       }
   }
    
    func removeAllUnsyncedEventCaptures() {
        let fetchRequest: NSFetchRequest<UnsyncedEventCaptures> = NSFetchRequest(entityName: "UnsyncedEventCaptures")
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            
            try context.save()
            
        } catch {
            print("Failed to fetch or delete entities: \(error)")
            
        }
    }
    
    
    func removeUnsyncedEventCaptures(date: Date, withCustCode custCode: String, completion: @escaping (Bool) -> ()) {
        let fetchRequest: NSFetchRequest<UnsyncedEventCaptures> = UnsyncedEventCaptures.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", custCode)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                let objectDateStr = object.eventcaptureDate?.toString(format: "MMMM dd, yyyy")
                let yettoDeleteDateStr = date.toString(format: "MMMM dd, yyyy")
                if objectDateStr == yettoDeleteDateStr {
                    context.delete(object)
                }
                
            }
            
            try context.save()
            completion(true)
        } catch {
            print("Failed to fetch or delete entities: \(error)")
            completion(false)
        }
    }
    
    func toReturnEventcaptureEntity(eventCaptures: [EventCapture], completion: @escaping (EventCaptureViewModelCDEntity?) -> Void) {
        
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "EventCaptureViewModelCDEntity", in: context) {
           // dispatchGroup.enter()
            let aEventCaptureEntity = EventCaptureViewModelCDEntity(entity: entityDescription, insertInto: context)
            convertToEventcaptureArr(eventCaptures, context: context) {
                capturedEentsSet in
                    
                aEventCaptureEntity.capturedEvents = capturedEentsSet
                    completion(aEventCaptureEntity)
                }
            }



}
    
    
    
    func convertToEventcaptureArr(_ eventCaptures: [EventCapture], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let capturedEentsSet = NSMutableSet()
        
        // Create a dispatch group to handle asynchronous tasks
        let dispatchGroup = DispatchGroup()
        
        // Iterate over each GroupedBrandsSlideModel
        for eventCapture in eventCaptures {
            dispatchGroup.enter()
            
            guard let entityDescriptioncapturedEvent = NSEntityDescription.entity(forEntityName: "EventCaptureCDM", in: context)
            else {
                dispatchGroup.leave()
                continue
            }
            
            let eventCaptureCDModel = EventCaptureCDM(entity: entityDescriptioncapturedEvent, insertInto: context)
            
            if let image = eventCapture.image {
                // Convert UIImage to Data
                if let imageData = image.pngData() {
                    // Use imageData as needed (e.g., save to file, send over network)
                    eventCaptureCDModel.image = imageData
                } else {
                    print("Failed to convert UIImage to Data.")
                }
            } else {
                print("UIImage named 'exampleImage' not found.")
            }
            
           
            eventCaptureCDModel.imageDescription = eventCapture.description
            eventCaptureCDModel.imageUrl = eventCapture.imageUrl
            eventCaptureCDModel.time = eventCapture.title
            eventCaptureCDModel.timeStamp = eventCapture.timeStamp
            eventCaptureCDModel.title = eventCapture.title

            
            capturedEentsSet.add(eventCaptureCDModel)
                dispatchGroup.leave()
            
        }
        
        // Notify the completion handler when all tasks in the dispatch group are complete
        dispatchGroup.notify(queue: .main) {
            completion(capturedEentsSet)
        }
    }
    
    
    
    func toReturnDetailedSlideEntity(detailedSlides: [DetailedSlide], completion: @escaping (DetailedSlideCDEntity?) -> Void) {
        
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "DetailedSlideCDEntity", in: context) {
           // dispatchGroup.enter()
            let aDetailedSlideEntity = DetailedSlideCDEntity(entity: entityDescription, insertInto: context)
            convertToDetailedSlidesArr(detailedSlides, context: context) {
                detailedSlidesSet in
                    
                aDetailedSlideEntity.detailedSlides = detailedSlidesSet
                    completion(aDetailedSlideEntity)
                }
            }



}
    
    
    
    func convertToDetailedSlidesArr(_ detailedSlides: [DetailedSlide], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let detailedSlidesSet = NSMutableSet()
        
        // Create a dispatch group to handle asynchronous tasks
        let dispatchGroup = DispatchGroup()
        
        // Iterate over each GroupedBrandsSlideModel
        for detailedSlide in detailedSlides {
            dispatchGroup.enter()
            
            guard let entityDescriptiondetailedslide = NSEntityDescription.entity(forEntityName: "DetailedSlideCDM", in: context)
            else {
                dispatchGroup.leave()
                continue
            }
            
            let detailedslideCDModel = DetailedSlideCDM(entity: entityDescriptiondetailedslide, insertInto: context)
            
            detailedslideCDModel.brandCode = "\(detailedSlide.brandCode ?? 0)"
            detailedslideCDModel.endTime = detailedSlide.endTime
            detailedslideCDModel.isDisliked = detailedSlide.isDisliked ?? false
            detailedslideCDModel.isLiked = detailedSlide.isLiked ?? false
            detailedslideCDModel.isShared = detailedSlide.isShared ?? false
            detailedslideCDModel.remarks = detailedSlide.remarks
            detailedslideCDModel.remarksValue = detailedSlide.remarksValue ?? 0
            detailedslideCDModel.slideID =  "\(detailedSlide.slideID ?? 0)"
            detailedslideCDModel.startTime = detailedSlide.startTime
            
            if let entityDescriptionslide = NSEntityDescription.entity(forEntityName: "SlidesCDModel", in: context) {
                let slideCDModel = SlidesCDModel(entity: entityDescriptionslide, insertInto: context)
                if let aCacheSlide = detailedSlide.slidesModel {
                    
                    slideCDModel.code = Int16(aCacheSlide.code)
                    slideCDModel.camp = Int16(aCacheSlide.camp)
                    slideCDModel.productDetailCode = aCacheSlide.productDetailCode
                    slideCDModel.filePath = aCacheSlide.filePath
                    slideCDModel.group = Int16(aCacheSlide.group)
                    slideCDModel.specialityCode = aCacheSlide.specialityCode
                    slideCDModel.slideId = Int16(aCacheSlide.slideId)
                    slideCDModel.fileType = aCacheSlide.fileType
                    slideCDModel.categoryCode = aCacheSlide.categoryCode
                    slideCDModel.name = aCacheSlide.name
                    slideCDModel.noofSamples = Int16(aCacheSlide.noofSamples)
                    slideCDModel.ordNo = Int16(aCacheSlide.ordNo)
                    slideCDModel.priority = Int16(aCacheSlide.priority)
                    slideCDModel.slideData =  Data() //aCacheSlide.slideData ??
                    slideCDModel.utType = aCacheSlide.utType
                    slideCDModel.isSelected = aCacheSlide.isSelected
                    slideCDModel.isFailed = aCacheSlide.isFailed
                    slideCDModel.isDownloadCompleted = aCacheSlide.isDownloadCompleted
                    
                    detailedslideCDModel.slidesModel = slideCDModel
                }
            }
          
            
            
            detailedSlidesSet.add(detailedslideCDModel)
                dispatchGroup.leave()
            
        }
        
        // Notify the completion handler when all tasks in the dispatch group are complete
        dispatchGroup.notify(queue: .main) {
            completion(detailedSlidesSet)
        }
    }
    
    
    
    func convertToProductWithCompetitorModelArr(_ productWithCompetiors: [ProductWithCompetiors], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let productWithCompetitorSet = NSMutableSet()
        
        // Create a dispatch group to handle asynchronous tasks
        let dispatchGroup = DispatchGroup()
        
        // Iterate over each GroupedBrandsSlideModel
        for productWithCompetior in productWithCompetiors {
            dispatchGroup.enter()
            
            guard let entityDescriptionProduct = NSEntityDescription.entity(forEntityName: "ProductWithCompetiorsCDModel", in: context),
                  let entityDescriptionProductCD = NSEntityDescription.entity(forEntityName: "Product", in: context)
            else {
                dispatchGroup.leave()
                continue
            }
            
            let productWithCompetiorsCDModel = ProductWithCompetiorsCDModel(entity: entityDescriptionProduct, insertInto: context)
            let productCDModel = Product(entity: entityDescriptionProductCD, insertInto: context)
            
            productCDModel.name = productWithCompetior.addedProduct?.name
            productCDModel.actFlg = productWithCompetior.addedProduct?.actFlg
            productCDModel.cateId = productWithCompetior.addedProduct?.cateId
            productCDModel.code = productWithCompetior.addedProduct?.code
            productCDModel.divisionCode = productWithCompetior.addedProduct?.divisionCode
            productCDModel.dRate = productWithCompetior.addedProduct?.dRate
            productCDModel.index = productWithCompetior.addedProduct?.index ?? 0
            productCDModel.mapId = productWithCompetior.addedProduct?.mapId
            productCDModel.noOfSamples = productWithCompetior.addedProduct?.noOfSamples
            productCDModel.productMode = productWithCompetior.addedProduct?.productMode
            productCDModel.pSlNo = productWithCompetior.addedProduct?.pSlNo
            
            productWithCompetiorsCDModel.addedProduct = productCDModel
            
            
            // Handle competitors info
            if let competitorsInfo = productWithCompetior.competitorsInfo  {
                convertToCompetitorinfoArr(competitorsInfo, context: context) { additionalCompetitorSet in
                    productWithCompetiorsCDModel.competitorsInfoArr = additionalCompetitorSet
                    productWithCompetitorSet.add(productWithCompetiorsCDModel)
                    dispatchGroup.leave()
                }
            } else {
                productWithCompetitorSet.add(productWithCompetiorsCDModel)
                dispatchGroup.leave()
            }
        }
        
        // Notify the completion handler when all tasks in the dispatch group are complete
        dispatchGroup.notify(queue: .main) {
            completion(productWithCompetitorSet)
        }
    }
    
    func toReturnaddedProductDetailsCDEntity(addedProductDetails: ProductDetails, completion: @escaping (ProductDetailsCDModel?) -> Void) {
        
        
        
        
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "ProductDetailsCDModel", in: context) {
           // dispatchGroup.enter()
            let aProductDetailsEntity = ProductDetailsCDModel(entity: entityDescription, insertInto: context)

            // Convert properties

            aProductDetailsEntity.addedQuantity =  addedProductDetails.addedQuantity
            
            aProductDetailsEntity.addedRate = addedProductDetails.addedRate
            aProductDetailsEntity.addedTotal = addedProductDetails.addedTotal
            aProductDetailsEntity.addedValue = addedProductDetails.addedValue
          //  aProductDetailsEntity.addedProductArr =
            

            if let productsWithCompetitors = addedProductDetails.addedProduct {
                convertToProductWithCompetitorModelArr(productsWithCompetitors, context: context) {
                    productWithCompetitorSet in
                    
                    aProductDetailsEntity.addedProductArr = productWithCompetitorSet
                    completion(aProductDetailsEntity)
                }
            }
       

        } else {
            
            completion(nil)
        }


}
    
    
    func toReturnRCPAdetailsCDModel(addedRCPAdetails: RCPAdetailsModal, completion: @escaping (RCPAdetailsCDModel?) -> Void) {

            


                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "RCPAdetailsCDModel", in: context) {
                   // dispatchGroup.enter()
                    let aRCPAdetailsEntity = RCPAdetailsCDModel(entity: entityDescription, insertInto: context)

                    // Convert properties
                    if let entityDescription = NSEntityDescription.entity(forEntityName: "Chemist", in: context) {
                        let aChemist = Chemist(entity: entityDescription, insertInto: context)
                        aChemist.addr = addedRCPAdetails.addedChemist?.addr
                        aChemist.chemistContact = addedRCPAdetails.addedChemist?.chemistContact
                        aChemist.chemistEmail = addedRCPAdetails.addedChemist?.chemistEmail
                        aChemist.chemistFax = addedRCPAdetails.addedChemist?.chemistFax
                        aChemist.chemistMobile = addedRCPAdetails.addedChemist?.chemistMobile
                        aChemist.chemistPhone = addedRCPAdetails.addedChemist?.chemistPhone
                        aChemist.code = addedRCPAdetails.addedChemist?.code
                        aChemist.geoTagCnt = addedRCPAdetails.addedChemist?.geoTagCnt
                        aChemist.index = addedRCPAdetails.addedChemist?.index ?? 0
                        aChemist.lat = addedRCPAdetails.addedChemist?.lat
                        aChemist.long = addedRCPAdetails.addedChemist?.long
                        aChemist.mapId =  addedRCPAdetails.addedChemist?.mapId
                        aChemist.maxGeoMap = addedRCPAdetails.addedChemist?.maxGeoMap
                        aChemist.name = addedRCPAdetails.addedChemist?.name
                        aChemist.sfCode = addedRCPAdetails.addedChemist?.sfCode
                        aChemist.townCode = addedRCPAdetails.addedChemist?.townCode
                        aChemist.townName = addedRCPAdetails.addedChemist?.townName
                        aRCPAdetailsEntity.addedChemist = aChemist
                        
                    }
                    
                    if let addedProductDetails = addedRCPAdetails.addedProductDetails {
                        toReturnaddedProductDetailsCDEntity(addedProductDetails: addedProductDetails) { ProductDetailsCDModel in
                             aRCPAdetailsEntity.addedProductDetails = ProductDetailsCDModel
                            completion(aRCPAdetailsEntity)
                        }
                    }
      
                } else {
                    
                    completion(nil)
                }

    }
    
    
    func toReturnRCPAdetailsCDEntity(rcpadtailsCDModels: [RCPAdetailsModal], completion: @escaping (RCPAdetailsCDEntity?) -> Void) {
        let context = self.context
        
        // Create a new managed object
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "RCPAdetailsCDEntity", in: context) else {
            completion(nil)
            return
        }
        
        let aRCPAdetailsCDArrEntity = RCPAdetailsCDEntity(entity: entityDescription, insertInto: context)
        
        // Create a dispatch group
        let dispatchGroup = DispatchGroup()
        
        // Convert and add
        let rcpaDetailsCDModelSet = NSMutableSet()
        for rcpadtailsCDModel in rcpadtailsCDModels {
            dispatchGroup.enter()
            toReturnRCPAdetailsCDModel(addedRCPAdetails: rcpadtailsCDModel) { rcpaDetailsCDModel in
                if let nonNilRCPAdetailsCDModel = rcpaDetailsCDModel {
                    rcpaDetailsCDModelSet.add(nonNilRCPAdetailsCDModel)
                }
                dispatchGroup.leave()
            }
        }
        
        // Notify when all tasks are complete
        dispatchGroup.notify(queue: .main) {
            aRCPAdetailsCDArrEntity.rcpadtailsCDModelArr = rcpaDetailsCDModelSet
            
            // Call completion handler
            completion(aRCPAdetailsCDArrEntity)
        }
    }
}


extension CoreDataManager {
    
    func removeAllSanvedCalls() {
        let fetchRequest: NSFetchRequest<AddedDCRCall> = NSFetchRequest(entityName: "AddedDCRCall")
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            
            try context.save()
            
        } catch {
            print("Failed to fetch or delete entities: \(error)")
            
        }
    }
    
    
    func toGetCallsCountForDate(callDate: Date, completion: @escaping (Int) -> () )  {
        do {
            let request = AddedDCRCall.fetchRequest() as NSFetchRequest

            let calls = try context.fetch(request)
            if calls.isEmpty {
                completion(0)
            } else {
                var filteredcalls: [AddedDCRCall] = []
                calls.forEach { aAddedDCRCall in
                    let dcrCalldate = aAddedDCRCall.callDate
                    let dateStr = dcrCalldate?.toString(format: "yyyy-MM-dd")
                    let editDateStr = callDate.toString(format: "yyyy-MM-dd")
                    if dateStr == editDateStr {
                        filteredcalls.append(aAddedDCRCall)
                    }
                }
                
                completion(filteredcalls.count)
            }
        } catch {
            print("unable to fetch")
            completion(0)
        }
    }
    
    
    func tofetchaSavedCalls(editDate: Date, callID: String, completion: @escaping ([AddedDCRCall]?) -> () )  {
        do {
            let request = AddedDCRCall.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "addedCallID == %@", callID)
            //LIKE
            request.predicate = pred
            let calls = try context.fetch(request)
            if calls.isEmpty {
                completion(nil)
            } else {
                var filteredcalls: [AddedDCRCall] = []
                calls.forEach { aAddedDCRCall in
                    let dcrCalldate = aAddedDCRCall.callDate
                    let dateStr = dcrCalldate?.toString(format: "yyyy-MM-dd")
                    let editDateStr = editDate.toString(format: "yyyy-MM-dd")
                    if dateStr == editDateStr {
                        filteredcalls.append(aAddedDCRCall)
                    }
                }
                
                completion(calls)
            }
        } catch {
            print("unable to fetch")
            completion(nil)
        }
    }

}

extension CoreDataManager {
    
    
    
    func toReturnAdditionalCallVM(addedAdditionalCalls: AdditionalCallsListViewModel, completion: @escaping (AdditionalCallViewModelCDEntity?) -> Void) {
        let context = self.context
        
        if let additionalCallCDentityDescription = NSEntityDescription.entity(forEntityName: "AdditionalCallViewModelCDEntity", in: context) {
            
            let aAdditionalCallEntity = AdditionalCallViewModelCDEntity(entity: additionalCallCDentityDescription, insertInto: context)
            
           
            convertToAdditionalCallCDModel(addedAdditionalCalls: addedAdditionalCalls) { additionalCallCDModelset in
                
                
                aAdditionalCallEntity.additionalCallViewModel = additionalCallCDModelset
                
                completion(aAdditionalCallEntity)
            }
        } else {
            completion(nil)
        }
    }
    
    
    func convertToAdditionalCallCDModel(addedAdditionalCalls: AdditionalCallsListViewModel, completion: @escaping (NSSet) -> Void) {
        
        let context = self.context
        let additionalCallCDModelset = NSMutableSet()

        let additioncallDatum = addedAdditionalCalls.getAdditionalCallData()

        let dispatchGroup = DispatchGroup()
        
        // Iterate over each additional call data
        for additioncallData in additioncallDatum {
        
            // Create a new managed object
            if let additionalCallCDentityDescription = NSEntityDescription.entity(forEntityName: "AdditionalCallCDModel", in: context) {
                
                let aAdditionalCallEntity = AdditionalCallCDModel(entity: additionalCallCDentityDescription, insertInto: context)
                
                
                if let additionalDocCallEntityDescription  = NSEntityDescription.entity(forEntityName: "DoctorFencing", in: context) {
                    let additionalDocCallCDEntity =  DoctorFencing(entity: additionalDocCallEntityDescription, insertInto: context)

                  
                    additionalDocCallCDEntity.addrs =  additioncallData.additionalCall?.addrs ?? ""
                    additionalDocCallCDEntity.category = additioncallData.additionalCall?.category ?? ""
                    additionalDocCallCDEntity.categoryCode = additioncallData.additionalCall?.categoryCode ?? ""
                    additionalDocCallCDEntity.code = additioncallData.additionalCall?.code ?? ""
                    additionalDocCallCDEntity.dob = additioncallData.additionalCall?.dob ?? ""
                    additionalDocCallCDEntity.docDesig = additioncallData.additionalCall?.docDesig ?? ""
                    additionalDocCallCDEntity.docEmail = additioncallData.additionalCall?.docEmail ?? ""
                    additionalDocCallCDEntity.dow = additioncallData.additionalCall?.dow ?? ""
                    additionalDocCallCDEntity.drSex = additioncallData.additionalCall?.drSex ?? ""
                    additionalDocCallCDEntity.geoTagCnt = additioncallData.additionalCall?.geoTagCnt ?? ""
                    additionalDocCallCDEntity.hosAddr = additioncallData.additionalCall?.hosAddr ?? ""
                    additionalDocCallCDEntity.index = additioncallData.additionalCall?.index ?? 0
                    additionalDocCallCDEntity.lat = additioncallData.additionalCall?.lat ?? ""
                    additionalDocCallCDEntity.long = additioncallData.additionalCall?.long ?? ""
                    additionalDocCallCDEntity.mapId = additioncallData.additionalCall?.mapId ?? ""
                    additionalDocCallCDEntity.mappProducts = additioncallData.additionalCall?.mappProducts ?? ""
                    additionalDocCallCDEntity.maxGeoMap = additioncallData.additionalCall?.maxGeoMap ?? ""
                    additionalDocCallCDEntity.mobile = additioncallData.additionalCall?.mobile ?? ""
                    additionalDocCallCDEntity.mProd = additioncallData.additionalCall?.mProd ?? ""
                    additionalDocCallCDEntity.name = additioncallData.additionalCall?.name ?? ""
                    additionalDocCallCDEntity.phone = additioncallData.additionalCall?.phone ?? ""
                    additionalDocCallCDEntity.plcyAcptFl = additioncallData.additionalCall?.plcyAcptFl ?? ""
                    additionalDocCallCDEntity.productCode = additioncallData.additionalCall?.productCode ?? ""
                    additionalDocCallCDEntity.resAddr = additioncallData.additionalCall?.resAddr ?? ""
                    additionalDocCallCDEntity.sfCode = additioncallData.additionalCall?.sfCode ?? ""
                    additionalDocCallCDEntity.speciality = additioncallData.additionalCall?.speciality ?? ""
                    additionalDocCallCDEntity.specialityCode = additioncallData.additionalCall?.specialityCode ?? ""
                    additionalDocCallCDEntity.townCode = additioncallData.additionalCall?.townCode ?? ""
                    additionalDocCallCDEntity.townName = additioncallData.additionalCall?.townName ?? ""
                    additionalDocCallCDEntity.uRwId = additioncallData.additionalCall?.uRwId ?? ""
                    
                    aAdditionalCallEntity.additionalCall = additionalDocCallCDEntity
                    
                }
                
                
                dispatchGroup.enter()
                let inputArr: [Input] = additioncallData.inputSelectedListViewModel.inputViewModel.map { aInputViewModel in
                    return  aInputViewModel.input.input ?? Input()
                }
                convertToInputViewModelArr(additioncallData.inputSelectedListViewModel.inputViewModel, inputs: inputArr, context: context) { inputViewModelSet in
                    aAdditionalCallEntity.inputs = inputViewModelSet
                    dispatchGroup.leave()
                }
                dispatchGroup.enter()
                convertToProductViewModelArr(additioncallData.productSelectedListViewModel.productViewModel, context: context) { productModelSet in
                    aAdditionalCallEntity.products = productModelSet
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                toReturnInputViewModelCDModel(addedinputs: additioncallData.inputSelectedListViewModel) { inputsViewModel in
                    aAdditionalCallEntity.inputSelectedListViewModel = inputsViewModel
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                toReturnProductViewModelCDModel(addedProducts: additioncallData.productSelectedListViewModel) { productsViewModel in
                    aAdditionalCallEntity.productSelectedListViewModel = productsViewModel
                    dispatchGroup.leave()
                }
                
                additionalCallCDModelset.add(aAdditionalCallEntity)
            }
            

            
          
        }
        
        // Notify completion when all tasks in the dispatch group are completed
        dispatchGroup.notify(queue: .main) {

            completion(additionalCallCDModelset)
        }
    }

    
    
    func convertToAdditionalCallViewModelArr(_ jointWorkViewModels: [JointWorkViewModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
       let jointWorkViewModelsSet = NSMutableSet()

       // Create a dispatch group to handle asynchronous tasks
       let dispatchGroup = DispatchGroup()

       // Iterate over each GroupedBrandsSlideModel
       for jointWorkViewModel in jointWorkViewModels {
           dispatchGroup.enter()

           if let entityDescription = NSEntityDescription.entity(forEntityName: "JointWorkDataCDModel", in: context) {
               let jointWorkDataCDModel = JointWorkDataCDModel(entity: entityDescription, insertInto: context)
 
               jointWorkDataCDModel.jointWork = jointWorkViewModel.jointWork
               // Add to set
               jointWorkViewModelsSet.add(jointWorkDataCDModel)
               dispatchGroup.leave()
           }
       }

       // Notify the completion handler when all tasks in the dispatch group are complete
       dispatchGroup.notify(queue: .main) {
           completion(jointWorkViewModelsSet)
       }
   }
    
    
    
    func toReturnJointWorkViewModelCDModel(addedJonintWorks: JointWorksListViewModel, completion: @escaping (JointWorkViewModelCDEntity?) -> Void) {

            


                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "JointWorkViewModelCDEntity", in: context) {
                   // dispatchGroup.enter()
                    let ajwEntity = JointWorkViewModelCDEntity(entity: entityDescription, insertInto: context)

              
                    convertToJointworkViewModelArr(addedJonintWorks.getJointWorkData(), context: context){ jwViewModelSet in
                        ajwEntity.jointWorkViewModelArr = jwViewModelSet

                        completion(ajwEntity)
                
                    }
                } else {
                    
                    completion(nil)
                }
 

    }
    
    
    func convertToJointworkViewModelArr(_ jointWorkViewModels: [JointWorkViewModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
       let jointWorkViewModelsSet = NSMutableSet()

       // Create a dispatch group to handle asynchronous tasks
       let dispatchGroup = DispatchGroup()

       // Iterate over each GroupedBrandsSlideModel
       for jointWorkViewModel in jointWorkViewModels {
           dispatchGroup.enter()

           if let entityDescription = NSEntityDescription.entity(forEntityName: "JointWorkDataCDModel", in: context) {
               let jointWorkDataCDModel = JointWorkDataCDModel(entity: entityDescription, insertInto: context)
 
              
               if let entityDescription = NSEntityDescription.entity(forEntityName: "JointWork", in: context) {
                   let jwCDModel = JointWork(entity: entityDescription, insertInto: context)
                   jwCDModel.actFlg = jointWorkViewModel.jointWork.actFlg
                   jwCDModel.code = jointWorkViewModel.jointWork.code
                   jwCDModel.desig = jointWorkViewModel.jointWork.desig
                   jwCDModel.divisionCode = jointWorkViewModel.jointWork.divisionCode
                   jwCDModel.index = jointWorkViewModel.jointWork.index
                   jwCDModel.mapId = jointWorkViewModel.jointWork.mapId
                   jwCDModel.name = jointWorkViewModel.jointWork.name
                   jwCDModel.ownDiv = jointWorkViewModel.jointWork.ownDiv
                   jwCDModel.reportingToSF = jointWorkViewModel.jointWork.reportingToSF
                   jwCDModel.sfName = jointWorkViewModel.jointWork.sfName
                   jwCDModel.sfStatus = jointWorkViewModel.jointWork.sfStatus
                   jwCDModel.sfType = jointWorkViewModel.jointWork.sfType
                   jwCDModel.steps = jointWorkViewModel.jointWork.steps
                   jwCDModel.usrDfdUserName = jointWorkViewModel.jointWork.usrDfdUserName
                   
                   
                   jointWorkDataCDModel.jointWork = jwCDModel
               }
               
               
               // Add to set
               jointWorkViewModelsSet.add(jointWorkDataCDModel)
               dispatchGroup.leave()
           }
       }

       // Notify the completion handler when all tasks in the dispatch group are complete
       dispatchGroup.notify(queue: .main) {
           completion(jointWorkViewModelsSet)
       }
   }
    
    
        func toReturnInputViewModelCDModel(addedinputs: InputSelectedListViewModel, completion: @escaping (InputViewModelCDEntity?) -> Void) {
    
                
     
          
                    let context = self.context
                    // Create a new managed object
                    if let entityDescription = NSEntityDescription.entity(forEntityName: "InputViewModelCDEntity", in: context) {
                      
                        let aInputEntity = InputViewModelCDEntity(entity: entityDescription, insertInto: context)
    
                        // Convert properties
                        aInputEntity.uuid = UUID()
                        
                        // Convert and add
            
                        convertToInputViewModelArr(addedinputs.inputData(), inputs: addedinputs.fetchAllInput()!, context: context){ inputViewModelSet in
                            aInputEntity.inputViewModelArr = inputViewModelSet as! NSMutableSet
    
                            completion(aInputEntity)
                        
                        }
                    } else {
                        completion(nil)
                
                    }
     
    
        }
    
    
    func convertToInputViewModelArr(_ inputViewModels: [InputViewModel], inputs: [Input], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
           let inputViewModelsSet = NSMutableSet()
    
           // Create a dispatch group to handle asynchronous tasks
           let dispatchGroup = DispatchGroup()
    
           // Iterate over each GroupedBrandsSlideModel
        for (index, inputViewModel) in inputViewModels.enumerated() {
               dispatchGroup.enter()
    
               if let entityDescription = NSEntityDescription.entity(forEntityName: "InputDataCDModel", in: context) {
                   let inputDataCDModel = InputDataCDModel(entity: entityDescription, insertInto: context)
     
                   inputDataCDModel.availableCount = inputViewModel.input.availableCount
                   inputDataCDModel.inputCount = inputViewModel.input.inputCount
                   
                   // Fetch or create the corresponding Input managed object
                   if let entityDescription = NSEntityDescription.entity(forEntityName: "Input", in: context) {
                       let inputCDModel = Input(entity: entityDescription, insertInto: context)
                       inputCDModel.name =  inputs[index].name
                       inputCDModel.code =  inputs[index].code
                       inputCDModel.index = inputs[index].index
                       inputCDModel.mapId = inputs[index].mapId
       
                       
                       let effF = inputs[index].effF
                       let effT = inputs[index].effT
                       if let entityDescription = NSEntityDescription.entity(forEntityName: "Efff", in: context) {
                           let effFCDModel = Efff(entity: entityDescription, insertInto: context)
                           
                           effFCDModel.timeZone = effF?.timeZone
                           effFCDModel.date = effF?.date
                           effFCDModel.timeZoneType = effF?.timeZoneType ?? 0
                           
                           inputCDModel.effF = effFCDModel
                           
                           let effTCDModel = Efff(entity: entityDescription, insertInto: context)
                           effTCDModel.timeZone = effT?.timeZone
                           effTCDModel.date = effT?.date
                           effTCDModel.timeZoneType = effT?.timeZoneType ?? 0
                           
                           inputCDModel.effT = effTCDModel
                           
                           inputDataCDModel.input = inputCDModel
                   }
                   }
                   // Add to set
                   inputViewModelsSet.add(inputDataCDModel)
                   dispatchGroup.leave()
               }
           }
    
           // Notify the completion handler when all tasks in the dispatch group are complete
           dispatchGroup.notify(queue: .main) {
               completion(inputViewModelsSet)
           }
       }
}


extension CoreDataManager {
    
    func fetchProductViewModels(completion: ([ProductViewModelCDEntity]) -> () )  {
        do {
            let savedVIewModels = try  context.fetch(ProductViewModelCDEntity.fetchRequest())
            completion(savedVIewModels )
            
        } catch {
            print("unable to fetch movies")
        }
        
    }
    
    
    func toCheckExistanceOfProductViewModel(_ id: UUID, completion: (Bool) -> ()) {
        
        do {
            let request = ProductViewModelCDEntity.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "uuid == '\(id)'")
            //LIKE
            request.predicate = pred
            let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    
    
    func toRemoveProductViewModel(_ id: UUID, completion: (Bool) -> ()) {
        
        
        do {
            let request = ProductViewModelCDEntity.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "uuid == '\(id)'")
            request.predicate = pred
            let presentations = try context.fetch(request)
            if presentations.isEmpty {
                completion(false)
            } else {
                let presentationToRemove = presentations[0]
                self.context.delete(presentationToRemove)
                do {
                    try self.context.save()
                    completion(true)
                } catch {
                    completion(false)
                }
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
        
    }
    
    

    
    
    func toReturnProductViewModelCDModel(addedProducts: ProductSelectedListViewModel, completion: @escaping (Bool) -> Void) {
    
            var tempcompletion: Bool = false
            let dispatchGroup = DispatchGroup()
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "ProductViewModelCDEntity", in: context) {
                    dispatchGroup.enter()
                    let aProductEntity = ProductViewModelCDEntity(entity: entityDescription, insertInto: context)
                    
                    // Convert properties
                    aProductEntity.uuid = UUID()
                    // Convert and add
                    convertToProductViewModelArr(addedProducts.productData(), context: context){ productViewModelSet in
                        aProductEntity.productViewModelArr = productViewModelSet
                        
                        // Save to Core Data
                        do {
                            try context.save()
                            tempcompletion = true
                            dispatchGroup.leave()
                        } catch {
                            print("Failed to save to Core Data: \(error)")
                            tempcompletion = false
                            dispatchGroup.leave()
                        }
                    }
                }
            
            // Notify the completion handler when all tasks in the dispatch group are complete
            dispatchGroup.notify(queue: .main) {
                completion(tempcompletion)
            }
        
    }
                    

        
    func toReturnProductViewModelCDModel(addedProducts: ProductSelectedListViewModel, completion: @escaping (ProductViewModelCDEntity?) -> Void) {
        let productUUID = addedProducts.uuid ?? UUID()
        let context = self.context
        // Create a new managed object
        if let entityDescription = NSEntityDescription.entity(forEntityName: "ProductViewModelCDEntity", in: context) {
            
            let aProductEntity = ProductViewModelCDEntity(entity: entityDescription, insertInto: context)
            
            // Convert properties
            aProductEntity.uuid = productUUID
            
            // Convert and add
            convertToProductViewModelArr(addedProducts.productData(), context: context) { productViewModelSet in
                aProductEntity.productViewModelArr = productViewModelSet
                completion(aProductEntity)
            }
        } else {
            completion(nil) // Entity creation failed
        }
    }
        
    
    

    
    
     func convertToProductViewModelArr(_ productViewModels: [ProductViewModel], context: NSManagedObjectContext, completion: @escaping (NSSet) -> Void) {
        let productViewModelsSet = NSMutableSet()

        // Create a dispatch group to handle asynchronous tasks
        let dispatchGroup = DispatchGroup()

        // Iterate over each GroupedBrandsSlideModel
        for productViewModel in productViewModels {
            dispatchGroup.enter()

            if let entityDescription = NSEntityDescription.entity(forEntityName: "ProductDataCDModel", in: context) {
                let productDataCDModel = ProductDataCDModel(entity: entityDescription, insertInto: context)
                productDataCDModel.availableCount = productViewModel.availableCount
                productDataCDModel.isDetailed = productViewModel.isDetailed
                productDataCDModel.rcpaCount = productViewModel.rcpaCount
                productDataCDModel.rxCount = productViewModel.rxCount
                productDataCDModel.sampleCount = productViewModel.sampleCount
                productDataCDModel.stockistCode = productViewModel.stockistCode
                productDataCDModel.stockistName = productViewModel.stockistName
                productDataCDModel.totalCount = productViewModel.totalCount

                if let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: context) {
                    
                    let productCDModel = Product(entity: entityDescription, insertInto: context)
                    productCDModel.name = productViewModel.product.product?.name
                    productCDModel.actFlg = productViewModel.product.product?.actFlg
                    productCDModel.cateId = productViewModel.product.product?.cateId
                    productCDModel.code = productViewModel.product.product?.code
                    productCDModel.divisionCode = productViewModel.product.product?.divisionCode
                    productCDModel.dRate = productViewModel.product.product?.dRate
                    productCDModel.index = productViewModel.product.product?.index ?? 0
                    productCDModel.mapId = productViewModel.product.product?.mapId
                    productCDModel.noOfSamples = productViewModel.product.product?.noOfSamples
                    productCDModel.productMode = productViewModel.product.product?.productMode
                    productCDModel.pSlNo = productViewModel.product.product?.pSlNo
                    
                    productDataCDModel.product = productCDModel
                    // Add to set
                  //  productViewModelsSet.add(productDataCDModel)
                }

                // Add to set
                productViewModelsSet.add(productDataCDModel)
                dispatchGroup.leave()
            }
        }

        // Notify the completion handler when all tasks in the dispatch group are complete
        dispatchGroup.notify(queue: .main) {
            completion(productViewModelsSet)
        }
    }
}

    
extension CoreDataManager {
    //EventCaptures
    func toFetchCacheEvents(completion: ([UnsyncedEventCaptures]) -> ()) {
        do {
           let savedCDEvents = try  context.fetch(UnsyncedEventCaptures.fetchRequest())
            completion(savedCDEvents)
            
        } catch {
            print("unable to fetch movies")
        }
    }
    
    func toRetriveEventcaptureCDM(completion: @escaping([UnsyncedEventCaptureModel]) -> ()) {
        CoreDataManager.shared.toFetchCacheEvents { savedCDEvents in
            var eventCaptures = [UnsyncedEventCaptureModel]()
            let dispatchGroup = DispatchGroup()
            savedCDEvents.forEach { cacheEvent in
                dispatchGroup.enter()
                var aEventCapture = UnsyncedEventCaptureModel()
                aEventCapture.custCode = cacheEvent.custCode
                aEventCapture.eventCaptureParamData = cacheEvent.eventcaptureParamData
                aEventCapture.eventcaptureDate = cacheEvent.eventcaptureDate
                
                var capturedEvents : [EventCapture] = []
                
                cacheEvent.unsyncedCapturedEvents?.capturedEvents?.forEach({ aElemet in
             
                        
                        if let aEventCaptureViewModelElemet = aElemet as? EventCaptureCDM {
                            let capturedImage = UIImage(data: aEventCaptureViewModelElemet.image ?? Data())
                            let aEventCapture  =  EventCapture(image: capturedImage, title: aEventCaptureViewModelElemet.title ?? "", description: aEventCaptureViewModelElemet.imageDescription ?? "", imageUrl: aEventCaptureViewModelElemet.imageUrl ?? "", time: aEventCaptureViewModelElemet.time ?? "", timeStamp: aEventCaptureViewModelElemet.timeStamp ?? "")
                            capturedEvents.append(aEventCapture)
                        }
                        
                    
                })
                
                aEventCapture.capturedEvents = capturedEvents
                eventCaptures.append(aEventCapture)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(eventCaptures)
            }
        }
        
    }
    
}

extension CoreDataManager {
    //Day Status
    func toFetchAllDayStatus(completion: ([EachDayStatus]) -> () )  {
        //unSyncedParams
        do {
           let savedDayStatus = try  context.fetch(EachDayStatus.fetchRequest())
            completion(savedDayStatus)
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    func saveDayStatusToCoreData(date: Date, didUserWindup: Bool, isSynced: Bool, checkinInfo: CheckinInfo? = nil, params: Data,  completion: @escaping (Bool) -> ()) {
        
        removeDayStatus(date: date) { isRemoved in
            let context = self.context
            // Create a new managed object for wind ups
            if let entityDescription = NSEntityDescription.entity(forEntityName: "EachDayStatus", in: context) {
                let eachDayStatusEntity = EachDayStatus(entity: entityDescription, insertInto: context)
                eachDayStatusEntity.isSynced = isSynced
                eachDayStatusEntity.param = params
                eachDayStatusEntity.statusDate = date
                eachDayStatusEntity.didUserWindup = didUserWindup
                
                if isDayCheckinNeeded {
                    guard let checkinInfo = checkinInfo else {
                        do {
                            try context.save()
                            completion(true)
                        } catch {
                            print("Failed to save to Core Data: \(error)")
                            completion(false)
                        }
                        return
                    }
                    
                    // Create a new managed object for Check ins
                    if let entityDescription = NSEntityDescription.entity(forEntityName: "ChekinInfo", in: context) {
                        let savedCDChekinInfo = ChekinInfo(entity: entityDescription, insertInto: context)
                        
                        // Convert properties
                        savedCDChekinInfo.address = checkinInfo.address
                        savedCDChekinInfo.checkinDateTime = checkinInfo.checkinDateTime
                        savedCDChekinInfo.checkOutDateTime = checkinInfo.checkOutDateTime
                        savedCDChekinInfo.latitude = checkinInfo.latitude ?? Double()
                        savedCDChekinInfo.longitude = checkinInfo.longitude ?? Double()
                        savedCDChekinInfo.checkinTime = checkinInfo.checkinTime
                        savedCDChekinInfo.checkOutTime = checkinInfo.checkOutTime
                      
                        
                        eachDayStatusEntity.checkinInfo = savedCDChekinInfo
                    }
                }

                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save to Core Data: \(error)")
                    completion(false)
                }
            }
        }
      

        

        

        
        
    }
    
    func removeAllDayStatus() {
        let fetchRequest: NSFetchRequest<EachDayStatus> = NSFetchRequest(entityName: "EachDayStatus")

        do {
            let eachDayStatus = try context.fetch(fetchRequest)
            for status in eachDayStatus {
                context.delete(status)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
    func removeDayStatus(date: Date, competion: @escaping((Bool) -> ())) {
        let fetchRequest: NSFetchRequest<EachDayStatus> = NSFetchRequest(entityName: "EachDayStatus")

        do {
            let eachDayStatus = try context.fetch(fetchRequest)
            for status in eachDayStatus {
                let savedDateStr = status.statusDate?.toString(format: "MMM dd, yyyy")
                let toRemoveDateStr = date.toString(format: "MMM dd, yyyy")
                if savedDateStr == toRemoveDateStr {
                    context.delete(status)
                }
            }

            try context.save()
            competion(true)
        } catch {
            print("Error deleting slide brands: \(error)")
            competion(false)
        }
    }
    
}

extension CoreDataManager {
    
    //Outbox param
    func toFetchAllOutboxParams(completion: ([OutBoxParam]) -> () )  {
        //unSyncedParams
        do {
           let savedOutBoxParam = try  context.fetch(OutBoxParam.fetchRequest())
            completion(savedOutBoxParam)
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    func removeAllOutboxParams() {
        let fetchRequest: NSFetchRequest<OutBoxParam> = NSFetchRequest(entityName: "OutBoxParam")

        do {
            let outBoxParams = try context.fetch(fetchRequest)
            for param in outBoxParams {
                context.delete(param)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
    func saveBrandSlidesToCoreData(updatedParams: Data  , completion: (Bool) -> ()) {
 
                let context = self.context
                
                if let entityDescription = NSEntityDescription.entity(forEntityName: "OutBoxParam", in: context) {
                    let outBoxParamCDM = OutBoxParam(entity: entityDescription, insertInto: context)

                    // Convert properties

                    outBoxParamCDM.unSyncedParams = updatedParams

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
    
}

/// - Author:  hassan
