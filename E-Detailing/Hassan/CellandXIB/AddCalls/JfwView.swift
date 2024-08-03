//
//  jfwView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 25/03/24.
//

import Foundation
import UIKit
import CoreData
import AVFoundation
extension JfwView: MenuResponseProtocol {
    func routeToView(_ view: UIViewController) {
        print("Yet to")
    }
    
    func callPlanAPI() {
        print("Yet to")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
       //lblEnterRemarks.textColor = .appLightTextColor
        
        if let feedbackObj = selectedObject as? Feedback {
            selectedfeedbackLbl.text = feedbackObj.name == "" ? "Select Overall Feedback" :  feedbackObj.name
            self.overallFeedback = feedbackObj
            
            guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
                return
                
            }
            
            let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
            tempFeedback.id = ""
            tempFeedback.index = Int16()
            tempFeedback.name = ""
            
            toFetchCacheJointWorks{  [weak self] jointWorkViewmodel in
                guard let welf = self else { return }
                    
                    welf.delegate?.selectedObjects(eventcptureVM: welf.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: jointWorkViewmodel ?? JointWorksListViewModel(), POBValue:   welf.pobValue ?? "", overallFeedback: welf.overallFeedback ?? tempFeedback, overallRemarks: welf.overallRemark ?? "")
            }
            
            
            return
        }
        
        
        if let jwObjs = selectedObjects as? [JointWork] {
            self.jointWorkSelectedListViewModel?.jointWorksListViewModel.removeAll()
            CoreDataManager.shared.toRemoveAllCacheJointWorks()
            CoreDataManager.shared.toSaveJointworks(jointWorks:  jwObjs) { [weak self] isSaved in
                guard let welf = self else {return}
                
                if jwObjs.isEmpty {
                    welf.selectedJwID = [String: Bool]()
                    welf.jointWorkTableView.reloadData()
                   return
                }
                
                jwObjs.forEach { aJointWork in
                   
                    welf.jointworkSelectionAction(obj: aJointWork)
                }
                
                if !(welf.jointWorkSelectedListViewModel?.jointWorksListViewModel.isEmpty ?? true) {
                    welf.jointWorkSelectedListViewModel?.jointWorksListViewModel.forEach { aJointWork in
                        welf.selectedJwID[aJointWork.code] = true
                    }
                } else {
                    welf.selectedJwID = [String: Bool]()
                }
                
                dump(welf.selectedJwID)
                welf.toFetchCacheJointWorks{_ in }
            }

            return
        }
        

    }
    
     func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to")
    }
    
    
}


protocol JfwViewDelegate: AnyObject {
    func selectedObjects(eventcptureVM: EventCaptureListViewModel, jointWorkSelectedListViewModel : JointWorksListViewModel, POBValue: String, overallFeedback: Feedback, overallRemarks: String)
}

extension JfwView : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        

        
        guard let eventCaptureListViewModel = self.eventCaptureListViewModel else {return}
        eventCaptureListViewModel.addEventCapture(EventCaptureViewModel(eventCapture: EventCapture(image: image,title: "",description: "", imageUrl: UUID().uuidString)))
        self.eventCaptureTableView.reloadData()
        
        
        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            return
            
        }
        
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        self.delegate?.selectedObjects(eventcptureVM: eventCaptureListViewModel, jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
    }
}

extension JfwView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        self.eventCaptureListViewModel?.updateDescription(textView.tag, remark: text)
        
        
        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            return
            
        }
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
    }
}



extension JfwView: UITableViewDelegate, UITableViewDataSource {
    func jointworkSelectionAction(obj: JointWork) {

    let jointWorkValue = JointWorkViewModel(jointWork: obj)
 

    self.jointWorkSelectedListViewModel?.addJointWorkViewModel(jointWorkValue)

        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            return
            
        }
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        self.jointWorkTableView.reloadData()
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
    }
    
    
    @objc func deleteEventCapture(_ sender : UIButton){
        self.eventCaptureListViewModel?.removeAtIndex(sender.tag)
        self.eventCaptureTableView.reloadData()
        
        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            return
            
        }
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
    }
    
    
    @objc func imageTitleEdit(_ sender : UITextField){
        self.eventCaptureListViewModel?.updateTitleAtIndex(sender.tag, name: sender.text ?? "")
    }
    
    
    @objc func addJointWork() {

        let vc = SpecifiedMenuVC.initWithStory(self, celltype: .jointCall)
        
        
        if !(jointWorkSelectedListViewModel?.jointWorksListViewModel.isEmpty ?? true) {
            jointWorkSelectedListViewModel?.jointWorksListViewModel.forEach { aJointWork in
                selectedJwID[aJointWork.code] = true
            }
        }

        
        
        vc.selectedJwID = selectedJwID
        vc.menuDelegate = self
        self.rootVC?.modalPresentationStyle = .custom
        self.rootVC?.navigationController?.present(vc, animated: false)
        
    }
    
    @objc func deleteJointWork (_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.jointWorkTableView)
        guard let indexPath = self.jointWorkTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        
      
        
        self.jointWorkSelectedListViewModel?.removeAtindex(indexPath.row)
      
        
        
        if !(jointWorkSelectedListViewModel?.jointWorksListViewModel.isEmpty ?? true) {
            self.selectedJwID = [String: Bool]()
            jointWorkSelectedListViewModel?.jointWorksListViewModel.forEach { aJointWork in
                selectedJwID[aJointWork.code] = true
            }
        } else {
            selectedJwID = [String: Bool]()
        }
        
        let  updatedJointworks = self.jointWorkSelectedListViewModel?.getJointWorkData().map({ aJointWorkViewModel in
            return aJointWorkViewModel.jointWork
        })
        guard let updatedJointworks = updatedJointworks else {return}
        CoreDataManager.shared.toRemoveAllCacheJointWorks()
        CoreDataManager.shared.toSaveJointworks(jointWorks: updatedJointworks) {[weak self] isSaved in
            guard let welf = self else {return}
            welf.toFetchCacheJointWorks{_ in }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.eventCaptureTableView :
            return self.eventCaptureListViewModel?.numberOfRows() ?? 0
            
        case self.jointWorkTableView:
            return self.jointWorkSelectedListViewModel?.numberofSelectedRows() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case self.eventCaptureTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCaptureCell", for: indexPath) as! EventCaptureCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexpath = indexPath.row
            cell.eventCapture = self.eventCaptureListViewModel?.fetchAtIndex(indexPath.row)
            cell.btnDelete.addTarget(self, action: #selector(deleteEventCapture(_:)), for: .touchUpInside)
            cell.txtName.addTarget(self, action: #selector(imageTitleEdit(_:)), for: .editingChanged)
            cell.txtName.tag = indexPath.row
            cell.btnDelete.tag =  indexPath.row
            return cell
            
            
        case self.jointWorkTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JointWorkTableViewCell", for: indexPath) as! JointWorkTableViewCell
            cell.selectionStyle = .none
            cell.jointWorkSample = self.jointWorkSelectedListViewModel?.fetchDataAtIndex(indexPath.row)
            cell.btnDelete.addTarget(self, action: #selector(deleteJointWork(_:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{ 
        case self.eventCaptureTableView:
            return 150
        case self.jointWorkTableView:
            return 60
        default:
            return 0
        }
    }
    
}

class JfwView: UIView {
    

    weak var delegate: JfwViewDelegate?
    
   // @IBOutlet var lblEnterRemarks: UILabel!
    
    @IBOutlet var lblPOBValue: UILabel!
    
    @IBOutlet var pobTF: UITextField!
    
    @IBOutlet var pobTFcurvedVIew: UIView!
    @IBOutlet var lblOverallFeedback: UILabel!
    
    
    @IBOutlet var overallFeedbackCurvedView: UIView!
    
    
    @IBOutlet var feedbackLbl: UILabel!
    
    @IBOutlet var lblCaptureEvent: UILabel!
    
    
    @IBOutlet var captureBtn: UIButton!
    
    @IBOutlet var eventcaptureCurvedView: UIView!
    
    @IBOutlet var eventCaptureTableView: UITableView!
    
    
    @IBOutlet var lblOverallRemarks: UILabel!
    
    
    @IBOutlet var overallremarksCurvedVIew: UIView!
    
    
    @IBOutlet var lblJointWork: UILabel!
    
    
    @IBOutlet var addJWbtn: UIButton!
    
    
    @IBOutlet var addJWcurvedView: UIView!
    
    
    @IBOutlet var captureCurvedVIew: UIView!
    
    
    @IBOutlet var jointWorkTableView: UITableView!
    
    
    
    @IBOutlet var jwCurvedView: UIView!
    
    @IBOutlet var viewoverallRemarks: UIView!
    
    @IBOutlet var viewPOB: UIView!
    
    @IBOutlet var viewOverallFeedback: UIView!
    
    
    @IBOutlet var selectedfeedbackLbl: UILabel!
    
    @IBOutlet var viewEventCaptureSegment: UIView!
    
    
    @IBOutlet var viewJointWorkSegment: UIView!
    
    @IBOutlet var remarksTF: UITextField!
    
    @IBOutlet var eventCaptureHolderStack: UIStackView!
    
    @IBOutlet var jointworkHolderStack: UIStackView!
    var selectedJwID = [String: Bool]()
    var rootVC: UIViewController?
    var pobValue: String?
    var overallFeedback: Feedback?
    var overallRemark: String?
    var captureSession : AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var eventCaptureListViewModel : EventCaptureListViewModel?
    var jointWorkSelectedListViewModel: JointWorksListViewModel?
    var dcrCall: CallViewModel!
    func initTaps() {
        overallFeedbackCurvedView.addTap {
            let vc = SpecifiedMenuVC.initWithStory(self, celltype: .feedback)
            self.rootVC?.modalPresentationStyle = .custom
            self.rootVC?.navigationController?.present(vc, animated: false)
        }
        
        captureBtn.addTarget(self, action: #selector(checkCameraAuthorization), for: .touchUpInside)
        
        addJWbtn.addTarget(self, action: #selector(addJointWork), for: .touchUpInside)
        
    }
    
    func toloadJWtable() {
        jointWorkTableView.delegate = self
        jointWorkTableView.dataSource = self
        jointWorkTableView.reloadData()
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
    
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        }
    }
    
//    func setupCamera() {
//        let pickerVC = UIImagePickerController()
//        pickerVC.sourceType = .camera
//        pickerVC.delegate = self
//        
//        self.rootVC?.present(pickerVC, animated: true)
//    }
    func setupCamera() {
   
        let picker = UIImagePickerController() //make a clean controller
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.modalPresentationStyle = .fullScreen
//        if !geoFencingEnabled {
//            self.rootVC?.present(picker,
//                animated: true)
//            return
//        }
        
        self.rootVC?.present(picker,
            animated: true)
        
//        var customOverlayView: CustomOverlayView?
//        customOverlayView =  picker.loadCustomView(nibname: XIBs.CustomOverlayView) as? CustomOverlayView
//        customOverlayView?.setupView()
//        let pickerViewWidth = picker.view.bounds.width
//                let pickerViewHeight = picker.view.bounds.height
//                let overlayHeight = picker.view.bounds.height / 3
//        let overlayFrame = CGRect(
//              x: 0,
//              y: pickerViewHeight - overlayHeight ,
//              width: pickerViewWidth,
//              height: overlayHeight
//          )
//          
//          customOverlayView?.frame = overlayFrame
//            //presentation of the camera
//          
//            self.rootVC?.present(picker,
//                animated: true,
//                completion: {
//                if geoFencingEnabled {
//                    picker.cameraOverlayView = customOverlayView
//                }
//                   
//            })
             
    
    }
    
    
    func toSetupAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "cancel", cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("yes action")
         

        }
        
        commonAlert.addAdditionalCancelAction {
            print("no action")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
    
    func promptToOpenSettings() {

        toSetupAlert(desc: "Camera Permission Required")
     }
    
    func setupUI() {
        
        
        if self.dcrCall.call is DoctorFencing {
            
            viewPOB.isHidden = isDoctorPOBNeeded ? false : true
        
            jointworkHolderStack.isHidden =  isDoctorJointWorkNeeded ? false : true
            
            jwCurvedView.backgroundColor = isDoctorJointWorkNeeded ? .appWhiteColor : .clear

            eventCaptureHolderStack.isHidden = isDoctorEventCaptureNeeded ? false : true
            
            eventcaptureCurvedView.backgroundColor = isDoctorEventCaptureNeeded ? .appWhiteColor : .clear
    
            viewOverallFeedback.isHidden =  isDoctorFeedbackNeeded ? false : true
            
            
        } else if self.dcrCall.call is Chemist {
          
            viewPOB.isHidden = isChemistPOBNeeded ? false : true
        
            jointworkHolderStack.isHidden = isChemistJointWorkNeeded ? false : true
            
            jwCurvedView.backgroundColor = isChemistJointWorkNeeded ? .appWhiteColor : .clear
      
            eventCaptureHolderStack.isHidden = isChemistEventCaptureNeeded ? false : true
    
            eventcaptureCurvedView.backgroundColor = isChemistEventCaptureNeeded ? .appWhiteColor : .clear
            
            viewOverallFeedback.isHidden =  isChemistFeedbackNeeded ? false : true
            
        }  else if self.dcrCall.call is Stockist {
            
    
            viewPOB.isHidden = isStockistPOBNeeded ? false : true
         
            jointworkHolderStack.isHidden = isStockistJointWorkNeeded ? false : true
            
            jwCurvedView.backgroundColor = isStockistJointWorkNeeded ? .appWhiteColor : .clear
            
            eventCaptureHolderStack.isHidden = isStockistEventCaptureNeeded ? false : true
            
            eventcaptureCurvedView.backgroundColor = isStockistEventCaptureNeeded ? .appWhiteColor : .clear
            
    
            viewOverallFeedback.isHidden =  isStockistFeedbackNeeded ? false : true
            
        } else if self.dcrCall.call is UnListedDoctor {
            
          
            viewPOB.isHidden = isUnListedDoctorPOBNeeded ? false : true

            jointworkHolderStack.isHidden = isUnListedDoctorJointWorkNeeded ? false : true
            
            jwCurvedView.backgroundColor = isUnListedDoctorJointWorkNeeded ? .appWhiteColor : .clear
      
            eventCaptureHolderStack.isHidden = isUnListedDoctorEventCaptureNeeded ? false : true
            
            eventcaptureCurvedView.backgroundColor = isUnListedDoctorEventCaptureNeeded ? .appWhiteColor : .clear
    
            viewOverallFeedback.isHidden =  isUnListedDoctorFeedbackNeeded ? false : true
            
        }
        //  viewEventCaptureSegment.isHidden = true
        selectedfeedbackLbl.setFont(font: .medium(size: .BODY))
        // lblEnterRemarks.setFont(font: .medium(size: .BODY))
        lblPOBValue.setFont(font: .bold(size: .BODY))
        feedbackLbl.setFont(font: .bold(size: .BODY))
        lblOverallRemarks.setFont(font: .bold(size: .BODY))
        lblCaptureEvent.setFont(font: .bold(size: .BODY))
        lblJointWork.setFont(font: .bold(size: .BODY))
        jwCurvedView.layer.cornerRadius = 5
        
        viewoverallRemarks.layer.cornerRadius = 5
        
        viewOverallFeedback.layer.cornerRadius = 5
        viewPOB.layer.cornerRadius = 5
        remarksTF.delegate = self
        
        captureCurvedVIew.layer.cornerRadius = 5
        //captureVXView.layer.cornerRadius = 5
        captureCurvedVIew.layer.borderWidth = 1
        captureCurvedVIew.layer.borderColor = UIColor.appGreen.cgColor
        
        
        
        
        pobTFcurvedVIew.layer.cornerRadius = 5
        //captureVXView.layer.cornerRadius = 5
        pobTFcurvedVIew.layer.borderWidth = 1
        pobTFcurvedVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        
        overallFeedbackCurvedView.layer.cornerRadius = 5
        //captureVXView.layer.cornerRadius = 5
        overallFeedbackCurvedView.layer.borderWidth = 1
        overallFeedbackCurvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        
        overallremarksCurvedVIew.layer.cornerRadius = 5
        //captureVXView.layer.cornerRadius = 5
        overallremarksCurvedVIew.layer.borderWidth = 1
        overallremarksCurvedVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        
        addJWcurvedView.layer.cornerRadius = 5
        //captureVXView.layer.cornerRadius = 5
        addJWcurvedView.layer.borderWidth = 1
        addJWcurvedView.layer.borderColor = UIColor.appGreen.cgColor
        
        eventcaptureCurvedView.layer.cornerRadius = 5
        
        jwCurvedView.layer.cornerRadius = 5
        initTaps()
        pobTF.delegate = self
        
        eventCaptureTableView.register(UINib(nibName: "EventCaptureCell", bundle: nil), forCellReuseIdentifier: "EventCaptureCell")
        
        
        jointWorkTableView.register(UINib(nibName: "JointWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "JointWorkTableViewCell")
        
        if let overallFeedback = self.overallFeedback {
            selectedfeedbackLbl.text = overallFeedback.name == "" || overallFeedback.name == nil  ? "Select Overall Feedback" :  overallFeedback.name
        }
        
        if let pobValue = self.pobValue {
            pobTF.text = pobValue
        }
        
        if let overallRemark = self.overallRemark {
            remarksTF.text = overallRemark
        }
        
        toloadEventCapuretable()
        
        toFetchCacheJointWorks{_ in }
        
    }
    
    func toFetchCacheJointWorks(completion: @escaping (JointWorksListViewModel?) -> ()) {
        CoreDataManager.shared.fetchCacheJointWorks{ [weak self] cacheJointworks in
            
            guard let welf = self else {
                completion(nil)
                return}
            welf.selectedJwID = [String: Bool]()
            guard let cacheJointworks = cacheJointworks else {
                completion(nil)
                welf.toloadJWtable()
                return}
            
            if cacheJointworks.isEmpty {
                welf.selectedJwID = [String: Bool]()
                welf.jointWorkTableView.reloadData()
                return
            }
            
            welf.jointWorkSelectedListViewModel?.jointWorksListViewModel.removeAll()
            
            cacheJointworks.forEach { aJointWork in
                welf.jointworkSelectionAction(obj: aJointWork)
                welf.selectedJwID[aJointWork.code ?? ""] = true
            }
            
            if !(welf.jointWorkSelectedListViewModel?.jointWorksListViewModel.isEmpty ?? true) {
                welf.jointWorkSelectedListViewModel?.jointWorksListViewModel.forEach { aJointWork in
                    
                }
            } else {
                welf.selectedJwID = [String: Bool]()
            }
            
            dump(welf.selectedJwID)
            welf.toloadJWtable()
            completion(welf.jointWorkSelectedListViewModel)
        }
    }
    
    func toloadEventCapuretable() {
        eventCaptureTableView.delegate = self
        eventCaptureTableView.dataSource = self
        eventCaptureTableView.reloadData()
    }
    
    @IBAction func didTapRemarks(_ sender: UITextField) {
        self.overallRemark = sender.text ?? ""
        
        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            
            return
            
        }
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
        
    }
    
    @IBAction func didtapPOBtf(_ sender: UITextField) {
        
        self.pobValue = sender.text ?? ""
        
        guard let feedbackEntityDesc = NSEntityDescription.entity(forEntityName: "Feedback", in: AppDelegate.shared.persistentContainer.viewContext) else {
            return
            
        }
        let tempFeedback = Feedback(entity: feedbackEntityDesc, insertInto: AppDelegate.shared.persistentContainer.viewContext)
        tempFeedback.id = ""
        tempFeedback.index = Int16()
        tempFeedback.name = ""
        
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? tempFeedback, overallRemarks: overallRemark ?? "")
    }
    
    
}




extension JfwView: EventCaptureCellDelegate {
    func didUpdate(title: String, description: String, index: Int, image: UIImage) {
        let eventCapture = self.eventCaptureListViewModel?.fetchAtIndex(index)
        
        eventCapture?.eventCapture.title = title
        
        eventCapture?.eventCapture.description = description
        
        eventCapture?.eventCapture.image = image
        
    }
    

    
    
}


extension JfwView:UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            switch textField {
            case pobTF:
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                let maxLength = 4
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                if string == numberFiltered && newString.length <= maxLength {
                    didtapPOBtf(pobTF)
                    return true
                }
               return false
            default:
                print("Default")
                // Get the current text in the text field
                 let currentText = textField.text ?? ""
                 
                 // Create the new text string by replacing the characters in the range with the new string
                 guard let stringRange = Range(range, in: currentText) else {
                     return false
                 }
                 let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                 
                 // Ensure the new string length is less than or equal to the max length
                 let maxLength = 50
                if updatedText.count <= maxLength {
                    self.didTapRemarks(remarksTF)
                    return true
                } else {
                    self.endEditing(true)
                    self.toCreateToast("Exeeced remarks character limit.")
                    return false
            
                }
            }


        }
    
    
}
class CustomOverlayView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
     func setupView() {
        self.backgroundColor = .clear
    }
    

}
