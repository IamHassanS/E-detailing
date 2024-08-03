//
//  SplashVIew.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 03/05/24.
//


import Foundation
import UIKit
import CoreLocation

extension SplashView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      
   
        
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            if let navigationController = rootViewController as? UINavigationController {
                if let visibleViewController = navigationController.visibleViewController {
                    if visibleViewController is SplashVC {
                        manageCLAuthorizationStatus(status: status)
                    } else {
                       // isVisibleController = false
                        return
                    }
                }
            } else {
                manageCLAuthorizationStatus(status: status)
            }
        }

        


    }
    
    func manageCLAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location services enabled")
            // Perform your actions here or notify the user
          
                timeZoneChanged()
            
        case .denied, .restricted:
            print("Location services disabled")
           
            setupNoGPSalert()
            Pipelines.shared.requestAuth() {_ in}
        case .notDetermined:
            print("Location services not determined")
            setupNoGPSalert()
            Pipelines.shared.requestAuth() {_ in}
        @unknown default:
            break
        }
    }
}

class SplashView: BaseView{
    var previousAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    var splashVC : SplashVC!
    var locationManager = CLLocationManager()
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var lblMenuTitle: UILabel!
    @IBOutlet var imgAppIcon: UIImageView!
    
    @IBOutlet var launchLoaderHolderView: UIView!
    
    @IBOutlet var launchIV: UIImageView!
    @IBOutlet weak var SplashImageHolderView: UIView!
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.splashVC = baseVC as? SplashVC
        setupUI()
        onSetRootViewController()
 //       locationManager.delegate = self
 //       checkReachability()
 //       addObserverForTimeZoneChange()
        
//        if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isTimeZoneChanged) {
//            setUIfortimeZoneChanges()
//        } else {
//            onSetRootViewController()
//        }
        
    }
    
    func initView(){


    
        }
    
    func setUIfortimeZoneChanges() {
       lblMenuTitle.text = "OOPS! you have accidentally changed time zone. Update the time zone to set automatically."
       btnLogout.isHidden = false
       
    }
    
    
    func setupNoGPSalert() {
  
        lblMenuTitle.text = "Location permission reqired to validate timezone."
        btnLogout.isHidden = false
    }
    
    func setupNoNetworkAlert() {
  
        lblMenuTitle.text = "Please connect to internet to validate timezone"
        btnLogout.isHidden = false
    }
    
    func addObserverForTimeZoneChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timeZoneChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async {
                    if status == ReachabilityManager.ReachabilityStatus.notConnected.rawValue  {
                        
                        self.toCreateToast("Please check your internet connection.")
                       LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
                            if let navigationController = rootViewController as? UINavigationController {
                                if let visibleViewController = navigationController.visibleViewController {
                                    if visibleViewController is SplashVC {
                                        // Your code
                                        self.setupNoNetworkAlert()
                                    }
                                }
                            } else {
                                self.setupNoNetworkAlert()
                            }
                        }
                      
                    } else if  status == ReachabilityManager.ReachabilityStatus.wifi.rawValue || status ==  ReachabilityManager.ReachabilityStatus.cellular.rawValue   {
                        
                      
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                        
                        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
                            if let navigationController = rootViewController as? UINavigationController {
                                if let visibleViewController = navigationController.visibleViewController {
                                    if visibleViewController is SplashVC {
                                        // Your code
                                        self.toCreateToast("You are now connected.")
                                        self.timeZoneChanged()
                                    }
                                }
                            } else {
                                self.toCreateToast("You are now connected.")
                                self.timeZoneChanged()
                            }
                        }
                        
                   
                    }
                }
            }
        }
    }
    
    func checkReachability() {
        network.isReachable() {  reachability in
            
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                self.setupNoNetworkAlert()
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
               
            }
            
         
        }

        network.isUnreachable() { reachability in
         
            
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                self.setupNoNetworkAlert()
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
             
                
            }
        }
       
        
    }
        
    
    func setupUI() {
        btnLogout.layer.cornerRadius = 5
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnLogout.isHidden = true
        lblMenuTitle.text = ""
        SplashImageHolderView.elevate(2, shadowColor: .lightGray, opacity: 0.5)
        imgAppIcon.clipsToBounds = true
        SplashImageHolderView.layer.cornerRadius = 12
        imgAppIcon.layer.cornerRadius  = 12
        
//        if splashVC.isTimeZoneChanged {
//            self.setUIfortimeZoneChanges()
//        }
    }

    @IBAction func didTapLogout(_ sender: Any) {
        Pipelines.shared.doLogout()
    }
    
    @objc func timeZoneChanged() {
        //var isManualTimeZoneChange = false
        
        Pipelines.shared.requestAuth() {[weak self] coordinates in
            guard let welf = self else {return}
            guard let nonNilcoordinates = coordinates else {
                welf.setupNoGPSalert()
                return}
            
            let location = CLLocation(latitude: nonNilcoordinates.latitude ?? Double(), longitude: nonNilcoordinates.longitude ?? Double())
          
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isTimeZoneChanged, value: true)
            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    guard let placemark = placemarks?.first else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    if let timeZone = placemark.timeZone {
                        let actualTimeZone = timeZone.identifier
                        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
                        if actualTimeZone == localTimeZoneIdentifier {
                            LocalStorage.shared.setBool(LocalStorage.LocalValue.isTimeZoneChanged, value: false)
                            welf.lblMenuTitle.text = "Welcome back!"
                            welf.btnLogout.isHidden = true
                            welf.onSetRootViewController()
                            return
                        } else {
                           // welf.toSetupAlert(text: "Oops! Time zone changed. Changing time zone can affect app behavior.")
                            LocalStorage.shared.setBool(LocalStorage.LocalValue.isTimeZoneChanged, value: true)
                            welf.setUIfortimeZoneChanges()
                        }
                    } else {
                        print("Unable to determine user timezone")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isTimeZoneChanged, value: true)
                  
                    }
                }
            } else {
                if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isTimeZoneChanged) {
                    welf.setupNoNetworkAlert()
                } else {
                    welf.onSetRootViewController()
                }
            }
        }
        
        

     }
    
    func toSetupAlert(text: String, istoValidate : Bool? = false) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: text, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
            self.openSettings()

   
        }
    }
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func onSetRootViewController()
    {
        splashVC.callStartupActions()

    }

}
