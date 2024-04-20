//
//  LocationManager.swift
//  E-Detailing
//
//  Created by SANEFORCE on 28/08/23.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate{
    typealias LocationCallBack = (_ location: CLLocationCoordinate2D) -> Void
    typealias ReverseLocation = (_ location: String) -> Void
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var completion: LocationCallBack?
    static let shared = LocationManager()
    
    
    override init(){
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
//        if (CLLocationManager.locationServicesEnabled())
//        {
//
//        }
//        else{
////            showAlert(title: "", message: "Location Service os turned off, please enable location services", style: .alert, buttons: ["Settings","Cancel"]) { (action) in
////                if action.title == "Settings"{
////
////                }
////            }
//        }
        
      //  if locationManagerDidChangeAuthorization?(cl)
        
    }
    
    func getCurrentLocation( completion: LocationCallBack? = nil){
        self.completion = completion
        guard let location = self.locationManager else{
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
            self.locationUpdate()
            return
        }
        location.startUpdatingLocation()
    }
    
    func locationUpdate(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            self.currentLocation = nil
          //  topMostViewController().showToast(with: "Please enable location")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")

        @unknown default:
            break
        }
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                self.currentLocation = nil
//                topMostViewController().showToast(with: "Please enable location")
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//
//            }
//        }else {
//            topMostViewController().showToast(with: "Location services are not enabled")
//        }
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        <#code#>
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        guard let location = locations.last else{
            return
        }
        self.currentLocation = location.coordinate
        guard let callback = self.completion else{
            return
        }
        callback(location.coordinate)
        self.completion = nil
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,callback:@escaping ReverseLocation) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.00000
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.00000
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                guard let placemarksList = placemarks,let placemark =  placemarksList.first else{
                    callback("Not Found")
                    return
                }
                let address = String(format: "%@,%@", placemark.locality ?? "",placemark.country ?? "")
                callback(address)
                return
        })
        
    }
}
