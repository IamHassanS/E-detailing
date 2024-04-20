//
//  ProductViewModel.swift
//  E-Detailing
//
//  Created by SANEFORCE on 16/08/23.
//

import Foundation

class ProductSelectedListViewModel {
    
    private var productViewModel = [ProductViewModel]()
    
    func fetchAllProducts() -> [Product]? {
        return productViewModel.map { $0.product.product ?? Product() }
        
    }
    
    
    func fetchProductData(_ index : Int , searchText : String , type : DCRType , selectedDoctorCode : String) -> Objects {
        
        if type == DCRType.doctor {
            
            let doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{$0.code == selectedDoctorCode}
            
            if doctor.first?.productCode == "" {
                let product = searchText == "" ? DBManager.shared.getProduct() : DBManager.shared.getProduct().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                
                
                let value = self.productData()
                
                let isSelected = value.filter{$0.code.contains(product[index].code ?? "")}
                return Objects(Object: product[index], isSelected: isSelected.isEmpty ? false : true, priority: "")
            }else {
                let code = doctor.first?.productCode ?? ""
                
                let product = searchText == "" ? DBManager.shared.getProduct() : DBManager.shared.getProduct().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                
                
                let pri = product.filter{code.contains($0.code ?? "")}
                
                let codee = product.filter{!code.contains($0.code ?? "")}
                
                
                var productArray = [Product]()
                
                let value = self.productData()
                
                var priority : String = ""
                
                let codeArray = code.components(separatedBy: ",")
                
                for code in codeArray {
                    let product = pri.filter{$0.code == code}
                    
                    if !product.isEmpty {
                        productArray.append(product.first!)
                    }
                }
                
                let orderedProduct = productArray + codee
                
                if let priorityIndex = codeArray.firstIndex(of: orderedProduct[index].code ?? ""){
                    priority = "P" + "\(priorityIndex + 1)"
                }
                
                let isSelected = value.filter{$0.code.contains(orderedProduct[index].code ?? "")}
                return Objects(Object: orderedProduct[index], isSelected: isSelected.isEmpty ? false : true, priority: priority)
            }
        }else {
            let product = searchText == "" ? DBManager.shared.getProduct() : DBManager.shared.getProduct().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            
            let value = self.productData()
            
            let isSelected = value.filter{$0.code.contains(product[index].code ?? "")}
            return Objects(Object: product[index], isSelected: isSelected.isEmpty ? false : true, priority: "")
        }
    }
    
    func numberOfProducts(searchText : String) -> Int {
        let products = searchText == "" ? DBManager.shared.getProduct() : DBManager.shared.getProduct().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        return products.count
    }
    
    func addProductViewModel(_ vm : ProductViewModel) {
        productViewModel.append(vm)
    }
    
    func numberOfRows() -> Int {
        return productViewModel.count
    }
    
    func productData() -> [ProductViewModel] {
        return productViewModel
    }
    
    func removeAtIndex(_ index : Int) {
        productViewModel.remove(at: index)
    }
    
    func removeById(_ id : String) {
        productViewModel.removeAll{$0.code == id}
    }
    
    func fetchDataAtIndex(_ index : Int) -> ProductViewModel {
        return productViewModel[index]
    }
    
    func setSampleCountAtIndex(_ index : Int , qty : String) {
        productViewModel[index].product.updateSampleCount(qty)
    }
    
    func setRxCountAtIndex(_ index : Int , qty : String) {
        productViewModel[index].product.updateRxCount(qty)
    }
    
    func setRcpaCountAtIndex(_ index : Int , qty : String) {
        productViewModel[index].product.updateRcpaCount(qty)
    }
    
    func setAvailableCountAtIndex(_ index : Int , qty : String) {
        productViewModel[index].product.updateAvailableCount(qty)
    }
    
    func setTotalCountAtIndex(_ index : Int , qty : String) {
        productViewModel[index].product.updateTotalCount(qty)
    }
    
    func setIsDetailedProductAtIndex(_ index : Int , isDetailed : Bool) {
        productViewModel[index].product.updateDetailedProduct(isDetailed)
    }
    
    func setProductAtIndex(_ index : Int , product : Product) {
        productViewModel[index].product.updateProduct(product)
    }
}

class ProductViewModel {
    
    var product : ProductData
    
    init(product: ProductData) {
        self.product = product
    }
    
    var name : String {
        return product.product?.name ?? ""
    }
    
    var code : String {
        return product.product?.code ?? ""
    }
    
    var mode : String {
        return product.product?.productMode ?? ""
    }
    
    var sampleCount : String {
        return product.sampleCount
    }
    var rxCount : String {
        return product.rxCount
    }
    
    var rcpaCount : String {
        return product.rcpaCount
    }
    
    var availableCount : String {
        return product.availableCount
    }
    
    var totalCount : String {
        return product.totalCount
    }
    
    var isDetailed : Bool {
        return product.isDetailed
    }
}
 
struct ProductData {
    
    var product : Product?
    var isDetailed : Bool
    var sampleCount : String
    var rxCount : String
    var rcpaCount : String
    var availableCount : String
    var totalCount : String
    
    mutating func updateProduct(_ selectedProduct : Product) {
        product = selectedProduct
    }
    
    mutating func updateDetailedProduct (_ isDetailedProduct : Bool) {
        isDetailed = isDetailedProduct
    }
    
    mutating func updateSampleCount(_ value : String){
        sampleCount = value
    }
    
    mutating func updateRxCount(_ value : String) {
        rxCount = value
    }
    
    mutating func updateRcpaCount(_ value : String) {
        rcpaCount = value
    }
    
    mutating func updateAvailableCount(_ value : String){
        availableCount = value
    }
    
    mutating func updateTotalCount(_ value : String) {
        totalCount = value
    }
}



