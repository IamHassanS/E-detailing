//
//  SplashVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 03/05/24.
//


import Foundation
import UIKit

class SplashVC: BaseViewController{
    
 
    
    @IBOutlet var splashView: SplashView!
    var isFirstTimeLaunch : Bool = false
    var isTimeZoneChanged : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
      //  callCheckVersion()
    }
    
    
    class func initWithStory() -> SplashVC {
        let splash : SplashVC = UIStoryboard.Hassan.instantiateViewController()
       // splash.accViewModel = AccountViewModel()
        return splash
    }
    
    func callStartupActions(){
        

         AppDelegate.shared.setupRootViewControllers(isFromlaunch: true)


    }
}

