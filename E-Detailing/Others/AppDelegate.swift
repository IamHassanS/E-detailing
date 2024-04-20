//
//  AppDelegate.swift
//  E-Detailing
//
//  Created by PARTH on 21/04/23.
//

import UIKit
import CoreData
import GoogleMaps
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
   
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        GMSServices.provideAPIKey(GooglePlacesApiKey)
        
        self.setupRootViewControllers(isFromlaunch: false)
        // Enable IQKeyboardManager
              IQKeyboardManager.shared.enable = true
        return true
    }
    
    
    func setupRootViewControllers(isFromlaunch: Bool? = false) {
        
        if !AppDefaults.shared.isConfigAdded() {
            
            self.window?.rootViewController = UINavigationController.init(rootViewController: ConfigVC.initWithStory(homeVM: HomeViewModal()))
                                                                      
        } else {

            if AppDefaults.shared.isLoggedIn() && DBManager.shared.hasMasterData() {
                BackgroundTaskManager.shared.stopBackgroundTask()
                
                self.window?.rootViewController = UINavigationController.init(rootViewController: MainVC.initWithStory(isfromLaunch: isFromlaunch ?? false, ViewModel: UserStatisticsVM()))

            }else if AppDefaults.shared.isLoggedIn() {
                let mastersyncVC = MasterSyncVC.initWithStory()
                mastersyncVC.isFromLaunch = true
                self.window?.rootViewController = UINavigationController.init(rootViewController:mastersyncVC)

            }else {
                self.window?.rootViewController = UINavigationController.init(rootViewController: LoginVC.initWithStory())
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "E-Detailing")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

