//
//  CustomerCheckinView.swift
//  E-Detailing
//
//  Created by San eforce on 03/04/24.
//

import Foundation
import UIKit
import CoreLocation
class CustomerCheckinView: UIView, CLLocationManagerDelegate {
    
    
    func setupUI() {
        
        self.layer.cornerRadius = 5
        
        confirmLbl.setFont(font: .medium(size: .BODY))
        confirmLbl.textColor = .appLightTextColor
        
        
        checkinDetailsLbl.setFont(font: .bold(size: .SUBHEADER))
        checkinDetailsLbl.textColor = .appTextColor
        
        heyLbl.setFont(font: .medium(size: .BODY))
        heyLbl.textColor = .appLightTextColor
        
        
        dcrNameLbl.setFont(font: .bold(size: .SUBHEADER))
        dcrNameLbl.textColor = .appTextColor
        
        titleLbl.setFont(font: .bold(size: .SUBHEADER))
        titleLbl.textColor = .appTextColor
        
        self.dcrNameLbl.text = dcrCall.name
        self.checkinDetailsLbl.text = dcrCall.dcrCheckinTime
        
        self.btnCheckin.addTarget(self, action: #selector(didUserCheckin), for: .touchUpInside)
        
        self.closeIV.addTap {
            self.delegate?.didClose()
        }
        
    }
    
    
    @objc func didUserCheckin() {
        self.delegate?.didUpdate()
    }
    
    @IBOutlet var closeIV: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var confirmLbl: UILabel!
    
    
    @IBOutlet var checkinDetailsLbl: UILabel!
    
    
    @IBOutlet var checkinImage: UIImageView!
    
    @IBOutlet var heyLbl: UILabel!
    
    @IBOutlet var dcrNameLbl: UILabel!
    
    @IBOutlet var btnCheckin: ShadowButton!
    
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
        
        //chckinInfo = CheckinInfo(address: address, checkinDateTime: self.getCurrentFormattedDateString(), checkOutDateTime: "", latitude: latitude ?? Double(), longitude: longitude ?? Double(), dateStr: datestr, checkinTime: timestr, checkOutTime: "")
        
        //guard let ainfo = chckinInfo else {return}
        
        guard let userstrtisticsVM = userstrtisticsVM else {return}
//        Pipelines.shared.callCheckinCheckoutAPI(userstrtisticsVM: userstrtisticsVM, model: ainfo, appsetup: appsetup) { result in
//            
//            switch result {
//
//            case .success(let responseArr):
//                
//                let aResponse = responseArr[0]
//                
//                if aResponse.isSuccess ?? false {
//                    self.toCreateToast("Checkin registered successfully")
//                } else {
//                    self.toCreateToast("OOPS can't able to check in right now!")
//                }
//                
//               
//                LocalStorage.shared.setBool(LocalStorage.LocalValue.isLoginSynced, value: true)
//                
//                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
//
//                LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
//                
//                LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: upDatedDateString)
//
//                self.saveLogininfoToCoreData() {_ in
//                    
//                    self.delegate?.didUpdate()
//                    
//                }
//                
//               
//                
//            case .failure(let error):
//                
//                self.toCreateToast(error.rawValue)
//                              
//                self.saveLogininfoToCoreData() {_ in
//                    
//                    self.delegate?.didUpdate()
//                    
//                }
//                
//          
//            }
//
//        }
    }
    
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
}
