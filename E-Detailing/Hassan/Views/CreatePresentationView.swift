//
//  CreatePresentationView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import Foundation
import UIKit



extension CreatePresentationView: UITextFieldDelegate {
    
}



class CreatePresentationView : BaseView {
    


    @IBOutlet var editView: UIView!
    var createPresentationVC : CreatePresentationVC!
    
    @IBOutlet var navigationVIew: UIView!
    
    @IBOutlet var selectSlidesCollectionHolder: UIView!
    
    
    @IBOutlet var selectSlidesCollection: UICollectionView!
    
    @IBOutlet var slidesCountHolder: UIView!
    
    @IBOutlet var editVxview: UIVisualEffectView!
    @IBOutlet var selectedSlidesTableHolder: UIView!
    
    @IBOutlet var playView: UIView!
    @IBOutlet var sledeCountLbl: UILabel!
    @IBOutlet var sledesCountVxView: UIVisualEffectView!
    
    @IBOutlet var playLbl: UILabel!
    
    @IBOutlet var calcelView: UIView!
    
    @IBOutlet var cancelLbl: UILabel!
    
    @IBOutlet var saveVIew: UIView!
    
    @IBOutlet var saveLbl: UILabel!
    
    @IBOutlet var addNameTFHolderView: UIView!
    
    @IBOutlet var addNameTF: UITextField!
    @IBOutlet var slidesTutle: UILabel!
    @IBOutlet var brandsTable: UITableView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var sampleImage: UIImageView!
    @IBOutlet var selectedSlidesTable: UITableView!
    var arrayOfBrandSlideObjects: [BrandSlidesModel]?
    var arrayOfAllSlideObjects: [SlidesModel]?
    var groupedBrandsSlideModel : [GroupedBrandsSlideModel]?
    var savedPresentation: SavedPresentation?
    var selectedSlides: [SlidesModel]?
    var selectedBrandsIndex: Int = 0
    var selectedPresentationIndex: Int? = nil
    var isEditing: Bool = false
    
    @IBOutlet var editLbl: UILabel!
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.createPresentationVC = baseVC as? CreatePresentationVC
        setupUI()
        cellRegistration()
        toRetriveModelsFromCoreData()
        initView()
    }
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
       // toRetriveModelsFromCoreData()
    }
    
    func toRetriveModelsFromCoreData() {
        self.groupedBrandsSlideModel =  CoreDataManager.shared.retriveGeneralGroupedSlides()
        guard  groupedBrandsSlideModel != nil else {return}
            self.selectedSlides = [SlidesModel]()
            createPresentationVC.isToedit ? toEditPresentationData() :  toLoadNewPresentationData()

    }
    
    
//    func processSlideModels(completion: @escaping () -> Void) {
//        guard let groupedBrandsSlideModel = self.groupedBrandsSlideModel else {
//            // Call the completion handler if there are no slide models to process
//            completion()
//            return
//        }
//        
//        // Create a serial DispatchQueue
//        
//        // Define a function to process each slide model
//        func processSlideModel(index: Int, completion: @escaping () -> Void) {
//            guard index < groupedBrandsSlideModel.count else {
//                // All models processed, call the completion handler
//                completion()
//                return
//            }
//            
//            let aGroupedBrandsSlideModel = groupedBrandsSlideModel[index]
//            
//            // Process each grouped slide model in the inner loop
//            let groupDispatchGroup = DispatchGroup()
//            
//            for aSlidesModel in aGroupedBrandsSlideModel.groupedSlide {
//                groupDispatchGroup.enter()
//                
//                let data = aSlidesModel.slideData
//                let utType = aSlidesModel.utType
//                
//                ObjectFormatter.shared.loadImageDataInBackground(utType: utType, data: data) { imageData in
//                    // Update the model with the retrieved image data
//                    aSlidesModel.imageData = imageData ?? Data()
//                    
//                    groupDispatchGroup.leave()
//                }
//            }
//            
//            groupDispatchGroup.notify(queue: .main) {
//                // Move to the next slide model after all inner loop tasks are completed
//                let nextIndex = index + 1
//                processSlideModel(index: nextIndex, completion: completion)
//            }
//        }
//        
//        // Start processing from index 0
//        processSlideModel(index: 0, completion: completion)
//    }
    
    func toLoadNewPresentationData() {
        self.editView.isHidden = true
        self.slidesCountHolder.isHidden = true
        toLoadBrandsTable()
        toLoadSelectedSlidesCollection()
    }
    

    func setEdit() {
        editLbl.text = isEditing ? "save" : "swap"
        editView.isHidden =  self.sledeCountLbl.text == "0" ||  self.sledeCountLbl.text == "" || self.sledeCountLbl.text == "1" ? true : false
        slidesCountHolder.isHidden = self.sledeCountLbl.text == "0" ||  self.sledeCountLbl.text == "" ? true : false
        selectedSlidesTable.isEditing = isEditing
    }
    
    func initView() {
        
        editView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.isEditing = !welf.isEditing
            welf.setEdit()
          
        }

        
        addNameTF.delegate = self
        
        playView.addTap { [weak self] in
            guard let welf = self else {return}
            
            let isToproceed =  welf.sledeCountLbl.text == "0" ||  welf.sledeCountLbl.text == "" ? false : true
            if isToproceed {
                let vc = PlayPresentationVC.initWithStory(model: welf.toSetupPlayerModel())
                welf.createPresentationVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                let commonAlert = CommonAlert()
                commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Add atleast 1 slide to preview", okAction: "Ok")
                commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    print("no action")
                }
            }
            
            
            
            
        }
        
        backHolderView.addTap {
            self.createPresentationVC.navigationController?.popViewController(animated: true)
        }
        
        
        saveVIew.addTap { [weak self] in
            guard let welf = self else {return}
            let isToproceed =  welf.toCheckDataPersistance()
            
            if isToproceed {
                if welf.createPresentationVC.isToedit {
                    welf.retriveEditandSave()
                } else {
                    welf.toSaveNewPresentation()
                }
            }
            
            
        }
        
        calcelView.addTap {
            [weak self] in
               guard let welf = self else {return}
            welf.groupedBrandsSlideModel?.forEach({ aGroupedBrandsSlideModel in
                aGroupedBrandsSlideModel.groupedSlide.forEach { aSlidesModel in
                    aSlidesModel.isSelected = false
                }
            })
//            welf.selectedSlides?.forEach({ aSlidesModel in
//                aSlidesModel.isSelected = false
//            })
            
            welf.selectedSlides =  [SlidesModel]()
            welf.toLoadBrandsTable()
            welf.toLoadselectedSlidesTable()
            welf.toLoadSelectedSlidesCollection()
            welf.sledeCountLbl.text = ""
        }
        
    }
    
    func toCheckDataPersistance() -> Bool {
        if self.sledeCountLbl.text == "" {
            let commonAlert = CommonAlert()
            commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Add atleast 1 slide to save.", okAction: "Ok")
            commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                print("no action")
            }
            return false
        } else if addNameTF.text == "" {
            let commonAlert = CommonAlert()
            commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Lets give presentation a name.", okAction: "Ok")
            commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                print("no action")
                self.alertTF()
            }
            return false
        } else {
            return true
        }
    }
    
    
//    func toSetupPlayerModel() -> [SlidesModel] {
//
//
//        var selectedSlidesModelArr = [SlidesModel]()
//
//        self.groupedBrandsSlideModel?.forEach({ aGroupedBrandsSlideModel in
//            let selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
//                aSlidesModel.isSelected == true
//            }
//            selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
//        })
//
//        selectedSlidesModelArr.sort { $0.index < $1.index }
//
//        return selectedSlidesModelArr
//
//    }
    
    func toSetupPlayerModel() -> [SlidesModel] {
        var selectedSlidesModelArr = [SlidesModel]()

        self.groupedBrandsSlideModel?.forEach { aGroupedBrandsSlideModel in
            let selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                aSlidesModel.isSelected == true
            }
            selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
        }

        selectedSlidesModelArr.sort { $0.index < $1.index }
        

        return selectedSlidesModelArr
    }
    
    
    func alertTF() {
        
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.addNameTFHolderView.backgroundColor =  .red.withAlphaComponent(0.5)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.addNameTFHolderView.backgroundColor = .appWhiteColor
                self.addNameTF.becomeFirstResponder()
            })
        }
        
    }
    
    
    func retriveEditandSave() {
        
        if let savedPresentation = self.savedPresentation {
            savedPresentation.name = self.addNameTF.text ?? ""
            CoreDataManager.shared.toEditSavedPresentation(savedPresentation: savedPresentation, id: savedPresentation.uuid) { isEdited in
                if isEdited {
                    self.toCreateToast("Presentation saved successfully.")
                } else {
                    self.toCreateToast("Error saving presentation.")
                }
                
            }
        } else {
            self.toCreateToast("Error saving presentation.")
            
        }
        
        toExiteVC()
    }
    
    func toExiteVC() {
        self.createPresentationVC.delegate?.presentationSaved()
        self.createPresentationVC.navigationController?.popViewController(animated: true)
    }
    
    func toSaveNewPresentation() {
        self.endEditing(true)
        let savedPresentation = SavedPresentation()
        savedPresentation.uuid = UUID()
        savedPresentation.name = self.addNameTF.text ?? ""
        savedPresentation.groupedBrandsSlideModel = groupedBrandsSlideModel ?? [GroupedBrandsSlideModel]()
        Shared.instance.showLoaderInWindow()
        CoreDataManager.shared.saveToCoreData(savedPresentation: savedPresentation) { isObjSaved in
            Shared.instance.removeLoaderInWindow()
            if isObjSaved {
                self.toCreateToast("Presentation saved Successfully.")
            } else {
                self.toCreateToast("Presentation might be aldready saved.")
            }
            self.toExiteVC()
        }
        
        
        
        //        CoreDataManager.shared.fetchMovies { savedCDPresentationArr in
        //            dump(savedCDPresentationArr)
        //        }
    }
    
    
    func saveObjectToDafaults() {}
    
    func cellRegistration() {
        brandsTable.register(UINib(nibName: "BrandsNameTVC", bundle: nil), forCellReuseIdentifier: "BrandsNameTVC")
        
        selectedSlidesTable.register(UINib(nibName: "SelectedSlidesTVC", bundle: nil), forCellReuseIdentifier: "SelectedSlidesTVC")
        
        selectSlidesCollection.register(UINib(nibName: "SelectPresentationCVC", bundle: nil), forCellWithReuseIdentifier: "SelectPresentationCVC")
    }
    
    func setupUI() {
        editView.layer.cornerRadius = 5
        editVxview.backgroundColor = .appTextColor
        editLbl.textColor = .appTextColor
        brandsTable.separatorStyle = .none
        editLbl.setFont(font: .bold(size: .BODY))
        selectedSlidesTable.separatorStyle = .none
        self.backgroundColor = .appGreyColor
        navigationVIew.backgroundColor = .appTextColor
        titleLbl.setFont(font: .bold(size: .SUBHEADER))
        selectSlidesCollectionHolder.backgroundColor = .appWhiteColor
        selectedSlidesTableHolder.backgroundColor = .appWhiteColor
        selectedSlidesTableHolder.layer.cornerRadius = 5
        selectSlidesCollectionHolder.layer.cornerRadius = 5
        slidesTutle.setFont(font: .bold(size: .BODY))
        slidesTutle.textColor = .appTextColor
        slidesCountHolder.layer.cornerRadius = 3
        sledesCountVxView.backgroundColor = .appTextColor.withAlphaComponent(0.2)
        sledeCountLbl.setFont(font: .bold(size: .BODY))
        sledeCountLbl.text = ""
        playView.backgroundColor = .appTextColor
        playView.layer.cornerRadius = 5
        playLbl.setFont(font: .bold(size: .BODY))
        calcelView.layer.cornerRadius = 5
        calcelView.backgroundColor = .appTextColor.withAlphaComponent(0.2)
        cancelLbl.setFont(font: .bold(size: .BODY))
        calcelView.backgroundColor = .appLightTextColor
        calcelView.layer.borderWidth = 0.5
        calcelView.layer.borderColor =  UIColor.appTextColor.cgColor
        saveVIew.layer.cornerRadius = 5
        saveLbl.textColor = .appWhiteColor
        saveLbl.setFont(font: .bold(size: .BODY))
        saveVIew.backgroundColor = .appTextColor
        addNameTF.font = UIFont(name: "Satoshi-Medium", size: 14)
        addNameTFHolderView.layer.cornerRadius = 5
        addNameTFHolderView.layer.borderColor =  UIColor.appSelectionColor.cgColor
        addNameTFHolderView.layer.borderWidth = 0.5
    }
    
    func toLoadBrandsTable() {
        brandsTable.delegate = self
        brandsTable.dataSource = self
        brandsTable.reloadData()
    }
    
    func toLoadselectedSlidesTable() {

        //selectedSlidesTable.isEditing = true
        selectedSlidesTable.delegate = self
        selectedSlidesTable.dataSource = self

        selectedSlidesTable.dragInteractionEnabled = true
        selectedSlidesTable.reloadData()
    }
    
    
    
    
    func toLoadSelectedSlidesCollection() {
        selectSlidesCollection.delegate = self
        selectSlidesCollection.dataSource = self
        selectSlidesCollection.reloadData()
    }
    
    func toEditPresentationData() {
     
        self.savedPresentation = createPresentationVC.savedPresentation
        self.groupedBrandsSlideModel = self.savedPresentation?.groupedBrandsSlideModel
        self.addNameTF.text = self.savedPresentation?.name
        var slideModel = [SlidesModel]()
        self.groupedBrandsSlideModel?.forEach({ aGroupedBrandsSlideModel in
            
            let selectedSlides =  aGroupedBrandsSlideModel.groupedSlide.filter({ $0.isSelected })
            
            slideModel.append(contentsOf: selectedSlides)
        })
        
        self.selectedSlides = slideModel.filter({ aSlideModel in
            aSlideModel.isSelected
        })
        
        self.selectedSlides?.sort { $0.index < $1.index }
        
      
        //   self.selectedSlides = slideModel
        if  slideModel.isEmpty {
            self.sledeCountLbl.text = ""
            self.editView.isHidden = true
            self.slidesCountHolder.isHidden = true
        } else {
           toSetCount()
        }
        
        
        
        toLoadBrandsTable()
        toLoadSelectedSlidesCollection()
        toLoadselectedSlidesTable()
    }
    

}

extension CreatePresentationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectPresentationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPresentationCVC", for: indexPath) as! SelectPresentationCVC
        
        let model: SlidesModel? = self.groupedBrandsSlideModel?[selectedBrandsIndex].groupedSlide[indexPath.row] ?? SlidesModel()
        cell.toPopulateCell(model ?? SlidesModel())
        
        
        if model?.isSelected == true {
            cell.selectionView.isHidden = false
            cell.selectedVxVIew.isHidden = false
        } else {
            cell.selectionView.isHidden = true
            cell.selectedVxVIew.isHidden = true
        }
        
        
        
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            model?.isSelected = model?.isSelected == true ? false : true
            welf.toManageSelectedSlides()
            welf.selectSlidesCollection.reloadData()
            welf.toSetCount()
            welf.toLoadselectedSlidesTable()
            welf.brandsTable.reloadData()
           
        }
        
        return cell
    }
    
    func toSetCount() {
        let selectedSlidesCount = self.selectedSlides?.reduce(0) { $1.isSelected ? $0 + 1 : $0 } ?? 0
        self.sledeCountLbl.text = "\(selectedSlidesCount)"
        editView.isHidden =  self.sledeCountLbl.text == "0" || self.sledeCountLbl.text == "" || self.sledeCountLbl.text == "1" ? true : false
        slidesCountHolder.isHidden = self.sledeCountLbl.text == "0" || self.sledeCountLbl.text == "" ? true : false
    }
    
//    func toManageSelectedSlides() {
//        self.selectedSlides = self.groupedBrandsSlideModel?.flatMap { aGroupedBrandsSlideModel in
//            aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
//                aSlidesModel.isSelected
//            }
//        }
//        self.selectedSlides?.sort {$0.index < $1.index}
//    }
    
    
    func toManageSelectedSlides() {
        self.selectedSlides = self.groupedBrandsSlideModel?.flatMap {
            $0.groupedSlide.filter { $0.isSelected }.sorted(by: { $0.index < $1.index })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.groupedBrandsSlideModel?.count != 0  else {
            return 0
        }
        
        return self.groupedBrandsSlideModel?[selectedBrandsIndex].groupedSlide.count ?? 0
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 2, height: collectionView.height / 4)
    }
    
}

extension CreatePresentationView: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case brandsTable:
            return self.groupedBrandsSlideModel?.count ?? 0
        case selectedSlidesTable:
//            let selectedSlides = self.groupedBrandsSlideModel?.flatMap { aGroupedBrandsSlideModel in
//                aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
//                    aSlidesModel.isSelected
//                }
//            }
            return self.selectedSlides?.count ?? 0
            //selectedSlides?.count ?? 0
            //selectedSlidesModel?.slideNames.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case brandsTable:
            let cell: BrandsNameTVC = brandsTable.dequeueReusableCell(withIdentifier: "BrandsNameTVC", for: indexPath) as! BrandsNameTVC
            cell.selectionStyle = .none
            let model = groupedBrandsSlideModel?[indexPath.row] ?? GroupedBrandsSlideModel()
            cell.toPopulateCell(model)
            cell.contentsHolderView.layer.borderWidth = 0
            cell.contentsHolderView.layer.borderColor = UIColor.clear.cgColor
            cell.contentsHolderView.elevate(0)
            cell.accessoryIV.image = UIImage(systemName: "chevron.down")
        
            if selectedBrandsIndex == indexPath.row {
                cell.contentsHolderView.layer.borderWidth = 0.5
                cell.contentsHolderView.layer.borderColor = UIColor.appTextColor.cgColor
                cell.contentsHolderView.elevate(1)
                cell.accessoryIV.image = UIImage(systemName: "chevron.right")
            
       
            }
            
            cell.addTap {[weak self] in
                guard let welf = self else {return}
                welf.selectedBrandsIndex = indexPath.row
                welf.brandsTable.reloadData()
                welf.selectSlidesCollection.reloadData()
            }
            
     return cell
            
            
        case selectedSlidesTable:
            let cell: SelectedSlidesTVC = selectedSlidesTable.dequeueReusableCell(withIdentifier: "SelectedSlidesTVC", for: indexPath) as! SelectedSlidesTVC
            cell.showsReorderControl = false
            cell.selectionStyle = .none
            //self.selectedSlidesModel?.slideNames[indexPath.row]
//            let selectedSlides = self.groupedBrandsSlideModel?.flatMap { aGroupedBrandsSlideModel in
//                aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
//                    aSlidesModel.isSelected
//                }
//            }
            var model: SlidesModel?
            if let slides = self.selectedSlides?.sorted(by: { $0.index < $1.index }) {
                let slidesmodel = slides[indexPath.row]
                model = slidesmodel
                // Use the 'model' here
            } else {
                // Handle the case when 'selectedSlides' is nil
            }
            cell.toPopulateCell(model: model ?? SlidesModel())
            cell.deleteoptionView.addTap { [weak self] in
                guard let welf = self else {return}

                welf.groupedBrandsSlideModel?[welf.selectedBrandsIndex].groupedSlide.forEach({ aSlideModel in
                    if  aSlideModel.slideId == model?.slideId {
                        aSlideModel.isSelected = false
                    }
                })
                
                
                model?.isSelected = false
                welf.toSetCount()
                welf.toManageSelectedSlides()
                welf.selectedSlidesTable.reloadData()
                welf.selectSlidesCollection.reloadData()
                welf.brandsTable.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case brandsTable:
            return tableView.height / 9.5
            default:
            return tableView.height / 6
            
        }
    }
    
    
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var selectedSlides = self.groupedBrandsSlideModel?.flatMap { aGroupedBrandsSlideModel in
            aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                aSlidesModel.isSelected
            }
        }
        
        selectedSlides?.sort {$0.index < $1.index}
        
        selectedSlides?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        
        // Set the index property based on the rearranged order
        if let unwrappedSelectedSlides = selectedSlides {
            for (index, selectedSlide) in unwrappedSelectedSlides.enumerated() {
                selectedSlide.index = index
            }
        }

        // Update the groupedBrandsSlideModel with the modified selectedSlides
        for groupedBrandsSlideModel in self.groupedBrandsSlideModel ?? [] {
            for selectedSlide in selectedSlides! {
                if var groupedSlide = groupedBrandsSlideModel.groupedSlide.first(where: { $0.uuid == selectedSlide.uuid }) {
                    groupedSlide.index = selectedSlide.index
                }
            }
        }


        self.selectedSlides = selectedSlides
        self.selectedSlidesTable.reloadData()
    }
    
    
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         return .none
    }
    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


