//
//  AppDelegate.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 05/05/24.
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
    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    
    
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        GMSServices.provideAPIKey(GooglePlacesApiKey)
        IQKeyboardManager.shared.enable = true
        addObservers()
      //  if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isTimeZoneChanged) {
         //   makeSplashView(isFirstTime: true, isTimeZoneChanged: true)
       // } else {
            makeSplashView(isFirstTime: true)
       // }
     
        return true
    }

    
    func addObservers() {
       // NotificationCenter.default.addObserver(self, selector: #selector(timeZoneChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//     
//        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isTimeZoneChanged) {
//            self.makeSplashView(isFirstTime: true, isTimeZoneChanged: true)
//        } 
//    
//    }
    
//    @objc func timeZoneChanged() {
//        makeSplashView(isFirstTime: true)
//    }
    
    func makeSplashView(isFirstTime:Bool, isTimeZoneChanged: Bool? = false)
    {
        let splashView = SplashVC.initWithStory()
        splashView.delegate = self
        splashView.isFirstTimeLaunch = isFirstTime
        splashView.isTimeZoneChanged = isTimeZoneChanged ?? false
        window?.rootViewController = UINavigationController.init(rootViewController: splashView)
        window?.makeKeyAndVisible()
    }
    
    
    func applicationSignificantTimeChange(_ application: UIApplication)  {
        
        NotificationCenter.default.post(name: UIApplication.significantTimeChangeNotification, object: nil)
        
    }
    
    func checkReachability() {
        network.isReachable() {  reachability in
            
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
            
            }
        
        }

        network.isUnreachable() { reachability in
         
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
             
                
            }
            
          
            
        }
        
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async {
                    if status == ReachabilityManager.ReachabilityStatus.notConnected.rawValue  {
                        
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                        
                    } else if  status == ReachabilityManager.ReachabilityStatus.wifi.rawValue || status ==  ReachabilityManager.ReachabilityStatus.cellular.rawValue   {
                        
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name("postAllPlan"), object: nil)
                    }
                }
            }
        }
    }
    
    
    func setupRootViewControllers() {
        
        if !AppDefaults.shared.isConfigAdded() {
            
            self.window?.rootViewController = UINavigationController.init(rootViewController: ConfigVC.initWithStory(homeVM: HomeViewModal()))
                                                                      
        } else {

            if AppDefaults.shared.isLoggedIn() && AppDefaults.shared.isSyncCompleted() {
             
                BackgroundTaskManager.shared.stopBackgroundTask()

                self.window?.rootViewController = UINavigationController.init(rootViewController: MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))

            } else if AppDefaults.shared.isLoggedIn() {
                
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



extension AppDelegate: splashVCDelegate {
    func setupControllers() {
        self.window?.rootViewController = nil
        self.setupRootViewControllers()
    }
    
    
}
