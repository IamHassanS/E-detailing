//
//  HomeSideMenuMenuView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 10/01/24.
//

import Foundation
import UIKit

class MenuItemModel{
    var title : String
    var imgName : UIImage?
    var viewController : UIViewController?
  
    init(withTitle title :String,image : UIImage? = nil,VC : UIViewController? ){
        self.title = title
        self.imgName = image
        self.viewController = VC
    }
}




extension HomeSideMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return menuItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeSideMenuTVC = sidemenuTable.dequeueReusableCell(withIdentifier: "HomeSideMenuTVC", for: indexPath) as! HomeSideMenuTVC
        cell.selectionStyle = .none
        let model = menuItemArr[indexPath.row]
        cell.sideMenuIcon.image = model.menuIcon
        cell.sideMenuIcon.tintColor = .appTextColor
        cell.sideMenuTitle.text = model.menuName
        
        cell.addTap {
            
            self.menuVC.dismiss(animated: false, completion: {
                let _selectedItem = self.menuItemArr[indexPath.row]
                switch _selectedItem.menuName {
                case "Refresh Location":
                    self.menuVC.delegate?.didLocationUpdated()
                    
                case "Clear slides":
                    self.menuVC.menuAlertDelegate?.addAlert(.clearSlides)
                    
//                case "FAQ":
//                    if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
//                        self.menuVC.menuAlertDelegate?.addAlert(.notConnected)
//                        return
//                    }
//                    if let vc = _selectedItem.viewController{
//                            self.menuVC.menuDelegate?.routeToView(vc)
//                    }
                    
                default:
                    if let vc = _selectedItem.viewController{
                            self.menuVC.menuDelegate?.routeToView(vc)
                    }
                }
        
            })
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sidemenuTable.height / 13
    }
    
    
}
class HomeSideMenuView : BaseView{
    
    struct MenuItems {
        let menuIcon: UIImage
        let menuName: String
        var viewController : UIViewController?
        
        init(menuName :String,menuIcon : UIImage,VC : UIViewController?){
            self.menuName = menuName
            self.menuIcon = menuIcon
            self.viewController = VC
        }
        
    }
    
    var menuVC :  HomeSideMenuVC!
    
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var syncBtn: UIButton!
    @IBOutlet var locationBtn: UIButton!
 
    @IBOutlet var pageTitle: UILabel!
    // @IBOutlet var topContainerView: UIView!
    @IBOutlet var closeBtn: UIButton!
   // @IBOutlet var titleLbl: UILabel!
    @IBOutlet var sidemenuTable: UITableView!
    
    @IBOutlet weak var sideMenuHolderView : UIView!
    
    
    //Setups
    
    @IBOutlet var geocheckViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sequentialViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var sequentialView: UIView!
    
    @IBOutlet var sequentialVXview: UIVisualEffectView!
    
    @IBOutlet var geoCheckVXview: UIVisualEffectView!
    
    @IBOutlet var geoCheckView: UIView!
    
    
    @IBOutlet var geoCheckLbl: UILabel!
    
    
    
    @IBOutlet var doctorFencingView: UIView!
    
    @IBOutlet var doctorFencingVXview: UIVisualEffectView!
    
    @IBOutlet var doctorFencingLbl: UILabel!
    
    
    
    @IBOutlet var chemistFencingView: UIView!
    
    @IBOutlet var chemistFencingVXview: UIVisualEffectView!
    
    @IBOutlet var chemistLbl: UILabel!
    
    
    @IBOutlet var stockistFencingView: UIView!
    
    @IBOutlet var stockistFencingVXview: UIVisualEffectView!
    
    @IBOutlet var stockistLbl: UILabel!
    
    
    @IBOutlet var unlistedDoctorFencingView: UIView!
    
    @IBOutlet var unlistedDoctorVXview: UIVisualEffectView!
    
    @IBOutlet var unlistedDoctorLbl: UILabel!
    
    @IBOutlet var unlistedDoctorFencingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var stockistFencingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var chemistFencingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var doctorFencingViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var appVersionLbl: UILabel!
    
    //MARK: UDF, gestures  and animations
    var menuItemArr: [MenuItems] = []
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.showMenu()
        setupUI()
        initVIews()
        cellRegistration()
        toLoadData()
    }
    @IBAction func profileAction(_ sender: Any) {
        self.menuVC.dismiss(animated: false) {
            self.menuVC.delegate?.didProfileTapped()
        }
      
        
    }
    @IBAction func syncAction(_ sender: Any) {
        
        self.menuVC.dismiss(animated: false) {
            self.menuVC.delegate?.didMasterSync()
        }
        
      
    }
    
    @IBAction func locationAction(_ sender: Any) {
        
        self.menuVC.dismiss(animated: false) {
            self.menuVC.delegate?.didLocationUpdated()
        }
        
       
    }
    
    
    func setupUI() {
        appVersionLbl.text = LocalStorage.shared.getString(key: .AppVersion)
        locationBtn.layer.cornerRadius = syncBtn.height / 2
        profileBtn.layer.cornerRadius = syncBtn.height / 2
        syncBtn.layer.cornerRadius = syncBtn.height / 2
        //  titleLbl.setFont(font: .bold(size: .SUBHEADER))
        // topContainerView.backgroundColor = .appTextColor
        //   titleLbl.text = "SAN Media Pvt Ltd.,"
        //  titleLbl.textColor = .appWhiteColor
        self.menuItemArr = self.toAppendMenuItems()
        geocheckViewWidthConstraint.constant = 0
        doctorFencingViewWidthConstraint.constant = 0
        chemistFencingViewWidthConstraint.constant = 0
        stockistFencingViewWidthConstraint.constant = 0
        unlistedDoctorFencingViewWidthConstraint.constant = 0
        sequentialViewWidthConstraint.constant = 0
        
        sequentialView.isHidden = true
        doctorFencingView.isHidden = true
        geoCheckView.isHidden = true
        chemistFencingView.isHidden = true
        stockistFencingView.isHidden = true
        unlistedDoctorFencingView.isHidden = true
        
        pageTitle.text = AppDefaults.shared.getAppSetUp().divisionName
        
        locationBtn.isHidden = geoFencingEnabled ? false : true
        
        if isSequentialDCRenabled {
            sequentialViewWidthConstraint.constant = 35
            sequentialVXview.backgroundColor = .appDeepBrown
            sequentialView.layer.cornerRadius = 25 / 2
            sequentialView.isHidden = false
        }
         
        if geoFencingEnabled {
            geoCheckVXview.backgroundColor = .appYellow
            geoCheckView.layer.cornerRadius = 25 / 2
            geoCheckLbl.textColor = .appWhiteColor
            geocheckViewWidthConstraint.constant = 35
            geoCheckView.isHidden = false
        }


        if isDoctorFencingNeeded {
            doctorFencingVXview.backgroundColor = .appGreen
            doctorFencingView.layer.cornerRadius = 25 / 2
            doctorFencingLbl.textColor = .appWhiteColor
            doctorFencingViewWidthConstraint.constant = 35
            doctorFencingView.isHidden = false
        }
        

        if isChemistFencingNeeded {
            chemistFencingVXview.backgroundColor = .appBlue
            chemistFencingView.layer.cornerRadius = 25 / 2
            chemistLbl.textColor = .appWhiteColor
            chemistFencingViewWidthConstraint.constant = 35
            chemistFencingView.isHidden = false
        }
 
        if isStockistFencingNeeded {
            stockistFencingVXview.backgroundColor = .appLightPink
            stockistFencingView.layer.cornerRadius = 25 / 2
            stockistLbl.textColor = .appWhiteColor
            stockistFencingViewWidthConstraint.constant = 35
            stockistFencingView.isHidden = false
        }

        
        if isUnliatedDoctorFencingNeeded {
            unlistedDoctorVXview.backgroundColor = .appLightGrey
            unlistedDoctorFencingView.layer.cornerRadius = 25 / 2
            unlistedDoctorLbl.textColor = .appWhiteColor
            unlistedDoctorFencingViewWidthConstraint.constant = 35
            unlistedDoctorFencingView.isHidden = false
        }
    }
    
    func initVIews() {
        closeBtn.addTap {
            self.hideMenuAndDismiss()
        }
    }
    
    
    func cellRegistration() {
        sidemenuTable.register(UINib(nibName: "HomeSideMenuTVC", bundle: nil), forCellReuseIdentifier: "HomeSideMenuTVC")
    }
    
    func toLoadData() {
        sidemenuTable.delegate = self
        sidemenuTable.dataSource = self
        sidemenuTable.reloadData()
    }
    
    
    
    func toAppendMenuItems() -> [MenuItems]{
      //  let vc = SlideDownloadVC.initWithStory()
        let refreshItem : MenuItems = MenuItems(menuName: "Refresh Location", menuIcon: UIImage(named: "refreshSlide") ?? UIImage(), VC: nil)
        menuItemArr.append(refreshItem)
        
        
        let tourplanVC = TourPlanVC.initWithStory()
        let tourPlan : MenuItems = MenuItems(menuName: "Tour Plan", menuIcon: UIImage(named: "tourplan") ?? UIImage(), VC: tourplanVC)
        menuItemArr.append(tourPlan)
        
        let resourceVC = ReportsVC.initWithStory(pageType: .myResource)
        let myResource : MenuItems = MenuItems(menuName: "My Resource", menuIcon: UIImage(named: "SideMenuMyResource") ?? UIImage(), VC: resourceVC)
        menuItemArr.append(myResource)
        
        let leaveVC = LeaveApplicationVC.initWithStory()
        let leaveApplication : MenuItems = MenuItems(menuName: "Leave application", menuIcon: UIImage(named: "leaveApplication") ?? UIImage(), VC: leaveVC)
        menuItemArr.append(leaveApplication)
        
//        let reportsVC = ReportsVC.initWithStory(pageType: .reports)
//        let report : MenuItems = MenuItems(menuName: "Report", menuIcon: UIImage(named: "report_black") ?? UIImage(), VC: reportsVC)
//        menuItemArr.append(report)
        
        
//        let activity : MenuItems = MenuItems(menuName: "Activity", menuIcon: UIImage(named: "SideMenuActivity") ?? UIImage(), VC: nil)
//        menuItemArr.append(activity)
        
        let nearMeVC = UIStoryboard.nearMeVC
        let nearMe : MenuItems = MenuItems(menuName: "Near Me", menuIcon: UIImage(named: "SideMenuNearMe") ?? UIImage(), VC: nearMeVC)
        menuItemArr.append(nearMe)
        
        if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
            let approvalsVC = ReportsVC.initWithStory(pageType: .approvals)
            let approvals : MenuItems = MenuItems(menuName: "Approvals", menuIcon: UIImage(named: "approval") ?? UIImage(), VC: approvalsVC)
            menuItemArr.append(approvals)
        }

        
//        let quiz : MenuItems = MenuItems(menuName: "Quiz", menuIcon: UIImage(named: "SideMenuQuiz") ?? UIImage(), VC: nil)
//        menuItemArr.append(quiz)
        
        
//        let survey : MenuItems = MenuItems(menuName: "Survey", menuIcon: UIImage(named: "SideMenuSurvey") ?? UIImage() , VC: nil)
//        menuItemArr.append(survey)
        
        
//        let forms : MenuItems = MenuItems(menuName: "Forms", menuIcon: UIImage(named: "SideMenuForms") ?? UIImage(), VC: nil)
//        menuItemArr.append(forms)
        
        
//        let profiling : MenuItems = MenuItems(menuName: "Profiling", menuIcon: UIImage(named: "SideMenuProfiling") ?? UIImage(), VC: nil)
//        menuItemArr.append(profiling)
        let faqVC =  FAQwebController.initWithStory()
        let FAQ : MenuItems = MenuItems(menuName: "FAQ", menuIcon: UIImage(systemName: "questionmark.circle") ?? UIImage(), VC: faqVC)
        menuItemArr.append(FAQ)
        
        
        let removeSlide : MenuItems = MenuItems(menuName: "Clear slides", menuIcon: UIImage(systemName: "text.append") ?? UIImage(), VC: nil)
        menuItemArr.append(removeSlide)
        
       return menuItemArr
    }
    
    
    
    
    
    
    
    override func didLoad(baseVC: BaseViewController) {
        self.menuVC = baseVC as? HomeSideMenuVC
       // self.initView()
        self.initGestures()
        //self.ThemeUpdate()
        //setTheme()

    }
    
    func showMenu(){
       // let isRTL = isRTLLanguage
        let _ : CGFloat =  -1
        //isRTL ? 1 :
        _ = self.frame.width
        self.sideMenuHolderView.transform =  CGAffineTransform(translationX: 1,y: -1)
        //isRTL ? CGAffineTransform(translationX: 1 * width,y: 0)  :
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
//        UIView.animate(withDuration: animationDuration,
//                       delay: aniamteionWaitTime,
//                       usingSpringWithDamping: animationDampning,
//                       initialSpringVelocity: animationVelocity,
//                       options: [.curveEaseOut,.allowUserInteraction],
//                       animations: {
//                        self.sideMenuHolderView.transform = .identity
//                        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
//                       }, completion: nil)
        
        self.sideMenuHolderView.transform = .identity
        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
    }
    
    func hideMenuAndDismiss(){
        self.menuVC.dismiss(animated: false, completion: nil)
    }
    
    func initGestures(){

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
    
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
      
        let _ : CGFloat =   -1
        //isRTL ? 1 :
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
        //        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
        case .began,.changed:
            guard  ( xMovement < 0)  else {return}
          //  ||  (xMovement < 0)
           // isRTL && || !isRTL &&
            
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        default:
            let velocity = gesture.velocity(in: self.sideMenuHolderView).x
            self.animationDuration = Double(velocity)
            if abs(xMovement) <= self.frame.width * 0.25{//show
                self.sideMenuHolderView.transform = .identity
                self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
            }else{//hide
                self.hideMenuAndDismiss()
            }
            
        }
    }
}
