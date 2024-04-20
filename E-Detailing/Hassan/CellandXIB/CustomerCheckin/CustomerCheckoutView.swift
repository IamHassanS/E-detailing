//
//  CustomerCheckoutView.swift
//  E-Detailing
//
//  Created by San eforce on 03/04/24.
//

import Foundation
import UIKit


class CustomerCheckoutView: UIView {
    
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var longitudeLbl: UILabel!
    @IBOutlet var latitudeLbl: UILabel!
    @IBOutlet var checkoutTimeLbl: UILabel!
    
    @IBOutlet var closeBtn: ShadowButton!
    
    var appsetup : AppSetUp?
    var delegate:  addedSubViewsDelegate?
    var dcrCall: CallViewModel?
    
    @IBAction func didTapcloseBtn(_ sender: UIButton) {
        guard let dcrCall = self.dcrCall else {
            delegate?.didUpdate()
            return
        }
        delegate?.didUpdateCustomerCheckin(dcrCall: dcrCall)
        //object: AnyObject
    }
    
    func setLabels(dcrCall: CallViewModel) {
        longitudeLbl.text = "\(dcrCall.checkOutlongitude)"
        latitudeLbl.text = "\(dcrCall.checkOutlatitude)"
        addressLbl.text = dcrCall.customerCheckOutAddress
        checkoutTimeLbl.text = dcrCall.dcrCheckOutTime
    }
    
    func setupUI(dcrCall: CallViewModel) {
        self.layer.cornerRadius = 5
        checkOutAction(dcrCall: dcrCall)

    }
    
    
    func showAlert() {
        print("Yet to implement")
        showAlertToEnableLocation()
    }
    
    
    func showAlertToEnableLocation() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Please enable location services in Settings.", okAction: "Cancel",cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
            self.redirectToSettings()
            
        }
    }
    
    func redirectToSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
    
    func checkOutAction(dcrCall : CallViewModel) {
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
            guard let welf = self else {return}
            guard let coordinates = coordinates else {
                
                welf.showAlert()
                
                return
            }
            
            Pipelines.shared.getAddressString(latitude: coordinates.latitude ?? Double(), longitude:  coordinates.longitude ?? Double()) { [weak self] address in
                guard let welf = self else {return}
                
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let currentDate = Date()
                let dateString = dateFormatter.string(from: currentDate)
                
                let datestr = dateString

                dcrCall.customerCheckOutAddress = address ?? ""
                dcrCall.checkOutlatitude = coordinates.latitude ?? Double()
                dcrCall.checkOutlongitude = coordinates.longitude ?? Double()
                dcrCall.dcrCheckOutTime = dateString
               // welf.checkinDetailsAction(dcrCall : dcrCall)
                welf.dcrCall = dcrCall
                DispatchQueue.main.async {
                    welf.setLabels(dcrCall: dcrCall)
                }
               
                
            }
        }
    }
    
    
    
    
}
