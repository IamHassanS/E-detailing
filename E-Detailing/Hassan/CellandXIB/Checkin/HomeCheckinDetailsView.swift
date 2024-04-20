//
//  HomeCheckinDetailsView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/02/24.
//

import Foundation
import UIKit
class HomeCheckinDetailsView: UIView {
    
    enum ViewType {
        case checkin
        case checkout
    }
    
 
    @IBOutlet var lblCheckin: UILabel!
    
    @IBOutlet var dateTimeinfoLbl: UILabel!
    
    @IBOutlet var locationLbl: UILabel!
    
    @IBOutlet var latitudeLbl: UILabel!
    @IBOutlet var longitudeLbl: UILabel!
    
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var localityDesc1: UILabel!
    
    //@IBOutlet var localityDesc2: UILabel!
    
    
    @IBOutlet var closeBtn: ShadowButton!
    var appsetup : AppSetUp?
    var delegate: addedSubViewsDelegate?
    var userstrtisticsVM: UserStatisticsVM?
    var viewType: ViewType = .checkin
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var chckinInfo:  CheckinInfo?
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        
        switch self.viewType {
            
        case .checkin:
            delegate?.didClose()
        case .checkout:
            callCheckoutAPI()
        }
           
        
       
    }
    
    func setupUI(type: ViewType) {
        
        self.layer.cornerRadius = 5
        self.viewType = type
        lblCheckin.setFont(font: .bold(size: .BODY))
        locationLbl.setFont(font: .bold(size: .BODY))
        addressLbl.setFont(font: .bold(size: .BODY))
        dateTimeinfoLbl.setFont(font: .medium(size: .BODY))
        latitudeLbl.setFont(font: .medium(size: .BODY))
        longitudeLbl.setFont(font: .medium(size: .BODY))
        localityDesc1.setFont(font: .medium(size: .BODY))
      //  localityDesc2.setFont(font: .medium(size: .BODY))
        switch type {
           
        case .checkin:
            retriveCheckinInfo()
        case .checkout:
            retriveCheckoutInfo()
        }
        
    
    }
    

    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
    
    func callCheckoutAPI() {
        guard let userstrtisticsVM =  userstrtisticsVM else {return}
        guard let chckinInfo = chckinInfo else {return}
        guard let appsetup = appsetup else {return}
        Pipelines.shared.callCheckinCheckoutAPI(userstrtisticsVM: userstrtisticsVM, model: chckinInfo, appsetup: appsetup) { result in
            
            switch result {

            case .success(let responseArr):
                
                let aResponse = responseArr[0]
                
                if aResponse.isSuccess ?? false {
                    self.toCreateToast("Checkout done")
                } else {
                    self.toCreateToast("OOPS can't able to check in right now!")
                }
                
               
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isLoginSynced, value: true)
                
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
                if self.viewType == .checkout {
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: true)
                }
                
                
                
                let dateFormatter = DateFormatter()
                let currentDate = Date()


                self.delegate?.didClose()
               
            case .failure(let error):
                self.toCreateToast(error.rawValue)
                              

                
          
            }

        }
    }
    
    func retriveCheckoutInfo() {
      
        self.lblCheckin.text = "Check OUT"
        closeBtn.setTitle("Check OUT", for: .normal)
        upDateLabels()
        updateCoreData()
                
                
                
    
    }
    
    func updateCoreData() {
        CoreDataManager.shared.removeAllCheckins()
        
        saveLogininfoToCoreData() { _ in

        }
    }
    
    
func upDateLabels() {
    guard let chckinInfo = chckinInfo else {return}
    dateTimeinfoLbl.text =  chckinInfo.checkOutDateTime
    latitudeLbl.text = "\(chckinInfo.latitude!),"
    longitudeLbl.text = "\(chckinInfo.longitude!)"
    // localityDesc1.text =  aCheckin.address
    
    
    let attributedString = NSMutableAttributedString(string:  chckinInfo.address ?? "")
    
    // *** Create instance of `NSMutableParagraphStyle`
    let paragraphStyle = NSMutableParagraphStyle()
    
    // *** set LineSpacing property in points ***
    paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
    
    // *** Apply attribute to string ***
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    
    // *** Set Attributed String to your label ***
    localityDesc1.attributedText =  attributedString
}
    
    
    func saveLogininfoToCoreData(completion: @escaping (Bool) -> Void) {

     
        guard let chckinInfo = self.chckinInfo else {
            
            completion(false)
            
            return}
        
        CoreDataManager.shared.saveCheckinsToCoreData(checkinInfo: chckinInfo) {isCompleted in
            completion(true)
        }
    }
    
    
    func retriveCheckinInfo() {
        CoreDataManager.shared.fetchCheckininfo() { saveCheckins  in
            guard let aCheckin = saveCheckins.first else {return}
            dateTimeinfoLbl.text = aCheckin.checkinDateTime
            latitudeLbl.text = "\(aCheckin.latitude),"
            longitudeLbl.text = "\(aCheckin.longitude)"
           // localityDesc1.text =  aCheckin.address
            
            
            let attributedString = NSMutableAttributedString(string: aCheckin.address ?? "")

            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()

            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points

            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

            // *** Set Attributed String to your label ***
            localityDesc1.attributedText =  attributedString
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      

    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
}
