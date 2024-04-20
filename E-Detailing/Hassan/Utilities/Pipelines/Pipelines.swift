//
//  Pipelines.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/02/24.
//

import Foundation
import UIKit
import MapKit




struct CheckinInfo {
    var address: String?
    var checkinDateTime: String?
    var checkOutDateTime: String?
    var latitude: Double?
    var longitude: Double?
    var dateStr: String?
    var checkinTime: String?
    var checkOutTime: String?
}

struct Coordinates {
    let latitude: Double?
    let longitude: Double?
}

class Pipelines  {


    static let shared = Pipelines()
    
    let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    
   
    var window: UIWindow?
    
    func doLogout() {
        window = appDelegate.window
        self.window?.rootViewController = UINavigationController.init(rootViewController: LoginVC.initWithStory())
    }
    
    
    func downloadData(mediaURL: String, delegate: MediaDownloaderDelegate) {
        //, completion: @escaping (Data?, Error?) -> Void
        guard let url = URL(string: mediaURL) else {
           // completion(nil, NSError(domain: "E-Detailing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let downloader = MediaDownloader()
        downloader.delegate = delegate
        downloader.downloadMedia(from: url)
    }
    
    
    func requestAuth(completion: @escaping (Coordinates?) -> Void)  {

        let locManager = CLLocationManager()
        var currentLocation = CLLocation()
      //  locManager.delegate = self

        locManager.requestWhenInUseAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location ?? CLLocation()
            
       let coordinates = Coordinates(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude))
            completion(coordinates)
        } else {
            
            completion(nil)
           
        }
    }
    
    
    func callCheckinCheckoutAPI(userstrtisticsVM: UserStatisticsVM, model: CheckinInfo, appsetup: AppSetUp, completion : @escaping (Result<[GeneralResponseModal],UserStatisticsError>) -> Void) {
        var param: [String: Any] = [:]
        param["tableName"] = "savetp_attendance"
        param["sfcode"] = appsetup.sfCode
        let divcodeArr = appsetup.divisionCode?.components(separatedBy: ",")
        param["division_code"] = divcodeArr?[0]
        param["lat"] = model.latitude
        param["long"] = model.longitude
        param["address"] = model.address
        param["update"] = "0"
        param["Appver"] = "V2.0.8"
        param["Mod"] = "iOS-Edet"
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfname"] = appsetup.sfName
        param["Employee_Id"] = appsetup.sfName
        param["Check_In"] = model.checkinTime
        param["Check_Out"] = model.checkOutTime
        param["DateTime"] = model.dateStr
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        print(param)
        
        userstrtisticsVM.registerCheckin(params: toSendData, api: .checkin, paramData: param) { result in
            completion(result)
        }
        
    }
    
    
    func getAddressString(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()

        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (places, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let place = places?.first {
                var addressString = ""
                if let subThoroughfare = place.subThoroughfare {
                    addressString += "\(subThoroughfare),"
                }
                
                if let thoroughfare = place.thoroughfare {
                    addressString += " \(thoroughfare),"
                }

        

                if let locality = place.locality {
                    addressString += " \(locality),"
                }

                if let administrativeArea = place.administrativeArea {
                    addressString += " \(administrativeArea),"
                }

                if let postalCode = place.postalCode {
                    addressString += " \(postalCode)"
                }

                completion(addressString)
            } else {
                completion(nil)
            }
        }
    }
    
    func calculatePersistentStorageSize() -> UInt64? {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentsPath = documentsURL.path
            
            var totalSize: UInt64 = 0
            
            if let enumerator = FileManager.default.enumerator(atPath: documentsPath) {
                for file in enumerator {
                     let filePath = (documentsPath as NSString).appendingPathComponent(file as! String)
                    if let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) {
                        if let fileSize = attributes[FileAttributeKey.size] as? UInt64 {
                            totalSize += fileSize
                        }
                    }
                }
            }
            
            // Convert to MB for readability
            let totalSizeInMB = Double(totalSize) / (1024 * 1024)
            print("Total Persistent Storage Size: \(totalSizeInMB) MB")
            
            return totalSize
        } catch {
            print("Error calculating persistent storage size: \(error)")
            return nil
        }
    }

    
//    func toGroupSlides(mastersyncVM: MasterSyncVM, completion: @escaping () -> ()) {
//        if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesGrouped) {
//  
//            mastersyncVM.toGroupSlidesBrandWise() { isgrouped in
//            
//                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesGrouped, value: true)
//                completion()
//        }
//        } else {
//            completion()
//        }
//    }
    
}
