//
//  ConfigVC.swift
//  E-Detailing
//
//  Created by NAGAPRASATH N on 27/05/23.
//

import Foundation
import UIKit


extension ConfigVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
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
    
   //MARK:- initWithStory
    class func initWithStory(homeVM: HomeViewModal)-> ConfigVC{
    
            let view : ConfigVC = UIStoryboard.Hassan.instantiateViewController()
            view.modalPresentationStyle = .overCurrentContext
            view.homeVM = homeVM
            return view
        }
    
        func setupUI() {
            txtWebUrl.delegate = self
            txtLicenceKey.delegate = self
            let headerLbl: [UILabel] = [languageLbl, devieIDLbl, languageLbl, licenceKeyLbl, pageTitle, lblURL]
            headerLbl.forEach {
                $0.setFont(font: .bold(size: .BODY))
                $0.textColor = .appTextColor
            }
    
            [txtWebUrl,txtLicenceKey,txtDeviceId,txtLanguage].forEach { textfield in
                textfield?.layer.borderColor = UIColor.appLightTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1
                textfield?.layer.cornerRadius = 5
                textfield?.font = UIFont(name: "Satoshi-Bold", size: 14)
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield?.frame.height ?? 50))
    
                textfield?.leftView = paddingView
                textfield?.rightView = paddingView
                textfield?.leftViewMode = .always
    
                textfield?.rightViewMode = .always
            }
            txtDeviceId.backgroundColor = .appSelectionColor
            appTitle.setFont(font: .bold(size: .SUBHEADER))
            lblPoweredBy.setFont(font: .medium(size: .BODY))
            lblPoweredBy.textColor = .appLightTextColor
            statusBarView.backgroundColor = .appTextColor
    
            txtWebUrl.text = "sanffa.info"
            txtLicenceKey.text = "sandemo"
        }


        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()

            let uuid = UIDevice.current.identifierForVendor?.uuidString
    
            let deviceid = UIDevice.current.identifierForVendor?.description
    
            print(deviceid ?? "")

            self.txtDeviceId.text = "\(uuid ?? "")"
        }

    @IBAction func saveSettingsAction(_ sender: UIButton) {
        print("save")

     
        if self.txtWebUrl.text!.isEmpty {
            self.toCreateToast("Please Enter Web URL")
            return
        }

        if self.txtLicenceKey.text!.isEmpty {
            self.toCreateToast("Please Enter License Key")
            return
        }
        toValidateURL()
    }



    func toValidateURL() {

        Shared.instance.showLoaderInWindow()
        AppConfigURL = self.txtWebUrl.text ?? ""

        let licenseKey = self.txtLicenceKey.text ?? ""
        LicenceKey = licenseKey
        let param = [String: Any]()
        homeVM?.getConfigData(params: param, api: .none) { result in
            switch result {
            case .success(let response):
                Shared.instance.removeLoaderInWindow()
                print(response)
                self.mapResponse(response: response)

            case .failure(let error):
                Shared.instance.removeLoaderInWindow()
                print(error.localizedDescription)
            }
        }
    }
    
    func mapResponse(response: [AppConfig]) {
        
        
        let config  = response.filter { $0.key.caseInsensitiveCompare(licenseKey) == .orderedSame }
        
        guard let appConfig = config.first else {
            self.toCreateToast("Invalid License Key")
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




//
//  ConfigVC.swift
//  E-Detailing
//
//  Created by NAGAPRASATH N on 27/05/23.


//import Foundation
//import UIKit
//import Alamofire
//import Combine


//class ConfigVC : UIViewController {
//    @IBOutlet var licenceKeyLbl: UILabel!
//    
//    @IBOutlet var devieIDLbl: UILabel!
//    @IBOutlet var languageLbl: UILabel!
//    @IBOutlet var lblURL: UILabel!
//    @IBOutlet var pageTitle: UILabel!
//    
//    @IBOutlet var appTitle: UILabel!
//    @IBOutlet weak var txtWebUrl: UITextField!
//    @IBOutlet weak var txtLicenceKey: UITextField!
//    @IBOutlet weak var txtDeviceId: UITextField!
//    @IBOutlet weak var txtLanguage: UITextField!
//    
//    @IBOutlet var statusBarView: UIView!
//    @IBOutlet var lblPoweredBy: UILabel!
//    var config = [AppConfig]()
//    
//    //MARK:- initWithStory
//    class func initWithStory()-> ConfigVC{
//        
//        let view : ConfigVC = UIStoryboard.Hassan.instantiateViewController()
//        view.modalPresentationStyle = .overCurrentContext
//
//        return view
//    }
//    
//    func setupUI() {
//        
//        let headerLbl: [UILabel] = [languageLbl, devieIDLbl, languageLbl, licenceKeyLbl, pageTitle, lblURL]
//        headerLbl.forEach {
//            $0.setFont(font: .bold(size: .BODY))
//            $0.textColor = .appTextColor
//        }
//        
//        appTitle.setFont(font: .bold(size: .SUBHEADER))
//        lblPoweredBy.setFont(font: .medium(size: .BODY))
//        lblPoweredBy.textColor = .appLightTextColor
//        statusBarView.backgroundColor = .appTextColor
//        
//        txtWebUrl.text = "sanffa.info"
//        txtLicenceKey.text = "ed19"
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        
//        
//        
//        [txtWebUrl,txtLicenceKey,txtDeviceId,txtLanguage].forEach { textfield in
//            textfield?.layer.borderColor = UIColor.appLightTextColor.withAlphaComponent(0.2).cgColor
//            textfield?.layer.borderWidth = 1
//            textfield?.layer.cornerRadius = 5
//            textfield?.font = UIFont(name: "Satoshi-Bold", size: 14)
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield?.frame.height ?? 50))
//            
//            textfield?.leftView = paddingView
//            textfield?.rightView = paddingView
//            textfield?.leftViewMode = .always
//            
//            textfield?.rightViewMode = .always
//        }
//        txtDeviceId.backgroundColor = .appSelectionColor
////        AF.request("http://crm.sanclm.info/Apps/ConfigiOS.json").responseJSON{ (responseFeed) in
////            print(responseFeed)
////
////        }
//        
//        
//        let uuid = UIDevice.current.identifierForVendor?.uuidString
//        
//        let deviceid = UIDevice.current.identifierForVendor?.description
//        
//        print(deviceid ?? "")
//        
////        self.txtWebUrl.text = "crm.saneforce.in"
////
////        self.txtLicenceKey.text = "PHP"
//        
//        self.txtDeviceId.text = "\(uuid ?? "")"
//        
//        
//        let uv = Locale.current.languageCode
//        
//
//        
//        if #available(iOS 16, *) {
//            let lan = Locale.current.language
//            
//            print(lan)
//            
//        } else {
//            
//            let lan = Locale.current.languageCode
//            
//   
//        }
//        
//        
//        
////        AF.request("http://crm.saneforce.in/apps/ConfigiOSEdet.json").responseJSON{ (responseFeed) in
////            print(responseFeed)
////
////        }
//        
//        // http://crm.saneforce.in/apps/ConfigiOSEdet.json
//        
//       // AF.request("http://crm.sanclm.info/Apps/ConfigiOS.json").responseDecodable(completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
//        
//        
//        
////        AF.request("http://crm.sanclm.info/Apps/ConfigiOS.json").responseDecodable{ (response) in
////
////            print(response)
////
////        }
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    @IBAction func saveSettingsAction(_ sender: UIButton) {
//        print("save")
//        
//        _ = self.txtWebUrl.text
//        if self.txtWebUrl.text!.isEmpty {
//         //   self.showToast(controller: self, message: "Please Enter Web URL", seconds: 2.0)
//            return
//        }
//        
//        if self.txtLicenceKey.text!.isEmpty {
//        //    self.showToast(controller: self, message: "Please Enter License Key", seconds: 2.0)
//            return
//        }
//        
//        self.configUrl()
//        
//        self.saveConfig()
////        let loginVC = UIStoryboard.loginVC
////        self.navigationController?.pushViewController(loginVC, animated: true)
//    }
//    
//    
//    func saveConfig() {
//        
//        let webUrl = self.txtWebUrl.text ?? ""
//        
//        _ = self.txtLicenceKey.text ?? ""
//        
//        
//        _ = "http://\(webUrl)/apps/ConfigiOS.json"
//
//        
//        // Edet
//        
////        AF.request(urlStr,method: .get,encoding: URLEncoding.default).responseJSON{ (responseFeed) in
////            print(responseFeed)
////
////
////            switch responseFeed.result {
////
////            case .success():
////                do {
////
////                }catch {
////
////                }
////
////            case .failure():
////                self.showToast(controller: self, message: "Invalid Access Configuration Url / Connection Failed", seconds: 2.0)
////
////            }
////
////
////            self.config = responseFeed.map{AppConfig(fromDictionary: $0)}
////
////            print(self.config)
////
////
////        }
//        
//        
//        
//    }
//    
//    
//    
//    func configUrl() {
//        
//        let webUrl = self.txtWebUrl.text ?? ""
//        
//        let licenseKey = self.txtLicenceKey.text ?? ""
//        
//        let urlStr = "http://\(webUrl.replacingOccurrences(of: " ", with: ""))/apps/ConfigiOS.json" // ConfigiOSEdet
//        
//        
//        
//        let url = URL(string: urlStr)!
//        
//        print(url)
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
//        
//        
//        print(request)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            print(data as Any)
//            
//            if error != nil || data == nil {
//              //  self.showToast(controller: self, message: "Invalid Access Configuration Url / Connection Failed", seconds: 2.0)
//                self.toCreateToast("Invalid Access Configuration Url / Connection Failed")
//            }
//            
//           // self.showToast(controller: self, message: "Invalid Access Configuration Url / Connection Failed", seconds: 2.0)
//            
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            
//            
//            if let response = responseJSON as? [[String: Any]] {
//                print(response)
//                
//            //    self.config = response.map{AppConfig(fromDictionary: $0)}
//                
//            //    let config = self.config.filter{$0.licenseKey.caseInsensitiveCompare(licenseKey) == .orderedSame}
//                
////                print(config)
////                guard let appConfig = config.first else {
////                  //  self.showToast(controller: self, message: "Invalid License Key", seconds: 2.0)
////                    self.toCreateToast("Invalid License Key")
////                    return
////                }
////                
////                AppDefaults.shared.save(key: .config, value: appConfig.toDictionary())
////                let appconfig = AppDefaults.shared.getConfig()
////                iosEndPoint = appconfig.config.iosUrl
////                webEndPoint = appconfig.config.webUrl
////                slideEndPoint = appconfig.config.slideUrl
////                 Example usage:
////                if let formattedURL = self.convertToURLFormat(userEnteredText: webUrl) {
////                    print(formattedURL)
////                    attachmentsUrl = formattedURL
////                } else {
////                    print("Invalid input.")
////                }
////               
////                AppMainAPIURL = iosEndPoint
////                AppMainSlideURL = slideEndPoint
////                
////                dump(APIUrl)
////                dump(appMainURL)
////                dump(slideURL)
////                
////                DispatchQueue.main.async {
////                    let loginVC = LoginVC.initWithStory()
////                    self.navigationController?.pushViewController(loginVC, animated: true)
////                }
// 
//            }
//            
//        }.resume()
//        
//        AF.request(urlStr,method: .get).responseDecodable(of: AppConfig.self) { (response) in
//            
//            print("5")
//            print(response)
//        
//          
//            print("5")
//        }
//        
//        
//    }
//
////    func convertToURLFormat(userEnteredText: String) -> String? {
////        // Check if the user entered text is not empty
////        guard !userEnteredText.isEmpty else {
////            return nil
////        }
////
////        // Check if the user entered text contains a period
////        guard userEnteredText.contains(".") else {
////            return nil
////        }
////
////        // Add "https://" if it's not already present
////        var formattedText = userEnteredText
////        if !formattedText.lowercased().hasPrefix("http://") && !formattedText.lowercased().hasPrefix("https://") {
////            formattedText = "https://" + formattedText
////        }
////
////        // Check if the formatted text ends with a period
////        if formattedText.hasSuffix(".") {
////            formattedText.removeLast() // Remove the trailing period
////        }
////
////        return formattedText
////    }
//
////    
////    func showToast(controller: UIViewController, message : String, seconds: Double) {
////        
////        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
////
////        alert.view.backgroundColor = .black
////        alert.view.alpha = 0.5
////        alert.view.layer.cornerRadius = 15
////
////        
////        DispatchQueue.main.async {
////            controller.present(alert, animated: true)
////        }
////        
////        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
////            alert.dismiss(animated: true)
////        }
////        
////    }
//
//    
//    
//}

