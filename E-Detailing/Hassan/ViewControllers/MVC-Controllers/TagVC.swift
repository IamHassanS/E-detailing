//
//  TagVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/04/24.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire
import MobileCoreServices
import CoreData
import AVFoundation

protocol TagVCDelegate: AnyObject {
    
    func didUsertagged()
    
}

class TagVC : UIViewController {
    
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet var custName: UILabel!
    
    @IBOutlet var btnTag: ShadowButton!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backGroundVXview: UIVisualEffectView!
    
    
    @IBOutlet weak var viewMapView: GMSMapView!
    var checkinVIew: CustomerCheckinView?
    var userStatisticsVM = UserStatisticsVM()
    var delegate : TagVCDelegate?
    var customer : CustomerViewModel!
    var pickedImage: UIImage?
    var pickedImageName : String?
    //var doctor : DoctorFencing!
    
    var selectedCoordinate : CLLocationCoordinate2D!
    var selectedDCRcall: CallViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.isHidden = true
        self.backGroundVXview.isHidden = true
        self.viewMapView.isMyLocationEnabled = true
        self.viewMapView.settings.myLocationButton = true
        self.viewMapView.settings.scrollGestures = false
        self.viewMapView.delegate = self
        custName.setFont(font: .bold(size: .SUBHEADER))
        custName.textColor = .appLightPink
        custName.text = customer.name
        btnTag.addTarget(self, action: #selector(checkCameraAuthorization), for: .touchUpInside)
        btnTag.backgroundColor = .appLightPink
        

        
        LocationManager.shared.getCurrentLocation { (coordinate) in
            
            let camera  = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17)
            
            self.viewMapView.camera = camera
            self.selectedCoordinate = coordinate
            
            
            let marker = GMSMarker()
            marker.position = coordinate
            marker.iconView = UIImageView(image: UIImage(named: "locationRedIcon"))
            marker.iconView?.tintColor = .appLightPink
            marker.iconView?.frame.size = CGSize(width: 35, height: 45)
            marker.title = self.customer.name
            marker.map = self.viewMapView
        }
        
        backgroundView.addTap {
            self.didClose()
        }
    }
    
    deinit {
        print("TagVC deallocated")
    }
    
    
    @IBAction func locationSettingAction(_ sender: UIButton) {
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            print("location == \(coordinate)")
            let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            self.viewMapView.camera =  camera
            //self.currentLocation = coordinate
            //self.drawCircle()
           // self.showAllTaggedList()
        }
        
    }
    
    
    @IBAction func refreshAction(_ sender: UIButton) {
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            print("location == \(coordinate)")
            let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            self.viewMapView.camera =  camera
           // self.currentLocation = coordinate
           // self.drawCircle()
           // self.showAllTaggedList()
        }
    }
    
    
    func setupCamera() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .camera
        pickerVC.delegate = self
        
        self.navigationController?.present(pickerVC, animated: true)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        }
    }
    
    
    func promptToOpenSettings() {

        toSetupAlert(desc: "Camera Permission Required", istoToreTry: false)
     }
    
    
    func toSetupAlert(desc: String, istoToreTry: Bool) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "cancel", cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("yes action")
         

        }
        
        commonAlert.addAdditionalCancelAction {
            print("no action")
          if  istoToreTry {
              guard let pickedImage =  self.pickedImage else {return}
              self.uploadImagess(image: pickedImage) { isCompleted in
                  
                  if isCompleted {
                      
                  } else {
                      
                      self.toSetupAlert(desc: "Image upload Failed Try again", istoToreTry: true)
                      
                  }
              }
            } else {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
         
        }
    }
    
    @objc func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
         case .authorized:
             setupCamera()
         case .notDetermined:
             requestCameraPermission()
         case .denied, .restricted:
             promptToOpenSettings()
         @unknown default:
             fatalError("Unknown case for camera authorization status.")
         }
     }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let checkinVIewwidth = view.bounds.width / 3.5
        let checkinVIewheight = view.bounds.height / 2
        
        let checkinVIewcenterX = view.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = view.bounds.midY - (checkinVIewheight / 2)

        checkinVIew?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
    }
    
    func checkinDetailsAction(dcrCall : CallViewModel) {
        
        self.selectedDCRcall = dcrCall
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1

            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
              
            default:
                print("Yet to implement")
          
                
                aAddedView.isUserInteractionEnabled = false
              
                
            }
            
        }
        
        checkinVIew = self.loadCustomView(nibname: XIBs.customerCheckinVIew) as? CustomerCheckinView
        checkinVIew?.delegate = self
       // checkinVIew?.dcrCall = dcrCall
        checkinVIew?.setupUItoAddTag(vm: dcrCall)
        //checkinVIew?.userstrtisticsVM = self.userststisticsVM
        //checkinVIew?.appsetup = self.appSetups

        
        
        self.view.addSubview(checkinVIew ?? CustomerCheckinView())
        
    }
    
    func fetchLatLongAndAddress(dcrCall : CallViewModel) {
     
     
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        let datestr = dateString
   
        dcrCall.checkinlatitude = self.selectedCoordinate.latitude
        dcrCall.checkinlongitude = self.selectedCoordinate.longitude
        dcrCall.dcrCheckinTime = datestr
        
        
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            Shared.instance.showLoaderInWindow()
            let geocoder = GMSGeocoder()
            self.selectedCoordinate = viewMapView.camera.target
            let latitute = viewMapView.camera.target.latitude
            let longitude = viewMapView.camera.target.longitude
            let position = CLLocationCoordinate2DMake(latitute, longitude)
            geocoder.reverseGeocodeCoordinate(position) { response , error in
                Shared.instance.removeLoaderInWindow()
                if error != nil {
                    print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
                 
                }else {
                    let result = response?.results()?.first
                    let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                    print(address ?? "")
                    
 
                    self.lblAddress.text = address ?? "No address found."
                    dcrCall.customerCheckinAddress = address ?? "No address found."
                    self.checkinDetailsAction(dcrCall : dcrCall)
                }
            }
        } else {
            self.lblAddress.text = "No address found."
            dcrCall.customerCheckinAddress =  "No address found."
            self.checkinDetailsAction(dcrCall : dcrCall)
            
            
        }

    }

    
    func showAlert(desc: String) {
        print("Yet to implement")
        showAlertToEnableLocation(desc: desc)
    }
    
    func showAlertToEnableLocation(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Cancel",cancelAction: "Ok")
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
    
    func toTaginfo(){
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
     //   let urlStr = APIUrl + "geodetails"
        
 //   http://crm.saneforce.in/iOSServer/db_module.php?axn=get/geodetails
        
        let divisionCode = (appsetup.divisionCode ?? "").replacingOccurrences(of: ",", with: "")
        
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
      //  {"tableName":"save_geo","lat":"13.030235516094693","long":"80.2416867390275","cuscode":"259433","divcode":"62","cust":"C","tagged_time":"2023-07-14 18:35:54","image_name":"MGR0523_14072023183554.jpeg","sfname":"TEST MGR","sfcode":"MGR0523","addr":"37, Pasumpon Muthuramalinga Thevar Rd, Nandanam Extension, Nandanam, Chennai, Tamil Nadu 600018, India Chennai Tamil Nadu","tagged_cust_HQ":"MR2567","cust_name":"hrishna","mode":"Android_edet","version":"N-v1"}
        
        var params =  [String: Any]()
        params["tableName"] = "save_geo"
        params["lat"] = "\(self.selectedCoordinate.latitude)"
        params["long"] = "\(self.selectedCoordinate.longitude)"
        params["cuscode"] = self.customer.code
        params["divcode"] =  divisionCode
        params["cust"] = self.customer.tagType
        params["tagged_time"] = date
        params["image_name"] = pickedImageName ?? ""
        params["sfname"] = appsetup.sfName ?? ""
        params["sfcode"] = appsetup.sfCode ?? ""
        params["addr"] = self.lblAddress.text ?? ""
        params["tagged_cust_HQ"] = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) ? appsetup.sfCode : LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        params["towncode"] = customer.townCode
        params["townname"] = customer.townName
        params["status"] = "1"
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        params["cust_name"] = self.customer.name
        params["mode"] = "iOS-Edet"
        params["version"] = "iEdet.1.1"
        
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        var toSendParam = [String: Any]()
        
        toSendParam["data"] = jsonDatum
       
        guard let pickedImage = self.pickedImage else {return}
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            self.toCreateToast("oops you are not connected to network.")
            return
        }
        Shared.instance.showLoaderInWindow()
        self.uploadImagess(image: pickedImage) { isSuccess in
            Shared.instance.removeLoaderInWindow()
            if isSuccess {
                Shared.instance.showLoaderInWindow()
                self.userStatisticsVM.toUploadTaggedInfo(params: toSendParam, api: .saveTag, paramData: params) { result in
                    Shared.instance.removeLoaderInWindow()
                    switch result {
                        
                    case .success(let model):
                        if model.isSuccess ?? false {
                            self.delegate?.didUsertagged()
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.toCreateToast(model.msg ?? "Couldn't tag info for now try again later.")
                        }
            
                    case .failure(_):
                        self.toCreateToast("Couldn't tag info for now try again later.")
                        
                    }
                    
                }
            } else {
                self.toSetupAlert(desc: "Image upload Failed Try again", istoToreTry: true)
            }
        }
        
        

    }
    
    private func popToBack<T>(_ VC : T) {
        let mainVC = navigationController?.viewControllers.first{$0 is T}
        
        if let vc = mainVC {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    

    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension TagVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        self.pickedImage = image
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        let code = appsetup.sfCode ?? ""
        let uuid = "\(UUID())"
        let uuidStr = uuid.replacingOccurrences(of: "-", with: "")
        let custCode = customer.code
        let taggedImageName = code + "_" + custCode + uuidStr + ".jpeg"
        self.pickedImageName = taggedImageName
        
        switch customer.type {
            
        case .doctor:
            self.selectedDCRcall = CallViewModel(call: customer.tag, type: .doctor)
        case .chemist:
            self.selectedDCRcall = CallViewModel(call: customer.tag, type: .chemist)
        case .stockist:
            self.selectedDCRcall = CallViewModel(call: customer.tag, type: .stockist)
        case .unlistedDoctor:
            self.selectedDCRcall = CallViewModel(call: customer.tag, type: .unlistedDoctor)
        }
        guard let aCallVM =  self.selectedDCRcall else {return}
        self.selectedDCRcall =    aCallVM.toRetriveDCRdata(dcrcall: aCallVM.call)
      
       
        self.fetchLatLongAndAddress(dcrCall:  self.selectedDCRcall!)
        
      
    }
    
    func uploadImagess(image: UIImage, completion: @escaping (Bool) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()

        let divisionCode = (appsetup.divisionCode ?? "").replacingOccurrences(of: ",", with: "")
        
        var params = [String: Any]()
        params["tableName"] = "imgupload"
        params["sfcode"]  = appsetup.sfCode ?? ""
        params["division_code"] =  appsetup.divisionCode
        //divisionCode
        params["Rsf"] = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) ? appsetup.sfCode : LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        params["sf_type"] = "\(appsetup.sfType ?? 0)"
        params["Designation"] = appsetup.dsName
        params["state_code"] = "\(appsetup.stateCode ?? 0)"
        params["subdivision_code"] = "\(appsetup.subDivisionCode ?? "")"

        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        var toSendParam = [String: Any]()
        toSendParam["data"]  = jsonDatum

        let custCode = customer.code
 
        Shared.instance.showLoaderInWindow()
     
        userStatisticsVM.toUploadCapturedImage(params: params, uploadType: .tagging, api: .imageUpload, image: [image], imageName: [pickedImageName ?? ""], paramData: jsonDatum, custCode: custCode) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
           
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
           
                  let generalResponse = try JSONDecoder().decode(GeneralResponseModal.self, from: jsonData)
                 print(generalResponse)
                    if generalResponse.isSuccess ?? false {
                        self.toCreateToast("Image upload completed")
                        completion(true)
                    } else {
                       
                        completion(false)
                    }
                 
                } catch {
                    print("Error converting parameter to JSON: \(error)")
                    completion(false)
                }

                
            case .failure(let error):
                dump(error.localizedDescription)
                completion(false)
            }
            
            
        }
    }
    
    
    private func mimeType(for path: String) -> String {
        let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString
        guard
            let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        else {
            return "application/octet-stream"
        }

        return mimetype as String
    }
}




extension TagVC: GMSMapViewDelegate{
    /**
     * Called repeatedly during any animations or gestures on the map (or once, if the camera is
     * explicitly set). This may not be called for all intermediate camera positions. It is always
     * called for the final position of an animation or gesture.
     */
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        print("didchange")
        returnPostionOfMapView(mapView: mapView)
    }
    
    /**
     * Called when the map becomes idle, after any outstanding gestures or animations have completed (or
     * after the camera has been explicitly set).
     */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        
        //called when the map is idle
        returnPostionOfMapView(mapView: mapView)
        
    }
    
    //Convert the location position to address
    func returnPostionOfMapView(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        self.selectedCoordinate = mapView.camera.target
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            geocoder.reverseGeocodeCoordinate(position) { response , error in
                if error != nil {
                    print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
                }else {
                    let result = response?.results()?.first
                    let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                    print(address ?? "")
                    self.lblAddress.text = address
                }
            }
        } else {
            self.lblAddress.text = "No address found"
        }

    }
}


extension TagVC : addedSubViewsDelegate {
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    

    
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("Yet to implement")
    }
    
   
    
    
    
    


    func didClose() {
       backgroundView.isHidden = true
        backgroundView.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    

    
    func didUpdate() {
        backgroundView.isHidden = true
        backgroundView.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            
               // self.navigateToPrecallVC(dcrCall: callViewModel, index: self.selectedDCRIndex ?? 0)
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
        
    
        
        
        self.toTaginfo()
        
    }
    
    
}
