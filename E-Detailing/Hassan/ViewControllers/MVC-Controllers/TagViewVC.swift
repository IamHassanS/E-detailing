//
//  TagViewVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 01/04/24.
//

import Foundation
import UIKit
import GoogleMaps

extension TagViewVC: GMSMapViewDelegate {
    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        // Perform reverse geocoding
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            
            // Extract the first placemark (if available)
            if let placemark = placemarks?.first {
               
                let subThoroughfare = placemark.subThoroughfare ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let subAdministrativeArea = placemark.subAdministrativeArea ?? ""
                let country = placemark.country ?? ""

                let formattedAddress = [subThoroughfare, thoroughfare, locality, administrativeArea, subAdministrativeArea, country]
                    .filter { !$0.isEmpty } // Filters out empty components
                    .joined(separator: ", ") // Joins non-empty components with a comma

                print("Formatted Address: \(formattedAddress)")
                
                
                if let userCoordinate = self.userCoordinate {
                    let cllocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
                    
                    let distanceInMeters = cllocation.distance(from: location)
                    
                            
                            
                    if distanceInMeters >= 1000 {
                        let kmValue = distanceInMeters / 1000
                        self.setDCRinfo(address: formattedAddress, distance: String(format: "%.2f KM", kmValue))
                    } else {
                        self.setDCRinfo(address: formattedAddress, distance:  String(format: "%.2f Meter", distanceInMeters))
                      
                    }
                    
                    
                }
                
  
                
               
             
            }
        }
        
        return true
    }
}

class TagViewVC : UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewMapView: GMSMapView!
    
    @IBOutlet var dcrNameLbl: UILabel!
    
    @IBOutlet var dcrAddressLbl: UILabel!
    
    @IBOutlet var distanceHolderView: UIView!
    @IBOutlet var distanceLbl: UILabel!
    var customer : CustomerViewModel!
    var userCoordinate : LocationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceHolderView.layer.borderWidth = 1
        distanceHolderView.layer.borderColor = UIColor.appLightPink.cgColor
        distanceHolderView.layer.cornerRadius = 5
        
        fetchLocations() {[weak self] coordinates in
            guard coordinates != nil, let welf = self else {return}
            welf.userCoordinate = coordinates
            welf.updateCustomerData()
        }
        
        
    }
    
    
    
    
    func setDCRinfo(address: String, distance: String) {
        dcrNameLbl.text = customer.name
        dcrAddressLbl.text = address
        distanceLbl.text = distance
    }
    
    func showAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
            // self.toDeletePresentation()
            
        }

    }
    
    func fetchLocations(completion: @escaping(LocationInfo?) -> ()) {
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
            guard let welf = self else {
                completion(nil)
                return
            }
            
            if geoFencingEnabled {
                guard coordinates != nil else {
                    welf.showAlert(desc: "Please enable location services in Settings.")
                    completion(nil)
                    return
                }
            }

            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                Pipelines.shared.getAddressString(latitude: coordinates?.latitude ?? Double(), longitude:  coordinates?.longitude ?? Double()) {  address in
                    completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address: address ?? "No address found"))
                    return
                }
            } else {
                
                completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address:  "No address found"))
                return
            }
        }
    }
    
    

    
    func updateCustomerData() {
        
        switch self.customer.type {
            
        case .doctor:
            let doctors = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{$0.code == self.customer.code}
            
            doctors.forEach { doctor in
                
                if let latitude = doctor.lat , let longitude = doctor.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    let marker = GMSMarker()
                    marker.position = location
                    marker.icon = UIImage(named: "locationRed")
                    marker.title = doctor.name ?? ""
                    marker.snippet = doctor.addrs ?? ""
                    marker.map = viewMapView
                    _ = self.mapView(self.viewMapView, didTap: marker)
                   // setDCRinfo
                  
                    let camera : GMSCameraPosition = GMSCameraPosition(latitude: douableLat, longitude: doubleLong, zoom: 12)
                    self.viewMapView.camera =  camera
                }
                 
            }
            
        case .chemist:
            let chemists = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{$0.code == self.customer.code}
            
            chemists.forEach { chemist in
                
                if let latitude = chemist.lat , let longitude = chemist.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    let marker = GMSMarker()
                    marker.position = location
                    marker.icon = UIImage(named: "locationRed")
                    marker.title = chemist.name ?? ""
                    marker.snippet = chemist.addr ?? ""
                    marker.map = viewMapView
                    
                    let camera : GMSCameraPosition = GMSCameraPosition(latitude: douableLat, longitude: doubleLong, zoom: 15)
                    self.viewMapView.camera =  camera
                }
            }
            
        case .stockist:
            let stockists = DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{$0.code == self.customer.code}
            
            stockists.forEach { stockist in
                
                if let latitude = stockist.lat , let longitude = stockist.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    let marker = GMSMarker()
                    marker.position = location
                    marker.icon = UIImage(named: "locationRed")
                    marker.title = stockist.name ?? ""
                    marker.snippet = stockist.addr ?? ""
                    marker.map = viewMapView
                    
                    let camera : GMSCameraPosition = GMSCameraPosition(latitude: douableLat, longitude: doubleLong, zoom: 15)
                    self.viewMapView.camera =  camera
                }
            }
            
        case .unlistedDoctor:
            let unListedDoctors = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{$0.code == self.customer.code}
            
            unListedDoctors.forEach { unListedDoctor in
                
                if let latitude = unListedDoctor.lat , let longitude = unListedDoctor.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    let marker = GMSMarker()
                    marker.position = location
                    marker.icon = UIImage(named: "locationRed")
                    marker.title = unListedDoctor.name ?? ""
                    marker.snippet = unListedDoctor.addrs ?? ""
                    marker.map = viewMapView
                    
                    let camera : GMSCameraPosition = GMSCameraPosition(latitude: douableLat, longitude: doubleLong, zoom: 15)
                    self.viewMapView.camera =  camera
                }
            }
            
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
