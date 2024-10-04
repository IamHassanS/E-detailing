//
//  SelectedPreviewTypesCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/02/24.
//

import UIKit

protocol SelectedPreviewTypesCVCDelegate: AnyObject {
    func didPlayTapped(playerModel: [SlidesModel], pageState: PlayPresentationView.PageState)
}

extension SelectedPreviewTypesCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.previewType {
            
        case .home:
            return groupedBrandsSlideModel?.count ?? 0
        case .brand:
            return groupedBrandsSlideModel?.count ?? 0
        case .speciality:
            return groupedBrandsSlideModel?.count ?? 0
        case .customPresentation:
            return savedPresentationArr?.count ?? 0
        case .therapist:
            return groupedBrandsSlideModel?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BrandsPreviewCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsPreviewCVC", for: indexPath) as!  BrandsPreviewCVC
        switch self.previewType {
            
        case .home:
            let model: GroupedBrandsSlideModel = groupedBrandsSlideModel?[indexPath.row] ?? GroupedBrandsSlideModel()
            cell.toPopulateCell(model)
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.delegate?.didPlayTapped(playerModel: welf.toSetupPlayerModel(indexPath.row), pageState: .minimized)
            }
        case .brand:
            let model: GroupedBrandsSlideModel = groupedBrandsSlideModel?[indexPath.row] ?? GroupedBrandsSlideModel()
            cell.toPopulateCell(model)
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.delegate?.didPlayTapped(playerModel: welf.toSetupPlayerModel(indexPath.row), pageState: .minimized)
            }
           
        case .speciality:
            let model: GroupedBrandsSlideModel = groupedBrandsSlideModel?[indexPath.row] ?? GroupedBrandsSlideModel()
            cell.toPopulateCell(model)
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.delegate?.didPlayTapped(playerModel: welf.toSetupPlayerModel(indexPath.row), pageState: .minimized)
            }
        case .customPresentation:
            let model: SavedPresentation = self.savedPresentationArr?[indexPath.row] ?? SavedPresentation()
            cell.toPopulateCell(model: model)
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.delegate?.didPlayTapped(playerModel: welf.toSetupPlayerModel(indexPath.row), pageState: .minimized)
            }
            
        case .therapist:
            let model: GroupedBrandsSlideModel = groupedBrandsSlideModel?[indexPath.row] ?? GroupedBrandsSlideModel()
            cell.toPopulateCell(model)
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.delegate?.didPlayTapped(playerModel: welf.toSetupPlayerModel(indexPath.row), pageState: .expanded)
            }
        }
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 4, height: collectionView.height / 2.5)
    }
    
    
    func toSetupPlayerModel(_ index: Int) -> [SlidesModel] {
     switch self.previewType {


     case .customPresentation:
         var selectedSlidesModelArr = [SlidesModel]()
         if let savePresentationArr = self.savedPresentationArr {
             let selectedPresentation = savePresentationArr[index]
             selectedPresentation.groupedBrandsSlideModel.forEach({ aGroupedBrandsSlideModel in
                 let selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                     aSlidesModel.isSelected == true
                 }
               
                 selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
             })
          
         }
       
         selectedSlidesModelArr.sort{$0.index < $1.index}
         return selectedSlidesModelArr
         
     default:
        // var selectedSlidesModelArr = [SlidesModel]()
         if let groupedBrandsSlideModel = self.groupedBrandsSlideModel?[index] {
             let slideArr = groupedBrandsSlideModel.groupedSlide
             
             return slideArr
         }
      return [SlidesModel]()
         
     }

        
    }
    
}


class SelectedPreviewTypesCVC: UICollectionViewCell {
    @IBOutlet var selectedPreviewTypeCollection: UICollectionView!
    var groupedBrandsSlideModel : [GroupedBrandsSlideModel]?
    var savedPresentationArr : [SavedPresentation]?
    var previewType: PreviewHomeView.PreviewType = .home
    weak var delegate: SelectedPreviewTypesCVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

        cellRegistration()
    }
    
    
    func toPopulateCell(_ model: [GroupedBrandsSlideModel], type: PreviewHomeView.PreviewType, state: PreviewHomeView.SortState) {
        self.previewType = type
        self.groupedBrandsSlideModel = model
        
        switch state {
            
        case .ascending:
            groupedBrandsSlideModel?.sort { (firstGroup, secondGroup) -> Bool in
                // Assuming the first and second groups have at least one slide
                guard let firstName = firstGroup.groupedSlide.first?.name,
                      let secondName = secondGroup.groupedSlide.first?.name else {
                    return false
                }
                
                return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedAscending
            }
        case .decending:
            groupedBrandsSlideModel?.sort { (firstGroup, secondGroup) -> Bool in
                // Assuming the first and second groups have at least one slide
                guard let firstName = firstGroup.groupedSlide.first?.name,
                      let secondName = secondGroup.groupedSlide.first?.name else {
                    return false
                }
                
                return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedDescending
            }
        case .none:
            print("No state order based on priority")
            
        }

        
        toLoadData()
    }
    
    
    func toPopulateCell(model: [SavedPresentation], type: PreviewHomeView.PreviewType, state:  PreviewHomeView.SortState) {
        self.savedPresentationArr = model
        switch state {
        case .ascending:
            self.savedPresentationArr?.sort { (firstGroup, secondGroup) -> Bool in
                // Assuming the first and second groups have at least one slide
                 let firstName = firstGroup.name
                 let secondName = secondGroup.name
                
                return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedAscending
            }
        case .decending:
            self.savedPresentationArr?.sort { (firstGroup, secondGroup) -> Bool in
                // Assuming the first and second groups have at least one slide
                 let firstName = firstGroup.name
                 let secondName = secondGroup.name
                
                return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedDescending
            }
        case .none:
            print("No state order based on priority")
        }
        
        self.previewType = type
        if  model.count > 0 {
            toLoadData()
        }
   
    }

    func cellRegistration() {
        
        selectedPreviewTypeCollection.register(UINib(nibName: "BrandsPreviewCVC", bundle: nil), forCellWithReuseIdentifier: "BrandsPreviewCVC")
        
    }
    func toLoadData() {
        selectedPreviewTypeCollection.delegate = self
        selectedPreviewTypeCollection.dataSource = self
        selectedPreviewTypeCollection.reloadData()
    }
    
}
