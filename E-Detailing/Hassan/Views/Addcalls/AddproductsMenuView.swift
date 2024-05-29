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
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
            cell.product = self.addproductsMenuVC?.additionalCallListViewModel?.fetchProductAtIndex(self.selectedDoctorIndex, index: indexPath.row)
        case .inputs:
            cell.input = self.addproductsMenuVC?.additionalCallListViewModel?.fetchInputAtIndex(self.selectedDoctorIndex, index: indexPath.row)
        }
        cell.btnProduct.addTarget(self, action: #selector(additionalCallSampleInputSelection(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(deleteAdditionalCallSampleInput(_:)), for: .touchUpInside)
        cell.txtSampleStock.addTarget(self, action: #selector(updateSampleInputQty(_:)), for: .editingChanged)
        return cell
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
          
            let products = DBManager.shared.getProduct()
            
            let selectionVC = UIStoryboard.singleSelectionVC
            selectionVC.isForinputs = false
            selectionVC.titleString = "Select Product"
            selectionVC.selectionData = products
            
            self.selectedProductIndex = indexPath
           
            if  selectedProductIndexpaths != nil  {
                // Handle the case whe n selectedProductIndex is nil
                if selectedProductIndexpaths?.count ?? 0 - 1 > indexPath.row {
                    cacheProduct = selectedProductIndexpaths?[indexPath.row]
                    selectedProductIndexpaths?.remove(at: indexPath.row)
                }
               
                selectionVC.prevObj = selectedProductIndexpaths
              
            }

          
            selectionVC.delegate = self
            self.addproductsMenuVC.present(selectionVC, animated: true)
            
        case .inputs:
          
            let inputs = DBManager.shared.getInput()
            
            let selectionVC = UIStoryboard.singleSelectionVC
            selectionVC.isForinputs = true
            selectionVC.titleString = "Select Input"
            self.selectedInputIndex = indexPath
            selectionVC.selectionData = inputs
            if  selectedInputIndexpaths != nil  {
                // Handle the case whe n selectedProductIndex is nil
                if selectedInputIndexpaths?.count ?? 0 - 1 > indexPath.row {
                    cacheInput = selectedInputIndexpaths?[indexPath.row]
                    selectedInputIndexpaths?.remove(at: indexPath.row)
                }
          
                    selectionVC.prevObj = selectedInputIndexpaths
            }
            selectionVC.delegate = self
            self.addproductsMenuVC.present(selectionVC, animated: true)
            
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
    
    
    
    
    @IBAction func addAdditionalCallSampleInput(_ sender: UIButton) {
      //  toLoadData()
        switch self.segmentType[self.selectedSegmentsIndex] {
        case .products:
            self.addproductsMenuVC?.additionalCallListViewModel?.addProductAtIndex(self.selectedDoctorIndex, vm: ProductViewModel(product: ProductData(isDetailed: false, sampleCount: "0", rxCount: "0", rcpaCount: "0", availableCount: "", totalCount: "0", stockistName: "", stockistCode: "")))
            
            self.selectedInputIndexpaths  = [Input]()
            toLoadData()
       
        case .inputs:
            self.addproductsMenuVC?.additionalCallListViewModel?.addInputAtIndex(self.selectedDoctorIndex, vm: InputViewModel(input: InputData(input: nil, availableCount: "", inputCount: "0")))
            self.selectedProductIndexpaths = [Product]()
            toLoadData()
          
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
        clearView.addTap {
            guard let productSelectedListViewModel = self.addproductsMenuVC.productSelectedListViewModel, let additionalCallListViewModel = self.addproductsMenuVC.additionalCallListViewModel else  {return}
            
            let  inputCount = additionalCallListViewModel.numberOfInputsInSection(self.selectedDoctorIndex)
            
            
            let productCount = additionalCallListViewModel.numberOfProductsInSection(self.selectedDoctorIndex)
            
            
//            if inputCount > productCount {
//                self.toCreateToast("Input count is greater then product count")
//                return
//            }
            
//            if productCount > inputCount {
//                self.toCreateToast("Please select Input")
//                return
//            }
            
            self.addproductsMenuVC.menuDelegate?.passProductsAndInputs(product: productSelectedListViewModel, additioncall: additionalCallListViewModel, index: self.selectedDoctorIndex)
            self.hideMenuAndDismiss()
        }
        
//        clearView.addTap {
//            self.specifiedMenuVC.selectedClusterID = nil
//            self.selectedClusterID = [String: Bool]()
//            self.menuTable.reloadData()
//        }
//        
//        saveView.addTap { [weak self] in
//            guard let welf = self else {return}
//            welf.filteredTerritories = welf.clusterArr?.filter { territory in
//                guard let code = territory.code else {
//                    return false
//                }
//                return welf.selectedClusterID[code] == true
//            }
//            
//
//            
//    
//            
//            welf.hideMenuAndDismiss()
//        }
//        
//        clearTFView.addTap { [weak self] in
//            guard let welf = self else {return}
//            welf.selectedObject = nil
//            welf.selectecIndex = nil
//            welf.searchTF.text = ""
//            welf.isSearched = false
//            welf.endEditing(true)
//            welf.toLoadRequiredData(isfromTF: true)
//            welf.toLOadData()
//        }
//        
//        closeTapView.addTap { [weak self] in
//            guard let welf = self else {return}
//            welf.filteredTerritories = welf.clusterArr?.filter { territory in
//                guard let code = territory.code else {
//                    return false
//                }
//                return welf.selectedClusterID[code] == true
//            }
//            welf.hideMenuAndDismiss()
//        }
        
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


extension AddproductsMenuView: SingleSelectionVCDelegate {
    func didUpdate(selectedObj: AnyObject, index: Int) {
        
        switch self.segmentType[self.selectedSegmentsIndex] {
            
        case .inputs:
            if let inputObj = selectedObj as? Input {
              // self.selectedProductIndexpaths = [IndexPath]()
                guard let selectedInputIndex = self.selectedInputIndex else{ return }
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
                self.addproductsMenuVC?.additionalCallListViewModel?.updateInputAtSection(self.selectedDoctorIndex, index: selectedInputIndex.row , input: inputObj)
                self.additionalCallSampleInputTableView.reloadData()
            }
        case .products:

            if let productObj = selectedObj as? Product {
              // self.selectedProductIndexpaths = [IndexPath]()
                guard let selectedProductIndex = self.selectedProductIndex else{ return }
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
                self.addproductsMenuVC?.additionalCallListViewModel?.updateProductAtSection(self.selectedDoctorIndex, index: selectedProductIndex.row , product: productObj)
                self.additionalCallSampleInputTableView.reloadData()
            }
    
       
        }

    }
    
    

    
    
}
