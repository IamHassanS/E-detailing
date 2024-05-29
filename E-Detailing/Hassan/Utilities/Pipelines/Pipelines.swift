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
import GoogleMaps



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
    let geocoder = GMSGeocoder()
    var downloader = MediaDownloader()
    var window: UIWindow?
    var isDownloading: Bool?
    func doLogout() {
        window = appDelegate.window
        //LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedIn)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedIn, value: false)
        self.window?.rootViewController = UINavigationController.init(rootViewController: LoginVC.initWithStory())
    }
    
    func toStopDownload() {
        downloader.toStopDownload()
    }
    
    func downloadData(mediaURL: String, delegate: MediaDownloaderDelegate) {
        //, completion: @escaping (Data?, Error?) -> Void
        guard let url = URL(string: mediaURL) else {
           // completion(nil, NSError(domain: "E-Detailing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
  
        isDownloading = true
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

    
//    func getAddressString(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
//
//         let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: latitude , longitude: longitude )
//
//         geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//             var placeMark: CLPlacemark!
//             placeMark = placemarks?[0]
//             completion(self.displayLocationInfo(placemark: placeMark))
//
//         })
//     }
    
    
    func displayLocationInfo(placemark: CLPlacemark?) -> String    {

          var locality =  ""
          var postalCode =  ""
          var administrativeArea = ""
          var country = ""
          var sublocality = ""
          var throughfare = ""

         

          if let containsPlacemark = placemark {
              //stop updating location to save battery life
              //            locationManager.stopUpdatingLocation()
              locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality! : ""
              postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode! : ""
              administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea! : ""
              country = (containsPlacemark.country != nil) ? containsPlacemark.country! : ""
              sublocality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality! : ""
              throughfare = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare! : ""

          }

          var adr: String  = ""

          if throughfare != "" {

              adr = throughfare + ", "

          }
          if sublocality != "" {

              adr = adr + sublocality + ", "

          }
          if locality != "" {

              adr = adr + locality + ", "

          }
          if administrativeArea != "" {

              adr = adr + administrativeArea + ", "

          }
          if postalCode != "" {

              adr = adr + postalCode + ", "

          }
          if country != "" {

              adr = adr + country
          }

          print(adr)

          return adr
      }
    
}
