//
//  SplashVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 03/05/24.
//


import Foundation
import UIKit
import ImageIO

protocol splashVCDelegate: AnyObject {
    func setupControllers()
}

class SplashVC: BaseViewController{
    
 
    
    @IBOutlet var splashView: SplashView!
    var isFirstTimeLaunch : Bool = false
    var isTimeZoneChanged : Bool = false
    weak var delegate : splashVCDelegate?
   // let delegate =   AppDelegate.shared?
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let plistReader = PlistReader<InfoPlistKeys>() {
            // Retrieve a string value for App_URL
            if let appVersion: String = plistReader.value(for: .CFBundleShortVersionString) {
                print("App version: \(appVersion)")
                LocalStorage.shared.setSting(.AppVersion, text: "Version \(appVersion)")
            } else {
                print("App version not found")
            }
        }
        
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
                AppDelegate.shared.setupRootViewControllers()
            })
        }
        
       


    }
}

