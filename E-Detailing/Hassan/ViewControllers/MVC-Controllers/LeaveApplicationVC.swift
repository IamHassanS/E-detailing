//
//  LeaveApplicationVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 12/07/23.
//

import Foundation
import UIKit
import Charts
import UICircularProgressRing
import Alamofire
import CoreData


extension LeaveApplicationVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case txtViewLeaveReason:
            if textView.text.isEmpty {
                textView.text = "Type here.."
                textView.textColor = UIColor.lightGray
            }
            self.leaveReadseon = textView.text == "Type here.." ? "" : textView.text
        case txtViewLeaveAddress:
            if textView.text.isEmpty {
                textView.text = "Type here.."
                textView.textColor = UIColor.lightGray
            }
            self.leaveAddress = textView.text == "Type here.." ? "" : textView.text
        default:
            print("yet to")
        }

       
   
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case txtViewLeaveReason:
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.isEmpty {

                textView.text = "Type here.."
                textView.textColor = UIColor.lightGray

                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                self.leaveReadseon = updatedText
            }

            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
             else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = UIColor.black
                textView.text = text
            }

            // For every other case, the text should change with the usual
            // behavior...
            else {
                self.leaveReadseon = updatedText
                return true
            }

            // ...otherwise return false since the updates have already
            // been made
          
            return false
        case txtViewLeaveAddress:
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.isEmpty {

                textView.text = "Type here.."
                textView.textColor = UIColor.lightGray

                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                self.leaveAddress = updatedText
            }

            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
             else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = UIColor.black
                textView.text = text
            }

            // For every other case, the text should change with the usual
            // behavior...
            else {
                self.leaveAddress = updatedText
                return true
            }

            // ...otherwise return false since the updates have already
            // been made
          
            return false
        default:
            print("yet to")
        }
return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case txtViewLeaveReason:
            if self.view.window != nil {
                if textView.textColor == UIColor.lightGray {
                    textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                }
            }
        case txtViewLeaveAddress:
            if self.view.window != nil {
                if textView.textColor == UIColor.lightGray {
                    textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                }
            }
        default:
            print("yet to")
        }

    }
}


extension LeaveApplicationVC: MenuResponseProtocol {
    func callPlanAPI() {
        print("Yet to")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        print("Yet to")
       
        if let selectedObject = selectedObject as? LeaveType {
            selectedLeveType = selectedObject
            self.selectedLeaveTypeLbl.text = selectedObject.leaveName
            updateLeave(leavetype: selectedObject)
        }
       
    }
    
     func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to")
    }
    
    
    func updateLeave(leavetype: LeaveType) {
       
        enableSubmitBtn()
        let totalNumberofLeaves = updateLeaveRequest()
        if appsetup.leaveEntitlementNeed == 0 {
            leaveNotifyView.isHidden = false
            
        } else {
            leaveNotifyView.isHidden = true
            
        }
     
       let cacheLeave = DBManager.shared.getLeaveType()
        let fetchedLeave = cacheLeave.filter { $0.leaveCode ==  leavetype.leaveCode }.first
        if let fetchedLeave = fetchedLeave {
            let aleaveStatus = self.leaveStatus.filter { $0.leaveCode == fetchedLeave.leaveCode }.first
            guard let aleaveStatus = aleaveStatus else {return}
            switch aleaveStatus.leaveCode {
            case "247":
                //cl
                lblAvailableDays.text = "\(totalNumberofLeaves)" + " days of Casual Leave"
                lblRemainingDays.text = "\(aleaveStatus.available ?? "0")" + " days remaining"
            case "248":
                //pl
                lblAvailableDays.text = "\(totalNumberofLeaves)" + " days of Paid Leave"
                lblRemainingDays.text = "\(aleaveStatus.available ?? "0")" + " days remaining"
            case "249":
                //sl
                lblAvailableDays.text = "\(totalNumberofLeaves)" + " days of Sick Leave"
                lblRemainingDays.text = "\(aleaveStatus.available ?? "0")" + " days remaining"
            case "250":
                //LOP
                lblAvailableDays.text = "\(totalNumberofLeaves)" + " days of LOP"
                lblRemainingDays.text = "\(aleaveStatus.available ?? "0")" + " days remaining"

            case .none:
                print("Yet to")
            case .some(_):
                print("Yet to")
            }
 
            
            
            
        }
        
    }
    
}

extension LeaveApplicationVC: CustomCalenderViewDelegate {
    
    
    func didClose() {
        backgroundView.isHidden = true
        stopBackgroundColorAnimation(view: toDateCurveVIew)
        stopBackgroundColorAnimation(view: fromDateCurveView)
    
         backgroundView.alpha = 0.3
         self.view.subviews.forEach { aAddedView in
             
             switch aAddedView {

             case customCalenderView:
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
    
    func didSelectDate(selectedDate: Date, isforFrom: Bool) {

       if isforFrom {
           self.fromDate = selectedDate
           txtFromDate.text = selectedDate.toString(format: "MMM dd, yyyy")
       } else {
           self.toDate = selectedDate
          
       }
        
        if let fromDate = self.fromDate, let toDate = self.toDate {
            if Calendar.current.compare(fromDate, to: toDate, toGranularity: .day) == .orderedDescending {
                if isforFrom {
                    self.toCreateToast("Select dates before leave to date")
                } else {
                    self.toCreateToast("Select dates after leave from date")
                }
               
                return
            } else {
                
                if isforFrom {
                    txtFromDate.text = selectedDate.toString(format: "MMM dd, yyyy")
                } else {
                    txtToDate.text = selectedDate.toString(format: "MMM dd, yyyy")
                }
                
            
            }
        }
        _ = updateLeaveRequest()
        enableSubmitBtn()
        stopBackgroundColorAnimation(view: toDateCurveVIew)
        stopBackgroundColorAnimation(view: fromDateCurveView)
        backgroundView.isHidden = true
         backgroundView.alpha = 0.3
         self.view.subviews.forEach { aAddedView in
             
             switch aAddedView {

             case customCalenderView:
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
    
    
}

class LeaveApplicationVC: UIViewController {
    
    
    
    class func initWithStory() -> LeaveApplicationVC {
        let tourPlanVC : LeaveApplicationVC = UIStoryboard.Hassan.instantiateViewController()
        //tourPlanVC.tourplanVM = TourPlanVM()
        return tourPlanVC
    }
    
    func setupUI() {
        backgroundView.isHidden = true
        
        enableSubmitBtn()
        lblLeaveRequest.setFont(font: .bold(size: .BODY))
        lblAvailableDays.setFont(font: .bold(size: .BODY))
        lblRemainingDays.setFont(font: .medium(size: .BODY))
         leaveNotifyView.isHidden = true

        lblRemainingDays.textColor = .appLightTextColor
        lblAvailableDays.textColor = .appTextColor
        lblLeaveRequest.textColor = .appTextColor
        let holerCurvedViews: [UIView] = [viewLeaveAvailablity, ViewLeaveinfo]
        holerCurvedViews.forEach { aView in
            aView.layer.cornerRadius = 5
        }
        self.selectedLeaveTypeLbl.text = selectedLeveType == nil ? "Select leave type" :  selectedLeveType?.leaveName ?? ""
        leaveEntryHolderVIew.layer.borderWidth = 1
        leaveEntryHolderVIew.layer.borderColor = UIColor.appBlue.cgColor
        leaveEntryHolderVIew.layer.cornerRadius = 5
        tableHolderVXview.backgroundColor = .appBlue.withAlphaComponent(0.1)
        let selectionViews: [UIView] = [leaveTypeCurveView, addressEnterCurveView, reasonEnterCurveView,  attachmentCurveView, toDateCurveVIew, fromDateCurveView]
        selectionViews.forEach { aView in
            aView.layer.borderWidth = 1
            aView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
            aView.layer.cornerRadius = 5
        }
        configureTextField(textView: self.txtViewLeaveReason)
        configureTextField(textView: self.txtViewLeaveAddress)
        
                if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.collectionView?.isScrollEnabled = false
        
                }
        tableView.separatorStyle = .none
        
       
        if appsetup.leaveEntitlementNeed == 0 {
            self.viewLeaveAvailablity.isHidden = false
            
        } else {
            self.viewLeaveAvailablity.isHidden = true
            
        }
        
        
        
        backHolderView.addTap {
            self.navigationController?.popViewController(animated: true)
        }
        
        fromDateCurveView.addTap {
            self.cacheToAndleaveType()
            self.animateBackgroundColorChange(view: self.fromDateCurveView)
            self.calenderAction(isForFrom: true)
        }
        
        toDateCurveVIew.addTap {
            self.cacheleaveType()
            guard (self.fromDate != nil) else {
                self.toCreateToast("Select leave date from")
                return}
            
            self.animateBackgroundColorChange(view: self.toDateCurveVIew)
            
            self.calenderAction(isForFrom: false)
        }
        
        backgroundView.addTap {
            self.didClose()
        }
        
        leaveTypeCurveView.addTap {
            guard (self.fromDate != nil  && self.toDate != nil) else {
                self.toCreateToast("Select from and to dates")
                return}
            
            let vc = SpecifiedMenuVC.initWithStory(self, celltype: .leave)
            self.modalPresentationStyle = .custom
            self.navigationController?.present(vc, animated: false)
        }
    }
    
    
    func cacheleaveType() {
      
        self.selectedLeveType = nil
        self.selectedLeaveTypeLbl.text = selectedLeveType == nil ? "Select leave type" :  selectedLeveType?.leaveName ?? ""
      
    }
    
    func cacheToAndleaveType() {
        self.toDate = nil
        self.selectedLeveType = nil
        self.selectedLeaveTypeLbl.text = selectedLeveType == nil ? "Select leave type" :  selectedLeveType?.leaveName ?? ""
        txtToDate.text = toDate == nil ? "Select date" : fromDate?.toString(format: "MMM dd, yyyy")
    }
    
    func removeAllCache() {
        self.fromDate = nil
        self.toDate = nil
        self.selectedLeveType = nil
        self.totalDays = []
        self.selectedLeaveTypeLbl.text = selectedLeveType == nil ? "Select leave type" :  selectedLeveType?.leaveName ?? ""
        
        txtFromDate.text = fromDate == nil ? "Select date" : fromDate?.toString(format: "MMM dd, yyyy")

        txtToDate.text = toDate == nil ? "Select date" : fromDate?.toString(format: "MMM dd, yyyy")
    
        self.toLoadTable()
     
    }
    
    func configureTextField(textView: UITextView) {
        switch textView {
        case txtViewLeaveReason:
            txtViewLeaveReason.text =  self.leaveReadseon == nil ? "Type here.." : self.leaveReadseon
            //txtViewLeaveReason.backgroundColor = .appSelectionColor
            //txtViewLeaveReason.layer.cornerRadius = 5
            txtViewLeaveReason.textColor = .appTextColor
           // remarksTV.font = UIFont(name: "Satoshi-Medium", size: 14)
            txtViewLeaveReason.delegate = self
            //remarksTV.text == "" ? "Type here.." : remarksTV.text
            txtViewLeaveReason.textColor =  txtViewLeaveReason.text == "Type here.." ? UIColor.lightGray : UIColor.black
        case txtViewLeaveAddress:
            txtViewLeaveAddress.text =  self.leaveAddress == nil ? "Type here.." : self.leaveAddress
            //txtViewLeaveAddress.backgroundColor = .appSelectionColor
            //txtViewLeaveAddress.layer.cornerRadius = 5
            txtViewLeaveAddress.textColor = .appTextColor
           // remarksTV.font = UIFont(name: "Satoshi-Medium", size: 14)
            txtViewLeaveAddress.delegate = self
            //remarksTV.text == "" ? "Type here.." : remarksTV.text
            txtViewLeaveAddress.textColor =  txtViewLeaveAddress.text == "Type here.." ? UIColor.lightGray : UIColor.black
        default:
            print("yet to")
        }

    }
   // lblLeaveRequest.setFont(font: .bold(size: .bo))
    //leaveNotifyView.isHidden = true
    //lblAvailableDays
    //lblRemainingDays
    @IBOutlet var lblLeaveRequest: UILabel!
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var lblRemainingDays: UILabel!
    @IBOutlet var lblAvailableDays: UILabel!
    @IBOutlet var leaveNotifyView: UIView!
    @IBOutlet var tableHolderVXview: UIVisualEffectView!
    
    @IBOutlet var contentsHolder: UIView!
    @IBOutlet var leaveTypeCurveView: UIView!
    
    @IBOutlet var leaveEntryHolderVIew: UIView!
    @IBOutlet var addressEnterCurveView: UIView!
    @IBOutlet var reasonEnterCurveView: UIView!
    @IBOutlet var attachmentCurveView: UIView!
    @IBOutlet var toDateCurveVIew: UIView!
    @IBOutlet var fromDateCurveView: UIView!
    
    @IBOutlet weak var lblLeaveDateFrom: UILabel!
    @IBOutlet weak var lblLeaveToDate: UILabel!
    @IBOutlet weak var lblLeaveType : UILabel!
    
    @IBOutlet var selectedLeaveTypeLbl: UILabel!
    @IBOutlet weak var lblChooseFile: UILabel!
    
    @IBOutlet weak var lblLeaveTotalDaysWithType: UILabel!
    
    @IBOutlet weak var lblRemaining: UILabel!
    
    @IBOutlet weak var lblLeaveTypeValue: UILabel!
    
    
    @IBOutlet weak var lblAttachment: UILabel!
    
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var txtFromDate: UILabel!
    
    @IBOutlet weak var txtToDate: UILabel!
    
    
    @IBOutlet weak var txtViewLeaveReason: UITextView!
    @IBOutlet weak var txtViewLeaveAddress: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    @IBOutlet weak var viewLeaveAvailablity: UIStackView!
    
    @IBOutlet var ViewLeaveinfo: UIView!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet weak var viewAttachment: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lblLeaveHide: UILabel!
    let appsetup = AppDefaults.shared.getAppSetUp()
    var userStatisticsVM = UserStatisticsVM()
    var customCalenderView: CustomCalenderView?
    var selectedLeveType: LeaveType?
    var isFromToDate : Bool = false
    var fromDate : Date?
    var toDate : Date?
    
    var totalDays = [Date]()
    var isAnimatingBackgroundColor = false
//    var selectedLeaveType : LeaveType?
    
    var leaveStatus = [LeaveStatus]()
    var leaveAddress: String? = nil
    var leaveReadseon: String? = nil

    func animateBackgroundColorChange(view: UIView) {

        view.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)

    }
    
    func stopBackgroundColorAnimation(view: UIView) {
        view.backgroundColor = .appWhiteColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let checkinVIewwidth = view.bounds.width / 3
        let checkinVIewheight = view.bounds.height / 2
        
        let checkinVIewcenterX = view.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = view.bounds.midY - (checkinVIewheight / 2)

        customCalenderView?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
    }
    
    func calenderAction(isForFrom: Bool) {
        
    
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case customCalenderView:
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
        
        customCalenderView = self.loadCustomView(nibname: XIBs.customCalenderView) as? CustomCalenderView
        customCalenderView?.setupUI(isPastDaysAllowed:  appsetup.pastLeavePost == 0 ? true : false)
        customCalenderView?.completion = self
        customCalenderView?.selectedFromDate = fromDate
        customCalenderView?.selectedToDate = toDate
        customCalenderView?.isForFrom = isForFrom
        //customCalenderView?.delegate = self
        //customCalenderView?.setupTaggeImage(fetchedImageData: imageData)
        self.view.addSubview(customCalenderView ?? CustomCalenderView())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.tableView.register(UINib(nibName: "LeaveStatusCell", bundle: nil), forCellReuseIdentifier: "LeaveStatusCell")
        self.collectionView.register(UINib(nibName: "LeaveAvailablityCell", bundle: nil), forCellWithReuseIdentifier: "LeaveAvailablityCell")
        
        self.btnSubmit.layer.cornerRadius = 5

        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            toShowAlert(desc: "Please connect to active network to apply leave.", istoNavigate: false)
            return
        }
        
        self.fetchLeave()
        
       // self.updateLabel()

    }
    
    
    func toLoadTable() {
        self.tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        
    }
    
    func toLoadCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func leaveTypeAction(_ sender: UIButton) {
 
        
     //   let leaveType = DBManager.shared.getLeaveType()
        

    }
    
    
    @IBAction func uploadDocAction(_ sender: UIButton) {
        
        // crm.saneforce.in/iOSServer/db_module.php?axn=save/leavemodule
        
       // {"tableName":"saveleave","sfcode":"MR0026","FDate":"2023-7-6","TDate":"2023-7-6","LeaveType":"CL","NOD":"1","LvOnAdd":"","LvRem":"test","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,","sf_emp_id":"give emp id here","leave_typ_code":"give leavetype code here"}
        
    }
    
    func enableSubmitBtn() {
        if self.fromDate == nil || self.toDate == nil {
            btnSubmit.alpha = 0.5
            btnSubmit.isUserInteractionEnabled = false
        } else if self.selectedLeveType == nil{
            btnSubmit.alpha = 0.5
            btnSubmit.isUserInteractionEnabled = false
        } else {
            self.leaveValidationApi()
 
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if self.fromDate == nil || self.toDate == nil {
            return
        } else if self.selectedLeveType == nil{
            return
        }
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            toShowAlert(desc: "Please connect to active network to apply leave.", istoNavigate: false)
            return
        }
      
        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")
        let fromDate = self.fromDate!.toString(format: "yyyy-MM-dd HH:mm:ss")
        let toDate = self.toDate!.toString(format: "yyyy-MM-dd HH:mm:ss")
        
        let numberofDays = "\(self.totalDays.count)"
        
        let leaveRemarks = self.txtViewLeaveReason.text ?? ""
        let leaveAddress = self.txtViewLeaveAddress.text ?? ""
        
        let selectedLeaveType = self.selectedLeveType
        
       // {"tableName":"saveleave","sfcode":"MR0026","FDate":"2023-7-6","TDate":"2023-7-6","LeaveType":"CL","NOD":"1","LvOnAdd":"","LvRem":"test","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,","sf_emp_id":"give emp id here","leave_typ_code":"give leavetype code here"}
        
        var param = [String: Any]()
        param["tableName"] = "saveleave"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["FDate"] = fromDate
        param["TDate"] = toDate
        param["LeaveType"] = selectedLeaveType?.leaveSName ?? ""
        param["NOD"] = numberofDays
        param["LvOnAdd"] = leaveAddress
        param["LvRem"] = leaveRemarks
        param["division_code"] = divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
        param["sf_emp_id"] = appsetup.sfEmpId ?? ""
        param["leave_typ_code"] = selectedLeaveType?.leaveCode ?? ""

        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        var tosendData = [String: Any]()
        tosendData["data"] = paramData


        Shared.instance.showLoaderInWindow()
        userStatisticsVM.toSubmitLeave(params: tosendData, api: .toSubmitLeave, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
                
            case .success(let response):
                if response.success ?? false {
                    self.removeAllCache()
                    self.toShowAlert(desc: "Leave submitted successfully", istoNavigate: true)
                }
            case .failure(let error):
                self.toCreateToast(error.localizedDescription)
            }
        }
    }
    

    
    private func updateLabel() {
        

        let color: UIColor = .appLightPink
        
        let fromDate = NSMutableAttributedString(string: "Leave Date From*",attributes: [NSAttributedString.Key.foregroundColor : color])
        fromDate.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSMakeRange(15, 1))
        self.lblLeaveDateFrom.attributedText = fromDate
        
        let toDate = NSMutableAttributedString(string: "Leave Date To*",attributes: [NSAttributedString.Key.foregroundColor : color])
        toDate.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSMakeRange(13, 1))
        self.lblLeaveToDate.attributedText = toDate
        
        let leaveType = NSMutableAttributedString(string: "Leave Type*",attributes: [NSAttributedString.Key.foregroundColor : color])
        leaveType.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSMakeRange(10, 1))
        self.lblLeaveType.attributedText = leaveType
        
        let text = NSMutableAttributedString(
          string: "Choose file to upload",
          attributes: [.font: UIFont(name: "Satoshi-Bold", size: 14) as Any])
        text.addAttributes([.font: UIFont(name: "Satoshi-Regular", size: 14) as Any], range: NSMakeRange(12,9))
        self.lblChooseFile.attributedText = text
    }
    
    
    private func leaveValidationApi() {
        
     
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            toShowAlert(desc: "Please connect to active network to apply leave.", istoNavigate: false)
            return
        }
        let fromDate = self.fromDate!.toString(format: "yyyy-MM-dd")
        let toDate = self.toDate!.toString(format: "yyyy-MM-dd")
        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")
       // let url = APIUrl + "get/leave"
       // {"tableName":"getlvlvalid","sfcode":"MR0026","Fdt":"2023-7-6","Tdt":"2023-7-6","LTy":"CL","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,"}
        var param = [String: Any]()
        param["tableName"] = "getlvlvalid"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["Fdt"] = fromDate
        param["Tdt"] = toDate
        param["LTy"] = self.selectedLeveType?.leaveSName ?? ""
        param["division_code"] = divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        var tosendData = [String: Any]()
        tosendData["data"] = paramData
        
        Shared.instance.showLoaderInWindow()
        
        userStatisticsVM.toCheckLeaveAvailability(params: tosendData, api: .leaveinfo, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
                
           
            case .success(let response):
                
                dump(response)
                let object = response[0]
                guard let responseMessage = object.message else {return}
                if !responseMessage.isEmpty {
                    self.toShowAlert(desc: object.message ?? "Unable to process leave application. Try again later.", istoNavigate: false)
                    self.removeAllCache()
                    self.btnSubmit.alpha  = 0.5
                    self.btnSubmit.isUserInteractionEnabled = false
                    self.tableView.isHidden = true
                } else {
                    self.toLoadTable()
                    self.btnSubmit.alpha  = 1
                    self.btnSubmit.isUserInteractionEnabled = true
                }
           
            case .failure(let error):
                self.toCreateToast(error.localizedDescription)
            }
        }

    }
    
    
    func toShowAlert(desc: String, istoNavigate: Bool) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            if istoNavigate {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("no action")
            }
        
           
        }

    }
    
    private func fetchLeave() {
        
      
      // let url = APIUrl + "get/leave"

        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")
        var param = [String: Any]()
        param["tableName"] = "getleavestatus"
       
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
        
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        var tosendData = [String: Any]()
        tosendData["data"] = paramData
//        "{\"tableName\":\"getleavestatus\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"
        
       
        Shared.instance.showLoaderInWindow()
        
        userStatisticsVM.toGetLeaveStatus(params: tosendData, api: .leaveinfo, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
                
            case .success(let response):
                dump(response)
                self.leaveStatus = response
                DispatchQueue.main.async {
                    self.toLoadCollection()
                }
          
            case .failure(let failure):
                self.toCreateToast(failure.localizedDescription)
            }
        }
    }
    
    
    
    
    private func updateLeaveRequest() -> Int {
        
        guard let fromDate = self.fromDate, let toDate = self.toDate else{
            return 0
        }
        
        print(fromDate)
        print(toDate)
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: fromDate)
        let date2 = calendar.startOfDay(for: toDate)
        
        let datesBetweenArray = Date.dates(from: date1, to: date2)
        
        self.totalDays = datesBetweenArray
        self.toLoadTable()
        return datesBetweenArray.count
    }
    
}


extension LeaveApplicationVC : tableViewProtocols {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveStatusCell", for: indexPath) as! LeaveStatusCell
        cell.selectionStyle = .none
        cell.lblDate.text = self.totalDays[indexPath.row].toString(format: "MMM dd, yyyy")
        return cell
    }
}


extension LeaveApplicationVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.leaveStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaveAvailablityCell", for: indexPath) as! LeaveAvailablityCell
        cell.leaveStatus = self.leaveStatus[indexPath.row]
       // cell.viewLop.isHidden = self.leaveStatus[indexPath.row].leaveTypeCode == "LOP" ? false : true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 4, height: collectionView.height)
    }

}






extension Date{
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}








