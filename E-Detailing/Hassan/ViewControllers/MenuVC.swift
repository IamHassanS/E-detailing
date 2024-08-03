//
//  MenuVC.swift
//  PlannerApp
//
//  Created by APPLE on 03/01/24.
//


import UIKit
import Foundation
import CoreData

  


class MenuVC: BaseViewController {

    
  
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
//    }
    
    @IBOutlet weak var menuView : MenuView!

    
//    @IBOutlet weak var menuHeaderHeight: NSLayoutConstraint!
    var masterVM: MasterSyncVM?
    var sessionDetailsArr : SessionDetailsArr?
    var menuDelegate : MenuResponseProtocol?
    var selectedDate : Date?
    var isForWeekoff = Bool()
    var isForHoliday = Bool()
    var isWeekoffEditable : Bool = true
    var isSentForApproval: Bool = false
  //  var accountViewModel : AccountViewModel?
    var dictParms = [String: Any]()
    var imageURL = ""
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.setprofileInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
   
    


    
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol?, _ date: Date, isForWeekOff: Bool?, isForHoliday: Bool?)-> MenuVC{
        
        let view : MenuVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.selectedDate = date
        view.masterVM = MasterSyncVM()
        view.isForWeekoff = isForWeekOff ?? false
        view.isForHoliday = isForHoliday ?? false
        view.menuDelegate = delegate


        
        return view
    }

    func toUpdateDCR(mapID: String,  completion: @escaping (Bool) -> ()) {
        
        Shared.instance.showLoaderInWindow()
        masterVM?.fetchMasterData(type: .clusters, sfCode: mapID, istoUpdateDCRlist: true, mapID: mapID) { [weak self] _  in
            
            guard let welf = self else {return}
            completion(true)
            Shared.instance.removeLoaderInWindow()
           // welf.toCreateToast("Clusters synced successfully")
            
        }
    }

    
    func removeAllNotication() {

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.menuView.ThemeUpdate()
    }
    // AFTER USER LOGOUT, WE SHOULD RESET WORK/HOME LOCATION DETAILS

    
    
}


class CellMenus: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
}

