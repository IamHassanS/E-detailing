//
//  MasterSyncVC.swift
//  E-Detailing
//
//  Modified by Hassan on 14/03/24.
//

import Foundation
import UIKit
import Alamofire
import CoreData
extension MasterSyncVC:  SlideDownloadVCDelegate {
    func didEncounterError() {
        isSlideDownloading = false
        retryVIew.isHidden = false
        //downloadingBottomView.isHidden = false
        //self.slideDownloadStatusLbl.isHidden = false
        //self.slideDownloadStatusLbl.text = "Error downloading slides.."
        var  isSuccess = false
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesGrouped) && !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesDownloadPending)  {
            isSuccess = true
        }
        _ = toCheckExistenceOfNewSlides(didEncountererror: !isSuccess)
        return
    }
    

    
    func isBackgroundSyncInprogress(isCompleted: Bool, cacheObject: [SlidesModel], isToshowAlert: Bool, didEncountererror: Bool) {
        
        
        if isToshowAlert && !isCompleted {
            toSetupAlert(desc: "Slides will be downloaded in background..", istoNavigate: false)
            return
        }
        
        self.arrayOfAllSlideObjects = cacheObject
        
        if didEncountererror {
            isSlideDownloading = false
            retryVIew.isHidden = false
            self.slideDownloadStatusLbl.text = "Error downloading slides.."
            return
        } else {
            retryVIew.isHidden = true
        }
        
        if isCompleted {
            isSlideDownloading = false
            downloadingBottomView.isHidden = true
            self.slideDownloadStatusLbl.isHidden = true
            return
        }
        
  
        
        
        downloadingBottomView.isHidden = false
        self.slideDownloadStatusLbl.isHidden = false
        let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
       // self.slideDownloadStatusLbl.text =  "Slide download in progress"
        self.slideDownloadStatusLbl.text =   "slides downloaded :\(downloadedArr.count)/\( self.arrayOfAllSlideObjects .count)"
        
    }
    
    
    func toSetupAlert(desc: String, istoNavigate: Bool, istoNavigatetoSettings : Bool? = false) {
        downloadAlertSet = true
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
          if istoNavigatetoSettings ?? false {
              self.navigateTosettings()
            }
            print("no action")

        }
    }
    
    
    func navigateTosettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    
    
    

    
    func didDownloadCompleted() {
        if isFromLaunch {
            self.moveToHome()
        } else {
            _ = toCheckExistenceOfNewSlides(didEncountererror: false)
        }
     

    }
    
    
}

class MasterSyncVC : UIViewController {
    var downloadAlertSet: Bool = false
    var isNewSlideExists: Bool = false
    var isSlideDownloading : Bool = false
    var isAlertShown: Bool = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = MasterSyncVC()
    var delegate : MasterSyncVCDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var tapInfoVIew: ShadowView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var lblHqName: UILabel!
    @IBOutlet weak var lblSyncStatus: UILabel!
    
    @IBOutlet var backBtn: UIButton!
    
    @IBOutlet var downloadingBottomView: UIView!
    @IBOutlet var slideDownloadStatusLbl: UILabel!
    
    @IBOutlet var retryVIew: UIView!
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var pageType: PageType = .loaded
    var loadedSlideInfo = [MasterInfo]()
    var extractedFileName: String?
    var isFromLaunch : Bool = false
    var masterVM: MasterSyncVM?
    var masterData = [MasterInfo]()
    var cacheMasterData = [MasterInfo]()
    var isDayPlanSynced: Bool = false
    var dcrList = [MasterCellData]()
    var dcrDates: [DCRdatesModel]?
    var selectedMasterGroupIndex: Int? = nil
    var fetchedHQObject: Subordinate?
    var isMaterSyncInProgress : Bool = false
    var isfromHome : Bool = false
     var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var isTosetDayplanHQ: Bool = true
//    var animations: [LoadingStatus] = MasterInfoState.loadingStatusDict.map { $0.value } {
//        didSet {
//            _ = self.animations.filter { $0 == .loaded }
//        }
//    }
    
    var arrayOfAllSlideObjects = [SlidesModel]()

    var mastersyncVM: MasterSyncVM?
    var getSFCode: String{
        let login = AppDefaults.shared.getAppSetUp()
        let isManager = AppDefaults.shared.getAppSetUp().sfType == 2
        if isManager{
            if AppDefaults.shared.sfCode != ""{
                return AppDefaults.shared.sfCode
            }
            return login.sfCode!
        }
        return login.sfCode!
    }

    
    let appsetup = AppDefaults.shared.getAppSetUp()
    var getRSF: String? {
     
        let selectedRSF = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        let rsfIDPlan1 = LocalStorage.shared.getString(key: LocalStorage.LocalValue.rsfIDPlan1)
        let rsfIDPlan2 = LocalStorage.shared.getString(key: LocalStorage.LocalValue.rsfIDPlan2)
        if !selectedRSF.isEmpty{
            return selectedRSF
        }
        if !rsfIDPlan1.isEmpty {
            return rsfIDPlan1
        } else if !rsfIDPlan2.isEmpty {
            return rsfIDPlan2
        } else {
            return "\(appsetup.sfCode ?? "")"
        }
    }
    
    

    
    
    
    var groupedBrandsSlideModel:  [GroupedBrandsSlideModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addobservers()
        masterVM = MasterSyncVM()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        collectionView.register(UINib(nibName: "MasterSyncCell", bundle: nil), forCellWithReuseIdentifier: "MasterSyncCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.updateList()

        if !isFromLaunch {
            selectedMasterGroupIndex = 0
    
        }else {
            selectedMasterGroupIndex = nil
            LocalStorage.shared.setBool(LocalStorage.LocalValue.hasMasterData, value: false)
           // if isConnected {
                syncAllAction(self)
          //  } else {
            //  toSetupAlert(desc: "please connect to internet for initial setups", istoNavigate: false, istoNavigatetoSettings: true)
        //    }
            
           
            
          
            
        }
        
        print(DBManager.shared.getSlide())
        
        
        let syncTime = AppDefaults.shared.getSyncTime()
        let date = syncTime.toString(format: "dd MMM yyyy hh:mm a")
        self.lblSyncStatus.text = "Last Sync: " + date
        
        tapInfoVIew.layer.cornerRadius = 5
    }
    
    
    //MARK:- initWithStory
    class func initWithStory()-> MasterSyncVC{
        
        let view : MasterSyncVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext

        return view
    }
    
    func setupUI() {
        
        retryVIew.isHidden = true
        backBtn.isHidden = isFromLaunch
        
        
        self.mastersyncVM = MasterSyncVM()
        lblHqName.setFont(font: .bold(size: .BODY))
        lblHqName.textColor = .appLightTextColor
        lblSyncStatus.textColor = .appLightTextColor
        lblSyncStatus.setFont(font: .bold(size:   .BODY))
        titleLbl.setFont(font: .bold(size: .SUBHEADER))
        slideDownloadStatusLbl.setFont(font: .medium(size: .BODY))
        slideDownloadStatusLbl.textColor = .appWhiteColor
        //downloadingBottomView.isHidden = true
        //slideDownloadStatusLbl.isHidden = true
        let toViewSlides = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesGrouped)
        if isFromLaunch {
            self.slideDownloadStatusLbl.text = "slides download inprogress.."
        } else {
            _ = toCheckExistenceOfNewSlides(didEncountererror:  !toViewSlides)
        }
       
        titleLbl.textColor = .appWhiteColor
        backBtn.setTitle("", for: .normal)
      
        retryVIew.layer.cornerRadius = retryVIew.height / 2
        setHQlbl(isTosetDayplanHQ: false)
        
     
        
        slideDownloadStatusLbl.addTap {
          //  if  !self.retryVIew.isHidden {
            if self.slideDownloadStatusLbl.text == "slides download inprogress.." || self.isMaterSyncInProgress {
                self.toCreateToast("Slide download in resume afer master sync.")
                return
            }
            
            if  Shared.instance.iscelliterating {
                return
            }
            
            if   LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesRemoved) {
                self.moveToDownloadSlide(isFromcache: true)
            } else {
                self.moveToDownloadSlide(isFromcache: false)
            }
          
           // } else {
            //    return
           // }
            
        }
    }
    
  
       
        
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        
        if isFromLaunch {
            self.moveToHome()
            return
        }
        
        delegate?.isHQModified(hqDidChanged: isDayPlanSynced)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "")
      //  self.isSlideDownloading = false
    }
    
    func addobservers() {

        
        NotificationCenter.default.addObserver(self, selector: #selector(dcrCallAdded) , name: NSNotification.Name("callsAdded"), object: nil)

    }
    
    
    @objc func dcrCallAdded() {
        self.fetchmasterData(type: .homeSetup) {_ in }
    }
    
    @objc func hqModified() {
        print("Tapped")
        self.fetchmasterData(type: .clusters) {_ in }
    }
    
    @objc func syncTapped() {
        print("Tapped")
        self.fetchmasterData(type: .getTP) {_ in}
    }
    
    

    
    func setHQlbl(isTosetDayplanHQ: Bool) {
        // let appsetup = AppDefaults.shared.getAppSetUp()
        self.isTosetDayplanHQ = isTosetDayplanHQ
        if isTosetDayplanHQ {
            guard self.fetchedHQObject != nil else {
                CoreDataManager.shared.toRetriveSavedDayPlanHQ { hqModelArr in
                    let savedEntity = hqModelArr.first
                    guard let savedEntity = savedEntity else{
                        
                        self.lblHqName.text = "Select HQ"
                        
                        return
                        
                    }
                    
                    self.lblHqName.text = savedEntity.name == "" ? "Select HQ" : savedEntity.name
                    
                    let subordinates = DBManager.shared.getSubordinate()
                    
                    let asubordinate = subordinates.filter{$0.id == savedEntity.code}
                    
                    if !asubordinate.isEmpty {
                        self.fetchedHQObject = asubordinate.first
                        LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text:  asubordinate.first?.id ?? "")
                    }
                
                  
      
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
        
                Shared.instance.isFetchingHQ = false
                return
            }
            let aHQobj = HQModel()
            aHQobj.code = self.fetchedHQObject?.id ?? ""
            aHQobj.mapId = self.fetchedHQObject?.mapId ?? ""
            aHQobj.name = self.fetchedHQObject?.name ?? ""
            aHQobj.reportingToSF = self.fetchedHQObject?.reportingToSF ?? ""
            aHQobj.steps = self.fetchedHQObject?.steps ?? ""
            aHQobj.sfHQ = self.fetchedHQObject?.sfHq ?? ""
            CoreDataManager.shared.removeDayPlanHQ()
            CoreDataManager.shared.saveToDayplanHQCoreData(hqModel: aHQobj){ _ in
                CoreDataManager.shared.toRetriveSavedDayPlanHQ { HQModelarr in
                    dump(HQModelarr)
                }
            }
            
            CoreDataManager.shared.removeHQ()
            CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                CoreDataManager.shared.toRetriveSavedHQ { HQModelarr in
                    dump(HQModelarr)
                }
            }
        
        LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aHQobj.code)
        self.lblHqName.text =   self.fetchedHQObject?.name
        Shared.instance.isFetchingHQ = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
            return
        }
        

        
        guard self.fetchedHQObject != nil else {
            CoreDataManager.shared.toRetriveSavedHQ { hqModelArr in
                let savedEntity = hqModelArr.first
                guard let savedEntity = savedEntity else{
                    
                    self.lblHqName.text = "Select HQ"
                    
                    return
                    
                }
                
                self.lblHqName.text = savedEntity.name == "" ? "Select HQ" : savedEntity.name
                
                let subordinates = DBManager.shared.getSubordinate()
                
                let asubordinate = subordinates.filter{$0.id == savedEntity.code}
                
                if !asubordinate.isEmpty {
                    self.fetchedHQObject = asubordinate.first
                    LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text:  asubordinate.first?.id ?? "")
                }
            
              
  
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
    
            Shared.instance.isFetchingHQ = false
            return
        }
            let aHQobj = HQModel()
            aHQobj.code = self.fetchedHQObject?.id ?? ""
            aHQobj.mapId = self.fetchedHQObject?.mapId ?? ""
            aHQobj.name = self.fetchedHQObject?.name ?? ""
            aHQobj.reportingToSF = self.fetchedHQObject?.reportingToSF ?? ""
            aHQobj.steps = self.fetchedHQObject?.steps ?? ""
            aHQobj.sfHQ = self.fetchedHQObject?.sfHq ?? ""
            CoreDataManager.shared.removeHQ()
            CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                CoreDataManager.shared.toRetriveSavedHQ { HQModelarr in
                    dump(HQModelarr)
                }
            }
        
      //  LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aHQobj.code)
        self.lblHqName.text =   self.fetchedHQObject?.name
        Shared.instance.isFetchingHQ = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
       
    }
    
    @IBAction func headquarterAction(_ sender: UIButton) {
      //  let headquarter = DBManager.shared.getSubordinate()

        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR)  {
            return
        }
        
        if  Shared.instance.isFetchingHQ {
            self.toCreateToast("Syncing please wait")
            return
        }

        
        let vc = SpecifiedMenuVC.initWithStory(self, celltype: .headQuater)
        vc.isFromMasterSync = true
        vc.menuDelegate = self
        
        if isTosetDayplanHQ {
            
            CoreDataManager.shared.fetchSavedDayPlanHQ{ [weak self] hqArr in
                guard let welf = self else {return}
                let savedEntity = hqArr.first
                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: welf.context)
         
                else {
                    fatalError("Entity not found")
                }
                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                
                welf.fetchedHQObject = CoreDataManager.shared.convertHeadQuartersToSubordinate(savedEntity ?? temporaryselectedHqobj, context: welf.context)
            }
            
        } else  {
            CoreDataManager.shared.fetchSavedHQ{ [weak self] hqArr in
                guard let welf = self else {return}
                let savedEntity = hqArr.first
                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: welf.context)
         
                else {
                    fatalError("Entity not found")
                }
                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
                
                welf.fetchedHQObject = CoreDataManager.shared.convertHeadQuartersToSubordinate(savedEntity ?? temporaryselectedHqobj, context: welf.context)
            }
        }
        
        

        vc.selectedObject = self.fetchedHQObject
        
        self.modalPresentationStyle = .custom
        self.navigationController?.present(vc, animated: false)

    }
    
    
    
    func fetchMasterDataRecursively(index: Int, isfromSyncall: Bool? = false) {
       
        
        
        let tosyncMasterData : [MasterInfo] = cacheMasterData

        guard index < tosyncMasterData.count else {
            print("DCR list sync completed")
            
            
            
            UIApplication.shared.endBackgroundTask(backgroundTask)
            
            DispatchQueue.main.async {
                
                if Shared.instance.isSlideDownloading {
                    return
                }
                
                if isfromSyncall ?? false {
                    
                    self.collectionView.reloadData()
                    
                }
                
                self.isMaterSyncInProgress = false
                
                var istoNavigate: Bool = false
                tosyncMasterData.forEach { aMasterInfo in
                    if aMasterInfo == .slides && !(isfromSyncall ?? false) {
                        istoNavigate = true
                    }
                }
                
                LocalStorage.shared.setBool(LocalStorage.LocalValue.hasMasterData, value: true)
                
                NotificationCenter.default.post(name: NSNotification.Name("daplanRefreshed"), object: nil)
                
                if istoNavigate  {
                    self.setLoader(pageType: .navigate, type: .slides)
                    self.backBtn.isHidden = false
                }

            }

           return
        }

        let masterType = tosyncMasterData[index]
        
        fetchmasterData(type: masterType) { [weak self] isSuccess in
            guard let welf = self else { return }

    
            MasterInfoState.loadingStatusDict[masterType] = isSuccess ? .loaded : .error
           // if   !(isfromSyncall ?? false) {
            DispatchQueue.main.async {
                welf.collectionView.reloadData()
            }
               
            //}
            
            welf.fetchMasterDataRecursively(index: index + 1, isfromSyncall: isfromSyncall)

           
        }
        
    }
    
    @IBAction func syncAll(_ sender: UIButton) {
       
//        cacheMasterData = masterData
//        
//        let selectedMasterInfo = masterData
//
//        // Set loading status based on MasterInfo for each element in the array
//        selectedMasterInfo.forEach { masterInfo in
//            MasterInfoState.loadingStatusDict[masterInfo] = .isLoading
//        }
//
//        collectionView.reloadData()
//        selectedMasterGroupIndex = nil
//
//
//     //   DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            self.fetchMasterDataRecursively(index: 0, isfromSyncall: true)
//          // }

        
    }
    
    
    func updateList() {
        let appsetup = AppDefaults.shared.getAppSetUp()
        

        
        self.dcrList.append(MasterCellData(cellType: MasterCellType.listedDoctor,isSelected: false))
        
        if appsetup.chmNeed == 0 {
            self.dcrList.append(MasterCellData(cellType: MasterCellType.chemist,isSelected: false))
        }
        if appsetup.stkNeed == 0 {
            self.dcrList.append(MasterCellData(cellType: MasterCellType.stockist,isSelected: false))
        }
        
       if appsetup.cipNeed == 0 {
           self.dcrList.append(MasterCellData(cellType: MasterCellType.cip, isSelected: false))
        }
        if appsetup.unlNeed == 0 {
            self.dcrList.append(MasterCellData(cellType: MasterCellType.unLstDoctor,isSelected: false))
        }
        
        if appsetup.cipNeed == 0 {
            self.dcrList.append(MasterCellData(cellType: MasterCellType.cip,isSelected: false))
        }
        if appsetup.hospNeed == 0 {
            self.dcrList.append(MasterCellData(cellType: MasterCellType.hospital,isSelected: false))
        }
        
        self.dcrList.append(MasterCellData(cellType: MasterCellType.cluster,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.input,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.Product,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.leave,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.dcr,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.tourPlan,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.workType,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.slides,isSelected: false))
    
        self.dcrList.append(MasterCellData(cellType: MasterCellType.subordinate,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.other,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.setup,isSelected: false))
        self.dcrList.append(MasterCellData(cellType: MasterCellType.syncAll,isSelected: false))
        
        self.masterData.append(MasterInfo.myDayPlan)
        
        self.masterData.append(MasterInfo.doctorFencing)
        self.masterData.append(MasterInfo.chemists)
        self.masterData.append(MasterInfo.chemistCategory)
        self.masterData.append(MasterInfo.stockists)
        self.masterData.append(MasterInfo.unlistedDoctors)
        self.masterData.append(MasterInfo.setups)
        self.masterData.append(MasterInfo.customSetup)
        
        self.masterData.append(MasterInfo.dcrDateSync)
        
        self.masterData.append(MasterInfo.tourPlanStatus)
        self.masterData.append(MasterInfo.leaveType)
        self.masterData.append(MasterInfo.visitControl)
        self.masterData.append(MasterInfo.mappedCompetitors)
        self.masterData.append(MasterInfo.stockBalance)
        self.masterData.append(MasterInfo.subordinate)
        //self.masterData.append(MasterInfo.subordinateMGR)
        self.masterData.append(MasterInfo.speciality)
        self.masterData.append(MasterInfo.departments)
        self.masterData.append(MasterInfo.category)
        self.masterData.append(MasterInfo.qualifications)
        self.masterData.append(MasterInfo.doctorClass)
        self.masterData.append(MasterInfo.worktype)
        self.masterData.append(MasterInfo.clusters)
        self.masterData.append(MasterInfo.jointWork)
        self.masterData.append(MasterInfo.products)
        self.masterData.append(MasterInfo.inputs)
        self.masterData.append(MasterInfo.brands)
       // self.masterData.append(MasterInfo.competitors)
      
        self.masterData.append(MasterInfo.holidays)
        self.masterData.append(MasterInfo.weeklyOff)
        self.masterData.append(MasterInfo.tourPlanSetup)
        self.masterData.append(MasterInfo.getTP)
        self.masterData.append(MasterInfo.homeSetup)
        self.masterData.append(MasterInfo.slideSpeciality)
        self.masterData.append(MasterInfo.slideBrand)
        self.masterData.append(MasterInfo.slides)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromLaunch {
          
            self.masterData = self.dcrList.first!.cellType.groupDetail
            
            self.collectionView.reloadData()

        }
    }
    

    func toSaveDayplansToDB(isSynced: Bool,planDate: Date, model: [MyDayPlanResponseModel]) {
        masterVM?.toUpdateDataBase(isSynced: isSynced, planDate: planDate, aDayplan: masterVM?.toConvertResponseToDayPlan(isSynced: isSynced, model: model) ?? DayPlan()) {_ in
            //refreshDayplan
            NotificationCenter.default.post(name: NSNotification.Name("daplanRefreshed"), object: nil)
            
        }
    }
    
    func setParentHQ() {
        
    }

    
    
    func fetchmasterData(type : MasterInfo, completion: @escaping (Bool) -> ()) {
        
        
        switch type {

        case .getTP :
            toPostDataToserver(type : type) {isCompleted in
                completion(isCompleted)
            }
          //  completion(true)
        case .dcrDateSync:
            masterVM?.tofetchDcrdates() { result in
                
                switch result {
                case .success(let respnse):
                    
                    self.dcrDates = respnse
                    CoreDataManager.shared.saveDatestoCoreData(model: respnse) {
                        
                        CoreDataManager.shared.fetchDcrDates() { savedDcrDates in
                            dump(savedDcrDates)
                            
                            
                           let planDates = savedDcrDates.filter { $0.flag == "0" && $0.tbname == "dcr" }
                            
                            guard !planDates.isEmpty, let currentDate = planDates.first  else {
                                completion(true)
                                return
                            }
                            //"2024-06-06 00:00:00"
                            guard let toDayDate = currentDate.date?.toDate(format: "yyyy-MM-dd") else {
                                completion(true)
                                return
                            }
                            Shared.instance.selectedDate = toDayDate
                            completion(true)
                        }
                        
                    }
              
                    
                  
                case .failure(let error):
                    completion(false)
                    print(error.rawValue)
                }
            }
        case .myDayPlan:
            mastersyncVM?.callSavePlanAPI(byDate: Shared.instance.selectedDate) {isUploaded in
                self.mastersyncVM?.toGetMyDayPlan(type: type, isToloadDB: false, date: Shared.instance.selectedDate) { [weak self] (result) in
                    guard let welf = self else {return}
                    //  completion(true)
                    switch result {
                        
                    case .success(let responseModel):
                        
                        let model: [MyDayPlanResponseModel] = responseModel
                        welf.isDayPlanSynced = true
                        if model.count > 0 {
                            var dayPlan1: MyDayPlanResponseModel?
                            var dayPlan2: MyDayPlanResponseModel?
                            let sessionArray = model.filter{$0.SFMem != ""}
                            let leaveArray = model.filter{$0.SFMem == ""}
                            if !leaveArray.isEmpty {
                                let subordinateArr =  DBManager.shared.getSubordinate()
                                let cacheHQ = subordinateArr.first
                                welf.fetchedHQObject = cacheHQ
                                welf.toSaveDayplansToDB(isSynced: true, planDate: Date(), model: responseModel)
                                welf.setHQlbl(isTosetDayplanHQ: true)
                                welf.masterVM?.fetchMasterData(type: .clusters, sfCode:  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID:  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) ) { _ in
                                    completion(true)
                                }
                            }
                            
                            
                            if sessionArray.isEmpty {
                                completion(true)
                            }
                     
                            sessionArray.enumerated().forEach { index, aMyDayPlanResponseModel in
                                switch index {
                                case 0:
                                    dayPlan1 = aMyDayPlanResponseModel
                                case 1:
                                    dayPlan2 = aMyDayPlanResponseModel
                                default:
                                    print("Yet to implement")
                                }
                            }

                            
                            welf.mastersyncVM?.fetchMasterData(type: .subordinate, sfCode:   LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) , istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { _ in
                                
                                let subordinateArr =  DBManager.shared.getSubordinate()
                                let filteredHQ = subordinateArr.filter {  $0.id == dayPlan1?.SFMem }
                                if !filteredHQ.isEmpty {
                                    let cacheHQ = filteredHQ.first
                                    welf.fetchedHQObject = cacheHQ
                                    welf.setHQlbl(isTosetDayplanHQ: true)
                                    
                                    welf.masterVM?.fetchMasterData(type: .clusters, sfCode:  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID:  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) ) { _ in
                                        if dayPlan2 != nil {
                                            welf.masterVM?.fetchMasterData(type: .clusters, sfCode: dayPlan2?.SFMem ?? "", istoUpdateDCRlist: false, mapID: dayPlan2?.SFMem ?? "") { _ in
                                                
                                                welf.toSaveDayplansToDB(isSynced: true, planDate: Date(), model: responseModel)
                                                
                                                dump(DBManager.shared.getTerritory(mapID: dayPlan2?.SFMem ?? ""))
                                                
                                                completion(true)
                                            }
                                        } else {
                                            welf.toSaveDayplansToDB(isSynced: true, planDate: Date(), model: responseModel)
                                            
                                            dump(DBManager.shared.getTerritory(mapID: dayPlan1?.SFMem ?? ""))
                                            
                                            completion(true)
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                        } else {
                                
                                welf.mastersyncVM?.fetchMasterData(type: .subordinate, sfCode:   LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { _ in
                                    
                                    let subordinateArr =  DBManager.shared.getSubordinate()
                                    let filteredHQ = subordinateArr.first
                                    //.filter {$0.mapId == LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)}
                                    // if !filteredHQ.isEmpty {
                                    
                                    let cacheHQ = filteredHQ
                                    welf.fetchedHQObject = cacheHQ
                                    welf.setHQlbl(isTosetDayplanHQ: true)
                                    // }
                                    NotificationCenter.default.post(name: NSNotification.Name("daplanRefreshed"), object: nil)
                                    completion(true)
                              
                                return
                            }
                        }
                        
                    case .failure( _):
                       // welf.toCreateToast(error.rawValue)
                        completion(false)
                    }
                }
            }
            

            
        default:
            
            mastersyncVM?.fetchMasterData(type: type, sfCode:  self.getRSF ?? "", istoUpdateDCRlist: false, mapID: self.getRSF ?? "") {[weak self] (response) in
                guard let welf = self else {return}
                let date1 = Date().toString(format: "yyyy-MM-dd HH:mm:ss ZZZ")
                
                print("date1 === \(date1)")
                
                switch response.result {
                    
                case .success(_):
                  
                        guard let data = response.data else {
                            completion(false)
                            return }
                        let apiResponse = ObjectFormatter.shared.convertDataToJsonArr(data: data)
                        //let apiResponse = try JSONSerialization.jsonObject(with: response.data! ,options: JSONSerialization.ReadingOptions.allowFragments)
                        print(apiResponse ?? "Its not proper response")
                    guard let apiResponse = apiResponse else {
                        completion(false)
                        return}
                       
                            DBManager.shared.saveMasterData(type: type, Values: apiResponse,id: welf.getRSF ?? "")
                            if type == MasterInfo.slides || type == MasterInfo.slideBrand {
                                welf.loadedSlideInfo.append(type)
                                switch type {
                                case MasterInfo.slides:
                                    
                                    var slides = AppDefaults.shared.getSlides()
                                    slides.removeAll()
                                    slides.append(contentsOf: apiResponse)
                                    
                                    LocalStorage.shared.setData(LocalStorage.LocalValue.slideResponse, data: response.data!)
                                    
                                  //  welf.setLoader(pageType: .navigate, type: .slides)
                                case MasterInfo.slideBrand:
                                    
                                    LocalStorage.shared.setData(LocalStorage.LocalValue.BrandSlideResponse, data: response.data!)
                                    
                                   // welf.setLoader(pageType: .navigate, type: .slides)
                                default:
                                    print("Yet to implement")
                                }
                                
                            }
                        
                    
                    AppDefaults.shared.save(key: .syncTime, value: Date())
                    let date = Date().toString(format: "dd MMM yyyy hh:mm a")
                    welf.lblSyncStatus.text = "Last Sync: " + date

                    completion(true)
                case .failure(let error):
                    
                  //  welf.toCreateToast("\(error)")
                    print(error)
                    completion(false)
                }
                
            }
            
        }
        
    }
    
}


extension MasterSyncVC : tableViewProtocols {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dcrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterSyncTbCell", for: indexPath) as! MasterSyncTbCell
        cell.selectionStyle = .none
        if indexPath.row == selectedMasterGroupIndex {
            cell.contentHolderView.backgroundColor = .appTextColor
            cell.lblName.textColor = .appWhiteColor
            cell.selectedIV.image = UIImage(named:   "chevlon.right")
            cell.selectedIV.tintColor = .appWhiteColor
           // cell.btnArrow.ima
        } else {
            cell.contentHolderView.backgroundColor = .appWhiteColor
            cell.lblName.textColor = .appTextColor
            cell.selectedIV.image = UIImage(named:   "chevlon.expand")
           
          
            cell.selectedIV.tintColor = .appTextColor
        }
        
        cell.lblName.text = self.dcrList[indexPath.row].cellType.name
        cell.btnSyncAll.isHidden = MasterCellType.syncAll.rawValue == self.dcrList[indexPath.row].cellType.rawValue ? false : true
        cell.btnSyncAll.addTarget(self, action: #selector(syncAllAction(_:)), for: .touchUpInside)

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMasterGroupIndex = indexPath.row
        for i in 0..<self.dcrList.count {
            self.dcrList[i].isSelected = false
        }
        
        self.tableView.reloadData()

       self.masterData = self.dcrList[indexPath.row].cellType.groupDetail

        self.collectionView.reloadData()
    }
    
    func showMasterSyncError(description: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "\(description)", okAction: "Close")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
    }
    
    @objc func syncAllAction (_ sender : Any) {
        
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                self.toSetupAlert(desc: "Check your Internet Connection", istoNavigate: false)
                return
        }

        if Shared.instance.isSlideDownloading {
            return
        }
        
        self.isMaterSyncInProgress = true
        
        self.loadedSlideInfo = []
      

        
        self.masterData = [MasterInfo.dcrDateSync, MasterInfo.subordinate, MasterInfo.worktype, MasterInfo.myDayPlan,  MasterInfo.doctorFencing, MasterInfo.speciality, MasterInfo.qualifications, MasterInfo.category, MasterInfo.departments, MasterInfo.doctorClass, MasterInfo.chemists, MasterInfo.chemistCategory, MasterInfo.stockists, MasterInfo.unlistedDoctors, MasterInfo.clusters, MasterInfo.inputs ,   MasterInfo.products, MasterInfo.productcategory, MasterInfo.brands,  MasterInfo.mappedCompetitors,  MasterInfo.leaveType,  MasterInfo.homeSetup,  MasterInfo.visitControl, MasterInfo.stockBalance,  MasterInfo.holidays, MasterInfo.weeklyOff, MasterInfo.getTP, MasterInfo.tourPlanSetup, MasterInfo.setups ,MasterInfo.customSetup,   MasterInfo.jointWork, MasterInfo.slideSpeciality,MasterInfo.slideBrand,MasterInfo.slides, MasterInfo.slideTheraptic, MasterInfo.docFeedback]
        //MasterInfo.competitors,
        //MasterInfo.subordinateMGR,

        
        cacheMasterData = masterData
        
        let selectedMasterInfo = masterData

        // Set loading status based on MasterInfo for each element in the array
        selectedMasterInfo.forEach { masterInfo in
            MasterInfoState.loadingStatusDict[masterInfo] = .isLoading
        }
        
              self.masterData = self.dcrList[selectedMasterGroupIndex ?? 0].cellType.groupDetail
              DispatchQueue.main.async {
                  self.collectionView.reloadData()
              }

         // Begin a background task
         backgroundTask = UIApplication.shared.beginBackgroundTask {
             // End the background task if the expiration handler is called
             UIApplication.shared.endBackgroundTask(self.backgroundTask)
         }
        
        // Perform API calls in the background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.fetchMasterDataRecursively(index: 0, isfromSyncall: self.isFromLaunch ? false : true)
            
  
        }
        
        // Reload the collection view on the main thread
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
}

extension MasterSyncVC : collectionViewProtocols{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 3
        
        if self.masterData[indexPath.row].rawValue == "Holidays" || self.masterData[indexPath.row].rawValue == "Weekly Off" || self.masterData[indexPath.row].rawValue == "Table Setup" || self.masterData[indexPath.row].rawValue == "Charts" {
            return CGSize(width: width - 10, height: 0)
        }
            let size = CGSize(width: collectionView.width / 3 - 10 , height: collectionView.height / 5.5)
       // let size = CGSize(width: collectionView.width / 3 - 10 , height: collectionView.height / 7)
            return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.masterData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterSyncCell", for: indexPath) as! MasterSyncCell
        cell.lblName.text = self.masterData[indexPath.row].rawValue
        cell.loaderImage.isHidden = false
        var status :  LoadingStatus = .loaded
        MasterInfoState.loadingStatusDict.forEach({ masterinfo, loadingStatus  in
        if masterinfo.rawValue == self.masterData[indexPath.row].rawValue {
            status = loadingStatus
        }
        })
        if status == .isLoading {
            cell.stopRotation()
            cell.isRotationEnabled = true
            cell.loaderImage.tintColor = .appLightPink
            cell.loaderImage.image = UIImage(named: "master_sync_refresh_icon")
            cell.rotateImage()
        }else if status == .error {
            cell.stopRotation()
            cell.isRotationEnabled = false
            cell.loaderImage.tintColor = .appYellow
            cell.loaderImage.image = UIImage(named: "icon_sync_failed")
        } else if status == .loaded  {
            cell.stopRotation()
            cell.isRotationEnabled = false
            cell.loaderImage.tintColor = .appGreen
            cell.loaderImage.image = UIImage(systemName: "checkmark.circle.fill")
        }

        cell.btnSync.addTarget(self, action: #selector(groupSyncAll(_:)), for: .touchUpInside)
        
        
        switch MasterInfo(rawValue: self.masterData[indexPath.row].rawValue){
            
        case .doctorFencing:
            cell.lblCount.text = String(DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)
        case .chemists:
            cell.lblCount.text = String(DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)
        case .stockists:
            cell.lblCount.text = String(DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)
        case .unlistedDoctors:
            cell.lblCount.text = String(DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)
        case .clusters:
            cell.lblCount.text = String(DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)
        case .worktype:
            cell.lblCount.text = String(DBManager.shared.getWorkType().count)
        case .subordinate:
            cell.lblCount.text =  ""
            //String(DBManager.shared.getSubordinate().count)
//        case .subordinateMGR:
//            cell.lblCount.text =  ""
            //String(DBManager.shared.getSubordinateMGR().count)
        case .myDayPlan:
            cell.lblCount.text =  ""
//            CoreDataManager.shared.retriveSavedDayPlans() { dayplans in
//                cell.lblCount.text =  "\(dayplans.count)"
//            }
        case .jointWork:
            cell.lblCount.text =  ""
            //String(DBManager.shared.getJointWork().count)
        case .products:
            cell.lblCount.text = String(DBManager.shared.getProduct().count)
        case .inputs:
            cell.lblCount.text = String(DBManager.shared.getInput().count)
        case .brands:
            cell.lblCount.text = String(DBManager.shared.getBrands().count)
        case .speciality:
            cell.lblCount.text = String(DBManager.shared.getSpeciality().count)
        case .doctorClass:
            cell.lblCount.text = String(DBManager.shared.getDoctorClass().count)
        case .category:
            cell.lblCount.text = String(DBManager.shared.getCategory().count)
//        case .competitors:
//            cell.lblCount.text = String(DBManager.shared.getCompetitor().count)
        case .slideBrand:
            cell.lblCount.text = String(DBManager.shared.getSlideBrand().count)
        case .slideTheraptic:
            cell.lblCount.text = String(DBManager.shared.getSlideTheraptic().count)
        case .slideSpeciality:
            cell.lblCount.text = String(DBManager.shared.getSlideSpeciality().count)
        case .slides:
            cell.lblCount.text = String(DBManager.shared.getSlide().count)
        case .qualifications:
            cell.lblCount.text = String(DBManager.shared.getQualification().count)
        case .visitControl:
            cell.lblCount.text =  ""
            //String(DBManager.shared.getVisitControl().count)
        case .leaveType:
            cell.lblCount.text = String(DBManager.shared.getLeaveType().count)
        case .mappedCompetitors:
            cell.lblCount.text = String(DBManager.shared.getMapCompDet().count)
        case .docFeedback:
            cell.lblCount.text = String(DBManager.shared.getFeedback().count)
        case .holidays:
            cell.lblCount.text = String(DBManager.shared.getHolidays().count)
        case .weeklyOff:
            cell.lblCount.text = String(DBManager.shared.getWeeklyOff().count)
        case .tourPlanSetup:
            cell.lblCount.text =  ""
            //String(DBManager.shared.getTableSetUp().count)
         
        case .getTP:
//            cell.lblCount.text = !DBManager.shared.getTP().tourPlanArr.isEmpty ? "\(DBManager.shared.getTP().tourPlanArr[0].arrOfPlan.count)" : "0"
            cell.lblCount.text =  ""

        case   .headquartes:
          //  cell.lblCount.text = DBManager.shared.gethe
            cell.lblCount.text = ""
        case   .departments:
            cell.lblCount.text = "\(DBManager.shared.getDeparts().count)"
        case   .docTypes:
            cell.lblCount.text = ""
        case   .ratingDetails:
            cell.lblCount.text = ""
        case   .ratingFeedbacks:
            cell.lblCount.text = ""
        case   .speakerList:
            cell.lblCount.text = ""
        case   .participantList:
            cell.lblCount.text = ""
        case   .indicationList:
            cell.lblCount.text = ""
        case   .setups:
            cell.lblCount.text = ""
        case   .doctors:
            cell.lblCount.text = ""
        case   .institutions:
            cell.lblCount.text = ""
        case   .customSetup:
            cell.lblCount.text = ""
        case   .tourPlanStatus:
            cell.lblCount.text = ""
        case   .stockBalance:
            cell.lblCount.text =  ""
//            let balance = DBManager.shared.getStockBalance()
//            cell.lblCount.text = "\(balance?.product?.allObjects.count)"
        case   .empty:
            cell.lblCount.text = "Yet to"
        case   .syncAll:
            cell.lblCount.text = "sync All"
        case   .apptableSetup:
            cell.lblCount.text =  ""
        case   .homeSetup:
            cell.lblCount.text =  ""
            //\(DBManager.shared.getHomeData().count)
        case   .callSync:
            cell.lblCount.text = "Yet to"
        case   .dcrDateSync:
//           CoreDataManager.shared.fetchDcrDates(){ dcrDates in
//               cell.lblCount.text = "\(dcrDates.count)"
//            }
            cell.lblCount.text = ""
        case .none:
            cell.lblCount.text = "Yet to"

        case .productcategory:
            cell.lblCount.text = ""
 
        case .chemistCategory:
            cell.lblCount.text = ""
        }
     //   cell.lblCount.text = ""
        
        if MasterInfo.syncAll.rawValue == self.masterData[indexPath.row].rawValue {
            cell.isHidden = false
            cell.btnSync.isHidden = false
            cell.btnSync.setTitle("Sync \(self.masterData.first?.rawValue ?? "")", for: .normal)
        }else if MasterInfo.empty.rawValue == self.masterData[indexPath.row].rawValue {
            cell.isHidden = true
        }else{
            cell.isHidden = false
            cell.btnSync.isHidden = true
        }
        return cell
    }
    
    @objc func groupSyncAll(_ sender : UIButton){

        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            
            self.toSetupAlert(desc: "Check your Internet Connection", istoNavigate: false)
            
            return
        }
        
       
        
        self.isMaterSyncInProgress = true
        
        cacheMasterData = masterData
        
        let selectedMasterInfo = masterData

        // Set loading status based on MasterInfo for each element in the array
        var istoReturn: Bool = false
        selectedMasterInfo.forEach { masterInfo in
          
            if masterInfo == .slides  && Shared.instance.isSlideDownloading {
                self.toCreateToast("Slide downloading please wait..")
                istoReturn = true
            }
            
            MasterInfoState.loadingStatusDict[masterInfo] = .isLoading
        }
        
        if istoReturn {
            return
        }
        
        self.collectionView.reloadData()

        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // End the background task if the expiration handler is called
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        }
       
       // Perform API calls in the background
       DispatchQueue.global(qos: .userInitiated).async { [weak self] in
           guard let self = self else { return }
           
           self.fetchMasterDataRecursively(index: 0)
           
 
       }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
           
                self.toSetupAlert(desc: "Check your Internet Connection", istoNavigate: false)
                return
            
        }
        
        let selectedMasterInfo = masterData[indexPath.row]

           // Set loading status based on MasterInfo
           MasterInfoState.loadingStatusDict[selectedMasterInfo] = .isLoading
          self.collectionView.reloadData()
        
        
        // Begin a background task
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // End the background task if the expiration handler is called
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        }
       
       // Perform API calls in the background
       DispatchQueue.global(qos: .userInitiated).async { [weak self] in
           guard let self = self else { return }

           
             self.fetchmasterData(type: self.masterData[indexPath.row]) {isCompleted in
                 UIApplication.shared.endBackgroundTask(self.backgroundTask)
               if isCompleted {
                   MasterInfoState.loadingStatusDict[selectedMasterInfo] = .loaded
               } else {
                   MasterInfoState.loadingStatusDict[selectedMasterInfo] = .error
               }
               
                 DispatchQueue.main.async {
                     self.collectionView.reloadData()
                 }
              
           }
 
       }
        
        
 
    }
    

}


struct MasterCellData {
    
    var cellType : MasterCellType!
    var isSelected : Bool!
}
