//
//  PlayPresentationView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import Foundation
import UIKit
import CoreData

struct DetailedSlide {
    var groupedSlides: [SlidesModel]?
    var slidesModel: SlidesModel?
    var brand: NSObject?
    var brandCode : Int?
    var slideID: Int?
    var isLiked: Bool?
    var isDisliked: Bool?
    var remarks: String?
    var remarksValue : Float?
    var isShared: Bool?
    var startTime: String?
    var endTime: String?
    
}

protocol PlayPresentationViewDelegate: AnyObject {
    func didUserDetailedSlides()
    func popAndRefresh(kind: PreviewHomeView.PreviewType)
    
}


class  PlayPresentationView: BaseView {
    
    override func willDisappear(baseVC: BaseViewController) {
        super.willDisappear(baseVC: baseVC)
        playPresentationVC.selectedSlideModel = nil
        self.selectedSlideModel = nil
        
    }
    
    
    enum PreviewType: String {
        case home = "All"
        case brand = "Brand Matrix"
        case speciality = "Speciality"
        case customPresentation = "Custom/My Presentation"
    }
    
    enum PageState {
        case expanded
        case minimized
    }
    
    enum OptionsState {
        case expanded
        case minimized
    }
    
    func setOptionsState(_ type: OptionsState) {
        self.optionsState = type
        switch type {
            
        case .expanded:
          //  viewShowOptions.isHidden = true
            viewOptions.isHidden = false
            
            showOptionsIV.image = UIImage(systemName: "xmark")
        case .minimized:
        
            
          //  viewShowOptions.isHidden = false
            viewOptions.isHidden = true
            showOptionsIV.image = UIImage(systemName: "arrow.left")
        }
    }
    
    func setPageType(_ type: PageState) {
        self.pageState = type
        switch type {
            
        case .expanded:
            self.viewMInimize.isHidden = false
            self.viewClosePreview.isHidden = playPresentationVC.pagetype == .detailing ? true : true
            backHolderView.isHidden =  playPresentationVC.pagetype == .detailing ? true : true
            
            self.loadedCollectionHolderView.isHidden = true
            self.previewCollectionHolderView.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name("viewExpanded"), object: nil)
        case .minimized:
            self.viewMInimize.isHidden = true
            self.viewClosePreview.isHidden = playPresentationVC.pagetype == .detailing ? true : false
            self.backHolderView.isHidden = playPresentationVC.pagetype == .detailing ? true : false
           
            self.previewCollectionHolderView.isHidden = playPresentationVC.pagetype == .detailing ? false : true
            self.loadedCollectionHolderView.isHidden = false
            
            NotificationCenter.default.post(name: NSNotification.Name("viewminimized"), object: nil)
           
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.setPageType(.expanded)
//        }
        
    }
    
    func setPreviewType(_ previewType: PreviewHomeView.PreviewType) {
        
       
        self.playPresentationVC.navigationController?.popViewController(animated: false)
        self.playPresentationVC.delegete?.popAndRefresh(kind: previewType)
    }
    
    var playPresentationVC : PlayPresentationVC!
    @IBOutlet var loadedCollectionHolderView: UIView!
    @IBOutlet var labelClosePreview: UILabel!
    @IBOutlet var PlayingSlideCollection: UICollectionView!
    
    @IBOutlet var loadedSlidesCollection: UICollectionView!
    
    @IBOutlet var viewClosePreview: UIView!
    
    @IBOutlet var loadedcollectionVxView: UIVisualEffectView!
    
    @IBOutlet var viewMInimize: UIView!
    
    @IBOutlet var viewOptions: UIView!
    @IBOutlet var viewShowOptions: UIView!
    
    @IBOutlet var showOptionsIV: UIImageView!
    @IBOutlet var navigationBackground: UIView!
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var backlbl: UILabel!
    
    @IBOutlet var viewNopresentation: UIView!
    @IBOutlet var previewCollectionHolderView: UIView!
    @IBOutlet var previewTypeCollection: UICollectionView!
    
    
    @IBOutlet var likeOptionsVIew: UIView!
    
    @IBOutlet var likeIV: UIImageView!
    @IBOutlet var disLikeOptionsView: UIView!
    
    @IBOutlet var disLikeIV: UIImageView!
    @IBOutlet var addRemarksOptionsView: UIView!
    
    @IBOutlet var remarksIV: UIImageView!
    @IBOutlet var shareOptionsView: UIView!
    
    @IBOutlet var shareIV: UIImageView!
    @IBOutlet var scribbleOptionsView: UIView!
    
    @IBOutlet var scribbleIV: UIImageView!
    @IBOutlet var stopOptionsView: UIView!
    
    @IBOutlet var stopIV: UIImageView!
    
    @IBOutlet var likeCurveView: UIView!
    
    @IBOutlet var dislikeCurveView: UIView!
    
    @IBOutlet var remarksCurveView: UIView!
    
    @IBOutlet var shareCurveView: UIView!
    
    @IBOutlet var stopCurveView: UIView!
    
    @IBOutlet var scribbleCurvedView: UIView!

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backGroundVXview: UIVisualEffectView!
    
    var tpDeviateReasonView:  TPdeviateReasonView?
    var previewType: [PreviewType] = []
    var pageState : PageState = .minimized
    var optionsState: OptionsState = .minimized
    var selectedLoadPresentationIndex : Int? = 0
    var selectedSlideModel : [SlidesModel]?
    var previewTypeIndex: Int = 0
    var detailedSlide: [DetailedSlide] = []
    var selectedSlideID: Int?
    var previousSlideID: Int?
    var selectedSlideURL: String?
    var backgroundTimer = BackgroundTimer()
    var finalIndex: Int? = nil

    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        
        let  tpDeviateVIewwidth = self.bounds.width / 1.7
        let  tpDeviateVIewheight = self.bounds.height / 2.7
        
        let  tpDeviateVIewcenterX = self.bounds.midX - (tpDeviateVIewwidth / 2)
        let tpDeviateVIewcenterY = self.bounds.midY - (tpDeviateVIewheight / 2)
        
        
        tpDeviateReasonView?.frame = CGRect(x: tpDeviateVIewcenterX, y: tpDeviateVIewcenterY, width: tpDeviateVIewwidth, height: tpDeviateVIewheight)
    }
    
    
    func toHandleFirstSlide() {
        guard let slideID = self.selectedSlideID else {return}
        var adetailedSlide = DetailedSlide(slideID: slideID, isLiked: nil, isDisliked: nil, remarks: nil, isShared: nil)
//        let slideTime = backgroundTimer.stop()
//        let startTime = slideTime.startTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
//        let endTime = slideTime.endTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
//        adetailedSlide.startTime = startTime
//        adetailedSlide.endTime = endTime
        Shared.instance.detailedSlides.append(adetailedSlide)
        updateLikeUI(isLiked: false)
        updateDisLikeUI(isDisLiked: false)
    }
    
    func toHandleLastSlide() {
        var lastSlide = Shared.instance.detailedSlides.last
        
        let slideTime = backgroundTimer.stop()
        let startTime = slideTime.startTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
        let endTime = slideTime.endTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
      
        lastSlide?.startTime = startTime
        lastSlide?.endTime = endTime
        
        dump(lastSlide)
        
        guard let lastSlideElement = lastSlide else {
            return
        }
        Shared.instance.detailedSlides.removeLast()
        Shared.instance.detailedSlides.append(lastSlideElement)
        dump(Shared.instance.detailedSlides)
    }
    
    
    func handleOptionsTaps() {
        likeIV.addTap {
            self.setupLikes()
        }
        
        disLikeIV.addTap {
            self.setupDisLikes()
        }
        
        shareIV.addTap {
            self.toShareMedia(sender: self.shareIV)
        }
        
        remarksIV.addTap {
            guard let selectedSlideID = self.selectedSlideID else {return}
            var addedRemars: String?
            Shared.instance.detailedSlides.forEach { aDetailedSlide in
                if aDetailedSlide.slideID == selectedSlideID {
                    addedRemars = aDetailedSlide.remarks
                }
            }
            self.commentsAction(isForremarks: true, remarksStr: addedRemars ?? nil)
        }
        
        stopIV.addTap {
            if self.playPresentationVC.pagetype == .detailing {
                self.toHandleLastSlide()
                self.toRetriveModelsFromCoreData()
                self.playPresentationVC.navigationController?.popViewController(animated: false)
                self.playPresentationVC.delegete?.didUserDetailedSlides()
            } else {
                self.playPresentationVC.navigationController?.popViewController(animated: true)
            }
     
       
        }
        
    }
    
    
    func toRetriveModelsFromCoreData() {

        Shared.instance.detailedSlides = Shared.instance.detailedSlides.reduce(into: []) { result, detailedSlide in
            // Check if the slideID already exists in the result array
            if !result.contains(where: { $0.slideID == detailedSlide.slideID }) {
                // If not, append the detailed slide to the result array
                result.append(detailedSlide)
            }
        }

        dump(Shared.instance.detailedSlides)
        
        let groupedSlides =  CoreDataManager.shared.retriveGeneralGroupedSlides()
      
        groupedSlides.forEach { groupedBrandsSlideModel in
            groupedBrandsSlideModel.groupedSlide.forEach { slidesModel in
                if let detailedSlideIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == slidesModel.slideId }) {
                    Shared.instance.detailedSlides[detailedSlideIndex].slidesModel = slidesModel
                    Shared.instance.detailedSlides[detailedSlideIndex].brandCode = groupedBrandsSlideModel.productBrdCode
                }
            }
        }
        

        
        dump(Shared.instance.detailedSlides)
        
      
    }
    
    
    func commentsAction(isForremarks: Bool, remarksStr: String?) {
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
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
        
        
        
        tpDeviateReasonView = self.playPresentationVC.loadCustomView(nibname: XIBs.tpDeviateReasonView) as? TPdeviateReasonView
        tpDeviateReasonView?.delegate = self
        tpDeviateReasonView?.addedSubviewDelegate = self
        tpDeviateReasonView?.isForRemarks = isForremarks
        tpDeviateReasonView?.remarks = remarksStr == "" ? nil :  remarksStr
        tpDeviateReasonView?.setupui()
        self.addSubview(tpDeviateReasonView ?? TPdeviateReasonView())
        
    }
    
    
    
    func toShareMedia(sender: UIView) {
        // Create an array of items to share
        guard let url = selectedSlideURL else {return}
        let items: [Any] = [URL(string: url)!]
        
        // Create an activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Configure activity view controller to exclude some activities if needed
        // activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        // Present the activity view controller
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }
        playPresentationVC.present(activityViewController, animated: true, completion: nil)
    }
    
    func setupLikes() {
        guard let slideID = self.selectedSlideID else { return }
        
        if let existingIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == slideID }) {
            Shared.instance.detailedSlides[existingIndex].isLiked = !(Shared.instance.detailedSlides[existingIndex].isLiked ?? false)
            Shared.instance.detailedSlides[existingIndex].isDisliked = false
            updateLikeUI(isLiked: Shared.instance.detailedSlides[existingIndex].isLiked ?? false)
            updateDisLikeUI(isDisLiked: Shared.instance.detailedSlides[existingIndex].isDisliked ?? false)
        }
        
    }
    
    func setupDisLikes() {
        guard let slideID = self.selectedSlideID else { return }
        
        if let existingIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == slideID }) {
            Shared.instance.detailedSlides[existingIndex].isDisliked = !(Shared.instance.detailedSlides[existingIndex].isDisliked ?? false)
            Shared.instance.detailedSlides[existingIndex].isLiked = false
            updateDisLikeUI(isDisLiked: Shared.instance.detailedSlides[existingIndex].isDisliked ?? false)
            updateLikeUI(isLiked: Shared.instance.detailedSlides[existingIndex].isLiked ?? false)
        }
        
    }
    
    
    
    func updateRemarks(remarksStr: String) {
        guard let slideID = self.selectedSlideID else { return }
        if let existingIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == slideID }) {
            Shared.instance.detailedSlides[existingIndex].remarks = remarksStr
           
            updateRemarksIV(isAdded: remarksStr != "" ? true : false)
        }
    }
    
    func updateRemarksIV(isAdded: Bool) {
        if isAdded {
            remarksIV.tintColor = .white
            remarksIV.backgroundColor = .appBlue
        } else {
            remarksIV.tintColor = .appBlue
            remarksIV.backgroundColor = .clear
        }
    }

    
    func populateDetailedSlide(isLiked: Bool? = nil, isDisliked: Bool? = nil, remarks: String? = nil, isShared: Bool? = nil, startTime: String? = nil, endTime: String? = nil) {
        guard let slideID = self.selectedSlideID else { return }
        if let existingIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == slideID }) {
            
            Shared.instance.detailedSlides[existingIndex].isLiked = Shared.instance.detailedSlides[existingIndex].isLiked ?? false
            Shared.instance.detailedSlides[existingIndex].isDisliked =  Shared.instance.detailedSlides[existingIndex].isDisliked ?? false
            Shared.instance.detailedSlides[existingIndex].remarks =  Shared.instance.detailedSlides[existingIndex].remarks ?? nil
            Shared.instance.detailedSlides[existingIndex].isShared = isShared
            updateLikeUI(isLiked: Shared.instance.detailedSlides[existingIndex].isLiked ?? false)
            updateDisLikeUI(isDisLiked: Shared.instance.detailedSlides[existingIndex].isDisliked ?? false)
            if let _ =  Shared.instance.detailedSlides[existingIndex].remarks {
                updateRemarksIV(isAdded: true)
            } else {
                updateRemarksIV(isAdded: false)
            }
            
            if let addedremarks = remarks {
                updateRemarks(remarksStr: addedremarks)
            }
           
           // dump(self.detailedSlide)
         
        } else {
            let adetailedSlide = DetailedSlide(slideID: slideID, isLiked: isLiked ?? false, isDisliked: isDisliked ?? false, remarks: remarks, isShared: isShared)
            Shared.instance.detailedSlides.append(adetailedSlide)
            updateLikeUI(isLiked: isLiked ?? false)
            updateDisLikeUI(isDisLiked: isLiked ?? false)
        }
        
       // dump(self.detailedSlide)
        
    }
    

    func updateDisLikeUI(isDisLiked: Bool) {
        if isDisLiked {
            disLikeIV.tintColor = .white
            disLikeIV.backgroundColor = .systemRed
        } else {
            disLikeIV.tintColor = .systemRed
            disLikeIV.backgroundColor = .clear
        }
    }
    
    
    func updateUI(isLiked: Bool, isDisliked: Bool) {
        updateLikeUI(isLiked: isLiked)
        updateDisLikeUI(isDisLiked: isDisliked)
    }
    
    
    func updateLikeUI(isLiked: Bool) {
        if isLiked {
            likeIV.tintColor = .white
            likeIV.backgroundColor = .appGreen
        } else {
            likeIV.tintColor = .appGreen
            likeIV.backgroundColor = .clear
        }
    }

    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.playPresentationVC = baseVC as? PlayPresentationVC
        setupUI()
        initView()
        cellregistration()
      
        toLoadloadedSlidesCollection()
        toLoadPlayingSlideCollection()
        if playPresentationVC.pagetype == .detailing {
            previewCollectionHolderView.isHidden = false
            toLoadPreviewCollection()
            backHolderView.isHidden = true
            viewClosePreview.isHidden = true
            
            switch previewType[playPresentationVC.previewTypeIndex] {
            case .home:
                self.previewTypeCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            case .brand :
                self.previewTypeCollection.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            case .speciality:
                self.previewTypeCollection.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: false)
            case .customPresentation:
                self.previewTypeCollection.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: false)
            }
            
            
        } else {
            previewCollectionHolderView.isHidden = true
           // backHolderView.isHidden = false
           // viewClosePreview.isHidden = false
        }

    }
    
    func toLoadPreviewCollection() {
        previewTypeCollection.delegate = self
        previewTypeCollection.dataSource = self
        previewTypeCollection.reloadData()
    }
    
    func toLoadPlayingSlideCollection() {
        PlayingSlideCollection.isPrefetchingEnabled = false
        PlayingSlideCollection.delegate = self
        PlayingSlideCollection.dataSource = self
        PlayingSlideCollection.reloadData()
    }
    
    func toLoadloadedSlidesCollection() {
        loadedSlidesCollection.delegate = self
        loadedSlidesCollection.dataSource = self
        loadedSlidesCollection.reloadData()
    }
    
    func cellregistration() {
        
        loadedSlidesCollection.isPagingEnabled = false
        PlayingSlideCollection.isPagingEnabled = true
        if let loadedSlideslayout = self.loadedSlidesCollection.collectionViewLayout as? UICollectionViewFlowLayout  {
            loadedSlideslayout.scrollDirection = .horizontal
            loadedSlideslayout.collectionView?.isScrollEnabled = true
        }
        
        
        if  let PlayingSlidelayout = self.PlayingSlideCollection.collectionViewLayout as? UICollectionViewFlowLayout  {
            PlayingSlidelayout.scrollDirection = .horizontal
            PlayingSlidelayout.collectionView?.isScrollEnabled = true
        }
        
        
        if  let previewTypelayout = self.previewTypeCollection.collectionViewLayout as? UICollectionViewFlowLayout  {
            previewTypelayout.scrollDirection = .horizontal
            previewTypelayout.collectionView?.isScrollEnabled = true
        }
        
        previewTypeCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
        
        PlayingSlideCollection.register(UINib(nibName: "PlayPDFCVC", bundle: nil), forCellWithReuseIdentifier: "PlayPDFCVC")
      
        PlayingSlideCollection.register(UINib(nibName: "VideoPlayerCVC", bundle: nil), forCellWithReuseIdentifier: "VideoPlayerCVC")
        
        
        
        loadedSlidesCollection.register(UINib(nibName: "PlayPresentationCVC", bundle: nil), forCellWithReuseIdentifier: "PlayPresentationCVC")
        
        
        PlayingSlideCollection.register(UINib(nibName: "PlayLoadedPresentationCVC", bundle: nil), forCellWithReuseIdentifier: "PlayLoadedPresentationCVC")
        
        PlayingSlideCollection.register(PlayHTMLCVC.self, forCellWithReuseIdentifier: PlayHTMLCVC.identifier)
      
    }
    
    deinit {
        self.selectedSlideModel = nil
    }
    
    override func didDisappear(baseVC: BaseViewController) {
        super.didDisappear(baseVC: baseVC)
        self.selectedSlideModel = nil
    }
    
    func  setupUI() {

        self.viewShowOptions.isHidden = playPresentationVC.pagetype == .preview ? true : false
        
        self.previewTypeIndex = playPresentationVC.previewTypeIndex
        viewNopresentation.isHidden = true
        previewCollectionHolderView.isHidden = true
        backgroundView.isHidden = true
        let views : [UIView] = [likeCurveView, dislikeCurveView, remarksCurveView, shareCurveView, stopCurveView, scribbleCurvedView]
        views.forEach { aView in
            aView.layer.cornerRadius = aView.height / 2

        }
        
        
        
        let images : [UIImageView] = [likeIV, disLikeIV, shareIV, remarksIV, scribbleIV, stopIV]
        images.forEach { aUIImageView in
            aUIImageView.layer.cornerRadius = aUIImageView.height / 2
            aUIImageView.layer.borderWidth = 0.7
            aUIImageView.layer.borderColor = UIColor.appWhiteColor.cgColor
        }
        self.selectedSlideModel = playPresentationVC.selectedSlideModel
        if let selectedSlideModel =  self.selectedSlideModel , selectedSlideModel.count > 0 {
            self.selectedSlideID =  selectedSlideModel.first?.slideId ?? Int()
            self.selectedSlideURL = slideURL+(selectedSlideModel.first?.filePath ?? String())
            self.backgroundTimer = BackgroundTimer()
            self.backgroundTimer.start()
            self.toHandleFirstSlide()
        }
        
        self.detailedSlide = Shared.instance.detailedSlides
        
        if self.selectedSlideModel?.count == 0 {
            viewNopresentation.isHidden = false
            self.PlayingSlideCollection.isHidden = true
        } else {
            viewNopresentation.isHidden = true
            self.PlayingSlideCollection.isHidden = false
        }
        loadedcollectionVxView.backgroundColor = .appTextColor
        self.setPageType(self.pageState)
        self.setOptionsState(self.optionsState)
        viewMInimize.layer.cornerRadius = viewMInimize.height / 2
        
        viewShowOptions.layer.cornerRadius = viewMInimize.height / 2
        viewOptions.layer.cornerRadius = 5
        viewClosePreview.backgroundColor = .appTextColor
        labelClosePreview.setFont(font: .bold(size: .BODY))
        
        backlbl.textColor = .appWhiteColor
        backlbl.setFont(font: .bold(size: .BODY))
        backHolderView.backgroundColor = .appTextColor
        previewType = [.home, .brand, .speciality, .customPresentation]

        
   
    }
    
    func initView() {
        handleOptionsTaps()
        self.viewClosePreview.addTap {
            self.setPageType(.expanded)
        }
        
        self.viewMInimize.addTap {
            self.pageState = self.pageState == .expanded ? .minimized : .expanded
            
            self.setPageType(self.pageState)
        }
        
        self.viewShowOptions.addTap {
            self.optionsState = self.optionsState == .expanded ? .minimized : .expanded
            
            self.setOptionsState(self.optionsState)
        }
        
        backHolderView.addTap {
            self.stopAllVideoPlayers()
            self.playPresentationVC.navigationController?.popViewController(animated: true)
        }

    }
    
}
extension PlayPresentationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func stopAllVideoPlayers() {
        // Iterate through visible cells and stop their video players
        for cell in PlayingSlideCollection.visibleCells {
            if let videoCell = cell as? VideoPlayerCVC {
                videoCell.player?.pause()
                videoCell.player = nil
            }
        }
    }
    
//     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let videoCell = cell as? VideoPlayerCVC {
//            videoCell.playVideo()
//        }
//    }

     func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
         switch collectionView {
         case PlayingSlideCollection:
             let slideTime = backgroundTimer.stop()
             let startTime = slideTime.startTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
             let endTime = slideTime.endTime?.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
         
             // Retrieve the last slide from Shared.instance.detailedSlides
             if var lastSlide = Shared.instance.detailedSlides.last {
                 lastSlide.startTime = startTime
                 lastSlide.endTime = endTime

                 // Log the last slide for debugging purposes
                 dump(lastSlide)

                 // Update the last slide in the Shared.instance.detailedSlides
                 if let index = Shared.instance.detailedSlides.lastIndex(where: { $0.slideID == lastSlide.slideID }) {
                     Shared.instance.detailedSlides[index] = lastSlide
                 }

                 // Check if there's an existing slide with the same slideID as the selectedSlideID
                 if let existingSlideIndex = Shared.instance.detailedSlides.firstIndex(where: { $0.slideID == selectedSlideID }) {
                     // Update the existing slide's start and end times
                     Shared.instance.detailedSlides[existingSlideIndex].startTime = startTime
                     Shared.instance.detailedSlides[existingSlideIndex].endTime = endTime
                 }

                 // Log the detailedSlides array for debugging purposes
                 dump(Shared.instance.detailedSlides)
             }

             // Restart the background time
             self.backgroundTimer.start()
         default:
             print("Yet to")
         }

         
        if let videoCell = cell as? VideoPlayerCVC {
            videoCell.pauseVideo()
        }
         
         
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case PlayingSlideCollection:
            
            
            
            let model =  self.selectedSlideModel?[indexPath.row]
            self.selectedSlideURL = slideURL+(model?.filePath ?? String())
        default:
            print("Yet to")
        }
 
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Calculate the index based on the current content offset and item size
        
        if let collect = scrollView as? UICollectionView {
            if collect == self.PlayingSlideCollection {
                let pageWidth = collect.frame.size.width
                let currentPage = Int(collect.contentOffset.x / pageWidth)
                print("Current Page: \(currentPage)")
                self.selectedLoadPresentationIndex = Int(currentPage)
                self.loadedSlidesCollection.reloadData()
                let indexPath: IndexPath = IndexPath(item: Int(currentPage), section: 0)
                self.loadedSlidesCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                let model =  self.selectedSlideModel?[indexPath.row]
                self.selectedSlideID = model?.slideId ?? Int()
                
                self.populateDetailedSlide()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case PlayingSlideCollection, loadedSlidesCollection:
            return selectedSlideModel?.count ?? 0
        case previewTypeCollection:
            return previewType.count
            
        default:
            return Int()
        }
      
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

       
        
        switch collectionView {
 
        case PlayingSlideCollection:
            self.finalIndex = indexPath.row
            let model =  self.selectedSlideModel?[indexPath.row]
            switch model?.utType {
            case "application/pdf":
                let cell: PlayPDFCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayPDFCVC", for: indexPath) as! PlayPDFCVC
                cell.toLoadData(data: model?.slideData ?? Data())
                cell.addTap {
                    self.pageState = self.pageState == .expanded ?  .minimized :  .expanded
                    self.setPageType(self.pageState)
                }
             //   cell.presentationIV.backgroundColor = colors[indexPath.row]
               
                return cell
            case "image/jpeg", "image/png", "image/jpg", "image/bmp", "image/gif":
                let cell: PlayLoadedPresentationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayLoadedPresentationCVC", for: indexPath) as! PlayLoadedPresentationCVC
                if let model = model {
                    cell.populateCell(model: model)
                }
              
                cell.addTap {
                    self.pageState = self.pageState == .expanded ?  .minimized :  .expanded
                    self.setPageType(self.pageState)
                }
               // cell.presentationIV.backgroundColor = colors[indexPath.row]
               
                return cell
            case "video/mp4":
                
                let cell: VideoPlayerCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPlayerCVC", for: indexPath) as! VideoPlayerCVC
               
                cell.setupPlayer(data: model?.slideData ?? Data())
                cell.state = self.pageState
                cell.delegate = self
                cell.addTap {
                    self.pageState = .expanded
                    self.setPageType(self.pageState)
                }
                //cell.presentationIV.backgroundColor = colors[indexPath.row]
               
                return cell

            default:
                let cell: PlayHTMLCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayHTMLCVC", for: indexPath) as! PlayHTMLCVC
                let fileURL =  model?.filePath ?? ""
                cell.loadURL(fileURL)
                
                cell.addTap {
                    self.pageState = self.pageState == .expanded ?  .minimized :  .expanded
                    self.setPageType(self.pageState)
                }
                //cell.presentationIV.backgroundColor = colors[indexPath.row]
               
                return cell
            }

        case loadedSlidesCollection:
            let model =  self.selectedSlideModel?[indexPath.row]
            let cell: PlayPresentationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayPresentationCVC", for: indexPath) as! PlayPresentationCVC
            if let model = model {
                cell.toPopulateCell(model)
            }
          //  cell.presentationIV.backgroundColor = colors[indexPath.row]
            if indexPath.row ==  self.selectedLoadPresentationIndex  {
                cell.holderViewWidth.constant = 155
                cell.holderViewHeight.constant = 105
                cell.holderIV.layer.borderWidth = 2
                cell.holderIV.layer.borderColor = UIColor.appWhiteColor.cgColor
            } else {
                cell.holderViewWidth.constant = 150
                cell.holderViewHeight.constant = 100
                cell.holderIV.layer.borderWidth = 0
                cell.holderIV.layer.borderColor = UIColor.clear.cgColor
            }
            
            cell.addTap {
                self.selectedLoadPresentationIndex = indexPath.row
                
                self.PlayingSlideCollection.reloadData()
                
                self.PlayingSlideCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
                let model =  self.selectedSlideModel?[indexPath.row]
                self.selectedSlideID = model?.slideId ?? Int()
                self.populateDetailedSlide()
                
                self.loadedSlidesCollection.reloadData()
            }
            
            return cell
            
        case previewTypeCollection:
            let cell: PreviewTypeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewTypeCVC", for: indexPath) as! PreviewTypeCVC
            cell.setupUI(pageType: playPresentationVC.pagetype)

            cell.titleLbl.text = previewType[indexPath.row].rawValue
            
//            if indexPath.row == previewTypeIndex {
//                cell.holderVIew.backgroundColor = .appTextColor
//            } else {
//                cell.holderVIew.backgroundColor = .appLightTextColor
//            }
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.previewTypeIndex  = indexPath.row
              
                welf.previewTypeCollection.reloadData()

                switch welf.previewType[welf.previewTypeIndex] {
                case .home:
                    welf.setPreviewType(PreviewHomeView.PreviewType.home)
                case .brand :
                    welf.setPreviewType(PreviewHomeView.PreviewType.brand)
                case .speciality:
                    welf.setPreviewType(PreviewHomeView.PreviewType.speciality)
                case .customPresentation:
                    welf.setPreviewType(PreviewHomeView.PreviewType.customPresentation)
                }
                }
               
            return cell
            
        default:
            return UICollectionViewCell()
        }

     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case PlayingSlideCollection:
            return CGSize(width: PlayingSlideCollection.width, height: PlayingSlideCollection.height)
            
        case loadedSlidesCollection:
            //150 cell width padding 10
            
            return CGSize(width: 170, height: 110)
            
        case previewTypeCollection:
            return CGSize(width: previewType[indexPath.item].rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
        default:
            return CGSize()
        }
    }
}


extension PlayPresentationView: VideoPlayerCVCDelegate {
    func videoplayingSatatus(isplaying: Bool) {
        if isplaying {
            self.pageState = .minimized
           
        } else {
            self.pageState = .expanded
        }
        
        self.setPageType(self.pageState)
    }
    
    
}


extension PlayPresentationView : addedSubViewsDelegate {
    func didClose() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
  
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
            }

        }
    }
    
    func didUpdate() {
        print("Yet to")
    }
    
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to")
    }
    
    func showAlert(desc: String) {
        print("Yet to")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("Yet to")
    }
    
    
}

extension PlayPresentationView : SessionInfoTVCDelegate {
    
    func handleAddedRemarks(remarksStr: String) {
      //  populateDetailedSlide(remarks: remarksStr)
        updateRemarks(remarksStr: remarksStr)
        
       // self.loadedContentsTable.reloadData()
    }
    
    func remarksAdded(remarksStr: String, index: Int) {
        
        dump(remarksStr)

        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
  
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
            }

        }
        handleAddedRemarks(remarksStr: remarksStr)

    }
    
    
    
    
    
}
