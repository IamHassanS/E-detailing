//
//  Appdelegate+Ex.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 31/01/24.
//

import Foundation
import MobileCoreServices
import SSZipArchive
import CoreData



extension MasterSyncVC {
    
    enum PageType {
        case loading
        case loaded
        case navigate
    }
    
    func setLoader(pageType: PageType, type: MasterInfo? = nil) {
        switch pageType {
        case .loading:
            Shared.instance.showLoaderInWindow()
        case .loaded:
            Shared.instance.removeLoaderInWindow()
        case .navigate:
            Shared.instance.removeLoaderInWindow()
            if isFromLaunch {
                if (type == .slides || type == .slideBrand) {
 
                    moveToDownloadSlide(isFromcache: true)
                    
                } else {
                    moveToHome()
                }
            
            } else  if (type == .slides) {
            _ = toCheckExistenceOfNewSlides(didEncountererror: false)
              //  let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.slideResponse)
              //  let localParamArr = parseParamData(paramData)
              //  arrayOfAllSlideObjects = decodeSlideObjects(from: localParamArr)
                removeNonExistingSlides(from: arrayOfAllSlideObjects)
                    if isNewSlideExists {
                        moveToDownloadSlide(isFromcache: true)
                    }
                    
                
           
            } else {
                moveToHome()
            }

            
        
        }
    }
    
    func moveToHome() {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: MainVC.initWithStory(isfromLaunch: true, ViewModel: UserStatisticsVM()))
            }
    }
    
    func toCheckExistenceOfNewSlides(didEncountererror: Bool) -> Bool? {
        if didEncountererror {
            showDownloadRetryUI()
            return false
        }

     let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.slideResponse)


        let localParamArr = parseParamData(paramData)

        if localParamArr.isEmpty {
            print("No data found in localParamArr")
            return false
        }

        arrayOfAllSlideObjects = decodeSlideObjects(from: localParamArr)

        let existingCDSlides: [SlidesModel] = CoreDataManager.shared.retriveSavedSlides()

        if arrayOfAllSlideObjects.isEmpty {
            arrayOfAllSlideObjects.append(contentsOf: existingCDSlides)
        }
        
        let nonExistingSlides = findNonExistingSlides(in: existingCDSlides, from: arrayOfAllSlideObjects)
       
        let notDownloadedSlides = existingCDSlides.filter { !$0.isDownloadCompleted }

        isNewSlideExists = !notDownloadedSlides.isEmpty || !nonExistingSlides.isEmpty
        
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: isNewSlideExists)
        
        updateSlideObjects(existingSlides: existingCDSlides, nonExistingSlides: nonExistingSlides)

        return handleSlideDownloadStatus(nonExistingSlides: nonExistingSlides)
    }
    
    
    func removeNonExistingSlides(from apiFetchedSlides: [SlidesModel]) {
        CoreDataManager.shared.fetchSlides { savedCDslides in
            let nonExistingSlidesIds = findNonExistingSlides(in: savedCDslides, from: apiFetchedSlides)
            
            let slidesToRemove = savedCDslides.filter { slide in
                nonExistingSlidesIds.contains(Int(slide.slideId))
            }
            removeSlides(slidesToRemove)
        }
    }
    
    func removeSlides(_ slides: [SlidesCDModel]) {
        let context = context // Ensure context is correctly set up
        
        // Begin a batch operation to handle all deletions
        context.perform {
            for slide in slides {
                context.delete(slide)
            }
            
            do {
                // Save context after all deletions
                try context.save()
                print("Successfully removed and saved slides.")
            } catch {
                print("Failed to remove slides: \(error)")
            }
        }
    }

 
    

    private func showDownloadRetryUI() {
        slideDownloadStatusLbl.isHidden = false
        downloadingBottomView.isHidden = false
        retryVIew.isHidden = false
        slideDownloadStatusLbl.text = "Tap to retry slide download"
    }

    private func parseParamData(_ paramData: Data) -> [[String: Any]] {
        do {
            return try JSONSerialization.jsonObject(with: paramData, options: []) as? [[String: Any]] ?? []
        } catch {
            print("Failed to parse paramData")
            return []
        }
    }

    private func decodeSlideObjects(from localParamArr: [[String: Any]]) -> [SlidesModel] {
        var slideObjects = [SlidesModel]()

        for dictionary in localParamArr {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
               let model = try? JSONDecoder().decode(SlidesModel.self, from: jsonData) {
                model.uuid = UUID()
                slideObjects.append(model)
            } else {
                print("Failed to decode dictionary into SlidesModel")
            }
        }

        return slideObjects
    }

//    private func findNonExistingSlides(in existingCDSlides: [SlidesModel], from apiFetchedSlides: [SlidesModel]) -> [SlidesModel] {
//        let existingSlideIds = Set(existingCDSlides.map { $0.slideId })
//        return apiFetchedSlides.filter { !existingSlideIds.contains($0.slideId) }
//    }
    private func findNonExistingSlides(in existingCDSlides: [SlidesModel], from apiFetchedSlides: [SlidesModel]) -> [SlidesModel] {
        
        let apiSlideIds = Set(apiFetchedSlides.map { $0.slideId })
        let apiSlideNames = Set(apiFetchedSlides.map { $0.filePath })
        // Filter out slides from existingCDSlides whose slideId is not in apiSlideIds
        let filteredExistingCDSlides = existingCDSlides.filter { apiSlideIds.contains($0.slideId) }
        
        // Find the slides in apiFetchedSlides that are not in filteredExistingCDSlides
        let existingSlideIds = Set(filteredExistingCDSlides.map { $0.slideId })
        let existingSlideNames = Set(filteredExistingCDSlides.map { $0.filePath })
        
       // let nonExistingSlides = apiFetchedSlides.filter { !existingSlideIds.contains($0.slideId) }
        let nonExistingSlides = apiFetchedSlides.filter { !existingSlideIds.contains(Int($0.slideId)) || !existingSlideNames.contains($0.filePath)  }
        
        let nonExistingSlidesCD = existingCDSlides.filter { !apiSlideIds.contains(Int(Int16($0.slideId))) || !apiSlideNames.contains($0.filePath) }
        
        // Get the common slides between nonExistingSlides and nonExistingSlidesCD based on slideId
        let commonSlides = findCommonSlidesBySlideId(nonExistingSlides: nonExistingSlides, nonExistingSlidesCD: nonExistingSlidesCD)
        
        return commonSlides
 
        
      
        
    }
    
    private func findCommonSlidesBySlideId(nonExistingSlides: [SlidesModel], nonExistingSlidesCD: [SlidesModel]) -> [SlidesModel] {
        // Create a set of slideIds from nonExistingSlidesCD to identify common elements
        let nonExistingCDSlideIds = Set(nonExistingSlidesCD.map { $0.slideId })
        
        // Filter nonExistingSlides to include only those slides whose slideId exists in nonExistingSlidesCD
        let commonSlides = nonExistingSlides.filter { nonExistingCDSlideIds.contains($0.slideId) }
        
        // If no common slides are found, return all nonExistingSlides
        if commonSlides.isEmpty {
            return nonExistingSlides + nonExistingSlidesCD
        }
        
        return commonSlides
    }


    
    
    private func findNonExistingSlides(in existingCDSlides: [SlidesCDModel], from apiFetchedSlides: [SlidesModel]) -> [Int] {
        
        let apiSlideIds = Set(apiFetchedSlides.map { $0.slideId })
        
        let apiSlideNames = Set(apiFetchedSlides.map { $0.filePath })
        
        // Filter out slides from existingCDSlides whose slideId is not in apiSlideIds
        let filteredExistingCDSlides = existingCDSlides.filter { apiSlideIds.contains(Int($0.slideId)) }
        
        // Find the slides in apiFetchedSlides that are not in filteredExistingCDSlides
        let existingSlideIds = Set(filteredExistingCDSlides.map { $0.slideId })
        
        
        let existingSlideNames = Set(filteredExistingCDSlides.map { $0.filePath })

        let nonExistingSlides = apiFetchedSlides.filter { !existingSlideIds.contains(Int16($0.slideId)) || !existingSlideNames.contains($0.filePath)  }
        
        let nonExistingSlidesCD = existingCDSlides.filter { !apiSlideIds.contains(Int(Int16($0.slideId))) || !apiSlideNames.contains($0.filePath ?? "") }
        
        return nonExistingSlides.map { Int($0.slideId) } + nonExistingSlidesCD.map { Int($0.slideId) }
        
    }
    

    private func updateSlideObjects(existingSlides: [SlidesModel], nonExistingSlides: [SlidesModel]) {
        // Create a set of slideIds from existingSlides
       // var existingSlideDict = Dictionary(uniqueKeysWithValues: existingSlides.map { ($0.slideId, $0) })
        var existingSlideDict = existingSlides.reduce(into: [Int: SlidesModel]()) { dict, slide in
            dict[slide.slideId] = slide
        }
        // Filter nonExistingSlides to include only those slides whose slideId is in existingSlides
        let existingSlideIds = Set(existingSlides.map { $0.slideId })
        
        let commonSlides = nonExistingSlides.filter { existingSlideIds.contains($0.slideId) }
        
        // If no common slides are found, consider all nonExistingSlides
        let slidesToAdd = commonSlides.isEmpty ? nonExistingSlides + existingSlides : commonSlides
        
        // Update existingSlides with slides from slidesToAdd (replacing slides with same slideId)
        for slide in slidesToAdd {
            existingSlideDict[slide.slideId] = slide
        }
        
        // Clear the array and append unique slides (i.e., existing slides + updated slidesToAdd)
        arrayOfAllSlideObjects.removeAll()
        
        arrayOfAllSlideObjects.append(contentsOf: Array(existingSlideDict.values))
    }

    private func handleSlideDownloadStatus(nonExistingSlides: [SlidesModel]) -> Bool? {
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesDownloadPending) || isNewSlideExists {
            slideDownloadStatusLbl.text = "Tap to retry slide download"
            retryVIew.isHidden = false
            return true
        }

        if !LocalStorage.shared.getBool(key: .isSlidesLoaded) || !LocalStorage.shared.getBool(key: .isSlidesGrouped) {
            if nonExistingSlides.isEmpty {
                showSlideViewUI()
                return false
            } else {
                slideDownloadStatusLbl.text = "Tap to retry slide download"
                retryVIew.isHidden = false
                return true
            }
        }

        if !nonExistingSlides.isEmpty {
            showDownloadingUI()

            if Shared.instance.isSlideDownloading {
                slideDownloadStatusLbl.text = "Slides download in progress..."
                retryVIew.isHidden = true
            } else if isfromHome {
                slideDownloadStatusLbl.text = "Tap to retry slide download"
                retryVIew.isHidden = false
            } else {
                hideSlideDownloadUI()
            }

            return true
        }

        showSlideViewUI()
        return false
    }

    private func showSlideViewUI() {
        slideDownloadStatusLbl.isHidden = false
        retryVIew.isHidden = true
        downloadingBottomView.isHidden = false
        slideDownloadStatusLbl.text = "View slides"
    }

    private func showDownloadingUI() {
        slideDownloadStatusLbl.isHidden = false
        downloadingBottomView.isHidden = false
    }

    private func hideSlideDownloadUI() {
        slideDownloadStatusLbl.isHidden = true
        retryVIew.isHidden = true
        downloadingBottomView.isHidden = true
    }
    
//    func toCheckExistenceOfNewSlides(didEncountererror: Bool) -> Bool? {
//        if didEncountererror {
//            slideDownloadStatusLbl.isHidden  =  false
//            downloadingBottomView.isHidden =  false
//            retryVIew.isHidden = false
//            slideDownloadStatusLbl.text = "Tap to retry slide download"
//            return false
//        }
//        let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.slideResponse)
//        var localParamArr = [[String:  Any]]()
//        do {
//            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as?  [[String:  Any]] ??  [[String:  Any]]()
//            dump(localParamArr)
//        } catch {
//            //  self.toCreateToast("unable to retrive")
//        }
//        arrayOfAllSlideObjects.removeAll()
//        for dictionary in localParamArr {
//            if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
//               let model = try? JSONDecoder().decode(SlidesModel.self , from: jsonData) {
//                model.uuid = UUID()
//                arrayOfAllSlideObjects.append(model)
//                
//                
//            } else {
//                print("Failed to decode dictionary into YourModel")
//            }
//        }
//        let existingCDSlides: [SlidesModel] = CoreDataManager.shared.retriveSavedSlides()
//        
//        if self.arrayOfAllSlideObjects.isEmpty {
//            self.arrayOfAllSlideObjects.append(contentsOf: existingCDSlides)
//        }
//        let apiFetchedSlide: [SlidesModel] = self.arrayOfAllSlideObjects
//        // Extract slideId values from each array
//        let existingSlideIds = Set(existingCDSlides.map { $0.slideId })
//
//        // Filter apiFetchedSlide to get slides with slideIds not present in existingCDSlides
//        let nonExistingSlides = apiFetchedSlide.filter { !existingSlideIds.contains($0.slideId) }
//
//        let notDownloadedSlides = existingCDSlides.filter { !$0.isDownloadCompleted }
//        
//        isNewSlideExists = !notDownloadedSlides.isEmpty || !nonExistingSlides.isEmpty
//        
//        
//        // Now, nonExistingSlides contains the slides that exist in apiFetchedSlide but not in existingCDSlides based on slideId
//        self.arrayOfAllSlideObjects.removeAll()
//        self.arrayOfAllSlideObjects.append(contentsOf: existingCDSlides)
//        self.arrayOfAllSlideObjects.append(contentsOf: nonExistingSlides)
//        
//        
//        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesDownloadPending) || isNewSlideExists {
//            slideDownloadStatusLbl.text = "Tap to retry slide download"
//            retryVIew.isHidden = false
//            return true
//        }
//        
//        
//        if !LocalStorage.shared.getBool(key: .isSlidesLoaded) ||  !LocalStorage.shared.getBool(key: .isSlidesGrouped) {
//        
//            if nonExistingSlides.isEmpty {
//                slideDownloadStatusLbl.isHidden = false
//                retryVIew.isHidden = true
//                downloadingBottomView.isHidden = false
//                slideDownloadStatusLbl.text = "View slides"
//                return false
//            } else {
//                slideDownloadStatusLbl.text = "Tap to retry slide download"
//                retryVIew.isHidden = false
//                return true
//            }
//        } else if !nonExistingSlides.isEmpty {
//            slideDownloadStatusLbl.isHidden  =  false
//            downloadingBottomView.isHidden =  false
//            if Shared.instance.isSlideDownloading  {
//                slideDownloadStatusLbl.text = "slides download in progress.."
//                retryVIew.isHidden = true
//                
//            } else if isfromHome   {
//                slideDownloadStatusLbl.text = "Tap to retry slide download"
//                retryVIew.isHidden = false
//            } else {
//                slideDownloadStatusLbl.isHidden = true
//                retryVIew.isHidden = true
//                downloadingBottomView.isHidden = true
//            }
//            return !nonExistingSlides.isEmpty
//        } else {
//            slideDownloadStatusLbl.isHidden = false
//            retryVIew.isHidden = true
//            downloadingBottomView.isHidden = false
//            slideDownloadStatusLbl.text = "View slides"
//        }
//       //let downloadedArr = self.arrayOfAllSlideObjects.filter { $0.isDownloadCompleted }
//       
//        return false
//    }
    
    func moveToDownloadSlide(isFromcache: Bool? = false, isDownloadPending: Bool? = false) {
        downloadAlertSet = false
        
        let vc = SlideDownloadVC.initWithStory(viewmodel: self.mastersyncVM ?? MasterSyncVM())
        vc.isFromlaunch = isFromLaunch
        if isFromcache ?? false{
            vc.arrayOfAllSlideObjects = self.arrayOfAllSlideObjects
        }
      
       else if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesDownloadPending) {
            vc.arrayOfAllSlideObjects = self.arrayOfAllSlideObjects
       } else if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesGrouped) {
           vc.arrayOfAllSlideObjects = self.arrayOfAllSlideObjects
       }
        
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}


func mimeTypeForData(data: Data) -> String {
    var buffer = [UInt8](repeating: 0, count: 1)
    data.copyBytes(to: &buffer, count: 1)

    let uti: CFString

    switch buffer[0] {
    case 0xFF:
        uti = kUTTypeJPEG
    case 0x89:
        uti = kUTTypePNG
    case 0x47:
        uti = kUTTypeGIF
    case 0x49, 0x4D:
        uti = kUTTypeTIFF
    case 0x52 where data.count >= 12:
        let identifier = String(data: data.subdata(in: 0..<12), encoding: .ascii)
        if identifier == "RIFFWAVEfmt " {
            uti = kUTTypeWaveformAudio
        } else {
            uti = kUTTypeAudio
        }
    case 0x00 where data.count >= 12:
        let identifier = String(data: data.subdata(in: 8..<12), encoding: .ascii)
        if identifier == "ftypmp42" {
            uti = kUTTypeMPEG4
        } else {
            uti = kUTTypeVideo
        }
    case 0x3C where data.count >= 4:
        let identifier = String(data: data.subdata(in: 0..<4), encoding: .ascii)
        if identifier == "<!DO" {
            uti = kUTTypeHTML
        } else {
            uti = kUTTypeData
        }
    default:
        uti = kUTTypeData
    }

    if let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
        return mimeType as String
    } else {
        return "application/octet-stream"
    }
}



func mimeTypeForPath(path: String) -> String {
    let url = NSURL(fileURLWithPath: path)
    let pathExtension = url.pathExtension

    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
            return mimetype as String
        }
    }
    return "application/octet-stream"
}
