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

var isDayCheckinNeeded : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isDayCheckinEnabled)

var isSequentialDCRenabled : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSequentialDCR)

var geoFencingEnabled : Bool =  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isGeoFencingEnabled)

var customerChekinEnabled : Bool =  false
//LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isCustomerChekinNeeded)


var isDoctorFencingNeeded : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isDoctorFencingEnabled)


var isChemistFencingNeeded : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isChemistFencingEnabled)

var isStockistFencingNeeded : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isStockistFencingEnabled)

var isUnliatedDoctorFencingNeeded : Bool = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUnlistedDoctorFencingEnabled)

//var isConnected: Bool {
//    get {
//        return LocalStorage.shared.getBool(key: .isConnectedToNetwork)
//    }
//}

//MARK: - DCR setups
//Listed doctor setups

var isDoctorDetailingNeeded = LocalStorage.shared.getBool(key: .isDoctorDetailingNeeded)

var isDoctorProductNedded = LocalStorage.shared.getBool(key: .isDoctorProductNedded)

var isDoctorProductSampleNeeded = LocalStorage.shared.getBool(key: .isDoctorProductSampleNeeded)

var isDoctorProductRXneeded = LocalStorage.shared.getBool(key: .isDoctorProductRXneeded)

var isDoctorInputNeeded = LocalStorage.shared.getBool(key: .isDoctorInputNeeded)

var isDoctorAdditionalCallNeeded = LocalStorage.shared.getBool(key: .isDoctorAdditionalCallNeeded)

var isDoctorRCPAneeded = LocalStorage.shared.getBool(key: .isDoctorRCPAneeded)

var isDoctorJointWorkNeeded = LocalStorage.shared.getBool(key: .isDoctorJointWorkNeeded)

var isDoctorPOBNeeded = LocalStorage.shared.getBool(key: .isDoctorPOBNeeded)

var isDoctorFeedbackNeeded = LocalStorage.shared.getBool(key: .isDoctorFeedbackNeeded)

var isDoctorEventCaptureNeeded = LocalStorage.shared.getBool(key: .isDoctorEventCaptureNeeded)

var isDoctorProductNeddedMandatory = LocalStorage.shared.getBool(key: .isDoctorProductNeddedMandatory)

var isDoctorProductSampleNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorProductSampleNeededMandatory)

var isDoctorProductRXneededMandatory = LocalStorage.shared.getBool(key: .isDoctorProductRXneededMandatory)

var isDoctorInputNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorInputNeededMandatory)

var isDoctorRCPAneededMandatory = LocalStorage.shared.getBool(key: .isDoctorRCPAneededMandatory)

var isDoctorJointWorkNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorJointWorkNeededMandatory)

var isDoctorPOBNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorPOBNeededMandatory)

var isDoctorFeedbackNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorFeedbackNeededMandatory)

var isDoctorRemarksNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorRemarksNeededMandatory)

var isDoctorEventCaptureNeededMandatory = LocalStorage.shared.getBool(key: .isDoctorEventCaptureNeededMandatory)

//Chemist

var isChemistDetailingNeeded = LocalStorage.shared.getBool(key: .isChemistDetailingNeeded)

var isChemistProductNedded = LocalStorage.shared.getBool(key: .isChemistProductNedded)

var isChemistProductSampleNeeded = LocalStorage.shared.getBool(key: .isChemistProductSampleNeeded)

var isChemistProductRXneeded = LocalStorage.shared.getBool(key: .isChemistProductRXneeded)

var isChemistInputNeeded = LocalStorage.shared.getBool(key: .isChemistInputNeeded)

var isChemistRCPAneeded = LocalStorage.shared.getBool(key: .isChemistRCPAneeded)

var isChemistJointWorkNeeded = LocalStorage.shared.getBool(key: .isChemistJointWorkNeeded)

var isChemistPOBNeeded = LocalStorage.shared.getBool(key: .isChemistPOBNeeded)

var isChemistFeedbackNeeded = LocalStorage.shared.getBool(key: .isChemistFeedbackNeeded)

var isChemistEventCaptureNeeded = LocalStorage.shared.getBool(key: .isChemistEventCaptureNeeded)

var isChemistRCPAneededMandatory = LocalStorage.shared.getBool(key: .isChemistRCPAneededMandatory)

var isChemistJointWorkNeededMandatory = LocalStorage.shared.getBool(key: .isChemistJointWorkNeededMandatory)

var isChemistPOBNeededMandatory = LocalStorage.shared.getBool(key: .isChemistPOBNeededMandatory)

var isChemistEventCaptureNeededMandatory = LocalStorage.shared.getBool(key: .isChemistEventCaptureNeededMandatory)

//Stockist

var istockisDetailingNeeded = LocalStorage.shared.getBool(key: .istockisDetailingNeeded)

var isStockistProductNedded = LocalStorage.shared.getBool(key: .isStockistProductNedded)

var isStockistProductSampleNeeded = LocalStorage.shared.getBool(key: .isStockistProductSampleNeeded)

var isStockistProductRXneeded = LocalStorage.shared.getBool(key: .isStockistProductRXneeded)

var isStockistInputNeeded = LocalStorage.shared.getBool(key: .isStockistInputNeeded)

var isStockistJointWorkNeeded = LocalStorage.shared.getBool(key: .isStockistJointWorkNeeded)

var isStockistPOBNeeded = LocalStorage.shared.getBool(key: .isStockistPOBNeeded)

var isStockistFeedbackNeeded = LocalStorage.shared.getBool(key: .isStockistFeedbackNeeded)

var isStockistEventCaptureNeeded = LocalStorage.shared.getBool(key: .isStockistEventCaptureNeeded)

var isStockistJointWorkNeededMandatory = LocalStorage.shared.getBool(key: .isStockistJointWorkNeededMandatory)

var isStockistPOBNeededMandatory = LocalStorage.shared.getBool(key: .isStockistPOBNeededMandatory)

var isStockistEventCaptureNeededMandatory = LocalStorage.shared.getBool(key: .isStockistEventCaptureNeededMandatory)

//Unlisted Doctors

var isUnListedDoctorDetailingNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorDetailingNeeded)

var isUnListedDoctorProductNedded = LocalStorage.shared.getBool(key: .isUnListedDoctorProductNedded)

var isUnListedDoctorProductSampleNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorProductSampleNeeded)

var isUnListedDoctorProductRXneeded = LocalStorage.shared.getBool(key: .isUnListedDoctorProductRXneeded)

var isUnListedDoctorInputNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorInputNeeded)

var isUnListedDoctorAdditionalCallNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorAdditionalCallNeeded)

var isUnListedDoctorRCPAneeded = LocalStorage.shared.getBool(key: .isUnListedDoctorRCPAneeded)

var isUnListedDoctorJointWorkNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorJointWorkNeeded)

var isUnListedDoctorPOBNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorPOBNeeded)

var isUnListedDoctorFeedbackNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorFeedbackNeeded)

var isUnListedDoctorEventCaptureNeeded = LocalStorage.shared.getBool(key: .isUnListedDoctorEventCaptureNeeded)

var isUnListedDoctorProductNeddedMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorProductNeddedMandatory)

var isUnListedDoctorProductSampleNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorProductSampleNeededMandatory)

var isUnListedDoctorProductRXneededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorProductRXneededMandatory)

var isUnListedDoctorInputNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorInputNeededMandatory)

var isUnListedDoctorRCPAneededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorRCPAneededMandatory)

var isUnListedDoctorJointWorkNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorJointWorkNeededMandatory)

var isUnListedDoctorPOBNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorPOBNeededMandatory)

var isUnListedDoctorFeedbackNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorFeedbackNeededMandatory)

var isUnListedDoctorRemarksNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorRemarksNeededMandatory)

var isUnListedDoctorEventCaptureNeededMandatory = LocalStorage.shared.getBool(key: .isUnListedDoctorEventCaptureNeededMandatory)


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
