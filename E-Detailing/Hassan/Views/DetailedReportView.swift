//
//  DetailedReportView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import Foundation
import UIKit
extension  DetailedReportView: DayReportsSortViewDelegate {
    func userDidSort(sorted index: Int?) {
        self.selectedSortIndex = index
        hideAddedViews()
        guard let index = index else {return}
        switch index {
        case 0:
            toReorderRepotes(type: .orderAscending)
        case 1:
            toReorderRepotes(type: .orderDescending)
        case 2:
            toReorderRepotes(type: .orderByDateAscending)
        case 3:
            toReorderRepotes(type: .orderByDateDesending)
        default:
            print("Yet to sort")
        }
    
    }
    
    func userDidCancel() {
        hideAddedViews()
    }
    
    func hideAddedViews() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case dayReportsSortView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
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

extension DetailedReportView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isMatched ? filteredreportsModel?.count ?? 0 : reportsModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasicReportsInfoTVC = tableView.dequeueReusableCell(withIdentifier: "BasicReportsInfoTVC") as!  BasicReportsInfoTVC
        cell.selectionStyle = .none
        let modal =  isMatched ? filteredreportsModel?[indexPath.row] ?? ReportsModel() : reportsModel?[indexPath.row] ?? ReportsModel()
        cell.populateCell(modal)
        cell.nextActionVIew.addTap {
            let vc = ViewDayReportVC.initWithStory(model: modal, dcrDate: self.fromDate?.toString(format: "dd MMM yyyy") ?? "")
            if isTohideCheckin(modal) && isTohideCheckout(modal) {
                vc.isToReduceLocationHeight = true
            }
            self.detailedreporsVC.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.remarksDescLbl.addTap { [weak self] in
            self?.didCommentsTapped(view:  cell.remarksDescLbl, comments: modal.remarks)
        }
        
        return cell
    }
    
    func didCommentsTapped(view: UIView, comments: String) {
        
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 7), on: view,  pagetype: .hover)

        vc.color = .appTextColor
        vc.comments = comments
        self.detailedreporsVC?.navigationController?.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = isMatched ? filteredreportsModel?[indexPath.row] ?? ReportsModel() : reportsModel?[indexPath.row] ?? ReportsModel()
        var tempCellHeight = cellHeight
        let isTohideCheckin = isTohideCheckin(model)
        let isTohideCheckout = isTohideCheckout(model)
        
        if isTohideCheckin && isTohideCheckout  {
            tempCellHeight = tempCellHeight - 80
        } else {
           tempCellHeight += 80
        }
        
        var count = Int()
        if model.chm != 0 {

            count += 1
        }
        
        if model.cip != 0 {

            count += 1
        }
        
        if model.drs != 0 {

            count += 1
        }
        
        
        if model.stk != 0 {

            count += 1
        }
     
        
        if model.udr != 0 {

            count += 1
        }
        
        if model.hos != 0 {

            count += 1
        }
       // remarksAndPlansView
        let isTohideRemarks = isTohideRemarks(model)
        let isTohideplanCollection = isTohideplanCollection(count:  count )
        
        if isTohideplanCollection {
       //     self.
        }
         
        if isTohideRemarks && isTohideplanCollection {
          //  tempCellHeight = tempCellHeight - 75
        } else {
         
        }
        
       
        return CGFloat(tempCellHeight)
    }
    
    
}

extension DetailedReportView {
    
    enum SortingType {
        case orderAscending
        case orderDescending
        case orderByDateAscending
        case orderByDateDesending
    }
    

    
    
    func toReorderRepotes(type: SortingType) {
        switch type {
            
        case .orderAscending:
          
            if isMatched {
                self.filteredreportsModel = self.filteredreportsModel?.sorted { $0.sfName < $1.sfName }
                
            } else {
                self.reportsModel = self.reportsModel?.sorted { $0.sfName < $1.sfName }
            }
            self.toLoadData()
        case .orderDescending:
            if isMatched {
                self.filteredreportsModel = self.filteredreportsModel?.sorted { $0.sfName > $1.sfName }
                
            } else {
                self.reportsModel = self.reportsModel?.sorted { $0.sfName > $1.sfName }
            }
            self.toLoadData()
        case .orderByDateAscending:
            print("Yet to implement")
            if isMatched {
                self.filteredreportsModel = self.filteredreportsModel?.sorted {
                    let date1 = toCOnvertTimeTodate($0.adate)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.adate) // Handle invalid time strings
                    return date1 < date2
                    
                }
                  
            } else {
             //   self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name < $1.name }
                
                
                self.reportsModel = self.reportsModel?.sorted {
                  let date1 = toCOnvertTimeTodate($0.adate)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.adate) // Handle invalid time strings
                    return date1 < date2
                    
                }
                
            }
            self.toLoadData()
        case .orderByDateDesending:
            print("Yet to implement")
            if isMatched {
                self.filteredreportsModel = self.filteredreportsModel?.sorted {
                    let date1 = toCOnvertTimeTodate($0.adate)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.adate) // Handle invalid time strings
                    return date1 > date2
                    
                }
                  
            } else {
             //   self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name < $1.name }
                
                
                self.reportsModel = self.reportsModel?.sorted {
                  let date1 = toCOnvertTimeTodate($0.adate)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.adate) // Handle invalid time strings
                    return date1 > date2
                    
                }
                
            }
            self.toLoadData()
        }
    }
    
    func toCOnvertTimeTodate(_ time: String) -> Date {
        let timeString = time

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"

        if let date = dateFormatter.date(from: timeString) {
            print(date)
            return date
        } else {
            print("Invalid time string format")
        }
        return Date()
    }

}

extension DetailedReportView :UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle the text change
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            toFilterResults(newText)
            
           
        }
        return true
    }
        
        func toFilterResults(_ toSearchString: String) {
            
            let newText = toSearchString
            self.filteredreportsModel = [ReportsModel]()
            reportsModel?.forEach({ report in
                if report.wtype.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                else if report.intime.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.outtime.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.inaddress.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.outaddress.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.remarks.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.rptdate.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                else if report.sfName.lowercased().contains(newText) {
                    self.filteredreportsModel?.append(report)
                }
                
                
                else if containsOnlyApprovedCharacters(in: newText, toCheckString: "approved") {
                    if report.typ == 1 {
                        self.filteredreportsModel?.append(report)
                    }
                }
                else if containsOnlyApprovedCharacters(in: newText, toCheckString: "pending") {
                    if report.typ == 0 {
                        self.filteredreportsModel?.append(report)
                    }
                }
                else if containsOnlyApprovedCharacters(in: newText, toCheckString: "rejected") {
                    if report.typ == 2 {
                        self.filteredreportsModel?.append(report)
                    }
                }
                
//                else if newText.contains("approved") {
//                    if report.typ == 1 {
//                        self.filteredreportsModel?.append(report)
//                    }
//                }
//
//                else if newText.contains("pending") {
//                    if report.typ == 0 {
//                        self.filteredreportsModel?.append(report)
//                    }
//                }
//
//                else if newText.contains("rejected") {
//                    if report.typ == 2 {
//                        self.filteredreportsModel?.append(report)
//                    }
//                }
              
                
                
                
            })
            
            if newText.isEmpty {
                isMatched = false
                self.noreportsView.isHidden = true
                self.reportsTable.isHidden = false
                self.toLoadData()
            }
            
            else if filteredreportsModel?.count != 0 {
                isMatched = true
                self.noreportsView.isHidden = true
                self.reportsTable.isHidden = false
                self.toLoadData()
                
            } else if filteredreportsModel?.count == 0 && !newText.isEmpty  {
                isMatched = false
                self.reportsTable.isHidden = true
                self.noreportsView.isHidden = false
            }
            dump(filteredreportsModel)
        }
        
        
    
    
    }
    

    

class DetailedReportView: BaseView {
    func containsOnlyApprovedCharacters(in userText: String, toCheckString: String) -> Bool {
        let approvedCharacters = Set(toCheckString)

        for char in userText {
            if !approvedCharacters.contains(char) {
                return false
            }
        }

        return true
    }
    var dayReportsSortView: DayReportsSortView?
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var titleLBL: UILabel!
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var sortCalenderView: UIView!
    
    @IBOutlet var sortSearchView: UIView!
    
    @IBOutlet var sortFiltersView: UIView!
    
    @IBOutlet var filterDateTF: UITextField!
    
    @IBOutlet var reportsTable: UITableView!
    
    @IBOutlet var noreportsView: UIView!
    
    @IBOutlet var noreportsLbl: UILabel!
    
    @IBOutlet var searchTF: UITextField!
    
    @IBOutlet var clearView: UIView!
    
    @IBOutlet var calendarView: UIView!
    var selectedSortIndex: Int? = nil
    
    var isSortPresented = false
    
    let cellHeight = 275
    var isMatched : Bool = false
    var reportsModel : [ReportsModel]?
    var filteredreportsModel : [ReportsModel]?
    var fromDate: Date?
    var customCalenderView: CustomCalenderView?
    var detailedreporsVC : DetailedReportVC!
    
    override func didLoad(baseVC: BaseViewController) {
     
        self.detailedreporsVC = baseVC as? DetailedReportVC
        self.setupUI()
        self.detailedreporsVC.appdefaultSetup = AppDefaults.shared.getAppSetUp()
        detailedreporsVC.toSetParamsAndGetResponse(Date())
  
    }
    
    override func willAppear(baseVC: BaseViewController) {
    
        self.detailedreporsVC = baseVC as? DetailedReportVC
    
       
       
      
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        let changePasswordViewwidth = self.bounds.width / 2.7
        let changePasswordViewheight = self.bounds.height / 1.7
        
        let changePasswordViewcenterX = self.bounds.midX - (changePasswordViewwidth / 2)
        let changePasswordViewcenterY = self.bounds.midY - (changePasswordViewheight / 2)
        
        self.dayReportsSortView?.frame = CGRect(x: changePasswordViewcenterX, y: changePasswordViewcenterY, width: changePasswordViewwidth, height: changePasswordViewheight)
        
        
        
        let checkinVIewwidth = self.bounds.width / 3
        let checkinVIewheight = self.bounds.height / 2
        
        let checkinVIewcenterX = self.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = self.bounds.midY - (checkinVIewheight / 2)

        customCalenderView?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
        
    }
    
    func cellRegistration() {
        reportsTable.register(UINib(nibName: "BasicReportsInfoTVC", bundle: nil), forCellReuseIdentifier: "BasicReportsInfoTVC")
    }
    
    func toLoadData() {
        
        reportsTable.delegate = self
        reportsTable.dataSource = self
        reportsTable.reloadData()
    }
    
    func toShowSortOptions() {
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
   
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case dayReportsSortView:
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
        
        dayReportsSortView = self.detailedreporsVC.loadCustomView(nibname: XIBs.dayReportsSortView) as? DayReportsSortView
        dayReportsSortView?.delegate = self
        dayReportsSortView?.selectedIndex = selectedSortIndex
        dayReportsSortView?.isFromDayReport = true
        dayReportsSortView?.setupUI()
    

        self.addSubview(dayReportsSortView ?? DayReportsSortView())
    }
    
    func toConfigureCellHeight() {
        
    }
    
    func initTaps() {

 
        backHolderView.addTap {
            self.detailedreporsVC.navigationController?.popViewController(animated: true)
        }
        
        clearView.addTap {
            self.toFilterResults("")
            self.searchTF.text = ""
            self.searchTF.placeholder = "Search"
        }
      
        backgroundView.addTap {
            self.hideAddedViews()
        }
        
        sortFiltersView.addTap {
            self.toShowSortOptions()
        }
        
        calendarView.addTap {
            self.calenderAction(isForFrom: true)
        }
        
//        filterDateTF.addTap {
//            <#code#>
//        }

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
        
        customCalenderView = self.detailedreporsVC.loadCustomView(nibname: XIBs.customCalenderView) as? CustomCalenderView
        customCalenderView?.setupUI(isPastDaysAllowed: true)
        customCalenderView?.today = self.fromDate ?? Date()
       // customCalenderView?.currentPage = self.fromDate ?? Date()
        customCalenderView?.isFromReports = true
        customCalenderView?.completion = self
        customCalenderView?.selectedFromDate = fromDate
        customCalenderView?.isForFrom = isForFrom

        self.addSubview(customCalenderView ?? CustomCalenderView())
        
    }
    
    

    @objc func donedatePicker(){

    guard let fromDate = self.fromDate else {return}
    filterDateTF.text = toConvertDate(date: fromDate)
     self.detailedreporsVC.toSetParamsAndGetResponse(fromDate)
     self.endEditing(true)
   }
    
    func toConvertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return  formatter.string(from: date)
       
        
    }
    
    @objc func cancelDatePicker(){
       self.endEditing(true)
     }

    
    func setupUI() {
        self.noreportsView.isHidden = true
        backgroundView.isHidden = true
        self.noreportsLbl.setFont(font: .bold(size: .BODY))
        searchTF.delegate = self
        initTaps()
       //searchTF.placeholder = UIFont(name: "Satoshi-Bold", size: 14)
        searchTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        titleLBL.setFont(font: .bold(size: .BODY))

        filterDateTF.font = UIFont(name: "Satoshi-Bold", size: 14)
     
        filterDateTF.text = toConvertDate(date: Date())
        self.fromDate = Date()
        filterDateTF.isUserInteractionEnabled = false
        toConfigureCellHeight()
        cellRegistration()
        reportsTable.separatorStyle = .none
        self.backgroundColor = .appGreyColor
        sortCalenderView.layer.borderColor = UIColor.appTextColor.cgColor
        sortCalenderView.layer.borderWidth = 0.5
        
        
        sortCalenderView.backgroundColor = .appWhiteColor
       // sortCalenderView.elevate(2)
        sortCalenderView.layer.cornerRadius = 5
        
        sortSearchView.backgroundColor = .appWhiteColor
       // sortSearchView.elevate(2)
        sortSearchView.layer.cornerRadius = 5
        
       // sortFiltersView.elevate(2)
        sortFiltersView.layer.cornerRadius = 5
        
        
        initTaps()
    }
}
extension DetailedReportView: CustomCalenderViewDelegate {
    
    
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
