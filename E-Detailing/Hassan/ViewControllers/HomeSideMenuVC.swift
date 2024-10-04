//
//  HomeSideMenuVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 10/01/24.
//

import Foundation
import UIKit


protocol HomeSideMenuVCDelegate : AnyObject {
    func didClose()
    func didMasterSync()
    func didProfileTapped()
    func didLocationUpdated()
}


class HomeSideMenuVC: BaseViewController {
    @IBOutlet weak var menuView : HomeSideMenuView!
    var menuDelegate : MenuResponseProtocol?
    weak var delegate: HomeSideMenuVCDelegate?
    weak var menuAlertDelegate: MenuAlertProtocols?
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

 
    class func initWithStory(_ delegate : MenuResponseProtocol?)-> HomeSideMenuVC{
        
        let view : HomeSideMenuVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext

        view.menuDelegate = delegate


        
        return view
    }
    
}
