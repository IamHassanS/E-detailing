//
//  ConfigVC.swift
//  E-Detailing
//
//  Created by NAGAPRASATH N on 27/05/23.
//

import Foundation
import UIKit


extension ConfigVC:UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}

class ConfigVC : UIViewController {


        @IBOutlet var licenceKeyLbl: UILabel!
    
        @IBOutlet var devieIDLbl: UILabel!
        @IBOutlet var languageLbl: UILabel!
        @IBOutlet var lblURL: UILabel!
        @IBOutlet var pageTitle: UILabel!
    
        @IBOutlet var appTitle: UILabel!
        @IBOutlet weak var txtWebUrl: UITextField!
        @IBOutlet weak var txtLicenceKey: UITextField!
        @IBOutlet weak var txtDeviceId: UITextField!
        @IBOutlet weak var txtLanguage: UITextField!
    

        @IBOutlet var statusBarView: UIView!
        @IBOutlet var lblPoweredBy: UILabel!
        var config = [AppConfig]()
        var homeVM: HomeViewModal?
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
   //MARK:- initWithStory
    class func initWithStory(homeVM: HomeViewModal)-> ConfigVC{
    
            let view : ConfigVC = UIStoryboard.Hassan.instantiateViewController()
            view.modalPresentationStyle = .overCurrentContext
            view.homeVM = homeVM
            return view
        }
    
    func addObserverForTimeZoneChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)

    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async {
                    if status == ReachabilityManager.ReachabilityStatus.notConnected.rawValue {
                        self.toCreateToast("Please check your internet connection.")
                       
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                    } else if  status == ReachabilityManager.ReachabilityStatus.wifi.rawValue || status ==  ReachabilityManager.ReachabilityStatus.cellular.rawValue   {
                        self.toCreateToast("You are now connected.")
                        
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                    }
                }
            }
        }
    }
    
    
    func checkReachability() {
        network.isReachable() {  reachability in
            
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
               // self.toSetupAlert(text: "Internet connection is required to validate configuration.")
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
               
            }
            
         
        }

        network.isUnreachable() { reachability in
         
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
              //  self.toSetupAlert(text: "Internet connection is required to validate configuration.")
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
             
                
            }
        }
       
        
    }
    
    
    func setupNoNetworkAlert() {
//  
//        lblMenuTitle.text = "Please connect to internet to validate timezone"
//        btnLogout.isHidden = false
    }
    
    
        func setupUI() {
            
            appTitle.text = AppName
            txtWebUrl.delegate = self
            txtLicenceKey.delegate = self
            let headerLbl: [UILabel] = [languageLbl, devieIDLbl, languageLbl, licenceKeyLbl, pageTitle, lblURL]
            headerLbl.forEach {
                $0.setFont(font: .bold(size: .BODY))
                $0.textColor = .appTextColor
            }
    
            [txtWebUrl,txtLicenceKey,txtDeviceId,txtLanguage].forEach { textfield in
                textfield?.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1
                textfield?.layer.cornerRadius = 5
                textfield?.font = UIFont(name: "Satoshi-Medium", size: 14)
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield?.frame.height ?? 50))
                textfield?.leftView = paddingView
                textfield?.rightView = paddingView
                textfield?.leftViewMode = .always
                textfield?.rightViewMode = .always
            }
            txtDeviceId.backgroundColor = .appSelectionColor
            appTitle.setFont(font: .bold(size: .HEADER))
            lblPoweredBy.setFont(font: .medium(size: .BODY))
            lblPoweredBy.textColor = .appLightTextColor
            statusBarView.backgroundColor = .appTextColor
    
          //  txtWebUrl.text = "sanffa.info"
          //  txtLicenceKey.text = "sandemo"
        }


        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            checkReachability()
            addObserverForTimeZoneChange()
            let uuid = UIDevice.current.identifierForVendor?.uuidString
    
            let deviceid = UIDevice.current.identifierForVendor?.description
    
            print(deviceid ?? "")

            self.txtDeviceId.text = "\(uuid ?? "")"
        }

    @IBAction func saveSettingsAction(_ sender: UIButton) {
        print("save")

        if self.txtWebUrl.text!.isEmpty {
           // self.toCreateToast("Please Enter web URL")
            self.toSetupAlert(text: "Please Enter web URL")
            return
        }
        if self.txtLicenceKey.text!.isEmpty {
         //   self.toCreateToast("Please enter license key")
            self.toSetupAlert(text: "Please enter license key")
            return
        }
        toValidateURL()
    }



    func toValidateURL() {

    
       AppConfigURL = self.txtWebUrl.text ?? ""

       //AppConfigURL = "http://\(configPath)/apps/ConfigiOS.json"
         
        //LocalStorage.shared.setSting(LocalStorage.LocalValue.AppconfigURL, text: AppConfigURL)
        
      
        let licenseKey = self.txtLicenceKey.text ?? ""
        LicenceKey = licenseKey
        let param = [String: Any]()
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            Shared.instance.showLoaderInWindow()
            homeVM?.getConfigData(params: param, api: .none) { result in
                switch result {
                case .success(let response):
                    Shared.instance.removeLoaderInWindow()
                    print(response)
                    self.mapResponse(response: response)

                case .failure(let error):
                    Shared.instance.removeLoaderInWindow()
                    //self.toCreateToast(error.rawValue)
                    self.toSetupAlert(text: error.rawValue)
                }
            }
        } else {
            toSetupAlert(text: "Internet connection is required to validate configuration.")
          
        }

    }
    
    
    func toSetupAlert(text: String, istoValidate : Bool? = false) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: text, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
           // self.openSettings()

   
        }
    }
    
    func mapResponse(response: [AppConfig]) {
        
        
        let config  = response.filter { $0.key.caseInsensitiveCompare(licenseKey) == .orderedSame }
        
        guard let appConfig = config.first else {
           // self.toCreateToast("Invalid license key")
            self.toSetupAlert(text: "Invalid license key")
            
            return
        }
        
        if let formattedURL = self.convertToURLFormat(userEnteredText: self.txtWebUrl.text ?? "") {
            print(formattedURL)
            attachmentsUrl = formattedURL
        } else {
            print("Invalid input.")
        }
        
        iosEndPoint = appConfig.config.iosUrl
        webEndPoint = appConfig.config.webUrl
        slideEndPoint = appConfig.config.slideUrl
     
        
        AppMainAPIURL = iosEndPoint
        AppMainSlideURL = slideEndPoint
        ImageUploadURL = attachmentsUrl

        dump(APIUrl)
        dump(AppConfigURL)
        dump(slideURL)
        
        do {
            try AppDefaults.shared.toSaveEncodedData(object: appConfig, key: .config) { isSuccess in
                if isSuccess {
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.isConfigAdded, value: true)
                    
                    self.navigateToLogin()
                }
            }
        } catch {
            print("Unable to save")
        }
        
    }

    func navigateToLogin() {
        self.toCreateToast("\(AppName)" + " configured successfully.")
        let loginVC = LoginVC.initWithStory()
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15


        DispatchQueue.main.async {
            controller.present(alert, animated: true)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }

    }

        func convertToURLFormat(userEnteredText: String) -> String? {
            // Check if the user entered text is not empty
            guard !userEnteredText.isEmpty else {
                return nil
            }
    
            // Check if the user entered text contains a period
            guard userEnteredText.contains(".") else {
                return nil
            }
    
            // Add "https://" if it's not already present
            var formattedText = userEnteredText
            if !formattedText.lowercased().hasPrefix("http://") && !formattedText.lowercased().hasPrefix("https://") {
                formattedText = "https://" + formattedText
            }
    
            // Check if the formatted text ends with a period
            if formattedText.hasSuffix(".") {
                formattedText.removeLast() // Remove the trailing period
            }
    
            return formattedText
        }

}




