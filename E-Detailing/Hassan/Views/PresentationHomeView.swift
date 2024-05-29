//
//  PresentationHomeView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/01/24.
//

import Foundation
import UIKit

extension PresentationHomeView: PopOverVCDelegate {
    func logoutAction() {
        print("Log out")
    }
    
    func changePasswordAction() {
        print("Change password")
    }
    
    
    func toSetupPlayerModel(_ index: Int) -> [SlidesModel] {
        var selectedSlidesModelArr = [SlidesModel]()
        if let savePresentationArr = self.savePresentationArr {
            let selectedPresentation = savePresentationArr[index]
            selectedPresentation.groupedBrandsSlideModel.forEach({ aGroupedBrandsSlideModel in
               var selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                    aSlidesModel.isSelected == true
                }
              
                selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
            })
         
        }
      
        selectedSlidesModelArr.sort{$0.index < $1.index}
        return selectedSlidesModelArr
        
    }
    
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int) {
        print("Index is: \(index) -- ArrIndex is \(SelectedArrIndex)")
        
        switch index {
        case 0:
            //VIEW
            let vc = PlayPresentationVC.initWithStory(model:  toSetupPlayerModel(createdPresentationSelectedIndex ?? 0))
            self.presentationHomeVC.navigationController?.pushViewController(vc, animated: true)
           
        case 1:
            //EDIT
            let model = self.savePresentationArr?[createdPresentationSelectedIndex ?? 0] ?? SavedPresentation()
            toEditPresentation(model: model)
        case 2:
            //DELETE
         toShowAlert()
        default:
            print("Yet to implement")
        }
        
    }
    
    
}
 
extension PresentationHomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savePresentationArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreatedPresentationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatedPresentationCVC", for: indexPath) as!  CreatedPresentationCVC
        
        let model = savePresentationArr?[indexPath.row]
            
            if let model = model {
                cell.populateCell(model: model)
            }
            
      
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            welf.createdPresentationSelectedIndex = indexPath.row
            let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 2, height: 120), on: cell.optionsIV,  pagetype: .presentation)
            vc.delegate = self
            welf.presentationHomeVC.navigationController?.present(vc, animated: true)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 4, height: collectionView.height / 2.5)
    }
    
    
}

class PresentationHomeView : BaseView {
    

    
    enum PageType {
        case exists
        case empty
    }
    
    func toSetPageType(pageType: PageType) {
        switch pageType {
            
        case .exists:
            self.presentationCollectionVIew.isHidden = false
            self.noPresentationView.isHidden = true
            cellRegistration()
            toLoadPresentationCollection()
        case .empty:
            self.presentationCollectionVIew.isHidden = true
            self.noPresentationView.isHidden = false
        }
    }
    
    var presentationHomeVC : PresentationHomeVC!
    
    @IBOutlet var presentationCollectionVIew: UICollectionView!
    @IBOutlet var navigationView: UIView!
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var addpresentationView: UIView!
    
    @IBOutlet var titlrLbl: UILabel!
    
    @IBOutlet var noPresentationsLbl: UILabel!
    @IBOutlet var addPresentationLbl: UILabel!
    
    @IBOutlet var noPresentationView: UIView!
    @IBOutlet var contentsHolderView: UIView!
   
    var pageType: PageType = .empty
    let localStorage =  LocalStorage.shared
    var savePresentationArr : [SavedPresentation]?
    var createdPresentationSelectedIndex: Int? = nil
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.presentationHomeVC = baseVC as? PresentationHomeVC
        setupUI()
        initView()
        retriveSavedPresentations()
       // groupSlides()

    }
    
    
    
    func retriveSavedPresentations()  {
 
        CoreDataManager.shared.retriveSavedPresentations{ savedPresentationArr in
        
            self.savePresentationArr = savedPresentationArr
            self.toLoadDataSource()
        }
 
    }
    
    
    
    
    func toLoadDataSource() {
        if let savePresentationArr =   self.savePresentationArr {
            dump(savePresentationArr)
            if savePresentationArr.count == 0 {
                toSetPageType(pageType: .empty)
            } else {
                toSetPageType(pageType: .exists)
            }
        }
    }
    
    func toLoadPresentationCollection() {
        presentationCollectionVIew.delegate = self
        presentationCollectionVIew.dataSource = self
        presentationCollectionVIew.reloadData()
    }
    
    func cellRegistration() {
        
        presentationCollectionVIew.register(UINib(nibName: "CreatedPresentationCVC", bundle: nil), forCellWithReuseIdentifier: "CreatedPresentationCVC")
        
    }
    
    func setupUI() {
//        if let layout = self.presentationCollectionVIew.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.collectionView?.isScrollEnabled = true
//
//        }
        
        noPresentationsLbl.setFont(font: .bold(size: .BODY))
        noPresentationsLbl.textColor = .appTextColor
        addPresentationLbl.setFont(font: .bold(size: .BODY))
        addPresentationLbl.textColor = .appWhiteColor
        addpresentationView.layer.cornerRadius = 5

        addpresentationView.backgroundColor = .appTextColor
    
        navigationView.backgroundColor = .appTextColor
        titlrLbl.setFont(font: .bold(size: .SUBHEADER))
        titlrLbl.textColor = .appWhiteColor
        contentsHolderView.elevate(2)
        contentsHolderView.layer.cornerRadius = 5
        contentsHolderView.backgroundColor = .appWhiteColor
        self.backgroundColor = .appGreyColor
    }
    
    
    func initView() {
        backHolderView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.presentationHomeVC.navigationController?.popViewController(animated: true)
        }
        
        addpresentationView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.moveToCreatePresentationVC()
        }
    }
    
    
    func moveToCreatePresentationVC() {
        let vc = CreatePresentationVC.initWithStory()
        vc.delegate = self
        vc.isToedit = false
        self.presentationHomeVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func toEditPresentation(model: SavedPresentation) {
        let vc = CreatePresentationVC.initWithStory()
        vc.delegate = self
        vc.isToedit = true
      
       // vc.groupedBrandsSlideModel = model.groupedBrandsSlideModel
        vc.savedPresentation = model
        self.presentationHomeVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toDeletePresentation() {

        if let  savePresentationArr =   self.savePresentationArr {
            CoreDataManager.shared.toRemovePresentation(savePresentationArr[createdPresentationSelectedIndex ?? 0].uuid) { isDeleted in
                if isDeleted {
                    self.toCreateToast("presentation deleted successfully")
                    retriveSavedPresentations()
                } else {
                    self.toCreateToast("operation couldn't be completed.")
                }
            }
        
        }
  
       
    }
    
    
    func toShowAlert() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "Are you sure about removing presentation?", okAction: "Yes",cancelAction: "No")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            self.toDeletePresentation()
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
         
        }
    }
}


extension PresentationHomeView: CreatePresentationVCDelegate {
    func presentationSaved() {
        retriveSavedPresentations()
        toLoadPresentationCollection()
    }
    
    
}
