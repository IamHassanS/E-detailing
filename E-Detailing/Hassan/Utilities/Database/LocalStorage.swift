//
//  LocalStorage.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/12/23.
//

import Foundation

class LocalStorage {
    
    enum UserDefaultsError: Error {
        case encodingFailed
        case decodingFailed
        case dataNotFound
    }
    
    static var shared = LocalStorage()
    
    var sentToApprovalModelArr = [SentToApprovalModel]()
    
    enum LocalValue:String {
        case AppMainURL
        case AppconfigURL
        case SlideURL
        case ImageUploadURL
        case ImageDownloadURL
        case AttachmentsURL
        case UserName
        case UserPassword
        case AppIcon
        case istoEnableApproveBtn
        case TPalldatesAppended
        case TPisForFinalDate
        case isMR
        case offsets
        case slideResponse
        case BrandSlideResponse
        case isConnectedToNetwork
        case LoadedSlideData
        case LoadedBrandSlideData
        case SavedPresentations
        case isSlidesLoaded
        case rsfIDPlan1
        case rsfIDPlan2
        case selectedRSFID
        case selectedHQObj
        case isUserCheckedin
        case lastCheckedInDate
        case isLoginSynced
        case userCheckedOut
        case istoUploadDayplans
        case slideDownloadIndex
        case isSlidesGrouped
        case isUserLoggedIn
        case hasMasterData
        case isConfigAdded
        case isSlidesDownloadPending
        case isTimeZoneChanged
        
    }
    
    enum Offsets: String {
        case none
        case all
        case current
        case next
        case previous
        case nextAndPrevious
        case currentAndNext
        case currentAndPrevious
    }
    
    
    func storeOffset(_ offset: Offsets) {
        let defaults = UserDefaults.standard
        defaults.set(offset.rawValue, forKey: "offsetKey")
    }
    
    func retrieveOffset() -> Offsets? {
        let defaults = UserDefaults.standard
        if let rawValue = defaults.string(forKey: "offsetKey"),
            let offset = Offsets(rawValue: rawValue) {
            return offset
        }
        return nil
    }
    
//    func setOffset(_ key :LocalValue,value: Offsets) {
//        UserDefaults.standard.set(value, forKey: key.rawValue)
//    }
//    
//    func getOffset(key:LocalValue)->Offsets {
//        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
//            self.setOffset(key, value: .all)
//        }
//        let result = UserDefaults.standard.value(forKey: key.rawValue)
//        return result as! LocalStorage.Offsets
//    }
    
    func setData(_ key:LocalValue,data:Data = Data()){
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    func setSting(_ key:LocalValue,text:String = "" ){
        UserDefaults.standard.set(text, forKey: key.rawValue)
    }
    
    func setDouble(_ key :LocalValue,value:Double = 0.0) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setBool(_ key :LocalValue,value:Bool = false) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getBool(key:LocalValue)->Bool{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setBool(key)
        }
     let result = UserDefaults.standard.bool(forKey: key.rawValue)
            return result
        
    }
    
    
    func getData(key:LocalValue)->Data{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setData(key)
        }
        if let result = UserDefaults.standard.value(forKey: key.rawValue) {
            return result as! Data
        }
        return  Data()
    }
    
    func getString(key:LocalValue)->String{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setSting(key)
        }
        if let result = UserDefaults.standard.string(forKey: key.rawValue) {
            return result
        }
        return  ""
    }
    
    func getDouble(key:LocalValue)->Double {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setDouble(key)
        }
        let result = UserDefaults.standard.double(forKey: key.rawValue)
        return result
    }
    
    
    // Save function
    func saveObjectToUserDefaults<T: Codable>(_ object: T, forKey key: LocalValue) {
        do {
            // Convert the object to Data
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(object)

            // Save the Data to UserDefaults
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
        } catch {
            print("Error encoding object: \(error)")
        }
    }

    // Retrieve function
    func retrieveObjectFromUserDefaults<T: Codable>(forKey key: LocalValue) throws -> T {
        guard let encodedData = UserDefaults.standard.data(forKey: key.rawValue) else {
            throw UserDefaultsError.dataNotFound
        }

        do {
            // Decode Data to the specified type
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: encodedData)
            return object
        } catch {
            throw UserDefaultsError.decodingFailed
        }
    }
    
    
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
