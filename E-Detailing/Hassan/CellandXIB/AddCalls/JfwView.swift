//
//  jfwView.swift
//  E-Detailing
//
//  Created by San eforce on 25/03/24.
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
        }
        
        
        if let jwObj = selectedObject as? JointWork {
            jointworkSelectionAction(obj: jwObj)
        }
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
        
    }
    
    func passProductsAndInputs(product: ProductSelectedListViewModel, additioncall: AdditionalCallsListViewModel, index: Int) {
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
        eventCaptureListViewModel.addEventCapture(EventCaptureViewModel(eventCapture: EventCapture(image: image,title: "",description: "")))
        self.eventCaptureTableView.reloadData()
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
    }
}

extension JfwView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        self.eventCaptureListViewModel?.updateDescription(textView.tag, remark: text)
        
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
    }
}



extension JfwView: UITableViewDelegate, UITableViewDataSource {
    func jointworkSelectionAction(obj: JointWork) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.selectionTableView)
//        guard let indexPath = self.selectionTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
        
        let jointWorkValue = self.jointWorkSelectedListViewModel?.fetchJointWorkData(obj.code ?? "")
        guard var jointWorkValue = jointWorkValue else {return}
        jointWorkValue.isSelected = true
        //jointWorkValue.isSelected ?  !jointWorkValue.isSelected : jointWorkValue.isSelected
        if jointWorkValue.isSelected {
            self.jointWorkSelectedListViewModel?.addJointWorkViewModel(JointWorkViewModel(jointWork: jointWorkValue.Object as! JointWork))

        } else {
            self.jointWorkSelectedListViewModel?.removeById(id: jointWorkValue.Object.code ?? "")
        
        }
        
        self.jointWorkTableView.reloadData()
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
    }
    
    
    @objc func deleteEventCapture(_ sender : UIButton){
        self.eventCaptureListViewModel?.removeAtIndex(sender.tag)
        self.eventCaptureTableView.reloadData()
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
    }
    
    
    @objc func imageTitleEdit(_ sender : UITextField){
        self.eventCaptureListViewModel?.updateTitleAtIndex(sender.tag, name: sender.text ?? "")
    }
    
    
    @objc func addJointWork() {

        let vc = SpecifiedMenuVC.initWithStory(self, celltype: .jointCall)
        self.rootVC?.modalPresentationStyle = .custom
        self.rootVC?.navigationController?.present(vc, animated: false)
        
    }
    
    @objc func deleteJointWork (_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.jointWorkTableView)
        guard let indexPath = self.jointWorkTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        self.jointWorkSelectedListViewModel?.removeAtindex(indexPath.row)
        self.jointWorkTableView.reloadData()
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
         //   cell.txtDescription.tag = indexPath.row
          // cell.txtDescription.delegate = self
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
    
    func setupCamera() {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .camera
        pickerVC.delegate = self
        
        self.rootVC?.present(pickerVC, animated: true)
    }
    
    
    
    func toSetupAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "E - Detailing", alertDescription: desc, okAction: "cancel", cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("yes action")
         

        }
        
        commonAlert.addAdditionalCancelAction {
            print("no action")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
    
    func promptToOpenSettings() {
//         let alertController = UIAlertController(title: "Camera Permission Required", message: "Please grant camera permission in settings to use this feature.", preferredStyle: .alert)
//         
//         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//         let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
//             UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//         }
//         
//         alertController.addAction(cancelAction)
//         alertController.addAction(settingsAction)
//         
//        self.rootVC?.present(alertController, animated: true, completion: nil)
        
        toSetupAlert(desc: "Camera Permission Required")
     }
    
    func setupUI() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        if self.dcrCall.call is DoctorFencing {
           if appsetup.docPobNeed != 0 {
               viewPOB.isHidden = true
            }
            
            if appsetup.docJointWrkNeed != 0 {
                jwCurvedView.isHidden = true
            }
            
            
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
            selectedfeedbackLbl.text = overallFeedback.name == "" ? "Select Overall Feedback" :  overallFeedback.name
        }
        
        if let pobValue = self.pobValue {
            pobTF.text = pobValue
        }
        
        if let overallRemark = self.overallRemark {
            remarksTF.text = overallRemark
        }
       
        toloadEventCapuretable()
        toloadJWtable()
    }
    
    func toloadEventCapuretable() {
        eventCaptureTableView.delegate = self
        eventCaptureTableView.dataSource = self
        eventCaptureTableView.reloadData()
    }
    
    @IBAction func didTapRemarks(_ sender: UITextField) {
        self.overallRemark = sender.text ?? ""
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
        
    }
    
    @IBAction func didtapPOBtf(_ sender: UITextField) {
        
        self.pobValue = sender.text ?? ""
        self.delegate?.selectedObjects(eventcptureVM: self.eventCaptureListViewModel ?? EventCaptureListViewModel(), jointWorkSelectedListViewModel: self.jointWorkSelectedListViewModel ?? JointWorksListViewModel(), POBValue:   self.pobValue ?? "", overallFeedback: overallFeedback ?? Feedback(), overallRemarks: overallRemark ?? "")
    }
    
    
}




extension JfwView: EventCaptureCellDelegate {
    func didUpdate(title: String, description: String, index: Int) {
        let eventCapture = self.eventCaptureListViewModel?.fetchAtIndex(index)
        
        eventCapture?.eventCapture.title = title
        
        eventCapture?.eventCapture.description = description
        
    }
    

    
    
}


extension JfwView: UITextFieldDelegate {
    
}
