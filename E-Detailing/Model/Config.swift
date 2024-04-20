////
////  Config.swift
////  E-Detailing
////
////  Created by NAGA PRASATH on 26/05/23.
////
//
//import Foundation
//
//
//struct AppConfig : Decodable {
//    
//    var licenseKey : String!
//    var config : Config!
//    
//    
//    init(fromDictionary dictionary: [String:Any]){
//        if let configData = dictionary["config"] as? [String:Any]{
//                config = Config(fromDictionary: configData)
//            }
//        licenseKey = dictionary["key"] as? String ?? ""
//    }
//    
//    
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if config != nil{
//            dictionary["config"] = config.toDictionary()
//        }
//        if licenseKey != nil{
//            dictionary["key"] = licenseKey
//        }
//        return dictionary
//    }
//}
//
//struct Config : Decodable {
//    
//    var iosUrl : String!
//    var bgImg : String!
//    var division : String!
//    var logoImg : String!
//    var mailUrl : String!
//    var reportUrl : String!
//    var slideUrl : String!
//    var syncUrl : String!
//    var webUrl : String!
//    
//    
//    init(fromDictionary dictionary: [String:Any]) {
//        self.iosUrl = dictionary["iosurl"] as? String ?? ""
//        self.bgImg = dictionary["bgimg"] as? String ?? ""
//        self.division = dictionary["division"] as? String ?? ""
//        self.logoImg = dictionary["logoimg"] as? String ?? ""
//        self.mailUrl = dictionary["mailUrl"] as? String ?? ""
//        self.reportUrl = dictionary["reportUrl"] as? String ?? ""
//        self.slideUrl = dictionary["slideurl"] as? String ?? ""
//        self.syncUrl = dictionary["syncurl"] as? String ?? ""
//        self.webUrl = dictionary["weburl"] as? String ?? ""
//    }
//    
//    
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        
//        if iosUrl != nil{
//            dictionary["iosurl"] = iosUrl
//        }
//        if bgImg != nil{
//            dictionary["bgimg"] = bgImg
//        }
//        if division != nil{
//            dictionary["division"] = division
//        }
//        if logoImg != nil{
//            dictionary["logoimg"] = logoImg
//        }
//        if mailUrl != nil{
//            dictionary["mailUrl"] = mailUrl
//        }
//        if reportUrl != nil{
//            dictionary["reportUrl"] = reportUrl
//        }
//        if slideUrl != nil{
//            dictionary["slideurl"] = slideUrl
//        }
//        if syncUrl != nil{
//            dictionary["syncurl"] = syncUrl
//        }
//        if webUrl != nil{
//            dictionary["weburl"] = webUrl
//        }
//        
//        return dictionary
//    }
//    
//}
