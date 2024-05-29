//
//  Constants.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/01/24.
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

let AppName : String =  infoPlist?.value(for: .App_Name) ?? ""

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

var appConfigURL : String =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.AppconfigURL)

var imageUploadURL : String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageUploadURL)

var imageDownloadURL : String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageDownloadURL)

var attachmentURL : String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.AttachmentsURL)

var AppConfigURL: String = "" {
    didSet {
        
    AppConfigURL = "http://\(AppConfigURL)/apps/ConfigiOS.json"
     
    LocalStorage.shared.setSting(LocalStorage.LocalValue.AppconfigURL, text: AppConfigURL)
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

var ImageUploadURL : String {
    get {
        attachmentsUrl
    }
    set {
        LocalStorage.shared.setSting(LocalStorage.LocalValue.ImageUploadURL, text: attachmentsUrl + "/" + iosEndPoint)
        
        LocalStorage.shared.setSting(LocalStorage.LocalValue.ImageDownloadURL, text: attachmentsUrl + "/photos/")
        
        
        LocalStorage.shared.setSting(LocalStorage.LocalValue.AttachmentsURL, text: attachmentsUrl + "/")
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
