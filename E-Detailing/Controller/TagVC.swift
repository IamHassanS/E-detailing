//
//  TagVC.swift
//  E-Detailing
//
//  Created by SANEFORCE on 28/08/23.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire
import MobileCoreServices

class TagVC : UIViewController {
    
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    @IBOutlet weak var viewMapView: GMSMapView!
    @IBOutlet weak var viewTagStatus: UIView!
    
    
    var customer : CustomerViewModel!
    
    var doctor : DoctorFencing!
    
    var selectedCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMapView.isMyLocationEnabled = true
        self.viewMapView.settings.myLocationButton = true
        self.viewMapView.settings.scrollGestures = false
        self.viewMapView.delegate = self
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            
            let camera  = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17)
            
            self.viewMapView.camera = camera
            self.selectedCoordinate = coordinate
            
            
            let marker = GMSMarker()
            marker.position = coordinate
            marker.iconView = UIImageView(image: UIImage(named: "locationRedIcon")!)
            marker.title = self.customer.name
            marker.map = self.viewMapView
        }
    }
    
    deinit {
        print("TagVC deallocated")
    }
    
    
    func tagging() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let urlStr = APIUrl + "geodetails"
        
 //   http://crm.saneforce.in/iOSServer/db_module.php?axn=get/geodetails
        
        let divisionCode = (appsetup.divisionCode ?? "").replacingOccurrences(of: ",", with: "")
        
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        let params =  [String: Any]()
//        ["tableName" : "save_geo",
//                      "lat" : self.selectedCoordinate != nil ? "\(self.selectedCoordinate.latitude)" : "0.0000",
//                      "long" : self.selectedCoordinate != nil ? "\(self.selectedCoordinate.longitude)" : "0.0000",
//                      "cuscode" : self.customer.code,
//                      "divcode" : divisionCode,
//                      "cust" : self.customer.tagType,
//                      "tagged_time" : date,
//                      "image_name" : "",
//                      "sfname" : appsetup.sfName ?? "",
//                      "sfcode" : appsetup.sfCode ?? "",
//                      "addr" : self.lblAddress.text ?? "",
//                      "tagged_cust_HQ" : appsetup.sfCode ?? "",
//                      "cust_name" : self.customer.name,
//                      "mode" : "iOS-Edet-New",
//                      "version" : "iEdet.1.1",
//        ]
        
        let param = ["data" : params.toString()]
        
        print(urlStr)
        print(param)
        
        AF.request(urlStr,method: .post,parameters: param).responseData(){ (response) in
            
            switch response.result {
                
                case .success(_):
                    do {
                        
                        print(response)
                        
                        let apiResponse = try? JSONSerialization.jsonObject(with: response.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        let date1 = Date()
                        
                        print(date1)
        
                        print("ssususnbjbo")
                        print(apiResponse)
                        print("ssusus")
                        self.updateTagList()
                        self.popToBack(UIStoryboard.nearMeVC)
                        
                      //  self.navigationController?.popViewController(animated: true)
                        
                    }catch {
                        print(error)
                    }
                case .failure(let error):
                
                  //  ConfigVC().showToast(controller: self, message: "\(error)", seconds: 2)
                    print(error)
                    return
            }
            
            print("2")
            print(response)
            print("2")
        }
    }
    
    private func popToBack<T>(_ VC : T) {
        let mainVC = navigationController?.viewControllers.first{$0 is T}
        
        if let vc = mainVC {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    
    func updateTagList()  {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        // http://crm.saneforce.in/iOSServer/db_api.php?axn=table/dcrmasterdata
        
        let url = APIUrl + "table/dcrmasterdata"
        
        var paramsDict = ""
        var params : [String : Any] = [:]

        switch self.customer.type {
        case .doctor:
            paramsDict = "{\"tableName\":\"getdoctors\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"

            params  = ["data" : paramsDict]
            
        case .chemist:
            paramsDict = "{\"tableName\":\"getchemist\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\"}"
            
            params = ["data": paramsDict]
        
        case .stockist:
            paramsDict = "{\"tableName\":\"getstockist\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\"}"
            
            params = ["data": paramsDict]
            
        case .unlistedDoctor:
            paramsDict = "{\"tableName\":\"getunlisteddr\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\"}"
            
            params = ["data": paramsDict]
            
        }
        
        
        AF.request(url, method: .post ,parameters: params).responseData { responseFeed in
            
            switch responseFeed.result {
                
            case .success(_):
                do {
                    let apiResponse = try JSONSerialization.jsonObject(with: responseFeed.data!,options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    print(apiResponse)
                    
                    guard let responseArray = apiResponse as? [[String : Any]] else {
                        return
                    }
                    
                    
                    switch self.customer.type {
                        
                    case .doctor:
                        DBManager.shared.saveMasterData(type: .doctorFencing, Values: responseArray, id: appsetup.sfCode ?? "")
                    case .chemist:
                        DBManager.shared.saveMasterData(type: .chemists, Values: responseArray, id: appsetup.sfCode ?? "")
                    case .stockist:
                        DBManager.shared.saveMasterData(type: .stockists, Values: responseArray, id: appsetup.sfCode ?? "")
                    case .unlistedDoctor:
                        DBManager.shared.saveMasterData(type: .unlistedDoctors, Values: responseArray, id: appsetup.sfCode ?? "")
                    }
                    
                }catch {
                    print(error)
                }
            case .failure(let Error):
                print(Error)
            }
        }
    }
    
    
    @IBAction func tagAction(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = self as UINavigationControllerDelegate & UIImagePickerControllerDelegate
        
        present(picker, animated:true)
        
        
//        self.lblName.text = self.customer.name
//        self.lblLatitude.text = "Latitude : " + "\(self.selectedCoordinate.latitude)"
//        self.lblLongitude.text = "Longitude : " + "\( self.selectedCoordinate.longitude)"
//        self.lblLocation.text = self.lblAddress.text ?? ""
//
//        UIView.animate(withDuration: 1.5) {
//            self.viewTagStatus.isHidden = false
//        }
        
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        UIView.animate(withDuration: 1.5) {
            self.viewTagStatus.isHidden = true
        }
    }
    
    
    @IBAction func confirmAction(_ sender: UIButton) {
        self.tagging()
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
        
        self.uploadImagess(image: image)
    }
    
    func uploadImagess(image: UIImage) {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let webUrlString = AppDefaults.shared.webUrl
        
        let urlString = webUrlString.contains("http://") ? webUrlString : "http://" + webUrlString
        
        let surl = urlString  + "/" + AppDefaults.shared.iosUrl + "save/image"
        
        print(surl)
        
        
  //  http://crm.saneforce.in/iOSServer/db_api.php/?axn=save/image
        
        let url = URL(string: surl)!
        
        let boundary = "Boundary-\(UUID().uuidString)" //UUID().uuidString
        
        let date = Date().toString(format: "yyyyMMddHHmmss")
        
     //   let dat = Date().toString(format: "HHmmss") // self.events[i].timeStamp ?? ""
        
        let fileName = "\(appsetup.sfCode!)"+"_"+"\(date)" + ".jpeg"
        
        
        let mimetype = mimeType(for: fileName)
        let paramName = "imgfile"
        
        
        var data = Data()
        
        let img = image.jpegData(compressionQuality: 0.5)
        
        let params = ["tableName" : "imgupload",
                      "sfcode" : appsetup.sfCode ?? "",
                      "division_code" : (appsetup.divisionCode ?? "").replacingOccurrences(of: ",", with: ""),
                      "Rsf" : appsetup.sfCode ?? "",
                      "sf_type" : appsetup.sfType ?? "",
                      "Designation" : appsetup.dsName ?? "",
                      "state_code" : appsetup.stateCode ?? "",
                      "subdivision_code" : appsetup.subDivisionCode ?? "",
        ] as [String : Any]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        
        data.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        data.append(img!)
        data.append(jsonData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = data
        
        
        URLSession.shared.uploadTask(with: request, from: data){ (data, response, error) in
            do {

                if let error = error {
                            print ("error: \(error)")
                            return
                    }

                guard let responseData = data else {
                        print("no response data")
                        return
                    }
                print(responseData)
                print(response!)
                print((response as? HTTPURLResponse)?.statusCode ?? "")
                        guard let response = response as? HTTPURLResponse,
                            (200...299).contains(response.statusCode) else {

                            print ("server error")

                            return
                        }
                
                
                let apiResponse = try? JSONSerialization.jsonObject(with: responseData,options: JSONSerialization.ReadingOptions.allowFragments)
                        
                print(apiResponse as Any)
                
                DispatchQueue.main.async {
                    self.lblName.text = self.customer.name
                    self.lblLatitude.text = "Latitude : " + "\(self.selectedCoordinate.latitude)"
                    self.lblLongitude.text = "Longitude : " + "\( self.selectedCoordinate.longitude)"
                    self.lblLocation.text = self.lblAddress.text ?? ""
            
                    UIView.animate(withDuration: 1.5) {
                        self.viewTagStatus.isHidden = false
                    }
                }
            }
        }.resume()
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
    }
}
