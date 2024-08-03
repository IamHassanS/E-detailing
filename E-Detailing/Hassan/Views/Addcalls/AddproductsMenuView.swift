//
//  AddproductsMenuView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/03/24.
//

import Foundation
import UIKit

extension AddproductsMenuView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return string == numberFiltered && newString.length <= maxLength
    }
}

extension AddproductsMenuView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.segmentType[selectedSegmentsIndex] {
            
        case .products:
            
            return 50
        case .inputs:
            return 50


        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch self.segmentType[selectedSegmentsIndex] {
            
        case .products:
            
            return 60
        case .inputs:
            return 60


        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch self.segmentType[selectedSegmentsIndex] {
            
        case .inputs:
            guard let headerView = additionalCallSampleInputTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddadditionalProductsFooter") as? AddadditionalProductsFooter else {
     
                return UIView()
            }
            headerView.btnAddtype?.setTitle("Add Input", for: .normal)
            headerView.btnAddtype.addTarget(self, action: #selector(addAdditionalCallSampleInput(_:)), for: .touchUpInside)

            return headerView
        case .products:
            guard let headerView = additionalCallSampleInputTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddadditionalProductsFooter") as? AddadditionalProductsFooter else {
               
                
                
                return UIView()
            }


            headerView.btnAddtype?.setTitle("Add Product", for: .normal)
            headerView.btnAddtype.addTarget(self, action: #selector(addAdditionalCallSampleInput(_:)), for: .touchUpInside)

            return headerView
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.segmentType[selectedSegmentsIndex] {
            
        case .inputs:
            guard let headerView = additionalCallSampleInputTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddAdditionalproductsHeader") as? AddAdditionalproductsHeader else {
     
                return UIView()
            }


            headerView.typeTitle.text = "Input"
            return headerView
        case .products:
            guard let headerView = additionalCallSampleInputTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddAdditionalproductsHeader") as? AddAdditionalproductsHeader else {
     
                return UIView()
            }

            headerView.typeTitle.text = "Product"

            return headerView
        }
    
    
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
            return self.addproductsMenuVC?.additionalCallListViewModel?.numberOfProductsInSection(self.selectedDoctorIndex) ?? 0
        case .inputs:
            return self.addproductsMenuVC?.additionalCallListViewModel?.numberOfInputsInSection(self.selectedDoctorIndex) ?? 0
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalCallSampleEntryTableViewCell", for: indexPath) as! AdditionalCallSampleEntryTableViewCell
        cell.txtSampleStock.delegate = self
        cell.txtSampleStock.isUserInteractionEnabled = true
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
            cell.product = self.addproductsMenuVC?.additionalCallListViewModel?.fetchProductAtIndex(self.selectedDoctorIndex, index: indexPath.row)
            if   cell.product.mode.lowercased() == "sale" {
                cell.txtSampleStock.isUserInteractionEnabled = false
            } else if  cell.product.mode.lowercased() == "sale/sample" {
                cell.txtSampleStock.isUserInteractionEnabled = true
                cell.txtSampleStock.addTarget(self, action: #selector(updateSampleInputQty(_:)), for: .editingChanged)
            } else if cell.product.mode.lowercased() == "sample" {
                cell.txtSampleStock.isUserInteractionEnabled = true
                cell.txtSampleStock.addTarget(self, action: #selector(updateSampleInputQty(_:)), for: .editingChanged)
            }
        case .inputs:
        let addedInput = self.addproductsMenuVC?.additionalCallListViewModel?.fetchInputAtIndex(self.selectedDoctorIndex, index: indexPath.row)
            cell.input = addedInput
            if addedInput?.code != "-1" {
                cell.txtSampleStock.isUserInteractionEnabled = true
                cell.txtSampleStock.addTarget(self, action: #selector(updateSampleInputQty(_:)), for: .editingChanged)
            } else {
                cell.txtSampleStock.isUserInteractionEnabled = false
   
            }
            
        }
        cell.btnProduct.addTarget(self, action: #selector(additionalCallSampleInputSelection(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(deleteAdditionalCallSampleInput(_:)), for: .touchUpInside)


        return cell
    }
    
    @objc func didProductSampleChanged() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func updateSampleInputQty(_ sender : UITextField) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
            self.addproductsMenuVC?.additionalCallListViewModel?.updateProductQtyAtSection(self.selectedDoctorIndex, index: indexPath.row, qty: sender.text ?? "")
            break
        case .inputs:
            self.addproductsMenuVC?.additionalCallListViewModel?.updateInputAtSection(self.selectedDoctorIndex, index: indexPath.row, qty: sender.text ?? "")
            break
        }
    }
    
    @objc func deleteAdditionalCallSampleInput(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
          
                self.addproductsMenuVC?.additionalCallListViewModel?.deleteProductAtIndex(self.selectedDoctorIndex, index: indexPath.row)
                self.additionalCallSampleInputTableView.reloadData()
            break
      
        case .inputs:
            self.addproductsMenuVC?.additionalCallListViewModel?.deleteInputAtIndex(self.selectedDoctorIndex, index: indexPath.row)
            self.additionalCallSampleInputTableView.reloadData()
            break
        }
    }
    
    @objc func additionalCallSampleInputSelection(_ sender : UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
            return
        }
        
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
          
            guard let inputVM = self.addproductsMenuVC.inputSelectedListViewModel, let productVM = self.addproductsMenuVC.productSelectedListViewModel, let dcrCall = self.addproductsMenuVC.dcrCall else {return}
            var addedProducts: [Product] = []
            var addedInputs: [Input] = []

            if let additionalCallData = self.addproductsMenuVC?.additionalCallListViewModel?.getAdditionalCallData() {
                additionalCallData.forEach { aAdditionalCallViewModel in
                    if let products = aAdditionalCallViewModel.productSelectedListViewModel.fetchAllProductData()?.compactMap({ $0.product }) {
                        addedProducts.append(contentsOf: products)
                    }

                    if let inputs = aAdditionalCallViewModel.inputSelectedListViewModel.fetchAllInputData()?.compactMap({ $0.input }) {
                        addedInputs.append(contentsOf: inputs)
                    }
                }
            }
            
            let vc = ProductInputSelectionVC.initWithStory(self, productViewModel: productVM, inputViewModel: inputVM, dcrCall: dcrCall, type: .Product, selectedProducts: addedProducts, selectedInputs: addedInputs)
            
            self.addproductsMenuVC.present(vc, animated: true)
            

        case .inputs:
            let index = addproductsMenuVC.selectedDoctorIndex ?? 0
            
            guard let inputVM = self.addproductsMenuVC.inputSelectedListViewModel, let productVM = self.addproductsMenuVC.productSelectedListViewModel, let dcrCall = self.addproductsMenuVC.dcrCall else {return}
            
            var addedProducts: [Product] = []
            var addedInputs: [Input] = []

            if let additionalCallData = self.addproductsMenuVC?.additionalCallListViewModel?.getAdditionalCallData() {
                additionalCallData.forEach { aAdditionalCallViewModel in
                    if let products = aAdditionalCallViewModel.productSelectedListViewModel.fetchAllProductData()?.compactMap({ $0.product }) {
                        addedProducts.append(contentsOf: products)
                    }

                    if let inputs = aAdditionalCallViewModel.inputSelectedListViewModel.fetchAllInputData()?.compactMap({ $0.input }) {
                        addedInputs.append(contentsOf: inputs)
                    }
                }
            }
            
            let vc = ProductInputSelectionVC.initWithStory(self, productViewModel: productVM, inputViewModel: inputVM, dcrCall: dcrCall, type: .Input, selectedProducts: addedProducts, selectedInputs: addedInputs)
            self.addproductsMenuVC.present(vc, animated: true)
     
            
        }
    }
    
}

extension AddproductsMenuView : collectionViewProtocols {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PreviewTypeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewTypeCVC", for: indexPath) as! PreviewTypeCVC
        
        
        cell.selectionView.isHidden =  selectedSegmentsIndex == indexPath.row ? false : true
        cell.titleLbl.textColor =  selectedSegmentsIndex == indexPath.row ? .appTextColor : .appLightTextColor
        cell.titleLbl.text = segmentType[indexPath.row].rawValue
        
        
        
        
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            welf.selectedSegmentsIndex  = indexPath.row
            
            welf.segmentsCollection.reloadData()
            
            
            switch welf.segmentType[welf.selectedSegmentsIndex] {

    
            case .products:
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
            case .inputs:
                welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
            }
            
            
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
             return CGSize(width:segmentType[indexPath.item].rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
        
    }
}

class AddproductsMenuView: BaseView {

    var selectedDoctorIndex = 0
    enum  SegmentType : String {
         case inputs = "Inputs"
         case products = "Products"
     }
    
    func cellregistration() {
        self.additionalCallSampleInputTableView.register(UINib(nibName: "AdditionalCallSampleEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalCallSampleEntryTableViewCell")
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
        
        
        self.additionalCallSampleInputTableView.register(UINib(nibName: "AddAdditionalproductsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddAdditionalproductsHeader")
        
        self.additionalCallSampleInputTableView.register(UINib(nibName: "AddadditionalProductsFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddadditionalProductsFooter")
        
        
    }
    
    func setSegment(_ segmentType: SegmentType, isfromSwipe: Bool? = false) {
        switch segmentType {
            
            
            
        case .products:
            self.toLoadData()
            break
        case .inputs:
            self.toLoadData()
            break
        }
    }
    
    func toLoadSegments() {
        segmentsCollection.isScrollEnabled = false
        segmentType = [.products, .inputs]
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
        segmentsCollection.delegate = self
        segmentsCollection.dataSource = self
        segmentsCollection.reloadData()
        self.setSegment(.products)
    }
    
    var segmentType: [SegmentType] = []
    var addproductsMenuVC :  AddproductsMenuVC!
    @IBOutlet weak var sideMenuHolderView : UIView!
    
    @IBOutlet weak var additionalCallSampleInputTableView : UITableView!
    
    @IBOutlet weak var segmentsCollection : UICollectionView!
    
    @IBOutlet weak var contentBgView: UIView!
    

    @IBOutlet var closeView: UIView!
    @IBOutlet var btnAddtype: UIButton!
    
    @IBOutlet var clearView: UIView!
    var selectedProductIndexpaths : [Product]?
    var cacheProduct : Product?
    var cacheInput : Input?
    var selectedProductIndex : IndexPath?
    var selectedInputIndex : IndexPath?
    var selectedInputIndexpaths : [Input]?
    var selectedSegmentsIndex: Int = 0
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    
    var filteredInputs: [Input] = {
        var inputs = DBManager.shared.getInput()
        let currentDate = Date()

        var filteredInputs = inputs.filter { input in
            guard let fromDate = input.effF?.date?.toDate(format: "yyyy-MM-dd HH:mm:ss"),
                  let toDate = input.effT?.date?.toDate(format: "yyyy-MM-dd HH:mm:ss") else {
                // If either fromDate or toDate is nil, exclude the input
                return false
            }

            return fromDate <= currentDate && toDate >= currentDate
        }

      return filteredInputs
        

    }()
    
    
    @IBAction func addAdditionalCallSampleInput(_ sender: UIButton) {
      //  toLoadData()
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
              guard let inputVM = self.addproductsMenuVC.inputSelectedListViewModel, let productVM = self.addproductsMenuVC.productSelectedListViewModel, let dcrCall = self.addproductsMenuVC.dcrCall else {return}
              var addedProducts: [Product] = []
              var addedInputs: [Input] = []

            let index = addproductsMenuVC.selectedDoctorIndex ?? 0
           let productSelectedListViewModel = self.addproductsMenuVC?.additionalCallListViewModel?.additionalCallListViewModel[index].productSelectedListViewModel
            
            let inputSelectedListViewModel  = self.addproductsMenuVC?.additionalCallListViewModel?.additionalCallListViewModel[index].inputSelectedListViewModel
            
            if let products =  productSelectedListViewModel?.productViewModel.compactMap({ $0.product }) {
               let mappedProducts = products.compactMap { aProductData in
                    aProductData.product
                }
                addedProducts.append(contentsOf: mappedProducts)
            }
            
            
            if let inputs =  inputSelectedListViewModel?.inputViewModel.compactMap({ $0.input }) {
               let mappedInputs = inputs.compactMap { aInputData in
                   aInputData.input
                }
                addedInputs.append(contentsOf: mappedInputs)
            }

              
              let vc = ProductInputSelectionVC.initWithStory(self, productViewModel: productVM, inputViewModel: inputVM, dcrCall: dcrCall, type: .Product, selectedProducts: addedProducts, selectedInputs: addedInputs)
              
              self.addproductsMenuVC.present(vc, animated: true)
        case .inputs:
            
            guard let inputVM = self.addproductsMenuVC.inputSelectedListViewModel, let productVM = self.addproductsMenuVC.productSelectedListViewModel, let dcrCall = self.addproductsMenuVC.dcrCall else {return}
            var addedProducts: [Product] = []
            var addedInputs: [Input] = []

          let index = addproductsMenuVC.selectedDoctorIndex ?? 0
         let productSelectedListViewModel = self.addproductsMenuVC?.additionalCallListViewModel?.additionalCallListViewModel[index].productSelectedListViewModel
          
          let inputSelectedListViewModel  = self.addproductsMenuVC?.additionalCallListViewModel?.additionalCallListViewModel[index].inputSelectedListViewModel
          
          if let products =  productSelectedListViewModel?.productViewModel.compactMap({ $0.product }) {
             let mappedProducts = products.compactMap { aProductData in
                  aProductData.product
              }
              addedProducts.append(contentsOf: mappedProducts)
          }
          
          
          if let inputs =  inputSelectedListViewModel?.inputViewModel.compactMap({ $0.input }) {
             let mappedInputs = inputs.compactMap { aInputData in
                 aInputData.input
              }
              addedInputs.append(contentsOf: mappedInputs)
          }
            
            let vc = ProductInputSelectionVC.initWithStory(self, productViewModel: productVM, inputViewModel: inputVM, dcrCall: dcrCall, type: .Input, selectedProducts: addedProducts, selectedInputs: addedInputs)
            self.addproductsMenuVC.present(vc, animated: true)

            
          
        }
    }
    
    func toLoadData() {
        additionalCallSampleInputTableView.delegate = self
        additionalCallSampleInputTableView.dataSource = self
        additionalCallSampleInputTableView.reloadData()
    }
    
    func initIndex() {
        guard let selectedDoctorIndex = addproductsMenuVC.selectedDoctorIndex else {return}
        self.selectedDoctorIndex = selectedDoctorIndex
        
    }
    
    override func didLoad(baseVC: BaseViewController) {
        self.addproductsMenuVC = baseVC as? AddproductsMenuVC

      
        self.showMenu()
        initIndex()
        initGestures()
        cellregistration()
        segmentType = [.products, .inputs]
        toLoadSegments()
        toLoadData()
        clearView.layer.cornerRadius = 5
    
       // setupUI()
       // cellRegistration()
       // toLoadRequiredData()
    }
    
    func showMenu(){
       // let isRTL = isRTLLanguage
        let _ : CGFloat =  -1
        //isRTL ? 1 :
        let width = self.frame.width
        self.sideMenuHolderView.transform =  CGAffineTransform(translationX: width,y: 1)
        //isRTL ? CGAffineTransform(translationX: 1 * width,y: 0)  :
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = .identity
                        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
                       }, completion: nil)
    }
    
    func hideMenuAndDismiss(type: MenuView.CellType? = nil , index: Int? = nil){
       
        let rtlValue : CGFloat = 1
      //  isRTL ? 1 :
        let width = self.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
            
        
        hideAnimation(width: width, rtlValue: rtlValue)

        
        
    }
    
    func hideAnimation(width: CGFloat, rtlValue: CGFloat) {
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = CGAffineTransform(translationX: width * rtlValue,
                                                                              y: 0)
                        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                       }) { (val) in
            
                           self.addproductsMenuVC.dismiss(animated: true)
        }
    }
    
    func initGestures() {
        closeView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.addproductsMenuVC.dismiss(animated: false)
        }
      //
        
        clearView.addTap {
            guard let productSelectedListViewModel = self.addproductsMenuVC.productSelectedListViewModel, let additionalCallListViewModel = self.addproductsMenuVC.additionalCallListViewModel, let inputSelectedListViewModel = self.addproductsMenuVC.inputSelectedListViewModel else  {return}
            
            _ = additionalCallListViewModel.numberOfInputsInSection(self.selectedDoctorIndex)
            
            
            _ = additionalCallListViewModel.numberOfProductsInSection(self.selectedDoctorIndex)

            let additionalCallData =  self.addproductsMenuVC?.additionalCallListViewModel?.getAdditionalCallData()
            let lastIndex = (additionalCallData?.count ?? 0) - 1
            if additionalCallData?[lastIndex].productSelectedListViewModel.productViewModel.count ?? 0 > 0 {
                let productData = additionalCallData?.filter { additionalCallViewModel in
                    additionalCallViewModel.productSelectedListViewModel.productViewModel.contains { productViewModel in
                        productViewModel.product.product == nil
                    }
                }
                dump(productData)
                guard let productData  =  productData, productData.isEmpty else {
                    self.selectedSegmentsIndex = 0
                    self.segmentsCollection.reloadData()
                    self.setSegment(.products)
                    self.toCreateToast("update added product to save list")
                    return }
            }

              if additionalCallData?[lastIndex].inputSelectedListViewModel.inputViewModel.count ?? 0 > 0 {
                  let productData = additionalCallData?.filter { additionalCallViewModel in
                      additionalCallViewModel.inputSelectedListViewModel.inputViewModel.contains { productViewModel in
                          productViewModel.input.input == nil
                      }
                  }
                  dump(productData)
                  guard let productData  =  productData, productData.isEmpty else {
                      self.selectedSegmentsIndex = 1
                      self.segmentsCollection.reloadData()
                      self.setSegment(.inputs)
                      self.toCreateToast("update added input first to add new input")
                      return }
              }
            
            
            self.addproductsMenuVC.menuDelegate?.passProductsAndInputs(additioncall: additionalCallListViewModel, index: self.selectedDoctorIndex)
            self.hideMenuAndDismiss()
        }
        

        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
    
    
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
      
        let _ : CGFloat =   -1
        //isRTL ? 1 :
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
        //        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
        case .began,.changed:
            guard  ( xMovement > 0)  else {return}
          //  ||  (xMovement < 0)
           // isRTL && || !isRTL &&
            
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        default:
            let velocity = gesture.velocity(in: self.sideMenuHolderView).x
            self.animationDuration = Double(velocity)
            if abs(xMovement) <= self.frame.width * 0.25{//show
                self.sideMenuHolderView.transform = .identity
                self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
            }else{//hide
                self.hideMenuAndDismiss()
            }
            
        }
    }
}


extension AddproductsMenuView: ProductInputSelectionVCDelegate {
    func didUpdate(selectedObj: [AnyObject], type: ProductInputSelectionVC.controllerType) {
        print("Yet to")
        switch type {
    
        case .Input:
            if let inputs =  selectedObj as? [Input] {
                
                let additionalCallData = self.addproductsMenuVC?.additionalCallListViewModel?.fetchDataAtIndex(selectedDoctorIndex)
                  additionalCallData?.inputSelectedListViewModel = InputSelectedListViewModel()
                  additionalCallData?.inputs = []
                inputs.forEach { inputObj in
                    // self.selectedProductIndexpaths = [IndexPath]()
                  
                      // Check if an object with the same code already exists in the array
                      if let index = selectedInputIndexpaths?.firstIndex(where: { $0.code == inputObj.code }) {
                          // If an object with the same code exists, update it with productObj
                          selectedInputIndexpaths?[index] = inputObj
                      } else {
                          // If no object with the same code exists, append productObj to the array
                          if selectedInputIndexpaths == nil {
                              selectedInputIndexpaths = [inputObj]
                          } else {
                              selectedInputIndexpaths?.append(inputObj)
                          }
                         
                      }
                    
                    
                    
                    let aInputData = InputData(input: inputObj, availableCount: "", inputCount: "1")
                    let inputVM = InputViewModel(input: aInputData)
                    self.addproductsMenuVC?.additionalCallListViewModel?.addInputAtIndex(selectedDoctorIndex, vm: inputVM)
                    self.additionalCallSampleInputTableView.reloadData()
                }
            }
        case .Product:
            if let products =  selectedObj as? [Product] {
              let additionalCallData = self.addproductsMenuVC?.additionalCallListViewModel?.fetchDataAtIndex(selectedDoctorIndex)
                additionalCallData?.productSelectedListViewModel = ProductSelectedListViewModel()
                additionalCallData?.products = []
                
//                additionalCallData?.forEach({ aAdditionalCallViewModel in
//                    let products = aAdditionalCallViewModel.productSelectedListViewModel.fetchAllProductData()
//                    if products?.count ?? 0 > selectedDoctorIndex {
//                        aAdditionalCallViewModel.productSelectedListViewModel.removeAtIndex(selectedDoctorIndex)
//                    }
//          
//                })
                products.forEach { productObj in
                  
        
                      // Check if an object with the same code already exists in the array
                      if let index = selectedProductIndexpaths?.firstIndex(where: { $0.code == productObj.code }) {
                          // If an object with the same code exists, update it with productObj
                          selectedProductIndexpaths?[index] = productObj
                      } else {
                          // If no object with the same code exists, append productObj to the array
                          if selectedProductIndexpaths == nil {
                              selectedProductIndexpaths = [productObj]
                          } else {
                              selectedProductIndexpaths?.append(productObj)
                          }
                        
                      }
                    var aProductData = ProductData(product: productObj, isDetailed: false, sampleCount: "1", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "", stockistName: "", stockistCode: "")
                    let productMode = productObj.productMode ?? ""
                    
                    if productMode == "Sale/Sample" {

                        aProductData.sampleCount = "1"
                        
                    }else if productMode == "Sample" {

                        aProductData.sampleCount = "1"
                        
                    }else if productMode == "Sale" {

                        aProductData.sampleCount = ""
                    }
                    
               
                    let productVM = ProductViewModel(product: aProductData)

                    self.addproductsMenuVC?.additionalCallListViewModel?.addProductAtIndex(selectedDoctorIndex, vm: productVM)
                    self.additionalCallSampleInputTableView.reloadData()
                }
            }
           

            
        }
    }

    
}
