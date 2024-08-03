//func resetCoreDataStack(delegate: AppDelegate?) throws {
//    
//    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    let archiveEachDatePlanURL = documentsDirectory.appendingPathComponent("EachDatePlan")
//
//   let archiveSentToApprovalURL = documentsDirectory.appendingPathComponent("SentToApprovalModelArr")
// 
//    let archiveURLs: [URL] = [archiveEachDatePlanURL, archiveSentToApprovalURL]
//    
//    archiveURLs.forEach { aURL in
//        removeData(at: aURL)
//    }
//    
//    UserDefaults.resetDefaults()
//    AppDefaults.shared.reset()
//    Shared.instance.toReset()
//    
//    guard let appDelegate = delegate else {
//        return
//    }
//    
//    // Get a reference to the NSPersistentStoreCoordinator
//    let storeContainer = appDelegate.persistentContainer.persistentStoreCoordinator
//    
//    // Delete each existing persistent store
//    for store in storeContainer.persistentStores {
//        try storeContainer.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
//    }
//    
//    // Re-create the persistent container
//    let newContainer = NSPersistentContainer(name: "E-Detailing")
//    
//    // Load persistent stores synchronously
//    var loadError: Error?
//    let semaphore = DispatchSemaphore(value: 0)
//    
//    newContainer.loadPersistentStores { (storeDescription, error) in
//        if let error = error {
//            loadError = error
//        }
//        semaphore.signal()
//    }
//    
//    // Wait for the load to complete
//    semaphore.wait()
//    
//    // Check for errors
//    if let loadError = loadError {
//        throw loadError
//    }
//    
//    // Assign the newly created container to the persistentContainer
//    appDelegate.persistentContainer = newContainer
//}


//func removeData(at url: URL) {
//    let fileManager = FileManager.default
//
//    // Check if the file exists
//    if fileManager.fileExists(atPath: url.path) {
//        do {
//            // Remove the file
//            try fileManager.removeItem(at: url)
//            print("File successfully removed")
//        } catch {
//            print("Failed to remove file: \(error)")
//        }
//    } else {
//        print("File does not exist")
//    }
//}
