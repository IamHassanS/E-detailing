//
//  LoginVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 13/03/2024.
//

import Alamofire
import UIKit
import CoreData

extension LoginVC:UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtPassWord:
            guard let text = textField.text as?  NSString else {return false}
            let updatedText = text.replacingCharacters(in: range, with: string)
            print("New text: \(updatedText)")
            
            if updatedText.contains(" ") {
                return false
            }
        default:
            return true
        }
        return true
    }
}



extension LoginVC: MediaDownloaderDelegate {
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float) {
        print("")
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?) {
        print("")
        guard let data = data else {
            self.imgLogo.image = UIImage(named: "logo")
            return}
        self.imgLogo.image = UIImage(data: data)
        LocalStorage.shared.setData(LocalStorage.LocalValue.AppIcon, data: data)
        
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: any Error) {
        print("Error no slide found")
        self.imgLogo.image = UIImage(named: "logo")
    }
}

class LoginVC : UIViewController {
    var newText : String = ""

    @IBOutlet var contentsHolderview: UIView!
    
    @IBOutlet var lblUserID: UILabel!
    
    @IBOutlet var lblPoweredBy: UILabel!
    
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!

    @IBOutlet weak var lblVersion: UILabel!

    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet var viewPasswordIV: UIImageView!
    @IBOutlet var PasswordIVHolderView: UIView!
    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
//    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var homeVM: HomeViewModal?

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var resetQueue = DispatchQueue(label: "com.reset.queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never)
    
    var isCahcheUser : Bool = {
          let cacheName = LocalStorage.shared.getString(key: LocalStorage.LocalValue.UserName)
        if !cacheName.isEmpty {
        return true
        } else {
         return false
        }
        
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        
        let data = AppDefaults.shared.getConfig()
        
        if !isCahcheUser {
            Pipelines.shared.downloadData(mediaURL:  LocalStorage.shared.getString(key: .AttachmentsURL) + data.config.logoImg, delegate: self)
        } else {
         let imageData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.AppIcon)
            self.imgLogo.image = UIImage(data: imageData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeVM = HomeViewModal()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
         
        let cacheName = LocalStorage.shared.getString(key: LocalStorage.LocalValue.UserName)
          if isCahcheUser {
              txtUserName.isUserInteractionEnabled = false
              txtUserName.text = cacheName
          } else {
              checkReachability()
          
              txtUserName.isUserInteractionEnabled = true
          }
        setupui()
    }
    
    class func initWithStory() -> LoginVC {
        let loginVC : LoginVC = UIStoryboard.Hassan.instantiateViewController()

        return loginVC
    }
    
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
        lblVersion.text = LocalStorage.shared.getString(key: .AppVersion)
        txtUserName.font = UIFont(name: "Satoshi-Medium", size: 14)
        txtPassWord.font = UIFont(name: "Satoshi-Medium", size: 14)
        lblPoweredBy.setFont(font: .medium(size: .BODY))
        lblPoweredBy.textColor = .appLightTextColor
        txtPassWord.isSecureTextEntry = true
        setEyeimage()
        PasswordIVHolderView.addTap {
            self.txtPassWord.isSecureTextEntry =  self.txtPassWord.isSecureTextEntry == true ? false : true
            self.setEyeimage()
        }

    }
    

    
    
    func setEyeimage() {
        
        viewPasswordIV.image = txtPassWord.isSecureTextEntry == true ? UIImage(systemName: "eye") :  UIImage(systemName: "eye.slash")
        
        viewPasswordIV.alpha =  viewPasswordIV.image == UIImage(systemName: "eye") ? 0.3 : 1
        
 
    }
    
    func toSetupAlert(text: String, istoValidate : Bool? = false) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: text, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
          
            if istoValidate ?? false {
                self.appDelegate.setupRootViewControllers()
            } else {
                print("no action")
            }
           // self.openSettings()

   
        }
    }
    
    
    
    
    func isPlanExists(completion: @escaping (Bool) -> ()) {

       isOutboxcallExists() { isExists in
           if isExists {
               completion(isExists)
               return
           } else {
               self.isDayPlanExists() { isExists in
               completion(isExists)
               }
           }
         
        }

        
    }
    
    func isOutboxcallExists(completion: @escaping (Bool) -> ()) {
        var isCallExists: Bool = false
       let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        guard let  tempUnsyncedArr = DBManager.shared.geUnsyncedtHomeData() else {
            isCallExists = false
            completion(isCallExists)
            dispatchGroup.leave()
            return
        }
        if tempUnsyncedArr.isEmpty{
            isCallExists = false
            dispatchGroup.leave()
        } else {
            isCallExists = true
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(isCallExists)
        }
    }
    
    func isDaySubmitexists(completion: @escaping (Bool) -> ()) {
        var isDaysStatusSubmitted = true
        CoreDataManager.shared.toFetchAllDayStatus { eachDayStatus in
            for daystatus in eachDayStatus {
                if !daystatus.isSynced {
                    isDaysStatusSubmitted = false
                    break
                }
            }
            completion(isDaysStatusSubmitted)
        }
    }
    
    func isDayPlanExists(completion: @escaping (Bool) -> ()) {
        CoreDataManager.shared.fetchEachDayPlan { eachDayPlans in
            if eachDayPlans.isEmpty {
                completion(false)
                return
            }
            let isAllSynced = eachDayPlans.allSatisfy { !$0.isSynced }
            completion(isAllSynced)
        }
    }
    
    func toSetupClearCacheAlert(text: String) {
        isPlanExists { isExists in
            if isExists {
                let commonAlert = CommonAlert()
                commonAlert.setupAlert(alert: AppName, alertDescription: text, okAction: "Ok", cancelAction: "Cancel")
                commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                    print("no action")
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        self.startBackgroundTaskWithLoader(delegate: appDelegate)
                    }

                }
                commonAlert.addAdditionalCancelAction {
                    print("Yes action")
                }
            
            } else {
                print("Resetted ")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    
               
                        self.startBackgroundTaskWithLoader(delegate: appDelegate)
                  
                    
                    
                }
            }
        }

        

        

    }
    
    func toShowAlert() {
        
    }
    
    func checkReachability() {
        network.isReachable() {  reachability in
            
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                self.toSetupAlert(text: "Internet connection is required to login user.")
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
               
            }
            
         
        }

        network.isUnreachable() { reachability in
         
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                self.toSetupAlert(text: "Internet connection is required to login user.")
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
             
                
            }
        }
       
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    

    

    @IBAction func resetConfiguration(_ sender: UIButton) {
        
        toSetupClearCacheAlert(text: "This action will clear all of unsynced outbox calls, Day plans and other cached datas. Are you sure you want to proceed?")
        
  
        
   

    }
    

    
    func doOfflineLogin() {
        let cachePassword = LocalStorage.shared.getString(key: LocalStorage.LocalValue.UserPassword)
        guard self.txtPassWord.text == cachePassword
        else {
           // self.toCreateToast("Entered password is incorrect.")
            self.toSetupAlert(text: "Check User Id and Password.")
            return }
     
        self.toCreateToast("logged in successfully")
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: true)
        self.navigate()
        
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
                    //self.toCreateToast(loginData.successMessage ?? "Failed to login")
                    self.toSetupAlert(text: loginData.successMessage ?? "Failed to login")
                } else {
                    do {
                      try  AppDefaults.shared.toSaveEncodedData(object: loginData, key: .appSetUp) { isSaved in
                          if isSaved {
                              LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: true)
                              self.navigate()
                              self.toCreateToast("logged in successfully")
                          } else {
                              LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
                            //  self.toCreateToast(loginData.successMessage ?? "Failed to save user config data")
                              self.toSetupAlert(text: loginData.successMessage ?? "Failed to save user config data")
                          }
                        }
                    } catch {
                        print("Unable to save data")
                    }
                }
            case .failure(let error):
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
                dump(error)
                //self.toCreateToast(error.rawValue)
                self.toSetupAlert(text: error.rawValue)
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
        
        LocalStorage.shared.setSting(LocalStorage.LocalValue.UserName, text: self.txtUserName.text ?? "")
        LocalStorage.shared.setSting(LocalStorage.LocalValue.UserPassword, text: self.txtPassWord.text ?? "")
        refreshConstants()
        appDelegate.setupRootViewControllers()
        
    }

    @IBAction func loginAction(_ sender: UIButton) {
        
        if txtUserName.text!.isEmpty {
          //  self.toCreateToast("Please Enter user ID")
            self.toSetupAlert(text: "Please Enter user ID")
            return
        }
        
        if txtPassWord.text!.isEmpty {
           // self.toCreateToast("Please enter password")
            self.toSetupAlert(text: "Please enter password")
            return
        }
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            if isCahcheUser {
                doOfflineLogin()
                return
            }
        }
        

        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            self.toSetupAlert(text: "Internet connection is required to login user.")
            return
        }
        

        let userId = self.txtUserName.text ?? ""
        let password = self.txtPassWord.text ?? ""


        if userId.isEmpty {
            //self.toCreateToast("Please Enter User ID")
            self.toSetupAlert(text: "Please Enter User ID")
            return

        }else if password.isEmpty {
          //  self.toCreateToast("Please Enter Password")
            self.toSetupAlert(text: "Please Enter Password")
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
    
//    func endBackgroundTask() {
//        if backgroundTask != .invalid {
//            UIApplication.shared.endBackgroundTask(backgroundTask)
//            backgroundTask = .invalid
//        }
//    }
    
    
    func startBackgroundTaskWithLoader(delegate: AppDelegate?) {

        guard let appDelegate = delegate else {
            return
        }

        Shared.instance.showLoaderInWindow()
        resetQueue.async {
            self.resetCoreDataStack(delegate: appDelegate) { isCompleted in
            Shared.instance.removeLoaderInWindow()
            self.toSetupAlert(text: "Data cleared successfully", istoValidate: true)
        }

        }

        
 
        
    }


    
    
    
    func clearDocumentsAndData() throws {
        URLCache.shared.removeAllCachedResponses()
        let fileManager = FileManager.default
        let urls = [
            fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
        ].compactMap { $0 }

        for url in urls {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for item in contents {
                try fileManager.removeItem(at: item)
            }
        }
    }
    
    func removeArchivedData() {
        let fileManager = FileManager.default

        // This is the ArchiveURL where the data is stored
        let archiveURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("SentToApprovalModelArr")

        // Check if the file exists
        if fileManager.fileExists(atPath: archiveURL.path) {
            do {
                // Try to remove the file
                try fileManager.removeItem(at: archiveURL)
                print("Archived data file deleted successfully.")
            } catch {
                // Handle error during deletion
                print("Failed to delete archived data file: \(error)")
            }
        } else {
            print("File does not exist.")
        }
    }
    
    func removeTourplanData() {
        let fileManager = FileManager.default

        // This is the ArchiveURL where the data is stored
        let archiveURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("EachDatePlan")

        // Check if the file exists
        if fileManager.fileExists(atPath: archiveURL.path) {
            do {
                // Try to remove the file
                try fileManager.removeItem(at: archiveURL)
                print("Archived data file deleted successfully.")
            } catch {
                // Handle error during deletion
                print("Failed to delete archived data file: \(error)")
            }
        } else {
            print("File does not exist.")
        }
    }
    
    
    
    func resetCoreDataStack(delegate: AppDelegate?, completion: @escaping (Bool) -> Void) {
        UserDefaults.resetDefaults()
        Shared.instance.toReset()
        removeArchivedData()
        removeTourplanData()
        guard let appDelegate = delegate else {
            completion(false)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityNames = appDelegate.persistentContainer.managedObjectModel.entities.compactMap { $0.name }
        
        let dispatchGroup = DispatchGroup()
        var didEncounterError = false
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            dispatchGroup.enter()
            
            managedContext.perform {
                do {
                    try managedContext.execute(batchDeleteRequest)
                    try managedContext.save()
                } catch {
                    print("Error clearing \(entityName): \(error)")
                    didEncounterError = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(!didEncounterError)
        }
    }

    func removeData(at url: URL) {
        let fileManager = FileManager.default
    
        // Check if the file exists
        if fileManager.fileExists(atPath: url.path) {
            do {
                // Remove the file
                try fileManager.removeItem(at: url)
                print("File successfully removed")
            } catch {
                print("Failed to remove file: \(error)")
            }
        } else {
            print("File does not exist")
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
