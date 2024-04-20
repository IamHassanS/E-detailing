////
////  AppDefaults.swift
////  E-Detailing
////
////  Created by NAGAPRASATH on 14/06/23.
////
//
//import Foundation
//
//enum keys : String {
//
//    case config = "Config"
//    case logoImage = "Logo Image"
//    case appSetUp = "App Set Up"
//    case slide = "Slides"
//    case syncTime = "Sync Time"
//    case appMainURL = "appMainURL"
//}
//
//class AppDefaults {
//
//
//    static let shared = AppDefaults()
//
//    var webUrl : String = ""
//    var iosUrl  : String = ""
//    var syncUrl : String = ""
//    var imgLogo : String = ""
//    var slideUrl : String  = ""
//    var reportUrl : String = ""
//    var appConfig : Config?
//    var appSetup : AppSetUp?
//    var sfCode : String = ""
//
//    let userdefaults = UserDefaults.standard
//
//
//    func getConfig() -> Config {
//
//        let configData = UserDefaults.standard.data(forKey: keys.config.rawValue)
//        let decoder = JSONDecoder()
//        var isDecoded: Bool = false
//        do {
//            let decodedData = try decoder.decode(Config.self, from: configData ?? Data())
//            isDecoded = true
//                        self.webUrl = decodedData.webUrl
//                        self.iosUrl = decodedData.iosUrl
//                        self.syncUrl = decodedData.syncUrl
//                        self.slideUrl = decodedData.slideUrl
//                        self.imgLogo = decodedData.logoImg
//                        self.reportUrl = decodedData.reportUrl
//            appMainURL = decodedData.webUrl + decodedData.iosUrl
//            self.save(key: .appMainURL, value: appMainURL)
//                        self.appConfig = decodedData
//
//        } catch {
//            print("Unable to decode")
//        }
//        if isDecoded {
//            return appConfig ?? Config()
//        } else {
//            return Config()
//        }
//    }
//
//
//
//
//    func isConfigAdded () -> Bool {
//        if appConfig == nil {
//            return false
//        }
//        return true
////        guard let _ = self.get(key: .config, type: [String: Any]()) else {
////            return false
////        }
////        return true
//    }
//
//    func isLoggedIn() -> Bool {
//
//       let appSetup = AppDefaults.shared.getAppSetUp()
//
//        return true
//
////        guard let appsetup = self.get(key: .appSetUp, type: [String : Any]())else{
////            return false
////        }
////
////        return !appsetup.isEmpty
//    }
//
//    func getLogoImgData() -> [String : Any] {
//        guard let data = self.get(key: .logoImage, type: [String : Any]())else{
//            return [String : Any]()
//        }
//        return data
//    }
//
////    func getAppSetUp() -> AppSetUp {
////        guard let setup = self.get(key: .appSetUp, type: [String : Any]()) else {
////            return AppSetUp(fromDictionary: [:])
////        }
////        return AppSetUp(fromDictionary: setup)
////    }
//

//
//
//    func getSlides() -> [[String : Any]] {
//        guard let slideArray = self.get(key: .slide, type: [[String : Any]]()) else{
//            return [[String : Any]]()
//        }
//        return slideArray
//    }
//
//
//    func getSyncTime() -> Date {
//        if let date = self.get(key: .syncTime, type: Date()) {
//            return date
//        }
//        return Date()
//    }
//
//
//    func reset () {
//        let dictionary = self.userdefaults.dictionaryRepresentation()
//        dictionary.keys.forEach{ key in
//            self.userdefaults.removeObject(forKey: key)
//        }
//        self.userdefaults.synchronize()
//    }
//
//
//    func save<T>(key : keys,value : T) {
//        self.userdefaults.set(value, forKey: key.rawValue)
//        self.userdefaults.synchronize()
//    }
//
//
//    func saveData<T>(key : keys,value : T) {
//        self.userdefaults.set(value, forKey: key.rawValue)
//        self.userdefaults.synchronize()
//    }
//
//
//    func get<T>(key: keys, type : T) -> T? {
//        if let data = self.userdefaults.value(forKey: key.rawValue) as? T {
//            return data
//        }
//        return nil
//    }
//

//
//
//
//
//
//}

//
//  AppDefaults.swift
//  E-Detailing
//
//  Created by NAGAPRASATH on 14/06/23.
//

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
    
//    func getToutplanDetails() -> TourPlanArr {
//        let tourPlanArr = TourPlanArr()
//        let tourData = UserDefaults.standard.data(forKey: keys.tourPlan.rawValue)
//        let decoder = JSONDecoder()
//        var isDecoded: Bool = false
//        do {
//            let decodedData = try decoder.decode(SessionAPIResponseModel.self, from: tourData!)
//            isDecoded = true
//
//            //self.appSetup = decodedData
//
//            decodedData.tpData.forEach { tourplanData in
//                var tempSessionArr  = SessionDetailsArr()
//                tourplanData.sessions.forEach { session in
//                    var tempSession = SessionDetail()
//                    //Field Work Y or N:
//                    tempSession.isForFieldWork = session.FWFlg == "N" ? false : true
//
//                    //Work type
//                    tempSession.workTypeCode = session.WTCode
//
//                    //HeadQuarters
////                    let headQuatersCodes =  session.HQCodes.components(separatedBy: ",")
////                    headQuatersCodes.forEach { code in
////                        tempSession.selectedHeadQuaterID[code] = true
////                    }
//                    tempSession.HQCodes = session.HQCodes
//                    //Chemist
//                    let chemistCodes =  session.chemCode.components(separatedBy: ",")
//                    chemistCodes.forEach { code in
//                        tempSession.selectedchemistID?[code] = true
//                    }
//
//
//                    //cluster
//                    let clusterCodes =  session.clusterCode.components(separatedBy: ",")
//                    clusterCodes.forEach { code in
//                        tempSession.selectedClusterID?[code] = true
//                    }
//
//                    //Doctor
//                    let doctorCode =  session.drCode.components(separatedBy: ",")
//                    doctorCode.forEach { code in
//                        tempSession.selectedlistedDoctorsID?[code] = true
//                    }
//
//                    let jwCode = session.jwCode.components(separatedBy: ",")
//                    jwCode.forEach { code in
//                        tempSession.selectedjointWorkID?[code] = true
//                    }
//
//                    tempSessionArr.sessionDetails?.append(tempSession)
//                    tempSession = SessionDetail()
//
//                }
//                tempSessionArr.changeStatus = tourplanData.changeStatus
//                tempSessionArr.date = tourplanData.date
//                tempSessionArr.day = tourplanData.day
//                tempSessionArr.dayNo = tourplanData.dayNo
//                tempSessionArr.entryMode = tourplanData.entryMode
//                tempSessionArr.rejectionReason = tourplanData.rejectionReason
//                tourPlanArr.arrOfPlan?.append(tempSessionArr)
//                tempSessionArr  = SessionDetailsArr()
//            }
//        } catch {
//            print("Unable to decode")
//        }
//        if isDecoded {
//            //return appSetup ?? AppSetUp()
//            return tourPlanArr
//        } else {
//            return TourPlanArr()
//        }
//    }
}
