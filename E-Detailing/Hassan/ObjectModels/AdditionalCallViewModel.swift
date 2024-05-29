//
//  AdditionalCallViewModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 17/04/24.
//

import Foundation


class AdditionalCallsListViewModel {
    
     var additionalCallListViewModel = [AdditionalCallViewModel] ()
    
    func addAdditionalCallViewModel(_ vm : AdditionalCallViewModel) {
        additionalCallListViewModel.append(vm)
    }
    
    func numberOfSelectedRows() -> Int {
        return additionalCallListViewModel.count
    }
    
    func getAdditionalCallData() -> [AdditionalCallViewModel]{
        return additionalCallListViewModel
    }
    
    func removeAtindex(_ index :Int) {
        additionalCallListViewModel.remove(at: index)
    }
    
    func fetchDataAtIndex(_ index :Int) -> AdditionalCallViewModel {
        return additionalCallListViewModel[index]
    }
    
    func removeById(id : String) {
        additionalCallListViewModel.removeAll{$0.docCode == id}
    }
        
    func fetchAdditionalCallData(_ index : Int , searchText : String, code: Int? = nil) -> Objects {
        let additionalCall = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) : DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let value = self.getAdditionalCallData()
        let isSelected = value.filter{$0.docCode.contains(additionalCall[index].code ?? "")}
        return Objects(Object: additionalCall[index], isSelected:  isSelected.isEmpty ? false : true, priority: "")
    }
    
    func numberofAdditionalCalls(searchText : String) -> Int {
        let additionalCalls = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) : DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        return additionalCalls.count
    }
    
    
    func addProductAtIndex (_ section : Int, vm : ProductViewModel) {
        additionalCallListViewModel[section].productSelectedListViewModel.addProductViewModel(vm)
    }
    
    func updateProductAtSection(_ section : Int, index : Int, product : Product) {
        additionalCallListViewModel[section].productSelectedListViewModel.setProductAtIndex(index, product: product)
    }
    
    func updateProductQtyAtSection(_ section : Int, index : Int, qty : String) {
        additionalCallListViewModel[section].productSelectedListViewModel.setSampleCountAtIndex(index, qty: qty)
    }
    
    func addInputAtIndex(_ section : Int, vm : InputViewModel) {
        additionalCallListViewModel[section].inputSelectedListViewModel.addInputViewModel(vm)
    }
    
    func updateInCallSection(_ section : Int , isView : Bool) {
        additionalCallListViewModel[section].isView = isView
    }
    
    func updateInputAtSection(_ section : Int, index : Int, input : Input) {
        additionalCallListViewModel[section].inputSelectedListViewModel.setInputAtIndex(index, input: input)
    }
    
    func updateInputAtSection(_ section : Int, index : Int, qty : String){
        additionalCallListViewModel[section].inputSelectedListViewModel.setInputCodeAtIndex(index, samQty: qty)
    }
    
    func deleteProductAtIndex(_ section : Int,index: Int){
        additionalCallListViewModel[section].productSelectedListViewModel.removeAtIndex(index)
    }
    
    func deleteInputAtIndex (_ section : Int,index: Int){
        additionalCallListViewModel[section].inputSelectedListViewModel.removeAtIndex(index)
    }
    
    func fetchProductAtIndex(_ section : Int, index : Int) -> ProductViewModel {
        additionalCallListViewModel[section].productSelectedListViewModel.fetchDataAtIndex(index)
    }
    
    func fetchInputAtIndex(_ section : Int, index : Int) -> InputViewModel {
        additionalCallListViewModel[section].inputSelectedListViewModel.fetchDataAtIndex(index)
    }
    
    func numberOfProductsInSection(_ section : Int) -> Int{
        if additionalCallListViewModel.isEmpty {
            return 0
        }
        return additionalCallListViewModel[section].productSelectedListViewModel.fetchAllProducts()?.count ?? 0
        //numberOfRows()
    }
    
    func numberOfInputsInSection(_ section : Int) -> Int {
        if additionalCallListViewModel.isEmpty {
            return 0
        }
        return additionalCallListViewModel[section].inputSelectedListViewModel.fetchAllInput()?.count ?? 0
            //.numberOfRows()
    }
    
}

class AdditionalCallViewModel {
    
    var additionalCall : DoctorFencing?
    var isView : Bool
    
    var productSelectedListViewModel = ProductSelectedListViewModel()
    var inputSelectedListViewModel = InputSelectedListViewModel()
    
    var products = [ProductViewModel]()
    
    var inputs  = [InputViewModel]()
    
    init(additionalCall: DoctorFencing?, isView: Bool, productSelectedListViewModel: ProductSelectedListViewModel = ProductSelectedListViewModel(), inputSelectedListViewModel: InputSelectedListViewModel = InputSelectedListViewModel()) {
        self.additionalCall = additionalCall ?? nil
        self.isView = isView
        self.productSelectedListViewModel = productSelectedListViewModel
        self.inputSelectedListViewModel = inputSelectedListViewModel
    }
    
    
    var docName : String {
        return additionalCall?.name ?? ""
    }
    
    var docCode : String {
        return additionalCall?.code ?? ""
    }
    
    var docTownCode : String {
        return additionalCall?.townCode ?? ""
    }
    
    var docTownName : String {
        return additionalCall?.townName ?? ""
    }
    
}
