//
//  TagViewVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 01/04/24.
//

import Foundation
import UIKit
import GoogleMaps



class TagViewVC : UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewMapView: GMSMapView!
    
    
    
    var customer : CustomerViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.updateCustomerData()
        
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
