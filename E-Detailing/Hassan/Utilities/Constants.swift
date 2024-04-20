//
//  Constants.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/11/23.
//



import Foundation
import UIKit

// MARK: - Application Details
/**
 isSimulator is a Global Variable.isSimulator used to identfy the current running mechine
 - note : Used in segregate Simulator and device to do appropriate action
 */
var isSimulator : Bool { return TARGET_OS_SIMULATOR != 0 }
/**
 AppVersion is a Global Variable.AppVersion used to get the current app version from info plist
 - note : Used in Force update functionality to get newer version update
 */
var AppVersion : String? = { return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String }()


// MARK: - UserDefaults Easy Access
/**
 userDefaults is a Global Variable.
 - note : userDefaults used to store and retrive details from Local Storage (Short Access)
 */
let userDefaults = UserDefaults.standard

let infoPlist = PlistReader<InfoPlistKeys>()
/**
 */

let GooglePlacesApiKey : String = infoPlist?.value(for: .Google_Places_keys) ?? ""

var APIBaseUrl : String  {
    get {
        APIUrl
    }
    set(newURL){
        APIUrl = "http://\(newURL.replacingOccurrences(of: " ", with: ""))/apps/ConfigiOS.json"
    }
}

var LicenceKey : String  {
    get {
        licenseKey
    }
    set(newKey){
        licenseKey = newKey
    }
}


//(infoPlist?.value(for: .App_URL) ?? "").replacingOccurrences(of: "\\", with: "")
//= (infoPlist?.value(for: .Image_URL) ?? "").replacingOccurrences(of: "\\", with: "")
var APIUrl : String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.AppMainURL)

var slideURL : String =   LocalStorage.shared.getString(key: LocalStorage.LocalValue.SlideURL)
var AppConfigURL: String = "" {
    didSet {
        
    AppConfigURL = "http://\(AppConfigURL)/apps/ConfigiOS.json"
     
    }
}
var licenseKey : String = ""

var  attachmentsUrl : String = ""
var  webEndPoint: String = ""
var  iosEndPoint : String = ""
var  syncEndPoint : String = ""
var  slideEndPoint: String = ""


var AppMainAPIURL : String  {
    get {
        webEndPoint
    }
    set(newURL){
        LocalStorage.shared.setSting(LocalStorage.LocalValue.AppMainURL, text: webEndPoint + iosEndPoint)
    }
}


var AppMainSlideURL : String  {
    get {
        slideEndPoint
    }
    set(newURL){
        LocalStorage.shared.setSting(LocalStorage.LocalValue.SlideURL, text: attachmentsUrl + "/" + slideEndPoint)
        
    }
}








//
