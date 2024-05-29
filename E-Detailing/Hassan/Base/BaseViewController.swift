
//
//  BaseViewController.swift
//  E - Detailing
//
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/01/24.
//

import UIKit

class BaseViewController: UIViewController {

    let appdelegate = UIApplication.shared.delegate as! AppDelegate
   // var sceneDelegate: SceneDelegate?
    
    fileprivate var _baseView : BaseView? {
        return self.view as? BaseView
    }
    fileprivate var onExit : (()->())? = nil
    
    var stopSwipeExitFromThisScreen : Bool? {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._baseView?.didLoad(baseVC: self)
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//          let sceneDelegate = windowScene.delegate as? SceneDelegate
//
//        else {
//          return
//        }
//        self.sceneDelegate = sceneDelegate
//
//
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
               if let status = dict["Type"] as? String{
                   DispatchQueue.main.async {
                       if status == "No Connection" {
                        //   self.toSetPageType(.notconnected)
                           self.toCreateToast("Please check your internet connection.")
                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                       } else if  status == "WiFi" || status ==  "Cellular"   {
                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                           self.toCreateToast("You are now connected.")
                           
                       }
                   }
               }
           }
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        self._baseView?.darkModeChange()
//    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._baseView?.willAppear(baseVC: self)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._baseView?.didAppear(baseVC: self)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        let attribute : UISemanticContentAttribute = isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
//        if self.navigationController?.navigationBar.semanticContentAttribute != attribute{
//            self.navigationController?.view.semanticContentAttribute = attribute
//            self.navigationController?.navigationBar.semanticContentAttribute = attribute
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._baseView?.willDisappear(baseVC: self)
        
      
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
        } else {
            // Fallback on earlier versions
            return self.preferredStatusBarStyle
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self._baseView?.didDisappear(baseVC: self)
        
        if self.isMovingFromParent{
            self.willExitFromScreen()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._baseView?.didLayoutSubviews(baseVC: self)
    }
    
    
    func exitScreen(animated : Bool,_ completion : (()->())? = nil){
        self.onExit = completion
        if self.isPresented(){
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    
    func willExitFromScreen(){
        
    }


}

extension BaseViewController : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = self.navigationController else {return true}
        if self.stopSwipeExitFromThisScreen ?? false{return false }
        return nav.viewControllers.count > 1
    }
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}

extension UIViewController{

    //MARK: Check screen presentation status
    func isPresented() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }

        return false
    }

//    func presentAlertWithTitle(title: String,
//                               message: String,
//                               options: String...,
//                               completion: @escaping (Int) -> Void) {
//        //TRVicky
//        let commonAlert = CommonAlert()
//
//        commonAlert.setupAlert(alert: title,
//                               alertDescription: message,
//                               okAction: options.first?.replacingOccurrences(of: "ð", with: "") ?? "",
//                               cancelAction: options.count > 1 ? options.last : nil )
//        commonAlert.addAdditionalOkAction(isForSingleOption: options.count == 1) {
//            completion(0)
//        }
//        if options.count > 1 {
//            commonAlert.addAdditionalCancelAction {
//                completion(1)
//            }
//
//        }
//
//    }

}

