//
//  DBManager + withHQ Ex.swift
//  SAN ZEN
//
//  Created by San eforce on 06/10/24.
//

import CoreData
import Foundation


extension DBManager {
    func saveInputData(values : [[String : Any]],id : String){
        self.deleteInputData(id: id) {
            let masterData = self.getMasterData()
            var inputArray = [Input]()
            for (index,input) in values.enumerated() {
                let contextNew = self.managedContext()
                let inputEntity = NSEntityDescription.entity(forEntityName: "Input", in: contextNew)
                let inputItem = Input(entity: inputEntity!, insertInto: contextNew)
                inputItem.setValues(fromDictionary: input, context: contextNew, id: id)
                inputItem.index = Int16(index)
                inputArray.append(inputItem)
            }

            inputArray.forEach { (input) in
                masterData.addToInput(input)
            }
            self.saveContext()
        }

    }
    
    
    func deleteEntityInfo(_ entity : String, completion: @escaping  (Bool) -> ()) {
        let context = self.managedContext()

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            context.reset()
            completion(true)
        } catch {
            print ("There was an error")
            completion(false)
        }
    }
    
    func saveSubordinateData(values: [[String: Any]], id: String, completion: @escaping () -> ()) {
        // Get the master data object
        
        
        deleteEntityInfo("Subordinate") { isRemoved in
            
            let masterData = self.getMasterData()
            
            // Create an array to hold new Subordinate objects
            var subordinateArray = [Subordinate]()
            
            // Prepare new Subordinate objects from the input values
            for (index, subordinateData) in values.enumerated() {
                let contextNew = self.managedContext()
                
                // Create a new Subordinate entity
                if let subordinateEntity = NSEntityDescription.entity(forEntityName: "Subordinate", in: contextNew) {
                    let subordinateItem = Subordinate(entity: subordinateEntity, insertInto: contextNew)
                    
                    // Set the values from the dictionary and assign an index
                    subordinateItem.setValues(fromDictionary: subordinateData, context: contextNew, id1: id)
                    subordinateItem.index = Int16(index)
                    
                    // Add the created subordinate to the array
                    subordinateArray.append(subordinateItem)
                }
            }

            // Perform deletion and addition of new subordinates within the Core Data context
            self.managedContext().perform {
                // Remove existing subordinates from masterData
                if let subordinateSet = masterData.subordinate,
                   let existingSubordinates = subordinateSet.allObjects as? [Subordinate] {
                    existingSubordinates.forEach { masterData.removeFromSubordinate($0) }
                }

                // Add the new subordinates to masterData
                subordinateArray.forEach { masterData.addToSubordinate($0) }
                
                // Save the context after making the changes
                self.saveContext()
                
                completion()
            }
        }
        

    }
    
    
    func saveDoctorFencingData(values : [[String : Any]],id : String) {
        self.deleteDoctorData(id: id) {
            let masterData = self.getMasterData()
            var doctorArray = [DoctorFencing]()
            for (index,doctor) in values.enumerated() {
                let contextNew = self.managedContext()
                let doctorEntity = NSEntityDescription.entity(forEntityName: "DoctorFencing", in: contextNew)
                let doctorItem = DoctorFencing(entity: doctorEntity!, insertInto: contextNew)
                doctorItem.setValues(fromDictionary: doctor, id: id)
                doctorItem.index = Int16(index)
                doctorArray.append(doctorItem)
                
            }
            
//            if let list = masterData.doctorFencing?.allObjects as? [DoctorFencing]{
//                _ = list.map{masterData.removeFromDoctorFencing($0)}
//            }
            doctorArray.forEach{ (doctor) in
                masterData.addToDoctorFencing(doctor)
            }
            self.saveContext()
        }

    }
    
    func saveChemistData (values : [[String : Any]],id : String) {
        self.deleteChemistData(id: id) {
            let masterData = self.getMasterData()
            var chemistArray = [Chemist]()
            for (index , chemist) in values.enumerated() {
                let contextNew = self.managedContext()
                let chemistEntity = NSEntityDescription.entity(forEntityName: "Chemist", in: contextNew)
                let chemistItem = Chemist(entity: chemistEntity!, insertInto: contextNew)
                chemistItem.setValues(fromDictionary: chemist, id: id)
                chemistItem.index = Int16(index)
                chemistArray.append(chemistItem)
            }
//            if let list = masterData.chemist?.allObjects as? [Chemist] {
//                _ = list.map{masterData.removeFromChemist($0)}
//            }
            chemistArray.forEach{ (chm) in
                masterData.addToChemist(chm)
            }
            self.saveContext()
        }

    }
    
    
    func saveStockistData(values : [[String :Any]],id : String) {
        self.deleteStockistData(id: id) {
            let masterData = self.getMasterData()
            var stockistArray = [Stockist]()
            for (index,stockist) in values.enumerated(){
                let contextNew = self.managedContext()
                let stockistEntity = NSEntityDescription.entity(forEntityName: "Stockist", in: contextNew)
                let stockistItem = Stockist(entity: stockistEntity!, insertInto: contextNew)
                stockistItem.setValues(fromDictionary: stockist, id: id)
                stockistItem.index = Int16(index)
                stockistArray.append(stockistItem)
            }
//            if let list = masterData.stockist?.allObjects as? [Stockist] {
//                _ = list.map{masterData.removeFromStockist($0)}
//            }
            stockistArray.forEach{ (stk) in
                masterData.addToStockist(stk)
            }
            self.saveContext()
        }

    }
    
    func saveUnListedDoctorData(values : [[String : Any]],id : String) {
        self.deleteUnListedDoctorData(id: id) {
            let masterData = self.getMasterData()
            var unListedDoctorArray = [UnListedDoctor]()
            for (index, doctor) in values.enumerated() {
                let contextNew = self.managedContext()
                let doctorEntity = NSEntityDescription.entity(forEntityName: "UnListedDoctor", in: contextNew)
                let doctorItem = UnListedDoctor(entity: doctorEntity!, insertInto: contextNew)
                doctorItem.setValues(fromDictionary: doctor, context: contextNew, id: id)
                doctorItem.index = Int16(index)
                unListedDoctorArray.append(doctorItem)
            }
//            if let list = masterData.unListedDoc?.allObjects as? [UnListedDoctor]{
//                _ = list.map{masterData.removeFromUnListedDoc($0)}
//            }
            unListedDoctorArray.forEach{ (doc) in
                masterData.addToUnListedDoc(doc)
            }
            self.saveContext()
        }

    }
    
    func saveTerritoryData(values : [[String : Any]],id : String) {
        self.deleteTerritoryData(id: id) {
            let masterData = self.getMasterData()
            var territoryArray = [Territory]()
            for (index,territory) in values.enumerated() {
                let contextNew = self.managedContext()
                let territoryEntity = NSEntityDescription.entity(forEntityName: "Territory", in: contextNew)
                let territoryItem = Territory(entity: territoryEntity!, insertInto: contextNew)
                territoryItem.setValues(fromDictionary: territory, mapID: id)
                territoryItem.index = Int16(index)
                territoryArray.append(territoryItem)
            }
//            if let list = masterData.territory?.allObjects as? [Territory]{
//                _ = list.map{masterData.removeFromTerritory($0)}
//            }
            territoryArray.forEach{ (territory) in
                masterData.addToTerritory(territory)
            }
            self.saveContext()
        }

    }
    
    
    
    
    func saveJointWorkData(values : [[String :Any]], id : String){
        self.deleteJointWorkData(id: id) {
            let masterData = self.getMasterData()
            var jointWorkArray = [JointWork]()
            for (index,jointWrk) in values.enumerated() {
                let contextNew = self.managedContext()
                let jointWorkEntity = NSEntityDescription.entity(forEntityName: "JointWork", in: contextNew)
                let jointWorkItem = JointWork(entity: jointWorkEntity!, insertInto: contextNew)
                jointWorkItem.setValues(fromDictionary: jointWrk, id: id)
                jointWorkItem.index = Int16(index)
                jointWorkArray.append(jointWorkItem)
            }
//            if let list = masterData.jointWork?.allObjects as? [JointWork]{
//                _ = list.map{masterData.removeFromJointWork($0)}
//            }
            jointWorkArray.forEach{ (jointWork) in
                masterData.addToJointWork(jointWork)
            }
            self.saveContext()
        }

    }
    
    func saveProductData(values : [[String : Any]],id : String) {
        self.deleteProductData(id: id) {
            let masterData = self.getMasterData()
            var productArray = [Product]()
            
            for (_,product) in values.enumerated(){
                let contextNew = self.managedContext()
                let productEntity = NSEntityDescription.entity(forEntityName: "Product", in: contextNew)
                let productItem = Product(entity: productEntity!, insertInto: contextNew)
                productItem.setValues(fromDictionary: product, id: id)
               // productItem.index = Int16(index)
                productArray.append(productItem)
            }
//            if let list = masterData.product?.allObjects as? [Product]{
//                _ = list.map{masterData.removeFromProduct($0)}
//            }
            // Filter products by different modes
            let saleArr = productArray.filter { $0.productMode?.lowercased() == "sale" }
            let saleSampleArr = productArray.filter { $0.productMode?.lowercased() == "sale/sample" }
            let sampleArr = productArray.filter { $0.productMode?.lowercased() == "sample" }
            let allArr = productArray.filter { $0.productMode == "" }
            
            productArray.removeAll()
            productArray.append(contentsOf: allArr)
            productArray.append(contentsOf: saleArr)
            productArray.append(contentsOf: saleSampleArr)
            productArray.append(contentsOf: sampleArr)
        
            // Reorder indices starting from 0
            for (index, product) in productArray.enumerated() {
                product.index = Int16(index) // Assuming index is an Int16 property in Product entity
            }
            
            // Sort array based on indices
            _ = productArray.sorted { $0.index < $1.index }
            
            productArray.forEach { (product) in
                masterData.addToProduct(product)
            }
            self.saveContext()
        }

    }
    
    func deleteInputData(id: String, completion: @escaping () -> Void) {
        // Create a DispatchGroup to manage the deletions
        let dispatchGroup = DispatchGroup()

        // Use perform to ensure that operations are on the managed context's queue
        self.managedContext().perform {
            let masterData = self.getMasterData()
            
            if let prevList = masterData.input?.allObjects as? [Input] {
                // Filter input data to delete by id
                let inputsToDelete = prevList.filter { $0.mapId == id }

                for input in inputsToDelete {
                    // Enter the dispatch group for each deletion
                    dispatchGroup.enter()

                    // Perform deletion
                    self.managedContext().delete(input)

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
}

