//
//  LoginVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 13/03/2024.
//

import Alamofire

import UIKit
import CoreData

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


extension LoginVC: MediaDownloaderDelegate {
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float) {
        print("")
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?) {
        print("")
        self.imgLogo.image = UIImage(data: data ?? Data())
        
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: any Error) {
        print("Error no slide found")
    }
}

class LoginVC : UIViewController {

    
    
    
    func setupui() {
        txtUserName.delegate = self
        txtPassWord.delegate = self
        contentsHolderview.elevate(2)
        contentsHolderview.layer.cornerRadius = 5
        lblUserID.setFont(font: .bold(size: .BODY))
        lblUserID.textColor = .appTextColor
        lblPassword.setFont(font: .bold(size: .BODY))
        lblPassword.textColor = .appTextColor
        lblVersion.setFont(font: .medium(size: .SMALL))
        lblVersion.textColor = .appLightTextColor
        
        txtUserName.font = UIFont(name: "Satoshi-Bold", size: 14)
        txtPassWord.font = UIFont(name: "Satoshi-Bold", size: 14)
        lblPoweredBy.setFont(font: .medium(size: .BODY))
        lblPoweredBy.textColor = .appLightTextColor
        
        txtUserName.text = "mgr123"
        txtPassWord.text = "123"
    }
    @IBOutlet var contentsHolderview: UIView!
    
    @IBOutlet var lblUserID: UILabel!
    
    @IBOutlet var lblPoweredBy: UILabel!
    
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!

    @IBOutlet weak var lblVersion: UILabel!

    @IBOutlet weak var imgLogo: UIImageView!
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var homeVM: HomeViewModal?

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    class func initWithStory() -> LoginVC {
        let loginVC : LoginVC = UIStoryboard.Hassan.instantiateViewController()

        return loginVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeVM = HomeViewModal()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupui()
        let data = AppDefaults.shared.getConfig()


//        Dispatch.background {
//            // do stuff
//            print("Data fetching")
//            var imageData : Data?
//            if let data = try? Data(contentsOf: url) {
//                imageData = data
//                let imgData : [String : Any] = ["name" : AppDefaults.shared.appConfig!.logoImg , "data" : data]
//                AppDefaults.shared.save(key: .logoImage, value: imgData)
//            Dispatch.main {
//                // update UI
//                self.imgLogo.image = UIImage(data: imageData ?? Data())
//            }
//        }
//        }
        Pipelines.shared.downloadData(mediaURL: data.config.logoImg, delegate: self)

    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    

    

    @IBAction func resetConfiguration(_ sender: UIButton) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            startBackgroundTaskWithLoader(delegate: appDelegate)
        }
                
    }

    func doUserLogin(_ param: [String: Any], paramData: JSON) {
        dump(param)
        
        Shared.instance.showLoaderInWindow()
        
        homeVM?.doUserLogin(params: param, api: .actionLogin, paramData: paramData) { responseData in
            Shared.instance.removeLoaderInWindow()
            switch responseData {

            case .success(let loginData):
                dump(loginData)
                if !(loginData.isSuccess ?? false) {
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
                    self.toCreateToast(loginData.successMessage ?? "Failed to login")
                } else {
                    do {
                      try  AppDefaults.shared.toSaveEncodedData(object: loginData, key: .appSetUp) { isSaved in
                          if isSaved {
                              LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: true)
                              self.navigate()
                          } else {
                              LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
                              self.toCreateToast(loginData.successMessage ?? "Failed to save user config data")
                          }
                        }
                    } catch {
                        print("Unable to save data")
                    }
                }
            case .failure(let error):
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
                dump(error)
                self.toCreateToast(error.rawValue)
            }
        }
    }

    
    func navigate() {
      
        let appsetup = AppDefaults.shared.getAppSetUp()
        if appsetup.sfType == 2 {
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isMR, value: false)
            
        } else {
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isMR, value: true)
        }
        
        appDelegate.setupRootViewControllers()
        
    }

    @IBAction func loginAction(_ sender: UIButton) {

        let userId = self.txtUserName.text ?? ""
        let password = self.txtPassWord.text ?? ""


        if userId.isEmpty {
          //  ConfigVC().showToast(controller: self, message: "Please Enter User ID", seconds: 2)
            return

        }else if password.isEmpty {
         //   ConfigVC().showToast(controller: self, message: "Please Enter Password", seconds: 2)
            return
        }

        let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model


        let param: [String: Any] = [
            "name": userId,
            "password": password,
            "versionNo": "i.1.0",
            "mode": "iOS-Edeting",
            "Device_version": version,
            "device_id": "",
            "Device_name": modelName,
            "AppDeviceRegId": "",
            "location": ""
        ]
        
    
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        doUserLogin(toSendData, paramData: param)

    }
    
    func endBackgroundTask() {
        // End the background task using its identifier
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid // Reset the identifier
    }
    
    
    func startBackgroundTaskWithLoader(delegate: AppDelegate?) {
        
        guard let appDelegate = delegate else {
            return
        }
        // Show loader on the main thread
        DispatchQueue.main.async {
            // Show your loader here
         Shared.instance.showLoaderInWindow()
        }
        
        // Begin a background task and store its identifier
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            // End the background task if the expiration handler is called
            self?.endBackgroundTask()
        }
        
        // Perform API calls or other background activities
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Your background task code here
          
            self.clearAllCoreData(delegate: appDelegate)
            AppDefaults.shared.reset()
         
            
            // Call endBackgroundTask when the task completes if it's not already stopped
            self.endBackgroundTask()
            
            // Hide loader on the main thread once the task completes
            DispatchQueue.main.async {
                // Hide your loader here
                Shared.instance.removeLoaderInWindow()
                self.appDelegate.setupRootViewControllers()
            }
        }
    }
    
    func clearAllCoreData(delegate: AppDelegate?) {
        guard let appDelegate = delegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Fetch all entity names in the data model
        let entityNames = appDelegate.persistentContainer.managedObjectModel.entities.map { $0.name }

        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName ?? "")

            // Create batch delete request
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                // Perform batch delete
                try managedContext.execute(batchDeleteRequest)

                // Save changes
                try managedContext.save()
            } catch {
                print("Error clearing \(entityName ?? ""): \(error)")
            }
        }
    }

}



extension Dictionary{
    func toString() -> String{
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            if let jsonString = jsonString{
                return jsonString
            }
        }
        return self.description
    }
}
