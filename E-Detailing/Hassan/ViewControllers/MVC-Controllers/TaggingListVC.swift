//
//  TaggingListVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/04/24.
//

import Foundation
import UIKit
import CoreData

class TaggingListVC : UIViewController {
    
    
    @IBOutlet weak var lblCollection: UILabel!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var resoureHQlbl: UILabel!
    
    @IBOutlet var selectHQholder: UIView!
    @IBOutlet var textFieldHolderView: UIView!
    var fetchedHQObject: Subordinate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var masterVM = MasterSyncVM()
    var type : TaggingType!
    
    var searchText : String = ""
    
    var doctor = [DoctorFencing]()
    
    
    private var customerListViewModel = CustomerListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        self.lblCollection.text = self.type.name
        
        self.collectionView.register(UINib(nibName: "DCRTaggingCell", bundle: nil), forCellWithReuseIdentifier: "DCRTaggingCell")
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = layout
     
        selectHQholder.layer.cornerRadius = 5
        selectHQholder.layer.borderWidth = 1
        selectHQholder.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
       // self.txtSearch.setIcon(UIImage(imageLiteralResourceName: "searchIcon"))
        self.txtSearch.addTarget(self, action: #selector(updateCustomerData(_:)), for: .editingChanged)
        
        self.doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
        setHQlbl()
        
        
        selectHQholder.addTap {
            if   Shared.instance.isFetchingHQ {
                self.toCreateToast("Syncing please wait")
                return
            }
            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR)  {
                return
            }
            
            
            let vc = SpecifiedMenuVC.initWithStory(self, celltype: .headQuater)
            
            vc.menuDelegate = self
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
            vc.selectedObject = self.fetchedHQObject
            
            self.modalPresentationStyle = .custom
            self.navigationController?.present(vc, animated: false)
        }
    }
    
    
    deinit {
        print("TaggingListVC deallocated")
    }
    
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setHQlbl(istoCallapi: Bool? = false) {
        textFieldHolderView.layer.cornerRadius = 5
        textFieldHolderView.layer.borderWidth = 1
        textFieldHolderView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        // let appsetup = AppDefaults.shared.getAppSetUp()
            CoreDataManager.shared.toRetriveSavedHQ { hqModelArr in
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
                  //  self.toloadCallsCollection()
                }
            
              
      
 
                
            }
            // Retrieve Data from local storage
            //   return
        

       
    }
    
    @objc func updateCustomerData(_ sender : UITextField) {
        
        
        self.searchText = sender.text ?? ""
        
        self.collectionView.reloadData()
        
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}




extension TaggingListVC : collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.customerListViewModel.numberOfRows(self.type, searchText: self.searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRTaggingCell", for: indexPath) as! DCRTaggingCell
        cell.customer = self.customerListViewModel.fetchDataAtIndex(indexPath.row, type: self.type, searchText: self.searchText)
        
        cell.btnView.addTarget(self, action: #selector(viewAction(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func viewAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: buttonPosition) else {
            return
        }
        
        let tagViewVC = UIStoryboard.tagViewVC
        tagViewVC.customer = self.customerListViewModel.fetchDataAtIndex(indexPath.row, type: self.type, searchText: self.searchText)
        self.navigationController?.pushViewController(tagViewVC, animated: true)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let width = self.collectionView.frame.width / 4
//        let size = CGSize(width: width - 10, height: 240)
//        return size
        
        let width = self.collectionView.frame.width / 4
    
        let size = CGSize(width: width - 10, height: collectionView.height / 3.5)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagVC  = UIStoryboard.tagVC
        let model =  self.customerListViewModel.fetchDataAtIndex(indexPath.row, type: self.type, searchText: self.searchText)
        tagVC.customer = model
        if model.maxCount ==  model.geoCount {
            self.toCreateToast("Maximum tags added")
            return
        }
        tagVC.delegate = self
        self.navigationController?.pushViewController(tagVC, animated: true)
    }
    
}
extension TaggingListVC: TagVCDelegate {
    func didUsertagged() {
        Shared.instance.showLoaderInWindow()
        masterVM.fetchMasterData(type: .clusters, sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: true, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { _ in
            self.collectionView.reloadData()
            Shared.instance.removeLoaderInWindow()
        }
        

    }
    
    
}

extension TaggingListVC: MenuResponseProtocol {
     func passProductsAndInputs(additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        switch type {

        case .headQuater:
            Shared.instance.isFetchingHQ = true
            guard let selectedObject = selectedObject as? Subordinate else {
                Shared.instance.isFetchingHQ = false
                return
            }

           // self.fetchedHQObject = selectedObject
            let aHQobj = HQModel()
            aHQobj.code = selectedObject.id ?? ""
            aHQobj.mapId = selectedObject.mapId ?? ""
            aHQobj.name = selectedObject.name ?? ""
            aHQobj.reportingToSF = selectedObject.reportingToSF ?? ""
            aHQobj.steps = selectedObject.steps ?? ""
            aHQobj.sfHQ = selectedObject.sfHq ?? ""

            
            
            let territories = DBManager.shared.getTerritory(mapID:  selectedObject.id ?? "")
            LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
            if  LocalStorage.shared.getBool(key: .isConnectedToNetwork) || territories.isEmpty  {
                self.resoureHQlbl.text = "Syncing..."
                //&& isConnected
                let tosyncMasterData : [MasterInfo]  = [.clusters, .doctorFencing, .chemists, .unlistedDoctors, .stockists]
                // Set loading status based on MasterInfo for each element in the array
                tosyncMasterData.forEach { masterInfo in
                    MasterInfoState.loadingStatusDict[masterInfo] = .isLoading
                }
                self.collectionView.reloadData()
                self.masterVM = MasterSyncVM()
                Shared.instance.showLoaderInWindow()
                masterVM.fetchMasterData(type: .clusters, sfCode: selectedObject.id ?? "", istoUpdateDCRlist: true, mapID: selectedObject.id ?? "") { response in
                    Shared.instance.removeLoaderInWindow()
                    switch response.result {
                    case .success(_):
                        tosyncMasterData.forEach { masterType in
                            MasterInfoState.loadingStatusDict[masterType] = .loaded
                        }
                        self.fetchedHQObject = selectedObject
                        CoreDataManager.shared.removeHQ()
                        CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                            LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
                            self.setHQlbl()
                            self.collectionView.reloadData()
                            Shared.instance.isFetchingHQ = false
                          //  self.isDayPlanSynced = true
                        }
                  
                    case .failure(_):
                        tosyncMasterData.forEach { masterType in
                            MasterInfoState.loadingStatusDict[masterType] = .error
                        }
                        self.collectionView.reloadData()
                        Shared.instance.isFetchingHQ = false
                    }
                }
            } else {
                self.fetchedHQObject = selectedObject
                CoreDataManager.shared.removeHQ()
                CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) { _ in
                    LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: selectedObject.id ?? "")
                    self.setHQlbl()
                    self.collectionView.reloadData()
                    Shared.instance.isFetchingHQ = false
                }
            }

           
            
        default:
            print("Yet to implement.")
        }
        
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("")
    }
    func routeToView(_ view : UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
