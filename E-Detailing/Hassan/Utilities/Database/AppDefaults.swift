

import Foundation

enum keys : String {
    
    case config = "Config"
    case logoImage = "Logo Image"
    case appSetUp = "App Set Up"
    case slide = "Slides"
    case syncTime = "Sync Time"
    case tourPlan = "TourPlan"
    case sessionDetails = "sessionDetails"
    case isAllDatesFilled =  "isAllDatesFilled"
}

class AppDefaults {
    
    
    static let shared = AppDefaults()
    
    var webUrl : String = ""
    var iosUrl  : String = ""
    var syncUrl : String = ""
    var imgLogo : String = ""
    var slideUrl : String  = ""
    var reportUrl : String = ""
    var sfCode : String = ""
    var sessionDetailsArr : SessionDetailsArr?
    var tpArry = TourPlanArr()
    var eachDatePlan = EachDatePlan()
    let userdefaults = UserDefaults.standard
    var appSetup: AppSetUp?
    var appConfig: AppConfig?
    
    func getConfig() -> AppConfig {
        let appData = UserDefaults.standard.data(forKey: keys.config.rawValue) ?? nil
        guard let appData = appData else {return AppConfig()}
        let decoder = JSONDecoder()
        var isDecoded: Bool = false
        do {
            
            let decodedData = try decoder.decode(AppConfig.self, from: appData)
            isDecoded = true
            self.appConfig = decodedData
        } catch {
            print("Unable to decode")
        }
        if isDecoded {
            self.webUrl = appConfig?.config.webUrl ?? ""
            self.iosUrl = appConfig?.config.iosUrl ?? ""
            self.syncUrl = appConfig?.config.syncUrl ?? ""
            self.slideUrl = appConfig?.config.slideUrl ?? ""
            self.imgLogo = appConfig?.config.logoImg ?? ""
            self.reportUrl = appConfig?.config.reportUrl ?? ""
            return appConfig ?? AppConfig()

        } else {
            return AppConfig()
        }
    }
    
//    func getConfignew() -> AppConfig {
//        
//        guard let config = self.get(key: .config, type: [String : Any]()) else {
//           return AppConfig(fromDictionary: [:])
//        }
//        
//        let configData = AppConfig(fromDictionary: config)
//        
//        if let config = configData.config {
//            
//            self.webUrl = config.webUrl
//            self.iosUrl = config.iosUrl
//            self.syncUrl = config.syncUrl
//            self.slideUrl = config.slideUrl
//            self.imgLogo = config.logoImg
//            self.reportUrl = config.reportUrl
//        }
//        return configData
//    }
    
    
    func isConfigAdded () -> Bool {
  
        return LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConfigAdded)
    }
    

    
    
        func isLoggedIn() -> Bool {
            
          return  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedIn)
        
      
            
        }
    
    
    func isSyncCompleted() -> Bool {
        return  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.hasMasterData)
    }
    
    func getLogoImgData() -> [String : Any] {
        guard let data = self.get(key: .logoImage, type: [String : Any]())else{
            return [String : Any]()
        }
        return data
    }
    
    
    func getAppSetUp() -> AppSetUp {

        let appData = UserDefaults.standard.data(forKey: keys.appSetUp.rawValue) ?? nil
        guard let appData = appData else {return AppSetUp()}
        let decoder = JSONDecoder()
        var isDecoded: Bool = false
        do {
            
            let decodedData = try decoder.decode(AppSetUp.self, from: appData)
            isDecoded = true
            self.appSetup = decodedData
        } catch {
            print("Unable to decode")
        }
        if isDecoded {
            return appSetup ?? AppSetUp()
        } else {
            return AppSetUp()
        }
    }
    
//    func getAppSetUp() -> AppSetUp {
//        guard let setup = self.get(key: .appSetUp, type: [String : Any]()) else {
//            return AppSetUp(fromDictionary: [:])
//        }
//        return AppSetUp(fromDictionary: setup)
//    }
    
    
    func getSlides() -> [[String : Any]] {
        guard let slideArray = self.get(key: .slide, type: [[String : Any]]()) else{
            return [[String : Any]]()
        }
        return slideArray
    }
    
    
    func getSyncTime() -> Date {
        if let date = self.get(key: .syncTime, type: Date()) {
            return date
        }
        return Date()
    }
    
    
    func reset () {
        let dictionary = self.userdefaults.dictionaryRepresentation()
        dictionary.keys.forEach{ key in
            self.userdefaults.removeObject(forKey: key)
        }
        self.userdefaults.synchronize()
    }
    
    
    func save<T>(key : keys,value : T) {
        self.userdefaults.set(value, forKey: key.rawValue)
        self.userdefaults.synchronize()
    }
    
    
    func get<T>(key: keys, type : T) -> T? {
        if let data = self.userdefaults.value(forKey: key.rawValue) as? T {
            return data
        }
        return nil
    }
    
        func toSaveEncodedData<T: Codable>(object: T, key : keys, completion: (Bool) -> ()) throws {
            let encoder = JSONEncoder()
            do {
                let encodedData = try encoder.encode(object)
                UserDefaults.standard.set(encodedData, forKey: key.rawValue)
                completion(true)
            } catch {
                print("Unable to Encode")
                completion(false)
            }
        }

}
