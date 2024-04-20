//
//  AddproductsMenuVC.swift
//  E-Detailing
//
//  Created by San eforce on 21/03/24.
//

import Foundation
import UIKit
class AddproductsMenuVC : BaseViewController {
    @IBOutlet var addproductsMenuView: AddproductsMenuView!
    var menuDelegate : MenuResponseProtocol?
    var productSelectedListViewModel : ProductSelectedListViewModel?
    var additionalCallListViewModel : AdditionalCallsListViewModel?
    var selectedDoctorIndex : Int? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol?, productSelectedListViewModel : ProductSelectedListViewModel, additionalCallListViewModel: AdditionalCallsListViewModel, selectedDoctorIndex: Int)-> AddproductsMenuVC{
        
        let view : AddproductsMenuVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.additionalCallListViewModel = additionalCallListViewModel
        view.productSelectedListViewModel = productSelectedListViewModel
        view.selectedDoctorIndex = selectedDoctorIndex
        view.menuDelegate = delegate


        
        return view
    }
}
