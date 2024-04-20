//
//  HomeCheckinView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/02/24.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData
import GoogleMaps




class HomeCheckinView: UIView, CLLocationManagerDelegate {
    @IBOutlet var checkinBtn: ShadowButton!
    
    @IBOutlet var closeIV: UIImageView!
    @IBOutlet var notifyLbl: UILabel!
    @IBOutlet var dateTimeLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var checkinTitltLbl: UILabel!
    var appsetup : AppSetUp?
    var delegate:  addedSubViewsDelegate?
    var userstrtisticsVM: UserStatisticsVM?
    var locManager : CLLocationManager?
    var currentLocation: CLLocation?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var chckinInfo:  CheckinInfo?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
    func  callAPI() {
        guard let appsetup = self.appsetup else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)

        let datestr = dateString
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let upDatedDateString = dateFormatter.string(from: currentDate)
        
        
        ///time
        dateFormatter.dateFormat = "HH:mm:ss"

        let timeString = dateFormatter.string(from: currentDate)

        let timestr = (timeString)
        
        chckinInfo = CheckinInfo(address: address, checkinDateTime: self.getCurrentFormattedDateString(), checkOutDateTime: "", latitude: latitude ?? Double(), longitude: longitude ?? Double(), dateStr: datestr, checkinTime: timestr, checkOutTime: "")
        
        guard let ainfo = chckinInfo else {return}
        
        guard let userstrtisticsVM = userstrtisticsVM else {return}
        Pipelines.shared.callCheckinCheckoutAPI(userstrtisticsVM: userstrtisticsVM, model: ainfo, appsetup: appsetup) { result in
            
            switch result {

            case .success(let responseArr):
                
                let aResponse = responseArr[0]
                
                if aResponse.isSuccess ?? false {
                    self.toCreateToast("Checkin registered successfully")
                } else {
                    self.toCreateToast("OOPS can't able to check in right now!")
                }
                
               
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isLoginSynced, value: true)
                
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)

                LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
                
                LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: upDatedDateString)

                self.saveLogininfoToCoreData() {_ in
                    
                    self.delegate?.didUpdate()
                    
                }
                
               
                
            case .failure(let error):
                
                self.toCreateToast(error.rawValue)
                              
                self.saveLogininfoToCoreData() {_ in
                    
                    self.delegate?.didUpdate()
                    
                }
                
          
            }

        }
    }
    
    
    
    
    func saveLogininfoToCoreData(completion: @escaping (Bool) -> Void) {

     
        guard let chckinInfo = self.chckinInfo else {
            
            completion(false)
            
            return}
        
        CoreDataManager.shared.saveCheckinsToCoreData(checkinInfo: chckinInfo) {isCompleted in
            completion(true)
        }
    }
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
    

    
    @IBAction func didTapCheckin(_ sender: Any) {
        
        locManager = CLLocationManager()
        currentLocation = CLLocation()
        
        
        Pipelines.shared.requestAuth() {[weak self] coordinates in
            guard let welf = self else {return}
            guard coordinates != nil else {
                welf.delegate?.showAlert()
                return
            }
            welf.latitude = coordinates?.latitude
            welf.longitude = coordinates?.longitude
            
            Pipelines.shared.getAddressString(latitude:   welf.latitude ?? Double(), longitude:   welf.longitude ?? Double()) { address in
                welf.address = address
                
             //   if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                    welf.callAPI()
//                } else {
//                    
//                    let dateFormatter = DateFormatter()
//    
//                    let currentDate = Date()
//                    
//                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    
//                    let upDatedDateString = dateFormatter.string(from: currentDate)
//                    
//                    
//                    LocalStorage.shared.setBool(LocalStorage.LocalValue.isLoginSynced, value: false)
//                    
//                    LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
//
//                    LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
//                    
//                    LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: upDatedDateString)
//                    CoreDataManager.shared.removeAllCheckins()
//                    welf.saveLogininfoToCoreData() {_ in
//                        
//                        welf.delegate?.didUpdate()
//                        
//                    }
//
//                }
              
            }
            
        }
        

   
        
    }
    
    func setupUI() {
        
        
        self.layer.cornerRadius = 5
        checkinTitltLbl.setFont(font: .bold(size: .SUBHEADER))
        userNameLbl.setFont(font: .bold(size: .BODY))
        dateTimeLbl.setFont(font: .medium(size: .BODY))
        notifyLbl.setFont(font: .bold(size: .BODY))
        notifyLbl.textColor = .appLightTextColor
        checkinTitltLbl.textColor = .appTextColor
        userNameLbl.textColor = .appTextColor
        dateTimeLbl.textColor = .appTextColor
        
        closeIV.addTap {
            self.delegate?.didClose()
            
        }
        
        dateTimeLbl.text = getCurrentFormattedDateString()
        let wavingHandEmoji = "\u{1F44B}"
        
        
        guard let username = appsetup?.sfName else {
            return
        }
        
        userNameLbl.text = "Hi \(username)! \(wavingHandEmoji)"
        
        
    }
    
}


extension CoreDataManager {
    
    func removeAllCheckins() {
        let fetchRequest: NSFetchRequest<ChekinInfo> = NSFetchRequest(entityName: "ChekinInfo")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
        } catch {
            print("Error deleting slide brands: \(error)")
        }
    }
    
    
    func saveCheckinsToCoreData(checkinInfo: CheckinInfo, completion: (Bool) -> ()) {
      
        
                let context = self.context
                // Create a new managed object
                if let entityDescription = NSEntityDescription.entity(forEntityName: "ChekinInfo", in: context) {
                    let savedCDChekinInfo = ChekinInfo(entity: entityDescription, insertInto: context)

                    // Convert properties
                    savedCDChekinInfo.address = checkinInfo.address
                    savedCDChekinInfo.checkinDateTime = checkinInfo.checkinDateTime
                    savedCDChekinInfo.checkOutDateTime = checkinInfo.checkOutDateTime
                    savedCDChekinInfo.latitude = checkinInfo.latitude ?? Double()
                    savedCDChekinInfo.longitude = checkinInfo.longitude ?? Double()
                    savedCDChekinInfo.checkinTime = checkinInfo.checkinTime
                    savedCDChekinInfo.checkOutTime = checkinInfo.checkOutTime
                    // Save to Core Data
                    do {
                        try context.save()
                        completion(true)
                    } catch {
                        print("Failed to save to Core Data: \(error)")
                        completion(false)
                    }
                }
          
        
    }
    
    func fetchCheckininfo(completion: ([ChekinInfo]) -> () )  {
        do {
           let savedChekinInfo = try  context.fetch(ChekinInfo.fetchRequest())
            completion(savedChekinInfo )
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
}
