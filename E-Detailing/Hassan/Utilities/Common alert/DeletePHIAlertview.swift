//
//  DeletePHIAlertview.swift
//  Intuitive
//
//

import UIKit

class DeletePHIAlertview: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
     */
    @IBOutlet weak var messageDescriptionLbl: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var message_titleLb: UILabel!
    @IBOutlet weak var PHI_DeleteYesBtn: UIButton!
    @IBOutlet weak var PHI_DeleteNoBtn: UIButton!
    @IBOutlet weak var deletePHI_popupTwoOption: UIView!
    @IBOutlet weak var deletePHI_popupOneOption: UIView!
    @IBOutlet weak var PHI_FinalMessage_OK: UIButton!
    
    @IBOutlet weak var imageWidhtConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    
    
}


//protocol CommonAlertProtocol {
//    func commonOkAlertAction()
//    func commonFailureAlertAction()
//    func commonSuccessAlertAction()
//
//}
//
//
//typealias MethodHandler2 = ()->Void
class CommonAlert:NSObject {
   
    
   
    override init() {
        super.init()
    }
    
    fileprivate func addAlert()->DeletePHIAlertview {
        let commonAlertView: DeletePHIAlertview = Bundle.main.loadNibNamed("DeletePHIAlertview", owner: nil, options: nil)?.first as! DeletePHIAlertview
        // let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
       // let sceneDelegate = windowScene!.delegate as? SceneDelegate
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
        let window = appDelegete.window
       
        commonAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        window?.addSubview(commonAlertView)
        window?.bringSubviewToFront(commonAlertView)
        return commonAlertView
    }
    
    
    public func removeAlert() {
        
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//       let sceneDelegate = windowScene!.delegate as? SceneDelegate
//       let window = sceneDelegate!.window

        
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
        let window = appDelegete.window
        if let commonAlertView = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            window?.subviews[commonAlertView].removeFromSuperview()
//            commonAlertView.removeFromSuperview()
        }
    }
    
    
    

    
    func setupAlert(alert title:String,alertDescription message:String? = nil,okAction:String,okColor:UIColor = .appTextColor,cancelAction:String? = nil, userImage:String? = nil)
    {
    
        let alertView = self.addAlert()
        alertView.message_titleLb.setFont(font: .bold(size: .BODY))
        alertView.message_titleLb.textAlignment = .center
        alertView.messageDescriptionLbl.setFont(font: .medium(size: .BODY))
        alertView.messageDescriptionLbl.textAlignment = .center
        alertView.userImageView.tintColor = .black
        alertView.message_titleLb.text = title

        
        if let description = message {
            alertView.messageDescriptionLbl.text = description
        }else {
            alertView.messageDescriptionLbl.text = ""
        }
        
        // MARK: cancelAction title will be change to alert box UI

        if cancelAction != nil {
            //        MARK: set for single Button UI
            alertView.PHI_DeleteYesBtn.setTitle(okAction, for: .normal)
            alertView.PHI_DeleteNoBtn.setTitle(cancelAction, for: .normal)
            alertView.deletePHI_popupOneOption.isHidden = true
            alertView.deletePHI_popupTwoOption.isHidden = false
            
            alertView.PHI_DeleteYesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_DeleteYesBtn.titleLabel?.setFont(font: .bold(size: .BODY))
            //font =  UIFont.systemFont(ofSize: 14, weight: .regular)
            alertView.PHI_DeleteYesBtn.backgroundColor = .white
          
            alertView.PHI_DeleteYesBtn.setTitleColor(.appLightPink, for: .normal)
            alertView.PHI_DeleteNoBtn.backgroundColor = .white
            alertView.PHI_DeleteNoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
          //  alertView.PHI_DeleteNoBtn.layer.borderWidth = 1
          //  alertView.PHI_DeleteNoBtn.layer.cornerRadius = 5
            alertView.PHI_DeleteNoBtn.titleLabel?.setFont(font: .bold(size: .BODY))
                //.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
            alertView.PHI_DeleteNoBtn.setTitleColor(.black, for: .normal)
            
            alertView.PHI_DeleteNoBtn.addTap {
                self.removeAlert()
            }
            alertView.PHI_DeleteYesBtn.addTap {
                self.removeAlert()
            }
        }
        else {
            //        MARK: set for dual Button UI
            alertView.PHI_FinalMessage_OK.setTitle(okAction, for: .normal)
            alertView.deletePHI_popupOneOption.isHidden = false
            alertView.deletePHI_popupTwoOption.isHidden = true
            alertView.PHI_FinalMessage_OK.setTitleColor(okColor, for: .normal)
            alertView.PHI_FinalMessage_OK.titleLabel?.setFont(font: .bold(size: .BODY))
            alertView.PHI_FinalMessage_OK.backgroundColor = .clear
            alertView.PHI_FinalMessage_OK.titleLabel?.adjustsFontSizeToFitWidth = true
         
            alertView.PHI_FinalMessage_OK.addTap {
                self.removeAlert()
            }

            
        }
       
        
        
        
        //        MARK: userimage is optional for alert
        if let url = userImage  {
            alertView.userImageView.image = UIImage(named: url)
            alertView.imageWidhtConstraint.constant = 60
        }else {
            alertView.imageWidhtConstraint.constant = 0
        }
        alertView.centerView = self.getViewExactHeight(view: alertView.centerView)
       
    }
    
    
    // MARK: actions for ok buttons first setupAlert
     
    func addAdditionalOkAction(isForSingleOption:Bool, customAction:@escaping()->Void) {
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//       let sceneDelegate = windowScene!.delegate as? SceneDelegate
//       let window = sceneDelegate!.window
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
        let window = appDelegete.window
        
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                        if isForSingleOption {
                            commonAlertView.PHI_FinalMessage_OK.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }else {
                            commonAlertView.PHI_DeleteYesBtn.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }
                    }
        }
        
    }
    
    func addAdditionalCancelAction( customAction:@escaping()->Void) {
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//       let sceneDelegate = windowScene!.delegate as? SceneDelegate
//       let window = sceneDelegate!.window
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
        let window = appDelegete.window
        
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                commonAlertView.PHI_DeleteNoBtn.addTap {
                                   self.removeAlert()
                                   customAction()
                               }
                    }
        }
        
    }
    
//    @objc fileprivate func okBtnPressed(_ sender:UIButton) {
//
//        self.delegate.commonOkAlertAction()
//        self.removeAlert()
//    }
//
//    @objc fileprivate func successBtnPressed(_ sender:UIButton) {
//
//        self.delegate.commonSuccessAlertAction()
//        self.removeAlert()
//    }
//
//    @objc fileprivate func failureBtnPressed(_ sender:UIButton) {
//        self.delegate.commonFailureAlertAction()
//        self.removeAlert()
//    }
    
    fileprivate func getViewExactHeight(view:UIView)->UIView {
       
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
    
    
    
}






