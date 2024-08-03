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
import ImageIO

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
        
        self.splashView.SplashImageHolderView.isHidden = false

        if let gifImage = UIImage.gif(asset: "launch", speedMultiplier: 4) {
            self.splashView.launchIV.image = gifImage
         }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.splashView.SplashImageHolderView.isHidden = true
                AppDelegate.shared.setupRootViewControllers(isFromlaunch: true)
            })
        }
        
       


    }
}

