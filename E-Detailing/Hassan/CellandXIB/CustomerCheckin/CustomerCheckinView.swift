//
//  CustomerCheckinView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 03/04/24.
//

import Foundation
import UIKit
import CoreLocation
class CustomerCheckinView: UIView, CLLocationManagerDelegate {
    

    func setupUItoAddTag(vm: CallViewModel) {
        checkinStack.isHidden = true
        self.layer.cornerRadius = 5
        viewCancel.layer.cornerRadius = 5
        viewConfirm.layer.cornerRadius = 5
        viewCancel.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        viewCancel.layer.borderWidth = 1
        viewCancel.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        viewConfirm.backgroundColor = .appTextColor
        
        lblCance.setFont(font: .bold(size: .BODY))
        
        lblConfirm.setFont(font: .bold(size: .BODY))
        
        
        lblCance.textColor = .appTextColor
        
        lblConfirm.textColor = .appWhiteColor
        
        
        
        lblTaginfo.setFont(font: .bold(size: .BODY))
        
        lblTaginfo.textColor = .appLightPink
        
        lblTaginfo.text = vm.name
        
        lblLatitude.setFont(font: .bold(size: .BODY))
        
        
        lblLongitude.setFont(font: .bold(size: .BODY))
        lblLatitude.text = "Latitude: \(vm.checkinlatitude)"
        
        lblLongitude.text = "Longitude: \(vm.checkinlongitude)"
        
        
        
        lblAddress.setFont(font: .medium(size: .BODY))
        lblAddress.text = vm.customerCheckinAddress
        viewCancel.layer.cornerRadius = 5
        viewConfirm.layer.cornerRadius = 5
        viewCancel.addTap {
            self.delegate?.didClose()
        }
        
        
        viewConfirm.addTap {
          
            self.delegate?.didUpdate()
        }
    }
    
    func setupUI() {
        taggingStack.isHidden = true
        self.layer.cornerRadius = 5
        
        confirmLbl.setFont(font: .medium(size: .BODY))
        confirmLbl.textColor = .appLightTextColor
        
        
        checkinDetailsLbl.setFont(font: .bold(size: .BODY))
        checkinDetailsLbl.textColor = .appTextColor
        
        heyLbl.setFont(font: .medium(size: .BODY))
        heyLbl.textColor = .appLightTextColor
        
        
        dcrNameLbl.setFont(font: .bold(size: .BODY))
        dcrNameLbl.textColor = .appTextColor
        
        titleLbl.setFont(font: .bold(size: .BODY))
        titleLbl.textColor = .appTextColor
        
        self.dcrNameLbl.text = dcrCall.name
        self.checkinDetailsLbl.text = dcrCall.dcrCheckinTime
        
        self.btnCheckin.addTarget(self, action: #selector(didUserCheckin), for: .touchUpInside)
        
        self.closeIV.addTap {
            self.delegate?.didClose()
        }
        
    }
    
    
    func setupTaggeImage(fetchedImageData: Data) {
        self.layer.cornerRadius = 5
        checkinStack.isHidden = true
        taggingStack.isHidden = true
        taggedIMageHolder.isHidden = false
        taggedImage.image = UIImage(data: fetchedImageData)
    }
    
    @objc func didUserCheckin() {
        self.delegate?.didUpdate()
    }
    @IBOutlet var taggedIMageHolder: UIView!
    
    @IBOutlet var taggedImage: UIImageView!
    @IBOutlet var closeIV: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var confirmLbl: UILabel!
    
    
    @IBOutlet var checkinDetailsLbl: UILabel!
    
    
    @IBOutlet var checkinImage: UIImageView!
    
    @IBOutlet var heyLbl: UILabel!
    
    @IBOutlet var dcrNameLbl: UILabel!
    
    @IBOutlet var btnCheckin: ShadowButton!
    
    
    //Tagging
    
    @IBOutlet var lblTaginfo: UILabel!
    
    @IBOutlet var lblLatitude: UILabel!
    
    @IBOutlet var lblLongitude: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var viewCancel: UIView!
    
    @IBOutlet var viewConfirm: UIView!
    
    @IBOutlet var lblCance: UILabel!
    
    @IBOutlet var lblConfirm: UILabel!
    
    @IBOutlet var checkinStack: UIStackView!
    
    @IBOutlet var taggingStack: UIStackView!
    var appsetup : AppSetUp?
    var delegate:  addedSubViewsDelegate?
    var userstrtisticsVM: UserStatisticsVM?
    var locManager : CLLocationManager?
    var currentLocation: CLLocation?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var dcrCall : CallViewModel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
    
//    func  callAPI() {
//        guard let appsetup = self.appsetup else {return}
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let currentDate = Date()
//        let dateString = dateFormatter.string(from: currentDate)
//
//        let datestr = dateString
//        
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let upDatedDateString = dateFormatter.string(from: currentDate)
//        
//        
//        ///time
//        dateFormatter.dateFormat = "HH:mm:ss"
//
//        let timeString = dateFormatter.string(from: currentDate)
//
//        let timestr = (timeString)
//        
//        //chckinInfo = CheckinInfo(address: address, checkinDateTime: self.getCurrentFormattedDateString(), checkOutDateTime: "", latitude: latitude ?? Double(), longitude: longitude ?? Double(), dateStr: datestr, checkinTime: timestr, checkOutTime: "")
//        
//        //guard let ainfo = chckinInfo else {return}
//        
//        guard let userstrtisticsVM = userstrtisticsVM else {return}
////        Pipelines.shared.callCheckinCheckoutAPI(userstrtisticsVM: userstrtisticsVM, model: ainfo, appsetup: appsetup) { result in
////            
////            switch result {
////
////            case .success(let responseArr):
////                
////                let aResponse = responseArr[0]
////                
////                if aResponse.isSuccess ?? false {
////                    self.toCreateToast("Checkin registered successfully")
////                } else {
////                    self.toCreateToast("OOPS can't able to check in right now!")
////                }
////                
////               
////                LocalStorage.shared.setBool(LocalStorage.LocalValue.isLoginSynced, value: true)
////                
////                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
////
////                LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
////                
////                LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: upDatedDateString)
////
////                self.saveLogininfoToCoreData() {_ in
////                    
////                    self.delegate?.didUpdate()
////                    
////                }
////                
////               
////                
////            case .failure(let error):
////                
////                self.toCreateToast(error.rawValue)
////                              
////                self.saveLogininfoToCoreData() {_ in
////                    
////                    self.delegate?.didUpdate()
////                    
////                }
////                
////          
////            }
////
////        }
//    }
    
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
}
