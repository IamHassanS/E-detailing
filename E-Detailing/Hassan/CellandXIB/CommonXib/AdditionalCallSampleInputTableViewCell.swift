//
//  AdditionalCallSampleInputTableViewCell.swift
//  SAN ZEN
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
                    let inputCount = additionalCall.inputSelectedListViewModel.fetchAllInput()?.count ?? 0
                    let optionalproducts = additionalCall.productSelectedListViewModel.fetchAllProductData()
                    let optionalinputs = additionalCall.inputSelectedListViewModel.fetchAllInputData()
                    //inputData()
                    guard var inputs = optionalinputs else {return}
                    guard var products  = optionalproducts else {return}
                    
                    if inputCount != 0 {
                        self.lblInputQty.text = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).inputCount
                        self.lblInputName.text = additionalCall.inputSelectedListViewModel.fetchDataAtIndex(0).name
                        inputQtyCorneredView.isHidden = self.lblInputQty.text == "" ? true : false
                        inputs.removeFirst()
                    }else {
                        inputQtyCorneredView.isHidden = true
                        self.lblInputQty.text = ""
                        self.lblInputName.text = ""
                    }
                    
                    if productCount != 0 {
                        self.lblProductName.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).name
                        self.lblProductQty.text = additionalCall.productSelectedListViewModel.fetchDataAtIndex(0).sampleCount
                    
                        products.removeFirst()
                    }else {
                    
                      //  self.lblInputQty.text = ""
                     //   self.lblInputName.text = ""
                    }
                    
                    
                    if inputCount > productCount {
                        
                        var previousView : UIView!
                        for (index,_) in
                                inputs.enumerated(){
                            
                            print("rcpa == \(inputs)")
                            
                            let productView = AdditionalCallSampleInputView.instanceFromNib()
                            productView.translatesAutoresizingMaskIntoConstraints = false
                            self.viewAdditionalSampleInputList.addSubview(productView)
                            if self.heightViewAdditionalSampleInputList != nil{
                                self.heightViewAdditionalSampleInputList.isActive = false
                            }
                            productView.input = inputs[index].input
                            productView.inputQty = inputs[index].inputCount
                            if index < productCount &&  !products.isEmpty  { // || index == productCount
                                productView.product = products[index].product
                            } else {
                                productView.productQtyCurvedVIew.isHidden = true
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
                            if index < products.count  {
                                productView.product = products[index].product
                                productView.productQty =  products[index].sampleCount
                            } else {
                                productView.productQtyCurvedVIew.isHidden = true
                            }
                     
                            if index < inputs.count  {
                                productView.input = inputs[index].input
                                productView.inputQty = inputs[index].inputCount
                            } else {
                                productView.inputQtyCurvedView.isHidden = true
                                // Handle the case where index is out of range
                                // For example, provide a default value or handle the error
                                print("Index is out of range.")
                       
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
                
     
                let inputCount =
                
                additionalCall.inputSelectedListViewModel.fetchAllInput()?.count ?? 0
                

                
                let optionalproducts = additionalCall.productSelectedListViewModel.fetchAllProductData()
           
                
                let optionalinputs = additionalCall.inputSelectedListViewModel.fetchAllInputData()
                //inputData()
                guard var inputs = optionalinputs else {return}
                guard var products  = optionalproducts else {return}
                
                if inputCount != 0 {
                
                    self.lblInputQty.text = inputs[0].inputCount
                    self.lblInputName.text = inputs[0].input?.name
                    inputQtyCorneredView.isHidden = self.lblInputQty.text == "" ? true : false
                    inputs.removeFirst()
                }else {
                    inputQtyCorneredView.isHidden = true
                    self.lblInputQty.text = ""
                    self.lblInputName.text = ""
                }
                
                if productCount != 0 {
                    self.lblProductName.text = products[0].product?.name
                    self.lblProductQty.text = products[0].sampleCount
                    productqtyCorneredVIew.isHidden = self.lblProductQty.text == "" ? true : false
                    products.removeFirst()
                }else {
                    productqtyCorneredVIew.isHidden = true
                //    self.lblInputQty.text = ""
                //   self.lblInputName.text = ""
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
