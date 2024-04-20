//
//  DetailedReportView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import Foundation
import UIKit


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
            let vc = ViewDayReportVC.initWithStory(model: modal)
            
            if isTohideCheckin(modal) && isTohideCheckout(modal) {
                vc.isToReduceLocationHeight = true
            }
            
         
            self.detailedreporsVC.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = isMatched ? filteredreportsModel?[indexPath.row] ?? ReportsModel() : reportsModel?[indexPath.row] ?? ReportsModel()
        var tempCellHeight = cellHeight
        let isTohideCheckin = isTohideCheckin(model)
        let isTohideCheckout = isTohideCheckout(model)
        
        if isTohideCheckin && isTohideCheckout  {
            tempCellHeight = tempCellHeight - 80
        } else {
          // tempCellHeight += 80
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

extension DetailedReportView: SortVIewDelegate {
    
    enum SortingType {
        case orderAscending
        case orderDescending
        case orderByDate
    }
    
    func didSelected(index: Int?, isTosave: Bool) {
        selectedSortIndex = index
        isSortPresented =  isSortPresented ? false : true
        addOrRemoveSort(isSortPresented)
        switch index {
        case 0:
            toReorderRepotes(type: .orderAscending)
        case 1:
            toReorderRepotes(type: .orderDescending)
        case 2:
            toReorderRepotes(type: .orderByDate)
        case .none:
            print("none")
        case .some(_):
            print("some")
        }
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
        case .orderByDate:
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

extension DetailedReportView : UITextFieldDelegate {
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
    
    var selectedSortIndex: Int? = nil
    
    var isSortPresented = false
    
    let cellHeight = 275
    var isMatched : Bool = false
    var reportsModel : [ReportsModel]?
    var filteredreportsModel : [ReportsModel]?
    let datePicker = UIDatePicker()
    
    private lazy var sortView: SortVIew = {
        let customView = SortVIew(frame: CGRect(x: (self.width / 2) - (self.width / 3) / 2, y: (self.height / 2) - 150, width: self.width / 3, height: 300))
     
        customView.delegate = self
        return customView
    }()
    
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
    
    func cellRegistration() {
        reportsTable.register(UINib(nibName: "BasicReportsInfoTVC", bundle: nil), forCellReuseIdentifier: "BasicReportsInfoTVC")
    }
    
    func toLoadData() {
        
        reportsTable.delegate = self
        reportsTable.dataSource = self
        reportsTable.reloadData()
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
      
        
        sortFiltersView.addTap {
            self.isSortPresented =  self.isSortPresented ? false : true
            UIView.animate(withDuration: 1.0,
                           delay: 0.15,
                           usingSpringWithDamping: 2.0,
                           initialSpringVelocity: 5.0,
                           options: [.curveEaseOut],
                           animations: {

                self.addOrRemoveSort(self.isSortPresented)

                           }, completion: nil)
        }
        

    }
    func showDatePicker(){
      //Formate Date
      datePicker.datePickerMode = .date
        datePicker.tintColor = .appTextColor
   
     //ToolBar
     let toolbar = UIToolbar();
     toolbar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donedatePicker));
       doneButton.tintColor = .appTextColor
      //  let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker));
        cancelButton.tintColor = .appLightPink
        toolbar.setItems([doneButton,cancelButton], animated: true)
//spaceButton,
        filterDateTF.inputAccessoryView = toolbar
        filterDateTF.inputView = datePicker

   }
    
    @objc func donedatePicker(){

  
     filterDateTF.text = toConvertDate(date: datePicker.date)
     self.detailedreporsVC.toSetParamsAndGetResponse(datePicker.date)
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
   
    func addOrRemoveSort(_ isToAdd: Bool) {
        let views: [UIView] = [self.reportsTable, self.sortCalenderView, self.sortSearchView]
        if isToAdd {
            views.forEach { aView in
                aView.alpha = 1
                aView.isUserInteractionEnabled = true
                
                self.sortView.removeFromSuperview()
            }
        } else {
            views.forEach { aView in
                aView.alpha = 0.3
                aView.isUserInteractionEnabled = false
                self.sortView.selectedIndex = selectedSortIndex
                self.sortView.toLoadData()
                self.addSubview(self.sortView)
            }
        }
    }
    
    func setupUI() {
        self.noreportsView.isHidden = true
        self.noreportsLbl.setFont(font: .bold(size: .BODY))
        searchTF.delegate = self
        initTaps()
       //searchTF.placeholder = UIFont(name: "Satoshi-Bold", size: 14)
        searchTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        titleLBL.setFont(font: .bold(size: .BODY))
        filterDateTF.inputView = datePicker
        filterDateTF.font = UIFont(name: "Satoshi-Bold", size: 14)
     
        filterDateTF.text = toConvertDate(date: Date())
        showDatePicker()
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
