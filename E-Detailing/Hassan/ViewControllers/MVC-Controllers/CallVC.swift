//
//  CallVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/04/24.
//

import UIKit
import CoreData


enum DCRType : Int {
    
    case doctor = 0
    case chemist = 1
    case stockist = 2
    case unlistedDoctor = 3
    case hospital = 4
    case cip = 5
    
    
    
    var productNeed : Int {
        let appSetup = AppDefaults.shared.getAppSetUp()
        switch self {
            case .doctor:
                return appSetup.dpNeed ?? 0
            case .chemist:
                return appSetup.cpNeed ?? 0
            case .stockist:
                return appSetup.spNeed ?? 0
            case .unlistedDoctor:
                return appSetup.npNeed ?? 0
            case .hospital:
                return 1
            case .cip:
                return appSetup.cipPNeed ?? 0
        }
    }
    
    var inputNeed : Int {
        let appSetup = AppDefaults.shared.getAppSetUp()
        switch self {
        case .doctor:
            return appSetup.diNeed ?? 0
        case .chemist:
            return appSetup.ciNeed ?? 0
        case .stockist:
            return appSetup.siNeed ?? 0
        case .unlistedDoctor:
            return appSetup.niNeed ?? 0
        case .hospital:
            return 1
        case .cip:
            return appSetup.cipINeed ?? 0
        }
    }
 
}


extension CallVC: DCRfiltersViewDelegate {
    func isFiltersupdated(_ addedFiltercount: Int, isItemAdded: Bool) {
        print(addedFiltercount)
        if addedFiltercount % 2 != 0 && isItemAdded {
            addedDCRVIewHeight =  60 + 130 + 70 + 70
            //addedDCRVIewHeight + 70
            
           
            
        } else if addedFiltercount % 2 == 0 && !isItemAdded {
            addedDCRVIewHeight =   60 + 130 + 70
            
            //addedDCRVIewHeight - 70
        } else  if addedFiltercount % 2 != 0 && !isItemAdded {
           
        }

      
        self.viewDidLayoutSubviews()
        
    }
    
    
}

struct FilteredCase {
    let specialityCode: Speciality?
    let categoryCode: DoctorCategory?
    let territoryCode: Territory?
    let classCode: DoctorClass?
    let chemistCategotyCode: ChemistCategory?
}

extension CallVC : addedSubViewsDelegate {
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    

    
    
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        if !filteredObjects.isEmpty {
            addedFiltersCount.isHidden = false
            filterCountHolderVIew.isHidden = false
           // addedFiltersCount.text = "\(filteredObjects.count)"
        } else {
            addedFiltersCount.isHidden = true
            filterCountHolderVIew.isHidden = true
        }
     
        if filteredObjects.isEmpty {
            self.filterscase = nil
            self.callCollectionView.reloadData()
            self.didClose()
            return
        }
        
        var specialitycode: Speciality?
        var catcode: DoctorCategory?
        var chemistCatCode : ChemistCategory?
        var territoryCode: Territory?
        var classCode: DoctorClass?
        filteredObjects.forEach { anObject in
            switch anObject {
            case let territoryObj as Territory:
               
                territoryCode = territoryObj
                
            case let catObj as DoctorCategory:
              
                catcode = catObj
                
            case let specialityObj as Speciality:
            
                specialitycode = specialityObj
                
            case let classObj as DoctorClass:
                
                classCode = classObj
                
            case let chemistCatObj as ChemistCategory:
                chemistCatCode = chemistCatObj
            default:
               print("object uncategorized")
            }
        }
        
        
        self.filterscase = FilteredCase(specialityCode: specialitycode, categoryCode: catcode, territoryCode: territoryCode, classCode: classCode, chemistCategotyCode: chemistCatCode)

        self.callCollectionView.reloadData()
        self.didClose()
    }
    
    func showAlert(desc: String) {
        print("Yet to implement")
        showAlertToEnableLocation(desc: desc)
    }
    
    
    
    func showAlertForCallExistence(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok" )

        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("yes action")
        }

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

    func didClose() {
       backgroundView.isHidden = true
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case dcrfiltersView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
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
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {
            case dcrfiltersView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                guard let callViewModel = self.selectedDCRcall else {return}
                
                self.navigateToPrecallVC(dcrCall: callViewModel, index: self.selectedDCRIndex ?? 0)
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    
}


class CallVC : UIViewController {
    
    @IBOutlet var seatchHolderVIew: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet var resoureHQlbl: UILabel!
    @IBOutlet weak var callCollectionView: UICollectionView!
    
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    @IBOutlet weak var viewSegmentControl: UIView!
    
    @IBOutlet var filtersBtn: UIButton!
    
    @IBOutlet var addedFiltersCount: UILabel!
    
    @IBOutlet var filterCountHolderVIew: UIView!
    
    @IBOutlet var  backgroundView : UIView!

    
    @IBOutlet var  backGroundVXview : UIView!
    
    var selectedTerritories = [Territory]()
    var clusterCodes: [String] = []
    private var dcrSegmentControl : UISegmentedControl!
    private var callListViewModel : CallListViewModel!
    
    var dcrActivityType = [DcrActivityType]()
    
    var searchText : String = ""
    var dcrfiltersView:  DCRfiltersView?
    private var CallListArray = CallListViewModel()
    var selectedDCRcall: CallViewModel?
    var addedDCRVIewHeight: CGFloat = 60 + 130 + 70
    
    var type : DCRType = .doctor
    var selectedDCRIndex: Int? = nil
    var filterscase: FilteredCase?
    var checkinVIew: CustomerCheckinView?
    @IBAction func didTapFiltersBtn(_ sender: UIButton) {
        filtersAction()
    }
    
    
    func setHQlbl() {
        // let appsetup = AppDefaults.shared.getAppSetUp()
            CoreDataManager.shared.toRetriveSavedDayPlanHQ { hqModelArr in
                let savedEntity = hqModelArr.first
                guard let savedEntity = savedEntity else{
                    
                    self.resoureHQlbl.text = "Select HQ"
                    
                    return
                    
                }
                
                self.resoureHQlbl.text = savedEntity.name == "" ? "Select HQ" : savedEntity.name
                
                let subordinates = DBManager.shared.getSubordinate()
                
                let asubordinate = subordinates.filter{$0.id == savedEntity.code}
                
                if !asubordinate.isEmpty {
                 //  self.fetchedHQObject = asubordinate.first
                    LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text:  asubordinate.first?.id ?? "")
                    self.toloadCallsCollection()
                }
            
              
  
 
                
            }
            // Retrieve Data from local storage
               return
        

       
    }

    func setupUI() {
        self.clusterCodes = self.selectedTerritories.compactMap{ $0.code }
        filterCountHolderVIew.backgroundColor = .appGreen
        addedFiltersCount.isHidden = true
        filterCountHolderVIew.isHidden = true
        filterCountHolderVIew.layer.cornerRadius =  25 / 2
        addedFiltersCount.layer.cornerRadius = 25 / 2
        callCollectionView.layer.cornerRadius = 5
        seatchHolderVIew.layer.cornerRadius = 5
        seatchHolderVIew.layer.borderWidth = 1
        seatchHolderVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        backgroundView.isHidden = true
        setHQlbl()
        self.backgroundView.addTap {
            self.didClose()
        }
        
        txtSearch.placeholder = "Search \(LocalStorage.shared.getString(key: .doctor))"
        

    }
    
    func toloadCallsCollection() {
        callCollectionView.delegate = self
        callCollectionView.dataSource = self
        callCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
      //  addedDCRVIewHeight = 60 + 130 + 70
  
        switch self.type {
            
        case .doctor:
            if let filterscase = filterscase {
                if let _ =   filterscase.territoryCode  {
                    addedDCRVIewHeight =  60 + 130 + 60 + 70
                   
                }
                
                if let _ =   filterscase.classCode  {
                    addedDCRVIewHeight =  60 + 130 + 60 + 70
                 
                }
            }
        case .chemist:
            addedDCRVIewHeight =  60 + 80 + 60 + 70
        case .stockist:
            addedDCRVIewHeight =  60 + 80 + 60 + 70
        case .unlistedDoctor:
            if let filterscase = filterscase {
                if let _ =   filterscase.territoryCode  {
                    addedDCRVIewHeight =  60 + 130 + 60 + 70
                   
                }
                if let _ =   filterscase.classCode  {
                    addedDCRVIewHeight =  60 + 130 + 60 + 70
                 
                }
            }
        case .hospital:
            print("Yet to")
        case .cip:
            print("Yet to")
        }

        
        
        
        let  tpDeviateVIewwidth = view.bounds.width / 1.7
        let  tpDeviateVIewheight = addedDCRVIewHeight
        
        
        
        let  tpDeviateVIewcenterX = view.bounds.midX - (tpDeviateVIewwidth / 2)
        let tpDeviateVIewcenterY = view.bounds.midY - (tpDeviateVIewheight / 2)
        
        
        dcrfiltersView?.frame = CGRect(x: tpDeviateVIewcenterX, y: tpDeviateVIewcenterY, width: tpDeviateVIewwidth, height: tpDeviateVIewheight)
        
        
        let checkinVIewwidth = view.bounds.width / 3
        let checkinVIewheight = view.bounds.height / 2
        
        let checkinVIewcenterX = view.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = view.bounds.midY - (checkinVIewheight / 2)
        
        
        checkinVIew?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.callCollectionView.register(UINib(nibName: "DoctorCallCell", bundle: nil), forCellWithReuseIdentifier: "DoctorCallCell")
        
        let layout = UICollectionViewFlowLayout()
        
        self.callCollectionView.collectionViewLayout = layout
        
        let headerLayout = UICollectionViewFlowLayout()
        headerLayout.scrollDirection = .horizontal
        self.headerCollectionView.collectionViewLayout = headerLayout
        
       // self.txtSearch.setIcon(UIImage(imageLiteralResourceName: "searchIcon"))
        
        self.txtSearch.addTarget(self, action: #selector(searchFilterAction(_:)), for: .editingChanged)
        
        
        updateDcrList()
       
        self.type = .doctor
        
        initGestures()
    }
    
    
    func initGestures() {

        self.callCollectionView.addAction(for: .swipe_left)  {
            let index =   self.CallListArray.dcrActivityList.firstIndex { $0.type.rawValue ==  self.type.rawValue }
            let dcrActivityListCount = self.CallListArray.numberofDcrs()
            guard let index = index, index < dcrActivityListCount - 1 else {
                return
            }
            self.type = self.CallListArray.fetchAtIndex(index + 1).type
            self.addedFiltersCount.isHidden = true
            self.filterCountHolderVIew.isHidden = true
            self.filterscase = nil
            self.headerCollectionView.reloadData()
            self.callCollectionView.reloadData()
        }
        
        self.callCollectionView.addAction(for: .swipe_right)  {
            let index =   self.CallListArray.dcrActivityList.firstIndex { $0.type.rawValue ==  self.type.rawValue }
            guard let index = index, index - 1 >= 0 else {
                return
            }
            self.type = self.CallListArray.fetchAtIndex(index - 1).type
            self.addedFiltersCount.isHidden = true
            self.filterCountHolderVIew.isHidden = true
            self.filterscase = nil
            self.headerCollectionView.reloadData()
            self.callCollectionView.reloadData()
        }
    }
    
    func checkinAction(dcrCall : CallViewModel) {
        
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
          
            guard let welf = self else {return}
            
            if geoFencingEnabled {
                guard coordinates != nil else {
                    welf.showAlert(desc: "Please enable location services in Settings.")
                    return
                }
            }
//            guard let coordinates = coordinates else {
//                welf.showAlert(desc: "Please enable location services in Settings.")
//                return
//            }
            Shared.instance.showLoaderInWindow()
            Pipelines.shared.getAddressString(latitude: coordinates?.latitude ?? Double(), longitude:  coordinates?.longitude ?? Double()) { [weak self] address in
                Shared.instance.removeLoaderInWindow()
                guard let welf = self else {return}
   
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let currentDate = Date()
                let dateString = dateFormatter.string(from: currentDate)
                
                let datestr = dateString
                
                ///time
                dateFormatter.dateFormat = "HH:mm:ss"
                
                let timeString = dateFormatter.string(from: currentDate)
                
                _ = (timeString)
                dcrCall.customerCheckinAddress = address ?? ""
                dcrCall.checkinlatitude = coordinates?.latitude ?? Double()
                dcrCall.checkinlongitude = coordinates?.longitude ?? Double()
                dcrCall.dcrCheckinTime = datestr
                welf.checkinDetailsAction(dcrCall : dcrCall)
                
                
                
            }
            
            
            
        }
    }
    
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
    

    
    func navigateToPrecallVC(dcrCall: CallViewModel, index: Int) {
        let precallvc = PreCallVC.initWithStory(pageType: .Precall)
        precallvc.dcrCall = self.CallListArray.fetchDataAtIndex(index: index, type: self.type,searchText: self.searchText, isFiltered: self.filterscase == nil ? false : true, filterscase: self.filterscase ?? nil, clusterCodes: self.clusterCodes)
        self.navigationController?.pushViewController(precallvc, animated: true)
    }
    
    func checkinDetailsAction(dcrCall : CallViewModel) {
        self.selectedDCRcall = dcrCall
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                
//            case checkinDetailsView:
//                aAddedView.removeFromSuperview()
//                aAddedView.isUserInteractionEnabled = true
//                aAddedView.alpha = 1
//
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
              
            default:
                print("Yet to implement")
          
                
                aAddedView.isUserInteractionEnabled = false
              
                
            }
            
        }
        
        checkinVIew = self.loadCustomView(nibname: XIBs.customerCheckinVIew) as? CustomerCheckinView
        checkinVIew?.delegate = self
        checkinVIew?.dcrCall = dcrCall
        checkinVIew?.setupUI()
        //checkinVIew?.userstrtisticsVM = self.userststisticsVM
        //checkinVIew?.appsetup = self.appSetups

        
        
        self.view.addSubview(checkinVIew ?? CustomerCheckinView())
        
    }
    
    
 
    
    
    func filtersAction() {
       backgroundView.isHidden = false
       backGroundVXview.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case dcrfiltersView:
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
       
        dcrfiltersView = self.loadCustomView(nibname: XIBs.dcrfiltersView) as? DCRfiltersView
        dcrfiltersView?.delegate = self
        dcrfiltersView?.selectedcategoty = self.filterscase?.categoryCode
        dcrfiltersView?.selectedterritory = self.filterscase?.territoryCode
        dcrfiltersView?.selectedspeciality = self.filterscase?.specialityCode
        dcrfiltersView?.selecteddocClass = self.filterscase?.classCode
        dcrfiltersView?.selectedChemistCategory = self.filterscase?.chemistCategotyCode
        dcrfiltersView?.addedSubviewDelegate = self
        dcrfiltersView?.type = self.type
        dcrfiltersView?.rootVC = self
        dcrfiltersView?.setupUI()
        view.addSubview(dcrfiltersView ?? DCRfiltersView())
    }
    
    
    @objc func searchFilterAction (_ sender : UITextField) {
        print(sender.text!)
        self.searchText = sender.text ?? ""
        self.callCollectionView.reloadData()
    }
    
    
    private func updateDcrList (){
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.docCap ?? "", type: .doctor)))
        
        if appsetup.chmNeed == 0 {
            self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.chmCap ?? "", type: .chemist)))
        }
        
        if appsetup.stkNeed == 0 {
            self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.stkCap ?? "", type: .stockist)))
        }
        
        if appsetup.unlNeed == 0 {
            self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.nlCap ?? "", type: .unlistedDoctor)))
        }
        
        if appsetup.hospNeed == 0 {
            self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.hospCaption ?? "", type: .hospital)))
        }
        
        if appsetup.cipNeed == 0 {
            self.CallListArray.addDcrActivity(DcrActivityViewModel(activityType: DcrActivityType(name: appsetup.cipCaption ?? "", type: .cip)))
        }
        
    }
    
    private func updateSegment() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var dcrList = [String]()
        
            dcrList.append("Listed Doctor")
        
            if appsetup.chmNeed == 0 {
                dcrList.append("Chemist")
            }
            if appsetup.stkNeed == 0 {
                dcrList.append("Stockist")
            }
            if appsetup.unlNeed == 0 {
                dcrList.append("Unlisted Doctor")
            }
            if appsetup.hospNeed == 0 {
                dcrList.append("Hospital")
            }
            if appsetup.cipNeed == 0 {
                dcrList.append("CIP")
            }
        
        dcrList.append("Hospital")
        dcrList.append("CIP")



        
    }

    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CallVC : collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            case self.callCollectionView:
            switch self.type {
            case .doctor:
                if let filterscase = self.filterscase   {
                    let objCount: Int = self.CallListArray.filteredDCRrows(self.type, searchText: searchText, filterscase: filterscase)
                    addedFiltersCount.text = "\(objCount)"
                    return objCount
                   
                } else {
                    return self.CallListArray.numberofDoctorsRows(self.type,searchText: self.searchText)
                }
            case .chemist:
                if let filterscase = self.filterscase   {
                    let objCount: Int =  self.CallListArray.filteredChemistRows(self.type, searchText: searchText, filterscase: filterscase)
                    
                    addedFiltersCount.text = "\(objCount)"
                    return objCount
                } else {
                    return self.CallListArray.numberofDoctorsRows(self.type,searchText: self.searchText)
                }
            case .stockist:
                if let filterscase = self.filterscase   {
                    let objCount: Int = self.CallListArray.filteredStockistRows(self.type, searchText: searchText, filterscase: filterscase)
                    addedFiltersCount.text = "\(objCount)"
                    return objCount
                } else {
                    return self.CallListArray.numberofDoctorsRows(self.type,searchText: self.searchText)
                }
            case  .unlistedDoctor:
                if let filterscase = self.filterscase   {
                    let objCount: Int = self.CallListArray.filteredUnlistedDocrows(self.type, searchText: searchText, filterscase: filterscase)
                    addedFiltersCount.text = "\(objCount)"
                    return objCount
                } else {
                    return self.CallListArray.numberofDoctorsRows(self.type,searchText: self.searchText)
                }
                
            default:
                return 0
            }

              
            case self.headerCollectionView:
                return self.CallListArray.numberofDcrs()
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            case self.callCollectionView :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorCallCell", for: indexPath) as! DoctorCallCell
           // cell.selectedTerritories = self.selectedTerritories
            cell.CallDetail = self.CallListArray.fetchDataAtIndex(index: indexPath.row, type: self.type,searchText: self.searchText, isFiltered: self.filterscase == nil ? false : true, filterscase: self.filterscase ?? nil, clusterCodes: self.clusterCodes)
            cell.btnTownName.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
            cell.btnTownName.tintColor = .appLightTextColor.withAlphaComponent(0.2)
            if selectedTerritories.contains(where: { aTerritory in
                aTerritory.name == cell.CallDetail.townName
            }) {
                updateTownButtonAppearance(cell: cell, isSelected: true)
            }
            
                return cell
            case self.headerCollectionView :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRSelectionTitleCell", for: indexPath) as! DCRSelectionTitleCell
                cell.title = self.CallListArray.fetchAtIndex(indexPath.row)
            
                if self.type.rawValue == self.CallListArray.fetchAtIndex(indexPath.row).type.rawValue {
                    cell.lblUnderLine.isHidden = false
                }else {
                    cell.lblUnderLine.isHidden = true
                }
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRSelectionTitleCell", for: indexPath) as! DCRSelectionTitleCell
                return cell
        }
    }
    
    private func updateTownButtonAppearance(cell: DoctorCallCell, isSelected: Bool) {
        let backgroundColor: UIColor = isSelected ? .appLightPink.withAlphaComponent(0.2) : .appLightTextColor.withAlphaComponent(0.2)
      //  let _: UIColor = isSelected ? .appLightPink : .appTextColor
        
        cell.btnTownName.backgroundColor = backgroundColor
       // cell.btnTownName.tintColor = titleColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            case self.callCollectionView:
            self.selectedDCRIndex = indexPath.row
            let adcrCall = self.CallListArray.fetchDataAtIndex(index: indexPath.row, type: self.type,searchText: self.searchText, isFiltered: self.filterscase == nil ? false : true, filterscase: self.filterscase ?? nil, clusterCodes: self.clusterCodes)
           // self.checkinDetailsAction(dcrCall: adcrCall)
            
            let homeDataArr : [HomeData] = DBManager.shared.getHomeData()
       
       
            switch self.type {
                
            case .doctor:
                let doctorArr =  homeDataArr.filter { aHomeData in
                    aHomeData.custType == "1"
                }
                
                

                
                if let addedDcrCall = adcrCall.call as? DoctorFencing {
                    
                    if let unsyncedArr = DBManager.shared.geUnsyncedtHomeData() {
                        let filteredArray = unsyncedArr.filter { aHomeData in
                              if aHomeData.custCode == addedDcrCall.code {
                                  let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss")
                                  let dcrDateString = dcrDate?.toString(format: "MMM d, yyyy")
                                  let currentDateStr = Shared.instance.selectedDate.toString(format: "MMM d, yyyy")
                                  if dcrDateString == currentDateStr {
                                      return true
                                  }
                              }
                              return false
                          }
                        if !filteredArray.isEmpty  {
                            self.showAlertForCallExistence(desc: "Selected Doctor call today already exists in outbox you can edit call in outbox")
                            self.view.endEditing(true)
                          //  self.toCreateToast("Doctor aldready visited today")
                            return
                        }
                    }
                    
                    
                  let filteredArray = doctorArr.filter { aHomeData in
                        if aHomeData.custCode == adcrCall.code {
                            let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd")
                            let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                            let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                            if dcrDateString == currentDateStr {
                                return true
                            }
                        }
                        return false
                    }
                    if !filteredArray.isEmpty  {
//                        self.showAlertForCallExistence(desc: "Doctor already visited today")
                                                self.showAlertForCallExistence(desc: "Already visited today")
                        self.view.endEditing(true)
                        return
                    } else {
                        if customerChekinEnabled {
                            self.checkinAction(dcrCall: adcrCall)
                        } else  {
                           
                            self.navigateToPrecallVC(dcrCall: adcrCall, index: indexPath.item)
                        }
                     
                    }
                }
                
            case .chemist:
                let   chemistArr =  homeDataArr.filter { aHomeData in
                       aHomeData.custType == "2"
                   }
                

                
                
                if let addedDcrCall = adcrCall.call as? Chemist {
                    
                    if let unsyncedArr = DBManager.shared.geUnsyncedtHomeData() {
                        let filteredArray = unsyncedArr.filter { aHomeData in
                              if aHomeData.custCode == addedDcrCall.code {
                                  let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss")
                                  let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                                  let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                                  if dcrDateString == currentDateStr {
                                      return true
                                  }
                              }
                              return false
                          }
                        if !filteredArray.isEmpty  {
                            self.showAlertForCallExistence(desc: "Already exists in outbox you can edit call in outbox")
                            self.view.endEditing(true)
                            return
                        }
                    }
                    
                  let filteredArray = chemistArr.filter { aHomeData in
                        if aHomeData.custCode == adcrCall.code {
                            let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd")
                            let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                            let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                            if dcrDateString == currentDateStr {
                                return true
                            }
                        }
                        return false
                    }
                    if !filteredArray.isEmpty  {
                        self.showAlertForCallExistence(desc: "Already visited today")
                        self.view.endEditing(true)
                        return
                    } else {
                        if customerChekinEnabled {
                            self.checkinAction(dcrCall: adcrCall)
                        } else  {
                           
                            self.navigateToPrecallVC(dcrCall: adcrCall, index: indexPath.item)
                        }
                    }
                }
                
                
               case .stockist:
                let  stockistArr =  homeDataArr.filter { aHomeData in
                       aHomeData.custType == "3"

                   }
                
                
                
                if let addedDcrCall = adcrCall.call as? Stockist {
                    
                    if let unsyncedArr = DBManager.shared.geUnsyncedtHomeData() {
                        let filteredArray = unsyncedArr.filter { aHomeData in
                              if aHomeData.custCode == addedDcrCall.code {
                                  let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss")
                                  let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                                  let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                                  if dcrDateString == currentDateStr {
                                      return true
                                  }
                              }
                              return false
                          }
                        if !filteredArray.isEmpty  {
                            self.showAlertForCallExistence(desc: "Already exists in outbox you can edit call in outbox")
                            self.view.endEditing(true)
                            return
                        }
                    }
                    
                  let filteredArray = stockistArr.filter { aHomeData in
                        if aHomeData.custCode == adcrCall.code {
                            let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd")
                            let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                            let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                            if dcrDateString == currentDateStr {
                                return true
                            }
                        }
                        return false
                    }
                    if !filteredArray.isEmpty  {
                        self.showAlertForCallExistence(desc: "Already visited today")
                        self.view.endEditing(true)
                        return
                    } else {
                        if customerChekinEnabled {
                            self.checkinAction(dcrCall: adcrCall)
                        } else  {
                           
                            self.navigateToPrecallVC(dcrCall: adcrCall, index: indexPath.item)
                        }
                    }
                }
            case .unlistedDoctor:
                let  unlistedDocArr =  homeDataArr.filter { aHomeData in
                       aHomeData.custType == "4"
                   }
                
                if let addedDcrCall = adcrCall.call as? UnListedDoctor {
                    
                    if let unsyncedArr = DBManager.shared.geUnsyncedtHomeData() {
                        let filteredArray = unsyncedArr.filter { aHomeData in
                              if aHomeData.custCode == addedDcrCall.code {
                                  let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss")
                                  let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                                  let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                                  if dcrDateString == currentDateStr {
                                      return true
                                  }
                              }
                              return false
                          }
                        if !filteredArray.isEmpty  {
                            self.showAlertForCallExistence(desc: "Already exists in outbox you can edit call in outbox")
                            self.view.endEditing(true)
                            return
                        }
                    }
                    
                    
                  let filteredArray = unlistedDocArr.filter { aHomeData in
                        if aHomeData.custCode == adcrCall.code {
                            let dcrDate = aHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd")
                            let dcrDateString = dcrDate?.toString(format: "yyyy-MM-dd")
                            let currentDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
                            if dcrDateString == currentDateStr {
                                return true
                            }
                        }
                        return false
                    }
                    if !filteredArray.isEmpty  {
                        self.showAlertForCallExistence(desc: "Already visited today")
                        self.view.endEditing(true)
                        return
                    } else {
                        if customerChekinEnabled {
                            self.checkinAction(dcrCall: adcrCall)
                        } else  {
                           
                            self.navigateToPrecallVC(dcrCall: adcrCall, index: indexPath.item)
                        }
                    }
                }
            case .cip:

                print("Yet to")
            case .hospital:

                print("Yet to")
  
            }
        

            case self.headerCollectionView:
            self.type = self.CallListArray.fetchAtIndex(indexPath.row).type
            
            switch type {
                
            case .doctor:
                txtSearch.placeholder = "Search \(LocalStorage.shared.getString(key: .doctor))"
            case .chemist:
                txtSearch.placeholder = "Search \(LocalStorage.shared.getString(key: .chemist))"
            case .stockist:
                txtSearch.placeholder = "Search \(LocalStorage.shared.getString(key: .stockist))"
            case .unlistedDoctor:
                txtSearch.placeholder = "Search \(LocalStorage.shared.getString(key: .unlistedDoctor))"
             default:
                print("Yet to")
            }
            
                addedFiltersCount.isHidden = true
                filterCountHolderVIew.isHidden = true
                self.filterscase = nil
                self.headerCollectionView.reloadData()
                self.callCollectionView.reloadData()
            default:
                break
        }
    }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            case self.callCollectionView :
                let width = self.callCollectionView.frame.width / 4
            switch self.type {
                
            case .doctor, .unlistedDoctor:
                let size = CGSize(width: width - 10, height: collectionView.height / 3.5)
                return size
            case .chemist:
                let size = CGSize(width: width - 10, height: collectionView.height / 4)
                return size
            case .stockist:
                let size = CGSize(width: width - 10, height: collectionView.height / 4)
                return size
       
            case .hospital:
              return  CGSize()
            case .cip:
                return CGSize()
            }
            
       
            

            case self.headerCollectionView:
            
                let label = UILabel()
            label.setFont(font: .bold(size: .BODY))
                label.text = self.CallListArray.fetchAtIndex(indexPath.row).name
                let sizeLabelFit = label.sizeThatFits(CGSize(width: self.headerCollectionView.frame.width-30, height: self.headerCollectionView.frame.height))
            
                let size = CGSize(width: sizeLabelFit.width + 40, height: self.headerCollectionView.frame.height)
                return size
            default :
                let size = CGSize(width: 200, height: 130)
                return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
