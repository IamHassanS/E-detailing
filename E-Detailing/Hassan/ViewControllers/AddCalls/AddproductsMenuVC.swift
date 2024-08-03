//
//  AddproductsMenuVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/03/24.
//

import Foundation
import UIKit
class AddproductsMenuVC : BaseViewController {
    @IBOutlet var addproductsMenuView: AddproductsMenuView!
    var menuDelegate : MenuResponseProtocol?
    var productSelectedListViewModel : ProductSelectedListViewModel?
    var inputSelectedListViewModel : InputSelectedListViewModel?
    var additionalCallListViewModel : AdditionalCallsListViewModel?
    var selectedDoctorIndex : Int? = nil
    var dcrCall:  CallViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol?, productSelectedListViewModel : ProductSelectedListViewModel, inputSelectedListViewModel: InputSelectedListViewModel, additionalCallListViewModel: AdditionalCallsListViewModel, dcrCall:  CallViewModel, selectedDoctorIndex: Int)-> AddproductsMenuVC{
        
        let view : AddproductsMenuVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.additionalCallListViewModel = additionalCallListViewModel
        view.productSelectedListViewModel = productSelectedListViewModel
        view.inputSelectedListViewModel = inputSelectedListViewModel
        view.selectedDoctorIndex = selectedDoctorIndex
        view.dcrCall = dcrCall
        view.menuDelegate = delegate

        return view
    }
}
