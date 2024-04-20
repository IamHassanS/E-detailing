//
//  InfoPlistKeys.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/11/23.
//

import Foundation



enum GooglePlistKeys : String{
    case clientId = "CLIENT_ID"
    case apiKey = "API_KEY"
}
extension GooglePlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "GoogleService-Info"
    }
    
    
}

enum InfoPlistKeys : String{
    case App_URL
    case Image_URL
    case ThemeColors
    case UserType
    case Google_Places_keys = "GMSServicesAPIKey"
}
extension InfoPlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "Info"
    }
    
    
}

protocol PlistKeys {
    var key : String{get}
    static var fileName : String {get}
}
class PlistReader<KeyContainer : PlistKeys>{
    fileprivate var data : JSON
    init?(){
        
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
          let plistPath: String? = Bundle.main.path(
            forResource: KeyContainer.fileName,
            ofType: "plist"
            )! //the path of the data
          let plistXML = FileManager.default.contents(atPath: plistPath!)!
          do {//convert the data to a dictionary and handle errors.
            self.data = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! JSON

          } catch {
        
              print("Error reading plist: \(error), format: \(propertyListFormat)")
            return nil
          }
    }
}
extension PlistReader {
    func value<T>(for key : KeyContainer) -> T?{
        return self.data[key.key] as? T
    }
    func value<T>(for key : KeyContainer) -> [T]?{
        return self.data[key.key] as? [T]
    }
}



//
