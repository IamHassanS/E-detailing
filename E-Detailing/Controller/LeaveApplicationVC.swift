//
//  LeaveApplicationVC.swift
//  E-Detailing
//
//  Created by SANEFORCE on 12/07/23.
//

import Foundation
import UIKit
import Charts
import UICircularProgressRing
import Alamofire

class LeaveApplicationVC: UIViewController {
    
    
    @IBOutlet weak var lblLeaveDateFrom: UILabel!
    @IBOutlet weak var lblLeaveToDate: UILabel!
    @IBOutlet weak var lblLeaveType : UILabel!
    @IBOutlet weak var lblChooseFile: UILabel!
    
    @IBOutlet weak var lblLeaveTotalDaysWithType: UILabel!
    
    @IBOutlet weak var lblRemaining: UILabel!
    
    @IBOutlet weak var lblLeaveTypeValue: UILabel!
    
    
    @IBOutlet weak var lblAttachment: UILabel!
    
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var txtFromDate: UITextField!
    
    @IBOutlet weak var txtToDate: UITextField!
    
    
    @IBOutlet weak var txtViewLeaveReason: UITextView!
    @IBOutlet weak var txtViewLeaveAddress: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var heightViewFromConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightViewAvailablityConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightViewAvailConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightLeaveTotalDaysConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var heightRemainingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topHeightLeaveTypeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topHeightDayRemainingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomHeightDayRemainingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewLeaveAvailablity: UIView!
    
    
    @IBOutlet weak var viewAttachment: UIView!
    
    @IBOutlet weak var lblLeaveHide: UILabel!
    
    var isFromToDate : Bool = false
    var fromDate : Date?
    var toDate : Date?
    
    var totalDays = [Date]()
    
//    var selectedLeaveType : LeaveType?
    
    var leaveStatus = [LeaveStatus]()
    
    var selectedLeaveType : LeaveType! {
        didSet {
            guard let selectedLeaveType = self.selectedLeaveType else{
                return
            }
            
            self.lblLeaveTypeValue.text = selectedLeaveType.leaveName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "LeaveStatusCell", bundle: nil), forCellReuseIdentifier: "LeaveStatusCell")
        self.collectionView.register(UINib(nibName: "LeaveAvailablityCell", bundle: nil), forCellWithReuseIdentifier: "LeaveAvailablityCell")
        
     //   self.progressView()
        
        
        self.viewAttachment.isHidden = true
        self.lblAttachment.isHidden = true
        self.lblSize.isHidden = true
        
        self.txtViewLeaveReason.text = "Enter leave Reason"
        self.txtViewLeaveReason.textColor = UIColor.lightGray
        self.txtViewLeaveAddress.text = "Enter the remarks"
        self.txtViewLeaveAddress.textColor = UIColor.lightGray
        
        self.fetchLeave()
        
        self.updateLabel()
        
        
//        let vc = UIStoryboard.slideDownloadVC
//        self.present(vc, animated: true)
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func fromDateAction(_ sender: UIButton) {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let calenterVC = UIStoryboard.calenderVC
        if appsetup.pastLeavePost == 1 {
            calenterVC.minDate = Date()
        }
        calenterVC.didSelectCompletion { selectedDat in
            let dateString = selectedDat.toString(format: "MMM dd, yyyy")
            self.fromDate = selectedDat
            self.txtFromDate.text = dateString
            
            self.txtToDate.text = ""
            self.toDate = nil
            self.selectedLeaveType = nil
            self.lblLeaveTypeValue.text = "Select Leave Type"
        }
        self.present(calenterVC, animated: true)
        
    }
    
    @IBAction func toDateAction(_ sender: UIButton) {
        if self.fromDate == nil {
            return
        }
        let calenterVC = UIStoryboard.calenderVC
        calenterVC.minDate = self.fromDate
        calenterVC.didSelectCompletion { selectedDat in
            let dateString = selectedDat.toString(format: "MMM dd, yyyy")
            self.toDate = selectedDat
            self.txtToDate.text = dateString
            
            self.selectedLeaveType = nil
            self.lblLeaveTypeValue.text = "Select Leave Type"
        }
        self.present(calenterVC, animated: true)
        
    }
    
    @IBAction func leaveTypeAction(_ sender: UIButton) {
        
        
        let vc = UIStoryboard.singleSelectionRightVC
        vc.modalPresentationStyle = .overCurrentContext
    //    vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        vc.view.alpha = 0
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if self.fromDate == nil || self.toDate == nil {
            return
        }
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let leaveType = DBManager.shared.getLeaveType()
        
//        var searchData = [SelectionData]()
//        searchData = leaveType.map{SelectionData(name: $0.leaveName, id: $0.leaveCode)}
        
        let singleSelectionVC = UIStoryboard.singleSelectionVC
        singleSelectionVC.searchTitle = "Select Leave Type"
        singleSelectionVC.selectionData = leaveType
        singleSelectionVC.didSelectCompletion { selectedIndex in
            self.selectedLeaveType = leaveType[selectedIndex]
            
            if appsetup.leaveEntitlementNeed == 0 {
                self.leaveValidationApi()
            }
            self.leaveValidationApi()
        }
        self.present(singleSelectionVC, animated: true)
    }
    
    
    @IBAction func uploadDocAction(_ sender: UIButton) {
        
        // crm.saneforce.in/iOSServer/db_module.php?axn=save/leavemodule
        
       // {"tableName":"saveleave","sfcode":"MR0026","FDate":"2023-7-6","TDate":"2023-7-6","LeaveType":"CL","NOD":"1","LvOnAdd":"","LvRem":"test","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,","sf_emp_id":"give emp id here","leave_typ_code":"give leavetype code here"}
        
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if self.fromDate == nil || self.toDate == nil {
            return
        }else if self.selectedLeaveType == nil{
            return
        }
        
        let appsetup = AppDefaults.shared.getAppSetUp()
    
        let fromDate = self.fromDate!.toString(format: "yyyy-MM-dd")
        let toDate = self.toDate!.toString(format: "yyyy-MM-dd")
        
        let leaveRemarks = self.txtViewLeaveReason.text!
        let leaveAddress = self.txtViewLeaveAddress.text!
        
        let selectedLeaveType = self.selectedLeaveType
        
        let url = APIUrl + "save/leavemodule"
        
        let paramString = "{\"tableName\":\"saveleave\",\"sfcode\":\"\(appsetup.sfCode!)\",\"FDate\":\"\(fromDate)\",\"TDate\":\"\(toDate)\",\"LeaveType\":\"\(selectedLeaveType?.leaveSName ?? "")\",\"NOD\":\"2\",\"LvOnAdd\":\"\(leaveAddress)\",\"LvRem\":\"\(leaveRemarks)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\",\"sf_emp_id\":\"\(appsetup.sfEmpId!)\",\"leave_typ_code\":\"\(selectedLeaveType?.leaveCode ?? "")\"}"

        let data = ["data" : paramString]
        
        print(url)
        print(data)
        
        AF.request(url,method: .post,parameters: data).responseData { (response) in

            switch response.result {
            case .success(_):
                do{
                    let apiResponse = try JSONSerialization.jsonObject(with: response.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                    print(apiResponse)
                }catch{
                    print(response.error as Any)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func updateLabel() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()

        if appsetup.leaveEntitlementNeed == 0 {
            self.lblLeaveHide.isHidden = false
            
            self.lblRemaining.isHidden = true
            self.lblLeaveTotalDaysWithType.isHidden = true
            
            self.topHeightLeaveTypeConstraint.constant = 0
            self.topHeightDayRemainingConstraint.constant = 0
            self.bottomHeightDayRemainingConstraint.constant = 0
            self.heightRemainingConstraint.constant = 0
            self.heightLeaveTotalDaysConstraint.constant = 0
            
        }else {
            self.lblLeaveHide.isHidden = true
        }
        
        let color = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.65))
        
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
          attributes: [.font: UIFont(name: "Satoshi-Bold", size: 17) as Any])
        text.addAttributes([.font: UIFont(name: "Satoshi-Regular", size: 17) as Any], range: NSMakeRange(12,9))
        self.lblChooseFile.attributedText = text
    }
    
    
    private func leaveValidationApi() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let fromDate = self.fromDate!.toString(format: "yyyy-MM-dd")
        let toDate = self.toDate!.toString(format: "yyyy-MM-dd")
        
        let url = APIUrl + "table/leave"
        
        let paramString = "{\"tableName\":\"getlvlvalid\",\"sfcode\":\"\(appsetup.sfCode!)\",\"Fdt\":\"\(fromDate)\",\"Tdt\":\"\(toDate)\",\"LTy\":\"\(self.selectedLeaveType?.leaveSName ?? "")\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"
        
        let data = ["data" : paramString]
        
        print(url)
        print(paramString)
        
        AF.request(url,method: .post,parameters: data).responseData{ (response) in
            
            switch response.result {
                
            case .success(_):
                do{
                    let apiResponse = try JSONSerialization.jsonObject(with: response.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                    print(apiResponse)
                    self.updateLeaveRequest()
                }catch{
                    print(response.error as Any)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchLeave() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        let url = APIUrl + "table/leave"
        
        let paramString = "{\"tableName\":\"getleavestatus\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"
        
        let data = ["data" : paramString]
        
        AF.request(url,method: .post,parameters: data).responseData{ (response) in
            
            switch response.result {
                
            case .success(_):
                do{
//                    let apiResponse = try JSONSerialization.jsonObject(with: response.description,options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                    
                    let apiResponse = try JSONSerialization.jsonObject(with: response.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                    print(apiResponse)
                    
                    guard let responseArray = apiResponse as? [[String : Any]] else{
                        return
                    }
                    
                    self.leaveStatus  = responseArray.map{LeaveStatus(fromDictionary: $0)}
                    self.collectionView.reloadData()
                    
                }catch{
                    print(response.error as Any)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
    private func updateLeaveRequest() {
        
        guard let fromDate = self.fromDate, let toDate = self.toDate else{
            return
        }
        
        print(fromDate)
        print(toDate)
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: fromDate)
        let date2 = calendar.startOfDay(for: toDate)
        
        let datesBetweenArray = Date.dates(from: date1, to: date2)
        
        self.totalDays = datesBetweenArray
        self.tableView.reloadData()
    }
    
}


extension LeaveApplicationVC : tableViewProtocols {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveStatusCell", for: indexPath) as! LeaveStatusCell
        cell.lblDate.text = self.totalDays[indexPath.row].toString(format: "MMM dd, yyyy")
        return cell
    }
}


extension LeaveApplicationVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.leaveStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaveAvailablityCell", for: indexPath) as! LeaveAvailablityCell
        cell.leaveStatus = self.leaveStatus[indexPath.row]
        cell.viewLop.isHidden = self.leaveStatus[indexPath.row].leaveTypeCode == "LOP" ? false : true
        return cell
    }
}



extension LeaveApplicationVC: UITextViewDelegate {
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if self.selectedLeaveType != nil{
//            return true
//        }else{
//
//            return false
//        }
//    }
    
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
                textView.text = "Enter leave Reason"
                textView.textColor = UIColor.lightGray
            }
            break
        default:
            if textView.text.isEmpty {
                textView.text = "Enter the remarks"
                textView.textColor = UIColor.lightGray
            }
            break
        }
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



struct LeaveStatus{
    
    var available : String!
    var eligibility : String!
    var leaveTypeCode : String!
    var leaveCode : String!
    var taken : String!
    
    
    init(fromDictionary dictionary: [String:Any]){

        available = dictionary["Avail"] as? String ?? ""
        eligibility = dictionary["Elig"] as? String ?? ""
        leaveTypeCode = dictionary["Leave_Type_Code"] as? String ?? ""
        leaveCode = dictionary["Leave_code"] as? String ?? ""
        taken = dictionary["Taken"] as? String ?? ""
        
    }
}




