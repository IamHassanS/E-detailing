//
//  SlideDownloadVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/05/24.
//


import UIKit
import Alamofire
import MobileCoreServices
import SSZipArchive


extension SlideDownloadVC: BackgroundTaskManagerDelegate {
    func didUpdate(rrayOfAllSlideObjects: [SlidesModel], index: Int, completion: @escaping () -> ()) {
        didDownloadCompleted(arrayOfAllSlideObjects: rrayOfAllSlideObjects, index: index, isForSingleSelection: false, isfrorBackgroundTask: true, istoreturn: false, didEncounterError: false) { _ in
            self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: rrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)
            completion()
        }
    }

}

extension SlideDownloadVC : MediaDownloaderDelegate {
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float) {
        print("Downloading...<--")
        isDownloading = true
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?) {
        print("success...<-")
        print("Download completed")
        isDownloading = false
         let params = arrayOfAllSlideObjects[self.loadingIndex]
            let data = data
            params.slideData = data ?? Data()
            params.isDownloadCompleted = true
            params.isFailed = false
            params.uuid = UUID()
      
        didDownloadCompleted(arrayOfAllSlideObjects: arrayOfAllSlideObjects, index: self.loadingIndex, isForSingleSelection: false, isfrorBackgroundTask: false, istoreturn: false, didEncounterError: false) {_ in
           
        self.delegate?.isBackgroundSyncInprogress(isCompleted: true, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)}
        
       // toDownloadMedia(index: self.loadingIndex, items: self.arrayOfAllSlideObjects)
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: Error) {
        isDownloading = false
        
            let params = arrayOfAllSlideObjects[self.loadingIndex]
             params.slideData =  Data()
             params.isDownloadCompleted = false
             params.isFailed = true
             params.uuid = UUID()
             LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: true)
        didDownloadCompleted(arrayOfAllSlideObjects: arrayOfAllSlideObjects, index: self.loadingIndex, isForSingleSelection: false, isfrorBackgroundTask: false, istoreturn: false, didEncounterError: true) {_ in
           
            self.delegate?.isBackgroundSyncInprogress(isCompleted: true, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)
            
        }
    }
    
    
}


extension SlideDownloadVC : SlideDownloaderCellDelegate {

    
    func didDownloadCompleted(arrayOfAllSlideObjects: [SlidesModel], index: Int, isForSingleSelection: Bool, isfrorBackgroundTask: Bool, istoreturn : Bool, didEncounterError: Bool,  completion: @escaping (Bool) -> Void) {
        
        
        if istoreturn {
            self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: true)
            completion(true)
            return
        }
        
  
        self.tableView.isUserInteractionEnabled = isForSingleSelection ?  false : true
        
   
        //!isDownloading
        //!isDownloading
      guard isDownloadingInProgress  else {
          return }
    
      self.loadingIndex = index + 1
      self.arrayOfAllSlideObjects = arrayOfAllSlideObjects

     
        switch isForSingleSelection {
            
        case true:
            isDownloading = false
      
            let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
            self.countLbl.text = "\(downloadedArr.count)/\( self.arrayOfAllSlideObjects .count)"
            let element = arrayOfAllSlideObjects[index]
            Shared.instance.showLoaderInWindow()
            CoreDataManager.shared.updateSlidesInCoreData(savedSlides: element) {  [weak self] isUpdated in
                guard let welf = self else {return}
                if isUpdated {
                  //  DispatchQueue.global().async {

                        DispatchQueue.main.async {
                            // Update UI on the main queue after background tasks are completed
                            welf.tableView.reloadData()
                           // LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "\(self.loadingIndex)")
                            welf.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: welf.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)
                            
                            if didEncounterError {
                                welf.isDownloadingInProgress = false
                                Shared.instance.isSlideDownloading = false
                                Shared.instance.iscelliterating = false
                                welf.isSlideDownloadCompleted = true
                                welf.isDownloading = false
                                welf.tableView.isUserInteractionEnabled = true
                                welf.tableView.isScrollEnabled = true
                                welf.closeHolderView.isUserInteractionEnabled = true
                                Shared.instance.removeLoaderInWindow()
                                return
                            }
                            
                            welf.toGroupSlidesBrandWise() { _ in
                                LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "")
                                LocalStorage.shared.setBool(.isSlidesGrouped, value: true)
                                welf.isDownloadingInProgress = false
                                Shared.instance.isSlideDownloading = false
                                Shared.instance.iscelliterating = false
                                welf.isSlideDownloadCompleted = true
                                welf.isDownloading = false
                                welf.tableView.isUserInteractionEnabled = true
                                welf.tableView.isScrollEnabled = true
                                welf.closeHolderView.isUserInteractionEnabled = true
                               Shared.instance.removeLoaderInWindow()
                              
                            }
                            
                     //   }
                    }
                }
            }
        case false:
            
            isDownloading = true
     
            let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
            self.countLbl.text = "\(downloadedArr.count)/\( self.arrayOfAllSlideObjects .count)"
            let aSlidesModel = arrayOfAllSlideObjects[index]

            CoreDataManager.shared.saveSlidesToCoreData(savedSlides: aSlidesModel)  { isInstanceSaved in
                if isInstanceSaved {

                    guard index + 1 < arrayOfAllSlideObjects.count else {
                        
                        //Shared.instance.showLoader(in: self.tableView, loaderType: .common)
                               
                                LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "")
                                self.delegate?.isBackgroundSyncInprogress(isCompleted: true, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)

                                self.checkifSyncIsCompleted(self.isFromlaunch) {
                                    Shared.instance.removeLoaderInWindow()
                                    if !isfrorBackgroundTask {
                                        self.tableView.reloadData()
                                        self.tableView.isScrollEnabled = true
                                        self.tableView.isUserInteractionEnabled = true
                                        Shared.instance.iscelliterating = false
                                        Shared.instance.isSlideDownloading = false
                                        if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesDownloadPending) {
                                          
                                            self.toSetupAlert(text: "Slides grouped successfully", isEncounteredError: false)
                                        } else {
                                            self.toSetupAlert(text: "Slides download pending please do retry later.", isEncounteredError: true)
                                           
                                        }
                                      
                                    } else {
                                        BackgroundTaskManager.shared.stopBackgroundTask()
                                    }
                                   // Shared.instance.removeLoader(in: self.tableView)
                                    completion(true)
                               
                                }
                        return
                    }
                    
                  
                    self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: false)
                    LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "\(self.loadingIndex)")
                    self.closeHolderView.isUserInteractionEnabled = true
                    Shared.instance.iscelliterating = false
                    if isfrorBackgroundTask {
                        completion(true)
                        return
                    }
                    self.tableView.reloadData()
                    self.toDownloadMedia(index: index + 1, items: arrayOfAllSlideObjects)
                }
            }



        }
 
    }

    
    
}


//if !isFromlaunch {
//    DispatchQueue.global().async {
//        // Perform subsequent tasks asynchronously on a background queue
//        self.toGroupSlidesBrandWise() { _ in
//            DispatchQueue.main.async {
//                // Update UI on the main queue after background tasks are completed
//               // self.tableView.reloadData()
//               // self.tableView.isUserInteractionEnabled = true
//              
//                self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false)
//                completion(true)
//            }
//        }
//    }
//} else {
//    self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false)
//}

protocol SlideDownloadVCDelegate: AnyObject {
    func retryDownload(slide: SlidesModel, completion: @escaping () -> ())
    func didDownloadCompleted()
    func isBackgroundSyncInprogress(isCompleted: Bool, cacheObject: [SlidesModel], isToshowAlert: Bool, didEncountererror: Bool)
    func didEncounterError()
}

typealias SlidesCallBack = (_ status: Bool) -> Void
 
class SlideDownloadVC : UIViewController {
    
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var slideHolderVIew: UIView!
    @IBOutlet var closeHolderView: UIView!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var titleLbl: UILabel!
    var isAlertShown: Bool = false
    weak var delegate: SlideDownloadVCDelegate?
    var mastersyncvm: MasterSyncVM?
    class func initWithStory(viewmodel: MasterSyncVM) -> SlideDownloadVC {
        let tourPlanVC : SlideDownloadVC = UIStoryboard.Hassan.instantiateViewController()
        tourPlanVC.mastersyncvm = viewmodel
        return tourPlanVC
    }
    var istoGroupBrandwise: Bool = false
    var isDownloadingInProgress : Bool = false
    var groupedBrandsSlideModel:  [GroupedBrandsSlideModel]?
    var arrayOfAllSlideObjects = [SlidesModel]()
    var extractedFileName: String?
    var loadingIndex: Int = 0
    var isSlideDownloadCompleted: Bool = false
    var isDownloading: Bool = false
    var isFromlaunch: Bool = false
  //  var isConnected = Bool()
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var isBackgroundTaskRunning: Bool = false
    var iscellIterating: Bool = false
    var isNewSlideExists: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    var slidesModel = [SlidesModel]()

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // isDownloadingInProgress = false
    }
    
    func startDownload(ifForsingleSeclection: Bool) {
      
         
         let cacheIndexstr: String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.slideDownloadIndex) == "" ? "\(0)" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.slideDownloadIndex)
         
         let cacheIndexInt: Int = Int(cacheIndexstr) ?? 0
        
        if ifForsingleSeclection {
            
        } else {
            toDownloadMedia(index: cacheIndexInt, items: arrayOfAllSlideObjects)
        }
        isDownloadingInProgress = true
      
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        isBackgroundTaskRunning = false
        backgroundTask = .invalid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupuUI()
        initVIew()
        let cacheIndexStr = LocalStorage.shared.getString(key: LocalStorage.LocalValue.slideDownloadIndex)
        if !cacheIndexStr.isEmpty  && !self.arrayOfAllSlideObjects.isEmpty {
            BackgroundTaskManager.shared.stopBackgroundTask()
            self.isDownloadingInProgress = false
            
          //   _ = toCheckExistenceOfNewSlides()
            
            
            
            toSetTableVIewDataSource()
            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                startDownload(ifForsingleSeclection: false)
            } else {
                self.toSetupAlert(text: "Connect to active network to Download slides", isEncounteredError: true)
            }
            
        } else if LocalStorage.shared.getBool(key: .isSlidesGrouped) {
            toSetTableVIewDataSource()
        } else {
            toLoadPresentationData(type: .slideBrand)
            toLoadPresentationData(type: .slides)
            
        }


    }
    
    func setupuUI() {
        let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
        
        self.countLbl.text = "\(downloadedArr.count)/\( self.arrayOfAllSlideObjects .count)"
        
        // LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: false)
        self.tableView.register(UINib(nibName: "SlideDownloaderCell", bundle: nil), forCellReuseIdentifier: "SlideDownloaderCell")
        titleLbl.setFont(font: .bold(size: .BODY))
        lblStatus.setFont(font: .bold(size: .BODY))
        slideHolderVIew.layer.cornerRadius = 5
        // slideHolderVIew.elevate(2)
        //  self.tableView.isScrollEnabled = true
        
    }
    
    func initVIew() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        
        closeHolderView.addTap {
            let existingCDSlides: [SlidesModel] = CoreDataManager.shared.retriveSavedSlides()
            let apiFetchedSlide: [SlidesModel] = self.arrayOfAllSlideObjects
            
            if existingCDSlides.count == apiFetchedSlide.count || existingCDSlides.count >= apiFetchedSlide.count {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: true)
            } else {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: false)
            }
            
            Pipelines.shared.toStopDownload()
            Shared.instance.isSlideDownloading = false
            Shared.instance.iscelliterating = false
            self.delegate?.didEncounterError()
            self.dismiss(animated: false)


        }
    }
    


    
    
    func toSetupAlert(text: String, isEncounteredError : Bool) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: text, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            self.isAlertShown = false
            print("no action")
            if isEncounteredError  {
                self.dismiss(animated: false) {
                    self.delegate?.didEncounterError()
                    Pipelines.shared.toStopDownload()
                    Shared.instance.isSlideDownloading = false
                    Shared.instance.iscelliterating = false
                }
               
            } else {
                self.dismiss(animated: false) {
                    self.delegate?.didDownloadCompleted()
                    Pipelines.shared.toStopDownload()
                    Shared.instance.isSlideDownloading = false
                    Shared.instance.iscelliterating = false
                }
            }
   
        }
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
               if let status = dict["Type"] as? String{
                   DispatchQueue.main.async {
                       if status == "No Connection" {
                        //   self.toSetPageType(.notconnected)
                           self.toCreateToast("Please check your internet connection.")
                       
                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                           self.delegate?.isBackgroundSyncInprogress(isCompleted: false, cacheObject: self.arrayOfAllSlideObjects, isToshowAlert: false, didEncountererror: true)
                          // self.toSetupRetryAction(index: self.loadingIndex, items: self.arrayOfAllSlideObjects, isConnected: self.isConnected)
                         //  self.checkAndShowAlertIfNeeded()
                           
                       } else if  status == "WiFi" || status ==  "Cellular"   {
                         
                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                           self.toCreateToast("You are now connected.")
                          // self.startDownload(ifForsingleSeclection: false)
                       }
                   }
               }
           }
    }
    
    // Your function or method where you need to show the alert
    func checkAndShowAlertIfNeeded() {
        // Check if the alert has already been shown
        if !self.isAlertShown {
            // Set the flag to true to prevent the alert from being shown again
            self.isAlertShown = true
            // Show the alert with the specified message
            self.toSetupAlert(text: "Internet connection is required to Download slides.", isEncounteredError: true)
            // Return to ensure the function exits after showing the alert
            return
        }

    }
    
    func toSetupRetryAction(index: Int, items : [SlidesModel], isConnected: Bool) {
        guard index >= 0, index < items.count else {

            return
        }

        self.arrayOfAllSlideObjects[index].isFailed = true
        self.tableView.reloadData()
        

    }
    

    @IBAction func CloseAction(_ sender: UIButton) {
        self.delegate?.didEncounterError()
        Shared.instance.iscelliterating = false
        Shared.instance.isSlideDownloading = false
        Pipelines.shared.toStopDownload()
        self.dismiss(animated: true)
    }

    func toCheckNetworkStatus() -> Bool {
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
          return true
        } else {
          return false
        }
    }
    
    func toSetTableVIewDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func toLoadPresentationData(type : MasterInfo) {
        
        let paramData = type == MasterInfo.slides ? LocalStorage.shared.getData(key: LocalStorage.LocalValue.slideResponse) :  LocalStorage.shared.getData(key: LocalStorage.LocalValue.BrandSlideResponse)
        //   var localParamArr = [[String: Any]]()
        //  var encodedSlideModelData: [SlidesModel]?
        
        var localParamArr = [[String:  Any]]()
        do {
            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as?  [[String:  Any]] ??  [[String:  Any]]()
            dump(localParamArr)
            
            
            
        } catch {
            //  self.toCreateToast("unable to retrive")
        }
        
        if type == .slides {
         //   let isNewSlideExists = toCheckExistenceOfNewSlides()
            if isNewSlideExists {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: false)
                toSetTableVIewDataSource()
                if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    self.startDownload(ifForsingleSeclection: false)
                } else {
                    self.toSetupAlert(text: "Connect to active network to Download slides", isEncounteredError: true)
                }
            
            } else {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: true)
                self.isSlideDownloadCompleted = true
                toSetTableVIewDataSource()
                self.countLbl.text = ""
            }

        }
        
    }
    
    func togroupSlides(completion: @escaping () -> ()) {
        self.closeHolderView.isHidden = false
        self.delegate?.didDownloadCompleted()
        self.countLbl.text = "Download completed.."
        completion()
    }


           
        
    
    
    
    func toDownloadMedia(index: Int, items: [SlidesModel], isForsingleRetry: Bool? = false) {

        Shared.instance.isSlideDownloading = true
       
   
        self.tableView.isUserInteractionEnabled =  false
        //!self.isDownloading
        guard index >= 0, index < items.count else {
            
            Shared.instance.isSlideDownloading = false
            isDownloadingInProgress = false
            self.tableView.isUserInteractionEnabled = true
            self.togroupSlides() {
                let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
                self.countLbl.text = "\(downloadedArr.count)/\( self.arrayOfAllSlideObjects .count)"
            }
            return
        }
        
        let indexPath = IndexPath(row: index , section: 0)
        
        scrollToItem(at: index, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? SlideDownloaderCell {
            Shared.instance.iscelliterating = true
            self.isDownloadingInProgress = true
            
            cell.toSendParamsToAPISerially(index: index, items: items, isForsingleRetry: isForsingleRetry)
            cell.delegate = self
           
        } else {
            Shared.instance.iscelliterating = false
            Shared.instance.isSlideDownloading = false
            print("Cant able to retrive cell.")
            self.tableView.isUserInteractionEnabled =  true
            isDownloadingInProgress = false
            
            let cacheIndexstr: String = LocalStorage.shared.getString(key: LocalStorage.LocalValue.slideDownloadIndex) == "" ? "\(0)" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.slideDownloadIndex)
            
            let cacheIndexInt: Int = Int(cacheIndexstr) ?? 0
            
            self.didDownloadCompleted(arrayOfAllSlideObjects: self.arrayOfAllSlideObjects, index: cacheIndexInt, isForSingleSelection: false, isfrorBackgroundTask: true, istoreturn: true, didEncounterError: false) {_ in
                //  BackgroundTaskManager.shared.stopBackgroundTask()
                self.toSetupAlert(text: "Slide download suspended please do retry manually.", isEncounteredError: true)
     
            }
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func toSendParamsToAPISerially(index: Int, items: [SlidesModel], isForsingleRetry: Bool? = false) {


        let params = items[index]
        let filePath = params.filePath
        let url =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.SlideURL)+filePath
        let type = mimeTypeForPath(path: url)
        params.utType = type
        
        // https://sanffa.info/Edetailing_files/DP/download/CC_VA_2021_.jpg
        
       // self.downloadData(mediaURL : url)
        Pipelines.shared.downloadData(mediaURL: url, delegate: self)
        
    }
    
    
    func scrollToItem(at index: Int, animated: Bool) {
        guard index >= 0, index < self.arrayOfAllSlideObjects.count else {
            return // Invalid index
        }
        
        let indexPath = IndexPath(row: index, section: 0) // Assuming single section
        tableView.scrollToRow(at: indexPath, at: .middle, animated: animated)
    }
    
    
    func toGroupSlidesBrandWise(completion: @escaping (Bool) -> Void) {
      //  Shared.instance.showLoaderInWindow()
        let allSlideObjects = CoreDataManager.shared.retriveSavedSlides()
        let brandSlideObjects = CoreDataManager.shared.retriveSavedBrandSlides()
        if brandSlideObjects.isEmpty {
            completion(true)
            return
        }
        CoreDataManager.shared.removeAllGeneralGroupedSlides()

        var groupedBrandsSlideModels = brandSlideObjects.compactMap { brandSlideModel -> GroupedBrandsSlideModel? in
            let brandSlides = allSlideObjects.filter { $0.code == brandSlideModel.productBrdCode }

            guard !brandSlides.isEmpty else {
                print("No slides found for iterated Brand code: \(brandSlideModel.productBrdCode)")
                return nil
            }
            
            print("slides found for iterated Brand code: \(brandSlideModel.productBrdCode)")
            let groupedBrandModel = GroupedBrandsSlideModel()
            groupedBrandModel.groupedSlide = brandSlides
            groupedBrandModel.priority = brandSlideModel.priority
            groupedBrandModel.divisionCode = brandSlideModel.divisionCode
            groupedBrandModel.productBrdCode = brandSlideModel.productBrdCode
            groupedBrandModel.subdivisionCode = brandSlideModel.subdivisionCode
            groupedBrandModel.id = brandSlideModel.id

            return groupedBrandModel
        }

        processBrandsSlideModels(groupedBrandsSlideModels: groupedBrandsSlideModels, index: 0) { _ in
            completion(true)
        }
        
    }
    
    func processBrandsSlideModels(groupedBrandsSlideModels:  [GroupedBrandsSlideModel],index: Int, completion: @escaping (Bool) -> Void) {
        guard index < groupedBrandsSlideModels.count else {
            // Base case: All items processed, notify completion
            completion(true)
            return
        }
        
        let groupedBrandModel = groupedBrandsSlideModels[index]
        
        tounArchiveData(aGroupedBrandsSlideModel: groupedBrandModel) { isSaved in
            // Continue with next iteration
            if isSaved {
                self.processBrandsSlideModels(groupedBrandsSlideModels: groupedBrandsSlideModels, index: index + 1, completion: completion)
            } else {
                completion(false) // Or handle failure appropriately
            }
        }
    }
    
    
    func tounArchiveData(aGroupedBrandsSlideModel: GroupedBrandsSlideModel, completion: @escaping (Bool) -> Void) {

        
        var modifiedZipgropedBrandModels = [GroupedBrandsSlideModel]()
  
        processSlides(index: 0, groupedBrandsSlideModel: aGroupedBrandsSlideModel) {  modifiedModels in
    
            modifiedZipgropedBrandModels.append(modifiedModels)
            
            self.saveModifiedModelsToCoreData(tempGroupedBrandsSlideModels: modifiedZipgropedBrandModels, index: 0) { _ in
                completion(true)
                
            }
           
        }
    }
    
    
    func processSlides(index: Int, groupedBrandsSlideModel: GroupedBrandsSlideModel, completion: @escaping (GroupedBrandsSlideModel) -> Void) {
      
        
        
     //   var modifiedModels = GroupedBrandsSlideModel()
        guard index < groupedBrandsSlideModel.groupedSlide.count else {
            // All slides processed
            completion(groupedBrandsSlideModel)
            return
        }
        
        let aSlidesModel = groupedBrandsSlideModel.groupedSlide[index]
        
        if aSlidesModel.utType == "application/zip" || aSlidesModel.fileType == "H" {
          let data =  unarchiveAndGetData(from: aSlidesModel.slideData)
         let groupedSlide = self.toExtractSlidesFromUnzippedContent(data: data, aSlidesModel: aSlidesModel)
                
                groupedBrandsSlideModel.groupedSlide[index] = groupedSlide.first ??  SlidesModel()
                
                processSlides(index: index + 1, groupedBrandsSlideModel: groupedBrandsSlideModel, completion: completion)
            
        } else {
            // Process the next slide
            processSlides(index: index + 1, groupedBrandsSlideModel: groupedBrandsSlideModel, completion: completion)
        }
    }
    
    func saveModifiedModelsToCoreData(tempGroupedBrandsSlideModels: [GroupedBrandsSlideModel], index: Int, completion: @escaping (Bool) -> Void) {
        guard index < tempGroupedBrandsSlideModels.count else {
            // All models are saved
            completion(true)
            return
        }
        
        let aGroupedBrandsSlideModel = tempGroupedBrandsSlideModels[index]
        CoreDataManager.shared.toSaveGeneralGroupedSlidesToCoreData(groupedBrandSlide: aGroupedBrandsSlideModel) { isSaved in
            if isSaved {
                // Move to the next model
                self.saveModifiedModelsToCoreData(tempGroupedBrandsSlideModels: tempGroupedBrandsSlideModels, index: index + 1, completion: completion)
            } else {
                // Handle failure
                completion(false)
            }
        }
    }
    


    func toExtractSlidesFromUnzippedContent(data: UnzippedDataInfo, aSlidesModel: SlidesModel) -> [SlidesModel] {
        if !data.videofiles.isEmpty {
            var slidesModelArr = [SlidesModel]()
            data.imagefiles.enumerated().forEach { enumeratedIndex, data in
                let aGroupedSlide = SlidesModel()
                aGroupedSlide.code = (aSlidesModel.code)
                aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                aGroupedSlide.isFailed = aSlidesModel.isFailed
                aGroupedSlide.code =   (aSlidesModel.code)
                aGroupedSlide.camp = (aSlidesModel.camp)
                aGroupedSlide.productDetailCode = aSlidesModel.productDetailCode
                //  aGroupedSlide.filePath = extractedfileURL ?? ""
                aGroupedSlide.group = (aSlidesModel.group)
                aGroupedSlide.specialityCode = aSlidesModel.specialityCode
                aGroupedSlide.slideId = (aSlidesModel.slideId)
                aGroupedSlide.fileType = aSlidesModel.fileType
                // aGroupedSlidedel.effFrom = effFrom = DateI
                aGroupedSlide.categoryCode = aSlidesModel.categoryCode
                aGroupedSlide.name = aSlidesModel.name
                aGroupedSlide.fileName = aSlidesModel.filePath
                aGroupedSlide.noofSamples = (aSlidesModel.noofSamples)
                aGroupedSlide.ordNo = (aSlidesModel.ordNo)
                aGroupedSlide.priority = (aSlidesModel.priority)
                aGroupedSlide.slideData = data.fileData ?? Data()
                aGroupedSlide.utType = data.filetype ?? "image/jpeg"
                aGroupedSlide.isSelected = aSlidesModel.isSelected
                aGroupedSlide.isFailed = aSlidesModel.isFailed
                aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                slidesModelArr.append(aGroupedSlide)
            }

            return slidesModelArr
           } else if !data.imagefiles.isEmpty {
               var slidesModelArr = [SlidesModel]()
               data.imagefiles.enumerated().forEach { enumeratedIndex, data in
                   let aGroupedSlide = SlidesModel()
                   aGroupedSlide.code = (aSlidesModel.code)
                   aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                   aGroupedSlide.isFailed = aSlidesModel.isFailed
                   aGroupedSlide.code =   (aSlidesModel.code)
                   aGroupedSlide.camp = (aSlidesModel.camp)
                   aGroupedSlide.productDetailCode = aSlidesModel.productDetailCode
                   //  aGroupedSlide.filePath = extractedfileURL ?? ""
                   aGroupedSlide.group = (aSlidesModel.group)
                   aGroupedSlide.specialityCode = aSlidesModel.specialityCode
                   aGroupedSlide.slideId = (aSlidesModel.slideId)
                   aGroupedSlide.fileType = aSlidesModel.fileType
                   // aGroupedSlidedel.effFrom = effFrom = DateI
                   aGroupedSlide.categoryCode = aSlidesModel.categoryCode
                   aGroupedSlide.name = aSlidesModel.name
                   aGroupedSlide.fileName = aSlidesModel.filePath
                   aGroupedSlide.noofSamples = (aSlidesModel.noofSamples)
                   aGroupedSlide.ordNo = (aSlidesModel.ordNo)
                   aGroupedSlide.priority = (aSlidesModel.priority)
                   aGroupedSlide.slideData = data.fileData ?? Data()
                   aGroupedSlide.utType = data.filetype ?? "image/jpeg"
                   aGroupedSlide.isSelected = aSlidesModel.isSelected
                   aGroupedSlide.isFailed = aSlidesModel.isFailed
                   aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                   slidesModelArr.append(aGroupedSlide)
               }
               return slidesModelArr
           } else if !data.htmlfiles.isEmpty {
               var slidesModelArr = [SlidesModel]()
               data.htmlfiles.enumerated().forEach { enumeratedIndex, data in
                   let aGroupedSlide = SlidesModel()
                   aGroupedSlide.code = (aSlidesModel.code)
                   aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                   aGroupedSlide.isFailed = aSlidesModel.isFailed
                   aGroupedSlide.code =   (aSlidesModel.code)
                   aGroupedSlide.camp = (aSlidesModel.camp)
                   aGroupedSlide.productDetailCode = aSlidesModel.productDetailCode
                   //  aGroupedSlide.filePath = extractedfileURL ?? ""
                   aGroupedSlide.group = (aSlidesModel.group)
                   aGroupedSlide.specialityCode = aSlidesModel.specialityCode
                   aGroupedSlide.slideId = (aSlidesModel.slideId)
                   aGroupedSlide.fileType = aSlidesModel.fileType
                   // aGroupedSlidedel.effFrom = effFrom = DateI
                   aGroupedSlide.categoryCode = aSlidesModel.categoryCode
                   aGroupedSlide.name = aSlidesModel.name
                   aGroupedSlide.fileName = data.fileName ?? "No name"
                   if let url = data.htmlFileURL {
                       //htmlFileURL
                       aGroupedSlide.filePath = "\(url)"
                       //.absoluteString
                   } else {

                       print("htmlFileURL is nil")
                   }
                   aGroupedSlide.noofSamples = (aSlidesModel.noofSamples)

                   aGroupedSlide.ordNo = (aSlidesModel.ordNo)
                   aGroupedSlide.priority = (aSlidesModel.priority)
                   aGroupedSlide.slideData = data.fileData ?? Data()
                   aGroupedSlide.utType = "text/html"
                   aGroupedSlide.isFailed = aSlidesModel.isFailed
                   aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
                   aGroupedSlide.isSelected = aSlidesModel.isSelected
                   slidesModelArr.append(aGroupedSlide)

               }
               return slidesModelArr
           } else   {
               var slidesModelArr = [SlidesModel]()
               let aGroupedSlide = SlidesModel()
               aGroupedSlide.code = (aSlidesModel.code)
               aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
               aGroupedSlide.isFailed = aSlidesModel.isFailed
               aGroupedSlide.code =   (aSlidesModel.code)
               aGroupedSlide.camp = (aSlidesModel.camp)
               aGroupedSlide.productDetailCode = aSlidesModel.productDetailCode
               //  aGroupedSlide.filePath = extractedfileURL ?? ""
               aGroupedSlide.group = (aSlidesModel.group)
               aGroupedSlide.specialityCode = aSlidesModel.specialityCode
               aGroupedSlide.slideId = (aSlidesModel.slideId)
               aGroupedSlide.fileType = aSlidesModel.fileType
               // aGroupedSlidedel.effFrom = effFrom = DateI
               aGroupedSlide.categoryCode = aSlidesModel.categoryCode
               aGroupedSlide.name = aSlidesModel.name
               aGroupedSlide.fileName = aSlidesModel.filePath
               aGroupedSlide.noofSamples = (aSlidesModel.noofSamples)
               aGroupedSlide.ordNo = (aSlidesModel.ordNo)
               aGroupedSlide.priority = (aSlidesModel.priority)
               aGroupedSlide.slideData =  Data()
               aGroupedSlide.utType = ""
               
        
               aGroupedSlide.imageData = Data()
              
               
               aGroupedSlide.isSelected = aSlidesModel.isSelected
               aGroupedSlide.isFailed = aSlidesModel.isFailed
               aGroupedSlide.isDownloadCompleted = aSlidesModel.isDownloadCompleted
               slidesModelArr.append(aGroupedSlide)
               return slidesModelArr
           }
               
            


    }
    
//    func checkifSyncIsCompleted(_ isFromLaunch: Bool, completion: @escaping () -> ()){
//        let existingCDSlides: [SlidesModel] = CoreDataManager.shared.retriveSavedSlides()
//
//        let apiFetchedSlide: [SlidesModel] = self.arrayOfAllSlideObjects
//        
//        let existingSlideIds = Set(existingCDSlides.map { $0.slideId })
//        
//        let nonExistingSlides = apiFetchedSlide.filter { !existingSlideIds.contains($0.slideId) ||  !$0.isDownloadCompleted }
//        
//       if nonExistingSlides.isEmpty {
//           LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: true)
//           self.isDownloading = false
//           isSlideDownloadCompleted = true
//           Shared.instance.showLoaderInWindow()
//           toGroupSlidesBrandWise() { _ in
//               
//               LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesGrouped, value: true)
//               Shared.instance.removeLoaderInWindow()
//               completion()
//           }
//           } else {
//               LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: false)
//               LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "")
//               self.isDownloading = false
//               isSlideDownloadCompleted = false
//               Shared.instance.showLoaderInWindow()
//               toGroupSlidesBrandWise() { _ in
//                   
//                   LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesGrouped, value: false)
//                   Shared.instance.removeLoaderInWindow()
//                   completion()
//               }
//           }
//    }

    
    
    func checkifSyncIsCompleted(_ isFromLaunch: Bool, completion: @escaping () -> ()){
        let existingCDSlides: [SlidesModel] = CoreDataManager.shared.retriveSavedSlides()
        let apiFetchedSlide: [SlidesModel] = self.arrayOfAllSlideObjects
        
        if existingCDSlides.count == apiFetchedSlide.count {
           
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: false)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: true)
            self.isDownloading = false
            isSlideDownloadCompleted = true
            Shared.instance.showLoaderInWindow()
            toGroupSlidesBrandWise() { _ in
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesGrouped, value: true)
            Shared.instance.removeLoaderInWindow()
            completion()
            }
        }
    }
    
    func unarchiveAndGetData(from zipData: Data) -> UnzippedDataInfo {
        guard let temporaryDirectoryURL = createTemporaryDirectory() else {
            print("Failed to create temporary directory.")
            return UnzippedDataInfo()
        }

        guard let zipFilePath = saveZipData(to: temporaryDirectoryURL, data: zipData) else {
            print("Failed to save zip data to temporary file.")
            return UnzippedDataInfo()
        }

        guard let extractedFolderPath = unzipFile(at: temporaryDirectoryURL, zipFilePath: zipFilePath) else {
            print("Failed to unzip file.")
            return UnzippedDataInfo()
        }

        var unzippedDataInfo = UnzippedDataInfo()
        var aHTMLinfoArr = [HTMLinfo]()
        var dataArray: Data = Data()

        // Get the contents of the extracted folder
        if let contents = try? FileManager.default.contentsOfDirectory(at: extractedFolderPath, includingPropertiesForKeys: nil, options: []) {
            // Enumerate through the contents
            for fileURL in contents {
                var aHTMLinfo = HTMLinfo()
                print("File URL: \(fileURL)")
                print("File Name: \(fileURL.lastPathComponent)")
                let fileNameWithoutExtension = fileURL.deletingPathExtension().lastPathComponent
                print("File Name (without extension): \(fileNameWithoutExtension)")
                
                // Create a valid file URL
                let validFileURL = URL(fileURLWithPath: fileURL.path)
                let result: (htmlString: String?, htmlFileURL: URL?) = readHTMLFile(inDirectory: validFileURL.path)
                guard result.htmlFileURL != nil, result.htmlString != nil else {
                    
                    let unzippedFolderURL = URL(fileURLWithPath: extractedFolderPath.absoluteString)
                    let unzippedDataInfo = extractUnzippedDataInfo(from: unzippedFolderURL)
                    
                    return unzippedDataInfo
                }
                extractedFileName = fileNameWithoutExtension
                dataArray = findImageData(inDirectory: validFileURL) ?? Data()
                aHTMLinfo.fileData = dataArray
                let fileName = "index.html"
                aHTMLinfo.htmlFileURL = extractedFolderPath.appendingPathComponent(fileNameWithoutExtension).appendingPathComponent(fileName)
                //validFileURL
                aHTMLinfo.htmlString = result.htmlString
                aHTMLinfo.fileName = extractedFileName
                aHTMLinfoArr.append(aHTMLinfo)
                unzippedDataInfo.htmlfiles.append(contentsOf: aHTMLinfoArr)
                return unzippedDataInfo
            }
        }
        
       // let unzippedDataInfo = extractUnzippedDataInfo(from: extractedFolderPath)
        removeTemporaryDirectory(at: temporaryDirectoryURL)

        return unzippedDataInfo
    }
    
    private func createTemporaryDirectory() -> URL? {
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        do {
            try FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            return temporaryDirectoryURL
        } catch {
            print("Error creating temporary directory: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveZipData(to directoryURL: URL, data: Data) -> URL? {
        let zipFilePath = directoryURL.appendingPathComponent("temp.zip")
        do {
            try data.write(to: zipFilePath)
            return zipFilePath
        } catch {
            print("Error saving zip data to temporary file: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func unzipFile(at temporaryDirectoryURL: URL, zipFilePath: URL) -> URL? {
        let extractedFolderName = "ExtractedContent"
        let extractedFolderPath = temporaryDirectoryURL.appendingPathComponent(extractedFolderName)

        do {
            try FileManager.default.createDirectory(at: extractedFolderPath, withIntermediateDirectories: true, attributes: nil)
            SSZipArchive.unzipFile(atPath: zipFilePath.path, toDestination: extractedFolderPath.path)
            print("File unzipped successfully.")
            return extractedFolderPath
        } catch {
            print("Error unzipping file: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func removeTemporaryDirectory(at directoryURL: URL) {
        do {
            try FileManager.default.removeItem(at: directoryURL)
        } catch {
            print("Error removing temporary directory: \(error.localizedDescription)")
        }
    }

    
    func extractUnzippedDataInfo(from folderURL: URL) -> UnzippedDataInfo {
        var unzippedDataInfo = UnzippedDataInfo()

        do {
            let contents = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
            
            for fileURL in contents {
                let mimeType = mimeTypeForPath(path: fileURL.path)
                
                if mimeType.hasPrefix("video") {
                    var videoInfo = Videoinfo()
                    videoInfo.fileData = try? Data(contentsOf: fileURL)
                    videoInfo.filetype = mimeType
                    unzippedDataInfo.videofiles.append(videoInfo)
                } else if mimeType.hasPrefix("image") {
                    var imageInfo = Imageinfo()
                    imageInfo.fileData = try? Data(contentsOf: fileURL)
                    imageInfo.filetype = mimeType
                    unzippedDataInfo.imagefiles.append(imageInfo)
                }
            }
        } catch {
            print("Error reading contents of the unzipped folder: \(error)")
        }

        return unzippedDataInfo
    }
    
    func readHTMLFile(inDirectory directoryPath: String) -> (htmlString: String?, htmlFileURL: URL?) {
        do {
            // Get the list of files in the directory
            let fileManager = FileManager.default
            let files = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            // Find the HTML file in the list of files
            if let htmlFileName = files.first(where: { $0.hasSuffix(".html") }) {
                let htmlFilePath = (directoryPath as NSString).appendingPathComponent(htmlFileName)
                let htmlFileURL = URL(fileURLWithPath: htmlFilePath)
                let htmlString = try String(contentsOfFile: htmlFilePath, encoding: .utf8)
                return (htmlString, htmlFileURL)
            } else {
                print("No HTML file found in the directory.")
                return (nil, nil)
            }
        } catch {
            print("Error reading HTML file: \(error)")
            return (nil, nil)
        }
    }
    
    
    
    
    
    
    func findImageData(inDirectory directoryURL: URL) -> Data? {
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            for itemURL in contents {
                // Check if the file is an image file (you can customize this check based on your file types)
                if isImageFile(itemURL) {
                    if let fileData = try? Data(contentsOf: itemURL) {
                        return fileData
                    }
                }
            }
        } catch {
            print("Error while accessing contents of directory: \(error)")
        }
        
        return nil
    }
    
    func isImageFile(_ fileURL: URL) -> Bool {
        let imageFileExtensions = ["jpg", "jpeg", "png", "gif", "bmp"] // Add more extensions as needed

        let fileExtension = fileURL.pathExtension.lowercased()
        return imageFileExtensions.contains(fileExtension)
    }

    func isMediaFile(_ fileURL: URL) -> Bool {
        let mediaFileExtensions = ["jpg", "jpeg", "png"] // Add more extensions as needed
        //, "gif", "mp4", "mov", "avi", "html"
        let fileExtension = fileURL.pathExtension.lowercased()
        return mediaFileExtensions.contains(fileExtension)

    }
    
    func downloadData(mediaURL: String, competion: @escaping (Data?, Error?) -> Void) {
//        let downloader = MediaDownloader()
//        let mediaURL = URL(string: mediaURL)!
//        downloader.downloadMedia(from: mediaURL) { (data, error) in
//            competion(data, error)
//        }
    }
}


extension SlideDownloadVC : tableViewProtocols {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAllSlideObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideDownloaderCell", for: indexPath) as! SlideDownloaderCell
        let model = arrayOfAllSlideObjects[indexPath.row]
        cell.lblName.text = arrayOfAllSlideObjects[indexPath.row].filePath
        if model.isDownloadCompleted  {
            cell.toSetupDoenloadedCell(false)
            //indexPath.row == 0 ? false : true
        } else if model.isFailed {
            cell.toSetupErrorCell(false)
        } else {
            cell.toSetupDownloadingCell(model.slideData.isEmpty ? false : true)
        }
        
 
        cell.btnRetry.addTap { [weak self] in
            guard let welf = self else {return}
            if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                welf.toCreateToast("Check your Internet Connection")
                return
            }
           
            if Shared.instance.isSlideDownloading {return}
            welf.isDownloadingInProgress = true
            
            
            guard let model = self?.arrayOfAllSlideObjects[indexPath.row]  else {
                return
            }
            
            welf.delegate?.retryDownload(slide: model) {
                welf.toDownloadMedia(index: indexPath.row, items: self?.arrayOfAllSlideObjects ?? [SlidesModel](), isForsingleRetry: true)
            }
            
         //
         
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 5
    }
    
    
}
