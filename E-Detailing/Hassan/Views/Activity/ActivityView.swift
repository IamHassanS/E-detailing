//
//  ActivityView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 05/08/24.
//

import Foundation
import UIKit

extension ActivityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ActivityTextEntryTVC = tableView.dequeueReusableCell(withIdentifier: "ActivityTextEntryTVC") as! ActivityTextEntryTVC
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: ActivitySelectionTVC = tableView.dequeueReusableCell(withIdentifier: "ActivitySelectionTVC") as! ActivitySelectionTVC
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell: ActivityDualEntryVC = tableView.dequeueReusableCell(withIdentifier: "ActivityDualEntryVC") as! ActivityDualEntryVC
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

class ActivityView: BaseView {
    
    func cellRegistration() {
        activityDetailsTable.register(UINib(nibName: "ActivityTextEntryTVC", bundle: nil), forCellReuseIdentifier: "ActivityTextEntryTVC")
        
        activityDetailsTable.register(UINib(nibName: "ActivitySelectionTVC", bundle: nil), forCellReuseIdentifier: "ActivitySelectionTVC")
        
        activityDetailsTable.register(UINib(nibName: "ActivityDualEntryVC", bundle: nil), forCellReuseIdentifier: "ActivityDualEntryVC")
    }
    
//    func containsOnlyApprovedCharacters(in userText: String, toCheckString: String) -> Bool {
//        let approvedCharacters = Set(toCheckString)
//        
//        for char in userText {
//            if !approvedCharacters.contains(char) {
//                return false
//            }
//        }
//        
//        return true
//    }
  //  var dayReportsSortView: DayReportsSortView?
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var titleLBL: UILabel!
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var sortCalenderView: UIView!
    
    
    @IBOutlet var activityView: UIView!
    
    @IBOutlet var filterDateTF: UITextField!
    
    @IBOutlet var activitiesTable: UITableView!
    
  //  @IBOutlet var noreportsView: UIView!
    
   // @IBOutlet var noreportsLbl: UILabel!
    
    @IBOutlet var searchTF: UITextField!
    
  //  @IBOutlet var clearView: UIView!
    
    @IBOutlet var resourceHQlbl: UITextField!
    
    @IBOutlet var resouceHQholderVIew: UIView!
    
    @IBOutlet var viewActivity: UIView!
    
    @IBOutlet var searchActivityView: UIView!
    
    @IBOutlet var viewCalender: UIView!
    
    @IBOutlet var activityDetailsHolder: UIView!
    
    @IBOutlet var activityDetailsTable: UITableView!
    @IBOutlet var activityTitleLbl: UILabel!
    @IBOutlet var btnSubmit: ShadowButton!
    //  @IBOutlet var calendarView: UIView!
    var selectedSortIndex: Int? = nil
    
    var isSortPresented = false

    var isMatched : Bool = false

    var fromDate: Date?
    var customCalenderView: CustomCalenderView?
    
    var activityVC : ActivityVC!
    
    override func didLoad(baseVC: BaseViewController) {
        
        self.activityVC = baseVC as? ActivityVC
        self.setupUI()
        toloadData()
        
    }
    
    func toloadData() {
        activityDetailsTable.delegate = self
        activityDetailsTable.dataSource = self
        activityDetailsTable.reloadData()
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)

        let checkinVIewwidth = self.bounds.width / 3
        let checkinVIewheight = self.bounds.height / 2
        
        let checkinVIewcenterX = self.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = self.bounds.midY - (checkinVIewheight / 2)

        customCalenderView?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
        
    }
    
    func setupUI() {
        activityDetailsTable.backgroundColor = .appGreyColor
        activityDetailsTable.layer.cornerRadius = 5
        backgroundView.isHidden = true
        btnSubmit.layer.cornerRadius = 5
        initTaps()
        searchTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        titleLBL.setFont(font: .bold(size: .BODY))
        activityTitleLbl.setFont(font: .bold(size: .BODY))
        filterDateTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        
        filterDateTF.text = toConvertDate(date: Date())
        self.fromDate = Date()
        filterDateTF.isUserInteractionEnabled = false
        resourceHQlbl.isUserInteractionEnabled = false
        activitiesTable.separatorStyle = .none
        self.backgroundColor = .appGreyColor
        sortCalenderView.layer.borderColor = UIColor.appTextColor.cgColor
        sortCalenderView.layer.borderWidth = 0.5
        sortCalenderView.backgroundColor = .appWhiteColor
        sortCalenderView.layer.cornerRadius = 5
        resouceHQholderVIew.layer.cornerRadius = 5
        activityView.layer.cornerRadius = 5
        searchTF.font  = UIFont(name: "Satoshi-Bold", size: 14)
        resourceHQlbl.font = UIFont(name: "Satoshi-Bold", size: 14)
        resouceHQholderVIew.layer.borderColor = UIColor.appTextColor.cgColor
        resouceHQholderVIew.layer.borderWidth = 0.5
        resouceHQholderVIew.backgroundColor = .appWhiteColor
        
        searchActivityView.layer.cornerRadius = 5
        
        activitiesTable.layer.cornerRadius = 5
        
        activityDetailsHolder.layer.cornerRadius = 5
        initTaps()
        setHQlbl()
        activityDetailsTable.separatorStyle = .none
        cellRegistration()
    }
    
    
    func setHQlbl() {
        // let appsetup = AppDefaults.shared.getAppSetUp()
            CoreDataManager.shared.toRetriveSavedDayPlanHQ { hqModelArr in
                let savedEntity = hqModelArr.first
                guard let savedEntity = savedEntity else{
                    
                    self.resourceHQlbl.text = "Select HQ"
                    
                    return
                    
                }
                
                self.resourceHQlbl.text = savedEntity.name == "" ? "Select HQ" : savedEntity.name
                
                let subordinates = DBManager.shared.getSubordinate()
                
                let asubordinate = subordinates.filter{$0.id == savedEntity.code}
                
                if !asubordinate.isEmpty {
                 //  self.fetchedHQObject = asubordinate.first
                 //   LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text:  asubordinate.first?.id ?? "")
                }
            
              
  
 
                
            }
            // Retrieve Data from local storage
               return
        

       
    }
    
    func toConvertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return  formatter.string(from: date)
       
        
    }
    
    
    func initTaps() {
        viewCalender.addTap {
            self.calenderAction(isForFrom: true)
        }
        
        backHolderView.addTap {
            self.activityVC.navigationController?.popViewController(animated: true)
        }
        
        backgroundView.addTap {
          //  self.activityVC.navigationController?.popViewController(animated: true)
            self.didClose()
        }
        
    }
    
    func calenderAction(isForFrom: Bool) {
        
    
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.subviews.forEach { aAddedView in
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
        
        customCalenderView = self.activityVC.loadCustomView(nibname: XIBs.customCalenderView) as? CustomCalenderView
        customCalenderView?.setupUI(isPastDaysAllowed: true)
        customCalenderView?.today = self.fromDate ?? Date()
       // customCalenderView?.currentPage = self.fromDate ?? Date()
        customCalenderView?.isFromReports = true
        customCalenderView?.completion = self
        customCalenderView?.selectedFromDate = fromDate
        customCalenderView?.isForFrom = isForFrom

        self.addSubview(customCalenderView ?? CustomCalenderView())
        
    }

}

extension ActivityView: CustomCalenderViewDelegate {
    
    @objc func donedatePicker(){

    guard let fromDate = self.fromDate else {return}
    filterDateTF.text = toConvertDate(date: fromDate)
  //   self.detailedreporsVC.toSetParamsAndGetResponse(fromDate)
     self.endEditing(true)
   }
    
    func didClose() {
        backgroundView.isHidden = true
       // stopBackgroundColorAnimation(view: toDateCurveVIew)
       // stopBackgroundColorAnimation(view: fromDateCurveView)
    
         backgroundView.alpha = 0.3
         self.subviews.forEach { aAddedView in
             
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

        self.fromDate = selectedDate
        donedatePicker()

        backgroundView.isHidden = true
         backgroundView.alpha = 0.3
         self.subviews.forEach { aAddedView in
             
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
