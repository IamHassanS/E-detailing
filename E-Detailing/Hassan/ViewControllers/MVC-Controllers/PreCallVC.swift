//
//  PreCallVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/04/24.
//

import Foundation
import UIKit
import CoreData

extension PreCallVC : collectionViewProtocols {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PreviewTypeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewTypeCVC", for: indexPath) as! PreviewTypeCVC
        
        
        cell.selectionView.isHidden =  selectedSegmentsIndex == indexPath.row ? false : true
        cell.titleLbl.textColor =  selectedSegmentsIndex == indexPath.row ? .appTextColor : .appLightTextColor
        cell.titleLbl.text = segmentType[indexPath.row].rawValue
        
        
        
        
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            welf.selectedSegmentsIndex  = indexPath.row
            
            welf.segmentsCollection.reloadData()
            
            
            switch welf.segmentType[welf.selectedSegmentsIndex] {
                
            case .Overview:
                
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
                
            case .Precall :
                
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
                
            case .Holidays:
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
            case .Weeklyoffs:
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
            }
            
            
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
             return CGSize(width:segmentType[indexPath.item].rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
         //   return CGSize(width: collectionView.width / 2, height: collectionView.height)
        
    }
}

extension PreCallVC: UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int) {
        switch self.segmentType[self.selectedSegmentsIndex] {
            

        case .Holidays:
            for index in holidaysSections.indices {
                if index == section {
                    let collapsed = !holidaysSections[section].collapsed
                    holidaysSections[section].collapsed = collapsed
                } else {
                    holidaysSections[index].collapsed = true
                }
            }
        case .Weeklyoffs:
            for index in weeklyoffSections.indices {
                if index == section {
                    let collapsed = !weeklyoffSections[section].collapsed
                    weeklyoffSections[section].collapsed = collapsed
                } else {
                    weeklyoffSections[index].collapsed = true
                }
            }
            
        default:
            print("Yet to")
        }
        


        

        
        // Reload the whole section
        
        var sections = IndexSet()
        sections.insert(section)
  
        self.funEventsTable.reloadData()
    }
    
    
    struct weekoffSections {
        var day: String
        var dates: [Date]
        var collapsed: Bool
    }
    
    
    struct HolidaysSections {
        var month: String
        var holidays: [HolidaysInfo]
        var collapsed: Bool
    }
    
    
    struct HolidaysInfo {
    var holidayName: String
        var holidayDate: Date
    }
    
    
    
    
    private func numberOfRowsForFunEventsTable() -> Int {
        switch segmentType[selectedSegmentsIndex] {
        case .Holidays:
            return holidaysSections.count
        case .Weeklyoffs:
            return weeklyoffDates.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == funEventsTable {
            switch segmentType[selectedSegmentsIndex] {
            case .Weeklyoffs:
                return tableView.height / 8
            default:
                return tableView.height / 8
        
            }
         
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == funEventsTable {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "outboxCollapseTVC") as? outboxCollapseTVC
            header?.backgroundVXview.backgroundColor = .appTextColor
            header?.backgroundVXview.layer.cornerRadius = 5
            header?.headerRefreshView.isHidden = true
            header?.seperatorView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
            header?.section = section
            switch segmentType[selectedSegmentsIndex] {
            case .Weeklyoffs:
                     header?.delegate = nil
                    if weeklyoffSections[section].collapsed {
                        header?.collapseIV.image = UIImage(named: "chevlon.expand")
                    } else {
                        header?.collapseIV.image = UIImage(named: "chevlon.collapse")
                    }

                    let object = weeklyoffSections[section]
                    let dateString = object.day
                    header?.dateLbl.text = dateString
                    header?.dateLbl.textColor = .appWhiteColor
                    header?.collapseIV.tintColor = .appWhiteColor
                    header?.dateLbl.setFont(font: .medium(size: .BODY))
                    header?.collapseIV.isHidden = true
                    return header
                
            case .Holidays:
                header?.delegate = self
                if holidaysSections[section].collapsed {
                    header?.collapseIV.image = UIImage(named: "chevlon.expand")
                } else {
                    header?.collapseIV.image = UIImage(named: "chevlon.collapse")
                }

            let object = holidaysSections[section]
            let dateString = object.month
            header?.dateLbl.text = dateString
            header?.dateLbl.setFont(font: .medium(size: .BODY))
                header?.dateLbl.textColor = .appWhiteColor
                header?.collapseIV.tintColor = .appWhiteColor
                header?.collapseIV.isHidden = false
                
                header?.addTap {
                    guard let header = header else {return}
                    header.delegate?.toggleSection(header, section: header.section)
                }

                return header
                
            default:
               
                return UIView()
            }
      
         

        }

            return UIView()
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch tableView  {
        case funEventsTable:
            switch segmentType[selectedSegmentsIndex] {
            case .Weeklyoffs:
                return weeklyoffSections.count
                
            default:
                return holidaysSections.count
            }
         

            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case funEventsTable:
            
            switch segmentType[selectedSegmentsIndex] {
            case .Weeklyoffs:
                if weeklyoffSections.isEmpty {
                    return  0
                } else {
                    return weeklyoffSections[section].collapsed ? 0 :  weeklyoffSections[section].dates.count
                }
            default:
                if holidaysSections.isEmpty {
                    return 0
                } else {
                    return holidaysSections[section].collapsed ? 0 :  holidaysSections[section].holidays.count
                }
              
            }
            

      
         default:
            return productStrArr.count
        }
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case funEventsTable:
            
            switch segmentType[selectedSegmentsIndex] {
                
            case .Weeklyoffs:
                let cell: FunEventsTVC = tableView.dequeueReusableCell(withIdentifier: "FunEventsTVC", for: indexPath) as! FunEventsTVC
                let date = weeklyoffSections[indexPath.section].dates[indexPath.row]
                cell.funDaysTitle.text = date.toString(format: "MMM dd, yyyy")
                cell.eventDate.isHidden = true
                cell.selectionStyle = .none
                return cell
            default:
                let cell: FunEventsTVC = tableView.dequeueReusableCell(withIdentifier: "FunEventsTVC", for: indexPath) as! FunEventsTVC
                cell.selectionStyle = .none
                let model = holidaysSections[indexPath.section].holidays[indexPath.row]
                cell.funDaysTitle.text = model.holidayName
         
              let holidayDate =  model.holidayDate
                cell.eventDate.text = holidayDate.toString(format: "MMM dd, yyyy")
                cell.eventDate.isHidden = false
                return cell
            }

        default:
            switch indexPath.row {
            case 0 :
                let cell: productSectiontitleTVC = tableView.dequeueReusableCell(withIdentifier: "productSectiontitleTVC", for: indexPath) as! productSectiontitleTVC
                
                cell.selectionStyle = .none
                return cell

            default:
                let cell: ProductsDescriptionTVC = tableView.dequeueReusableCell(withIdentifier: "ProductsDescriptionTVC", for: indexPath) as! ProductsDescriptionTVC
                let model = self.productStrArr[indexPath.row]
                cell.topopulateCell(modelStr: model, isforPreCall: true)
                cell.selectionStyle = .none
                return cell
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 10
    }
    
    
}

class PreCallVC : UIViewController {
    func getFirstDayOfCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the components (year, month, day) of the current date
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        // Create a new date using the components for the first day of the current month
        if let firstDayOfMonth = calendar.date(from: components) {
            return firstDayOfMonth
        } else {
            return nil
        }
    }
    
//    func getWeekoffDates(forMonths months: [Int], weekoffday: Int) -> [Date] {
//        let currentDate = getFirstDayOfCurrentMonth() ?? Date()
//        let calendar = Calendar.current
//        
//        var saturdays: [Date] = []
//        
//        for monthOffset in months {
//            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
//                continue
//            }
//            
//            let monthRange = calendar.range(of: .day, in: .month, for: targetDate)!
//            
//            for day in monthRange.lowerBound..<monthRange.upperBound {
//                guard let date = calendar.date(bySetting: .day, value: day, of: targetDate) else {
//                    continue
//                }
//                
//                if calendar.component(.weekday, from: date) == weekoffday { // Sunday is represented as 1, so Saturday is 7
//                    saturdays.append(date)
//                }
//            }
//        }
//        
//        return saturdays
//    }
    
    func getWeekoffDates(forMonths months: [Int], weekoffday: Int) -> [weekoffSections] {
        let currentDate = getFirstDayOfCurrentMonth() ?? Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // This will give us the full name of the weekday (e.g., "Saturday")
        
        var weekoffDates: [Date] = []
        
        for monthOffset in months {
            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
                continue
            }
            
            let monthRange = calendar.range(of: .day, in: .month, for: targetDate)!
            
            for day in monthRange.lowerBound..<monthRange.upperBound {
                guard let date = calendar.date(bySetting: .day, value: day, of: targetDate) else {
                    continue
                }
                
                if calendar.component(.weekday, from: date) == weekoffday { // Sunday is represented as 1, so Saturday is 7
                    weekoffDates.append(date)
                }
            }
        }
        
        // Group dates by weekday name
        var groupedDates: [String: [Date]] = [:]
        for date in weekoffDates {
            let weekdayName = dateFormatter.string(from: date)
            if groupedDates[weekdayName] == nil {
                groupedDates[weekdayName] = []
            }
            groupedDates[weekdayName]?.append(date)
        }
        
        // Create WeekoffSection instances
        var sections: [weekoffSections] = []
        for (day, dates) in groupedDates {
            sections.append(weekoffSections(day: day, dates: dates, collapsed: true))
        }
        
        return sections
    }
    
    func cellregistration() {
        productsTable.register(UINib(nibName: "ProductsDescriptionTVC", bundle: nil), forCellReuseIdentifier: "ProductsDescriptionTVC")
        
        productsTable.register(UINib(nibName: "productSectiontitleTVC", bundle: nil), forCellReuseIdentifier: "productSectiontitleTVC")
        
    }
    
    enum PageType {
        case Precall
        case Fundays
    }
    
    
    
    enum SegmentType : String {
        case Overview = "Overview"
        case Precall = "Pre call Analysis"
        case Holidays = "Holiday"
        case Weeklyoffs = "Weekly off"

    }
    
    func setPagetype(pageType: PageType) {
        switch pageType{
            
        case .Precall:
            funEventsHolderVIew.isHidden = true
        
            bottomHolderVIew.isHidden = false
            toretriveDCRdata()
            toLoadSegments()
            cellregistration()
            noProductsLbl.isHidden = true
            setupUI()
        case .Fundays:
            bottomHolderVIew.isHidden = true
            funEventsHolderVIew.isHidden = false
            self.pagetitle.text = "Holiday / Weekly off"
            toLoadSegmentsforFundays()
            toSyncFundays()
            setupUIforFunEvents()
           
            cellregistrationForFunEvents()
        }
    }
    
    func toModifyDate(date: Date, isForHoliday: Bool? = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (isForHoliday ?? false) ? "yyyy-MM-dd" : "d MMMM yyyy"
        return dateFormatter.string(from: date )
    }
    
    func toSyncFundays() {
        
        var weeklyOffDates = [String]()
        var holidays : [Holidays]?
        var holidayDates = [Date]()
        var weeklyOffRawDates = [Date]()
        var responseHolidaydates = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var holidaysArr: [HolidaysInfo] = []
        holidayDates.removeAll()
        
        let weeklyoffSetupArr = DBManager.shared.getWeeklyOff()
        if !weeklyoffSetupArr.isEmpty {
            weeklyOff = weeklyoffSetupArr[0]
        }
        
        let holidaysSetupArr = DBManager.shared.getHolidays()
        if !holidaysSetupArr.isEmpty {
            holidays = holidaysSetupArr
        }
        
        holidays?.forEach({ aholiday in
            responseHolidaydates.append(aholiday.holiday_Date ?? "")
               let aHolidayDateStr = aholiday.holiday_Date ?? ""
               let aHolidayDate = aHolidayDateStr.toDate(format: "yyyy-MM-dd")
                let aHoliday = HolidaysInfo(holidayName: aholiday.holiday_Name ?? "", holidayDate: aHolidayDate)
                
                holidaysArr.append(aHoliday)
        })
        

        
        var groupedHolidays: [String: [HolidaysInfo]] = [:]
        dateFormatter.dateFormat = "MMMM" // Month format (e.g., January, February)

        for holiday in holidaysArr {
            let monthName = dateFormatter.string(from: holiday.holidayDate)
            if groupedHolidays[monthName] == nil {
                groupedHolidays[monthName] = []
            }
            groupedHolidays[monthName]?.append(holiday)
        }
        
        
        // Step 2: Create HolidaysSections Instances
        var holidaysSections: [HolidaysSections] = []
        for (month, holidays) in groupedHolidays {
            let section = HolidaysSections(month: month, holidays: holidays, collapsed: true)
            holidaysSections.append(section)
        }
    
        
        // Step 3: Sort HolidaysSections by Month Using Numeric Month Values
        let numericMonthFormatter = DateFormatter()
        numericMonthFormatter.dateFormat = "MM"

        holidaysSections.sort { lhs, rhs in
            let lhsMonthNumber = numericMonthFormatter.date(from: lhs.month) ?? Date()
            let rhsMonthNumber = numericMonthFormatter.date(from: rhs.month) ?? Date()
            return lhsMonthNumber < rhsMonthNumber
        }

        // Now holidaysSections contains the grouped and sorted holidays by month
        for section in holidaysSections {
            print("Month: \(section.month)")
            for holiday in section.holidays {
                print(" - \(holiday.holidayName) on \(holiday.holidayDate)")
            }
        }
        
       self.holidaysSections = holidaysSections
        
       let weekoffIndex = Int(weeklyOff?.holiday_Mode ?? "0") ?? 0
       let monthIndex =  [0, 1]
        let weekoffDates = getWeekoffDates(forMonths: monthIndex, weekoffday: weekoffIndex + 1)
        dump(weekoffDates)
        self.weeklyoffSections = weekoffDates
        toLoadFunEventsTable()
    }
    

    
    
    func cellregistrationForFunEvents() {
        funEventsTable.layer.cornerRadius = 5
       // funEventsCollection
        funEventsTable.register(UINib(nibName: "FunEventsTVC", bundle: nil), forCellReuseIdentifier: "FunEventsTVC")
        
        self.funEventsTable.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "outboxCollapseTVC")
    }
    
    func toLoadFunEventsTable() {
        funEventsTable.delegate = self
        funEventsTable.dataSource = self
        funEventsTable.reloadData()
    }
    
    func setupUIforFunEvents() {
        funEventsTable.separatorStyle = .none
        funEventsHolderVIew.layer.cornerRadius = 5
    }
    
    class func initWithStory(pageType: PageType) -> PreCallVC {
        let preCallVC : PreCallVC = UIStoryboard.activity.instantiateViewController()
        preCallVC.pagetype = pageType
        return preCallVC
    }
    
    func setSegment(_ segmentType: SegmentType, isfromSwipe: Bool? = false) {
        switch segmentType {
            
        case .Overview:
            self.selectedSegmentsIndex = 0
            self.segmentsCollection.reloadData()
            self.overVIewVIew.isHidden = false
            self.preCallVIew.isHidden = true
            
        case .Precall:
            self.selectedSegmentsIndex = 1
            self.segmentsCollection.reloadData()
            self.overVIewVIew.isHidden = true
            self.preCallVIew.isHidden = false
            if !self.isDatafetched {
                fetchPrecall()
            }
            
        case .Holidays:
       
            toLoadFunEventsTable()
        case .Weeklyoffs:
            toLoadFunEventsTable()
        }
    }
    
    func toLoadSegmentsforFundays() {
        segmentsCollection.isScrollEnabled = false
        segmentType = [.Holidays , .Weeklyoffs]
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
        segmentsCollection.delegate = self
        segmentsCollection.dataSource = self
        segmentsCollection.reloadData()
        self.setSegment(.Overview)
    }
    
    func toLoadSegments() {
        segmentsCollection.isScrollEnabled = false
        segmentType = [.Overview , .Precall]
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
        segmentsCollection.delegate = self
        segmentsCollection.dataSource = self
        segmentsCollection.reloadData()
        self.setSegment(.Overview)
    }
    @IBOutlet var funEventsHolderVIew: UIView!
    
    @IBOutlet var preCallVIew: UIView!
    @IBOutlet weak var viewSegmentControl: UIView!
    
    @IBOutlet var segmentsCollection: UICollectionView!
    
    @IBOutlet var bottomHolderVIew: UIView!
    @IBOutlet var overVIewVIew: ShadowView!
    
    @IBOutlet var preCallsHolderVIew: UIView!
    @IBOutlet var nameTitleLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var dobTit: UILabel!
    
    @IBOutlet var funEventsTable: UITableView!
    
    @IBOutlet var dobLbl: UILabel!
    
    
    @IBOutlet var weddingDateTit: UILabel!
    
    
    @IBOutlet var weddingDateLbl: UILabel!
    
    @IBOutlet var mobileTit: UILabel!
    
    
    @IBOutlet var mobileLbl: UILabel!
    
    
    
    @IBOutlet var emailTit: UILabel!
    
    @IBOutlet var emailLbl: UILabel!
    
    
    @IBOutlet var addressTit: UILabel!
    
    @IBOutlet var addressLbl: UILabel!
    
    
    @IBOutlet var qualificationtit: UILabel!
    
    
    @IBOutlet var qualificationLBl: UILabel!
    
    
    
    @IBOutlet var categoryTit: UILabel!
    
    
    @IBOutlet var btnSkip: UIButton!
    
    
    @IBOutlet var btnStartdetailing: UIButton!
    
    
    @IBOutlet var categoryLbl: UILabel!
    
    
    @IBOutlet var specialityLbl: UILabel!
    
    @IBOutlet var specialityTit: UILabel!
    
    
    @IBOutlet var territoryTit: UILabel!
    
    
    @IBOutlet var territoryLbl: UILabel!
    
    
    @IBOutlet var pagetitle: UILabel!
    
    
    @IBOutlet var precallLastVIsitLbl: UILabel!
    
    @IBOutlet var precallFeedbackLbl: UILabel!
    
    @IBOutlet var precallRemarksLbl: UILabel!
    
    @IBOutlet var precallInputsLbl: UILabel!
    
    @IBOutlet var noProductsLbl: UILabel!
 
    var callresponse: [PrecallsModel]?
    @IBOutlet var productsTable: UITableView!
    var pagetype: PageType = .Precall
    var isDatafetched: Bool = false
    var userStatisticsVM: UserStatisticsVM?
    var productStrArr : [SampleProduct] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  weeklyOff : Weeklyoff?
    var  holidays : [Holidays]?
    var weeklyoffSections : [weekoffSections] = []
    var holidaysSections : [HolidaysSections] = []
    var weeklyoffDates = [Date]()
    func toloadProductsTable() {
        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.reloadData()
    }
    

    
    func toretriveDCRdata() {
        
        var dcrObject : AnyObject?
        
        switch dcrCall.type {
            
        case .doctor:
            if let  tempdcrObject = dcrCall.call as? DoctorFencing {
                dcrObject = tempdcrObject
            }
        case .chemist:
            if let  tempdcrObject = dcrCall.call as? Chemist {
                dcrObject = tempdcrObject
            }
        case .stockist:
            if let  tempdcrObject = dcrCall.call as? Stockist {
                dcrObject = tempdcrObject
            }
        case .unlistedDoctor:
            if let  tempdcrObject = dcrCall.call as? UnListedDoctor {
                dcrObject = tempdcrObject
            }
        case .hospital:
            print("Yet yo implement")
        case .cip:
            print("Yet yo implement")
        }
        
        
        self.dcrCall = dcrCall.toRetriveDCRdata(dcrcall: dcrObject ?? nil)
        
        
        topopulateVIew(dcrCall: self.dcrCall)
        
    }
    
    
    func topopulateVIew(dcrCall : CallViewModel) {
      
        switch  dcrCall.type {
            
           
        case .doctor:
            pagetitle.text = dcrCall.name == "" ? "DCR details" :  dcrCall.name
            nameLbl.text = dcrCall.name == "" ? "-" :  dcrCall.name
            dobLbl.text =  dcrCall.dob == "" ? "-" :  dcrCall.dob
            weddingDateLbl.text =  dcrCall.dow == "" ? "-" :  dcrCall.dob
            mobileLbl.text = dcrCall.mobile == "" ? "-" :  dcrCall.mobile
            emailLbl.text = dcrCall.email == "" ? "-" :  dcrCall.email
            addressLbl.text = dcrCall.address == "" ? "-" :  dcrCall.address
            qualificationLBl.text = dcrCall.qualification == "" ? "-" :  dcrCall.qualification
            categoryLbl.text = dcrCall.category == "" ? "-" :  dcrCall.category
            territoryLbl.text = dcrCall.territory == "" ? "-" :  dcrCall.territory
            
        case .chemist:
            pagetitle.text = dcrCall.name == "" ? "DCR details" :  dcrCall.name
            nameLbl.text = dcrCall.name == "" ? "-" :  dcrCall.name
            dobLbl.text =  dcrCall.dob == "" ? "-" :  dcrCall.dob
            weddingDateLbl.text = dcrCall.dow == "" ? "-" :  dcrCall.dob
            mobileLbl.text = dcrCall.mobile == "" ? "-" :  dcrCall.mobile
            emailLbl.text = dcrCall.email == "" ? "-" :  dcrCall.email
            addressLbl.text = dcrCall.address == "" ? "-" :  dcrCall.address
            qualificationLBl.text = dcrCall.qualification == "" ? "-" :  dcrCall.qualification
            categoryLbl.text = dcrCall.category == "" ? "-" :  dcrCall.category
            territoryLbl.text = dcrCall.territory == "" ? "-" :  dcrCall.territory
        case .stockist:
            pagetitle.text = dcrCall.name == "" ? "DCR details" :  dcrCall.name
            nameLbl.text = dcrCall.name == "" ? "-" :  dcrCall.name
            dobLbl.text =  dcrCall.dob == "" ? "-" :  dcrCall.dob
            weddingDateLbl.text = dcrCall.dow == "" ? "-" :  dcrCall.dob
            mobileLbl.text = dcrCall.mobile == "" ? "-" :  dcrCall.mobile
            emailLbl.text = dcrCall.email == "" ? "-" :  dcrCall.email
            addressLbl.text = dcrCall.address == "" ? "-" :  dcrCall.address
            qualificationLBl.text = dcrCall.qualification == "" ? "-" :  dcrCall.qualification
            categoryLbl.text = dcrCall.category == "" ? "-" :  dcrCall.category
            territoryLbl.text = dcrCall.territory == "" ? "-" :  dcrCall.territory
        case .unlistedDoctor:
            pagetitle.text = dcrCall.name == "" ? "DCR details" :  dcrCall.name
            nameLbl.text = dcrCall.name == "" ? "-" :  dcrCall.name
            dobLbl.text = dcrCall.dob == "" ? "-" :  dcrCall.dob
            weddingDateLbl.text = dcrCall.dow == "" ? "-" :  dcrCall.dob
            mobileLbl.text = dcrCall.mobile == "" ? "-" :  dcrCall.mobile
            emailLbl.text = dcrCall.email == "" ? "-" :  dcrCall.email
            addressLbl.text = dcrCall.address == "" ? "-" :  dcrCall.address
            qualificationLBl.text = dcrCall.qualification == "" ? "-" :  dcrCall.qualification
            categoryLbl.text = dcrCall.category == "" ? "-" :  dcrCall.category
            territoryLbl.text = dcrCall.territory == "" ? "-" :  dcrCall.territory
        case .hospital:
            print("Yet to implement")
        case .cip:
            print("Yet to implement")
        }
    }
    
    
    var segmentType: [SegmentType] = []
    private var segmentControl : UISegmentedControl!
    var selectedSegmentsIndex: Int = 0
    var dcrCall : CallViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPagetype(pageType: self.pagetype)
       //updateSegment()

    }
    
    func setupUI() {
        
        btnSkip.layer.cornerRadius = 5
        btnSkip.layer.borderWidth = 1
        btnSkip.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnSkip.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        
        
        btnStartdetailing.layer.cornerRadius = 5
        btnStartdetailing.backgroundColor = .appTextColor

    }

    
    @IBAction func skipDetailingAction(_ sender: Any) {
        
   
        
        let vc = AddCallinfoVC.initWithStory(viewmodel: self.userStatisticsVM ?? UserStatisticsVM())
        vc.dcrCall = self.dcrCall
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func toRetriveRCPAfromCDentity(rcpaEntity: RCPAdetailsCDEntity) {
//        
//        RCPAdetailsCDEntity.
//        
//        
//    }
    
    @IBAction func startDetailingAction(_ sender: UIButton) {
        
        let vc = PreviewHomeVC.initWithStory(previewType: .detailing, dcrCall: self.dcrCall)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupPrecallsinfo() {
        
    }
    
    func fetchPrecall() {
        //getTodayCalls
        
       // {"tableName":"getcuslvst","typ":"D","CusCode":"1679478","sfcode":"MR5940","division_code":"63,","Rsf":"MR5940","sf_type":"1","Designation":"MR","state_code":"2","subdivision_code":"86,"}
        self.userStatisticsVM = UserStatisticsVM()
        
        let setup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getcuslvst"
        param["CusCode"] = self.dcrCall.code

        param["typ"] = "D"
        param["sfcode"] =  setup.sfCode

        param["division_code"] =  setup.divisionCode
 
        param["Rsf"] =   LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
  
        param["sf_type"] =  setup.sfType

        param["Designation"] = setup.desig
 
        param["state_code"] =  setup.stateCode
  
        param["subdivision_code"] = "\(setup.subDivisionCode!),"

        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        userStatisticsVM?.getPrecalls(params: toSendData, api: .getTodayCalls, paramData: param) {  result in
            
            switch result {
                
            case .success(let response):
                dump(response)
                self.callresponse = response
                self.toPopulateView()
                self.isDatafetched = true
            case .failure(let error):
                dump(error.localizedDescription)
            }
        }
    }
    
    func toPopulateView() {
        
        guard let callresponse = self.callresponse?.first else {return}
        
      let cleanedResponse = callresponse.inputs == "( 0 )," ? "No inputs" : callresponse.inputs
        
        self.precallInputsLbl.text = cleanedResponse
        self.precallRemarksLbl.text = callresponse.remarks.isEmpty ? "No remarks" : callresponse.remarks
        self.precallFeedbackLbl.text = callresponse.feedback.isEmpty ? "No feedback" : callresponse.feedback
      
        let rawDate = callresponse.visitDate.date.toDate(format: "yyyy-MM-dd HH:mm:ss")
        self.precallLastVIsitLbl.text = rawDate.toString(format:  "yyyy-MM-dd HH:mm:ss")
        
        toSetDataSourceForProducts(detailedReportModel: callresponse)
    }
    
    
    func toSetDataSourceForProducts(detailedReportModel: PrecallsModel?) {
        productStrArr.removeAll()
        productStrArr.append(SampleProduct(prodName: "", isPromoted: false, noOfSamples: "", rxQTY: "", rcpa: "", isDemoProductCell: true, remarks: "No remarks found."))
        
       if detailedReportModel?.sampleProduct != "" {
           var prodArr =  detailedReportModel?.sampleProduct.components(separatedBy: ",")
           if prodArr?.last == "" {
               prodArr?.removeLast()
           }
           let filteredComponents = prodArr?.map { anElement -> String in
               var modifiedElement = anElement
               if modifiedElement.first == " " {
                   modifiedElement.removeFirst()
               }
               return modifiedElement
           }
           
           
           filteredComponents?.forEach { prod in
               var prodString : [String] = []
               prodString.append(contentsOf: prod.components(separatedBy: "("))
               prodString = prodString.map({ aprod in
                   aprod.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
               })
               var name: String = ""
               let isPromoted: Bool = false
               var noOfsamples: String = ""
               var rxQty: String = ""
               var rcpa: String  = ""
               prodString.enumerated().forEach {prodindex, prod in
                   
                   // let sampleProduct: SampleProduct
                   switch prodindex {
                   case 0 :
                       name = prod
                   case 1:
                       noOfsamples = prod
                   case 2:
                       rxQty = prod
                   case 3:
                       if let index = prod.firstIndex(of: "^") {
                           let startIndex = prod.index(after: index)
                           let numberString = String(prod[startIndex...])
                           rcpa = numberString
                           print(numberString) // This will print "5"
                       } else {
                           print("'^' not found in the expression.")
                           rcpa = "-"
                       }
                       
                       
                   default:
                       print("default")
                   }
               }
               
               let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false, remarks: detailedReportModel?.remarks ?? "")
               productStrArr.append(aProduct)
           }
           
           
       } else {
           productStrArr.append(SampleProduct(prodName: "-", isPromoted: false, noOfSamples: "-", rxQTY: "-", rcpa: "-", isDemoProductCell: true, remarks: "No remarks found"))
       }

        
        //productStrArr.append(contentsOf: detailedReportModel?.products.components(separatedBy: ",") ?? [])
  
        
        toloadProductsTable()
         
    }
    

    
}




extension PreCallVC:  PreviewHomeViewDelegate {
    func didUserDetailedSlide() {
        self.skipDetailingAction(self.btnSkip!)
    }
    
    
}
