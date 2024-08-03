//
//  BaseView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/01/24.
//


import UIKit
class BaseView: UIView{
    fileprivate var baseVc : BaseViewController?
    
    @IBOutlet weak var backBtn: UIButton?
    
    @IBAction func backBtnAction(_ sender: UIButton){
        self.baseVc?.exitScreen(animated: true)
    }
    
    func didLoad(baseVC : BaseViewController){

        self.backBtn?.setImage(UIImage(named: ""), for: .normal)
        self.backBtn?.setTitle(nil, for: .normal)
        self.baseVc = baseVC
        self.backgroundColor = .white
    }
    
    func willAppear(baseVC : BaseViewController){}
    func didAppear(baseVC : BaseViewController){}
    func willDisappear(baseVC : BaseViewController){}
    func didDisappear(baseVC : BaseViewController){}
    func didLayoutSubviews(baseVC: BaseViewController){}


}


extension UIView {
    func toCreateToast(_ text: String) {

            if #available(iOS 13.0, *) {
                (UIApplication.shared.delegate as! AppDelegate).createToastMessage(text, isFromWishList: true)
            } else {
              print(text)
            }
        
    }
}
extension UIViewController {
    func toCreateToast(_ text: String) {
        DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).createToastMessage(text, isFromWishList: true)
         
        }

        
    }
}
