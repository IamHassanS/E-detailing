//
//  AdditionalCallSampleInputTableViewCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/04/24.
//

import Foundation
import UIKit

class AdditionalCallSampleInputTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet var inputQtyCorneredView: UIView!
    
    @IBOutlet var productqtyCorneredVIew: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductQty: UILabel!
    
    @IBOutlet weak var lblInputName: UILabel!
    @IBOutlet weak var lblInputQty: UILabel!
    
    
    @IBOutlet weak var btnDownArrow: UIButton!
    @IBOutlet weak var btnAddProductInput: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var viewProductInputButton: UIView!
    
    
    @IBOutlet weak var viewAdditionalSampleInputList: UIView!
    
    
    @IBOutlet weak var heightViewAdditionalSampleInputList: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productqtyCorneredVIew.layer.cornerRadius = 3
        productqtyCorneredVIew.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        
        
        inputQtyCorneredView.layer.cornerRadius = 3
        inputQtyCorneredView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        
        
        
        
       
    }
    
    var additionalCall : AdditionalCallViewModel!{
        didSet {
            self.lblName.text = additionalCall.docName
            self.btnDownArrow.isSelected = additionalCall.isView
            
            
            if self.btnDownArrow.isSelected {
                
                if additionalCall.productSelectedListViewModel.numberOfRows() != 0 || additionalCall.inputSelectedListViewModel.numberOfRows() != 0{
                    
                    
                    let productCount =      additionalCall.productSelectedListViewModel.fetchAllProducts()?.count ?? 0
                    //additionalCall.productSelectedListViewModel.numberOfRows()
                    let inputCount = additionalCall.inputSelectedListViewModel.fetchAllInput()?.count ?? 0
                    //additionalCall.inputSelectedListViewModel.numberOfRows()
                    
                  //  var products = additionalCall.productSelectedListViewModel.productData()
                    
                 //   var inputs = additionalCall.inputSelectedListViewModel.inputData()
                    
                    let optionalproducts = additionalCall.productSelectedListViewModel.fetchAllProducts()
                    //productData()
                    
                    let optionalinputs = additionalCall.inputSelectedListViewModel.fetchAllInput()
                    //inputData()
                    guard var inputs = optionalinputs else {return}
                    guard var products  = optionalproducts else {return}
                    
                    if inputCount != 0 {
                        self.lblInputQty.text = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).inputCount
                        self.lblInputName.text = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).name
                        
                        inputs.removeFirst()
                    }else {
                        self.lblInputQty.text = ""
                        self.lblInputName.text = ""
                    }
                    
                    if productCount != 0 {
                        self.lblProductName.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).name
                        self.lblProductQty.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).sampleCount
                        
                        products.removeFirst()
                    }else {
                        self.lblInputQty.text = ""
                        self.lblInputName.text = ""
                    }
                    
                    
                    if inputCount > productCount {
                        
                        var previousView : UIView!
                        for (index,input) in
                                inputs.enumerated(){
                            
                            print("rcpa == \(inputs)")
                            
                            let productView = AdditionalCallSampleInputView.instanceFromNib()
                            productView.translatesAutoresizingMaskIntoConstraints = false
                            self.viewAdditionalSampleInputList.addSubview(productView)
                            if self.heightViewAdditionalSampleInputList != nil{
                                self.heightViewAdditionalSampleInputList.isActive = false
                            }
                            productView.input = input
                            
                            if index < productCount  { // || index == productCount
                                productView.product = products[index] //additionalCall.productSelectedListViewModel.fetchDataAtIndex(index)
                            }
                            
                            if index == 0 {
                                var constraintArray = [productView.topAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.topAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                if inputs.count == 1{
                                    constraintArray.append(productView.bottomAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.bottomAnchor, constant: 0))
                                }
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }else if index == inputs.count - 1{
                                let constraintArray = [productView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 0),
                                productView.bottomAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.bottomAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }else{
                                let constraintArray = [productView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }
                        }
                        
                    }else {
                        var previousView : UIView!
                        for (index,product) in
                                products.enumerated(){
                            
                            print("rcpa == \(product)")
                            
                            let productView = AdditionalCallSampleInputView.instanceFromNib()
                            productView.translatesAutoresizingMaskIntoConstraints = false
                            self.viewAdditionalSampleInputList.addSubview(productView)
                            if self.heightViewAdditionalSampleInputList != nil{
                                self.heightViewAdditionalSampleInputList.isActive = false
                            }
                            productView.product = product
                            productView.productQty = additionalCall.productSelectedListViewModel.fetchDataAtIndex(index + 1).sampleCount
                            if index < inputs.count {
                                productView.input = inputs[index]
                                productView.inputQty = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(index + 1).inputCount
                            } else {
                                // Handle the case where index is out of range
                                // For example, provide a default value or handle the error
                                print("Index is out of range.")
                                // You might want to provide a default input or inputQty value here
                            }
                            
                            if index == 0 {
                                var constraintArray = [productView.topAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.topAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                if products.count == 1{
                                    constraintArray.append(productView.bottomAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.bottomAnchor, constant: 0))
                                }
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }else if index == products.count - 1{
                                let constraintArray = [productView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 0),
                                productView.bottomAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.bottomAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }else{
                                let constraintArray = [productView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 0),
                                productView.leftAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.leftAnchor, constant: 0),
                                productView.rightAnchor.constraint(equalTo: self.viewAdditionalSampleInputList.rightAnchor, constant: 0)]
                                NSLayoutConstraint.activate(constraintArray)
                                previousView = productView
                            }
                        }
                    }
                }
            }else {
                let productCount =
                
                
                additionalCall.productSelectedListViewModel.fetchAllProducts()?.count ?? 0
                
                
               // additionalCall.productSelectedListViewModel.numberOfRows()
                let inputCount =
                
                additionalCall.inputSelectedListViewModel.fetchAllInput()?.count ?? 0
                
               // additionalCall.inputSelectedListViewModel.numberOfRows()
                
                let optionalproducts = additionalCall.productSelectedListViewModel.fetchAllProducts()
           
                
                let optionalinputs = additionalCall.inputSelectedListViewModel.fetchAllInput()
                //inputData()
                guard var inputs = optionalinputs else {return}
                guard var products  = optionalproducts else {return}
                
                if inputCount != 0 {
                
                    self.lblInputQty.text = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).inputCount
                    self.lblInputName.text = inputs[0].name //additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).name
                    
                    inputs.removeFirst()
                }else {
                    self.lblInputQty.text = ""
                    self.lblInputName.text = ""
                }
                
                if productCount != 0 {
                    self.lblProductName.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).name
                    self.lblProductQty.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).sampleCount //additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).sampleCount
                    
                    products.removeFirst()
                }else {
                    self.lblInputQty.text = ""
                    self.lblInputName.text = ""
                }
                
                if self.heightViewAdditionalSampleInputList != nil{
                    self.heightViewAdditionalSampleInputList.constant = 0
                }else {
                    let productView = AdditionalCallSampleInputView.instanceFromNib()
                    productView.translatesAutoresizingMaskIntoConstraints = false
                    self.viewAdditionalSampleInputList.subviews.forEach{ $0.removeFromSuperview()}
                    self.viewAdditionalSampleInputList.addSubview(productView)
                }
            }
        }
    }
    
    

}
