

import UIKit

protocol PopOverVCDelegate: AnyObject {
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int)
    
    func logoutAction()
    func changePasswordAction()
    
}


class PopOverVC: UIViewController {
    
    
    enum PageType {
        case TP
        case HomeGraph
        case calls
        case events
        case presentation
        case profile
        case customMarker
    }
    
    
    func toSetPageType(_ pageType: PageType) {
        contentTable.showsVerticalScrollIndicator = false
        contentTable.showsHorizontalScrollIndicator = false
        switch pageType {
            
        case .TP:
            customMarkerView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            userProfileInfoView.isHidden = true
            toLOadData()
        case .HomeGraph:
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = true
            graphInfoView.isHidden = false
            setupUI()
            
        case .calls:
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            toLOadData()
        case .presentation:
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            toLOadData()
        case .profile:
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = false
            self.contentTable.isHidden = true
            graphInfoView.isHidden = true
            setProfileInfo()
        case .customMarker:
            customMarkerView.isHidden = false
            print("Yet to implement")
            setCustomerInfo()
            
        case .events:
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            toLOadData()
        }
    }
    
    @IBOutlet var userProfileInfoView: UIView!
    
    @IBOutlet var userDesignationLbl: UILabel!
    
    @IBOutlet var userHQlbl: UILabel!
    
    @IBOutlet var lblChangePassword: UILabel!
    
    @IBOutlet var lblLogout: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userIV: UIImageView!
    
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var viewChangePassword: UIView!
    
    @IBOutlet var viewLogout: UIView!
    
    @IBOutlet var graphInfoView: UIView!
    
    @IBOutlet weak var contentTable: UITableView!
    
    @IBOutlet var callCountLbl: UILabel!
    @IBOutlet var totalCallsLbl: UILabel!
    
    @IBOutlet var avgCllLbl: UILabel!
    
    @IBOutlet var avgCallCount: UILabel!
    
    //Custom Marker
    
    @IBOutlet var customMarkerView: UIView!
    @IBOutlet var customerIcon: UIImageView!
    
    @IBOutlet var customerInfoLbl: UILabel!
    
    @IBOutlet var customerAddress: UILabel!
    
    @IBOutlet var viewTaggedImgHolder: UIStackView!
    
    var delegate: PopOverVCDelegate?
    var strArr = [String]()
    var isExist = Bool()
    var isFromWishlist = Bool()
    var isFromHome = Bool()
    var selectedIndex = Int()
    var pageType: PageType = .TP
    var totalCalls: Int = 0
    var avgCalls: Int = 0
    var color : UIColor? = .appWhiteColor
    var visitViewModel : VisitViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        toSetPageType(self.pageType)
    }

    func setCustomerInfo() {
        guard let visitViewModel = visitViewModel else {return}
        customerInfoLbl.text = visitViewModel.name
        customerAddress.text = visitViewModel.address
        switch visitViewModel.taggedDetail.tagType {
            
     
        case .doctor:
            customerIcon.image = UIImage(named: "ListedDoctor")
        case .chemist:
            customerIcon.image = UIImage(named: "Chemist")
        case .stockist:
            customerIcon.image = UIImage(named: "Stockist")
        case .unlistedDoctor:
            customerIcon.image = UIImage(named: "Doctor")
        }
        viewTaggedImgHolder.addTap {
            self.dismissPopover()
          //  self.delegate?.changePasswordAction()
        }
       //
    }
    
    
    func setProfileInfo() {
        seperatorView.backgroundColor = .appSelectionColor
        userIV.layer.cornerRadius = userIV.height / 2
        lblChangePassword.setFont(font: .medium(size: .BODY))
        lblLogout.setFont(font: .medium(size: .BODY))
        
        lblLogout.textColor = .appTextColor
        lblChangePassword.textColor = .appTextColor
        
        userNameLbl.setFont(font: .bold(size: .BODY))
        userNameLbl.textColor = .appTextColor
        userDesignationLbl.setFont(font: .medium(size: .SMALL))
        userDesignationLbl.textColor = .appLightTextColor
        userHQlbl.setFont(font: .medium(size: .SMALL))
        userHQlbl.textColor = .appGreen
        
       let appsetup = AppDefaults.shared.getAppSetUp()
        
        userNameLbl.text = appsetup.sfName
        userDesignationLbl.text = appsetup.dsName
        userHQlbl.text = appsetup.hqName
        
        viewChangePassword.addTap { [weak self] in
            guard let welf = self else {return}
            welf.dismissPopover()
          
        }
        
        
        
        viewLogout.addTap { [weak self] in
            guard let welf = self else {return}
            welf.delegate?.logoutAction()
        }
        
    }
    
    func dismissPopover() {
        dismiss(animated: true) { [weak self] in
            guard let welf = self else {return}
            welf.delegate?.changePasswordAction()
        }
    }
    
    func setupUI() {

        
        graphInfoView.backgroundColor = color
        graphInfoView.layer.cornerRadius = 5
        
        
        let infoLbls = [callCountLbl, totalCallsLbl, avgCllLbl, avgCallCount]
        
        infoLbls.forEach { lbl in
            
            if lbl == totalCallsLbl || lbl == avgCllLbl {
                lbl?.setFont(font: .bold(size: .BODY))
            } else {
                lbl?.setFont(font: .medium(size: .BODY))
                
            }
            
            lbl?.textColor = .appWhiteColor
            
        }
        callCountLbl.text = "\(self.avgCalls)"
        avgCallCount.text =  "\(self.totalCalls)"
    }
    
    func toLOadData() {
        strArr = pageType == .TP ? ["Edit"] : pageType == .calls ? ["Edit", "Delete"] : pageType == .events ? ["Delete"] : ["Play", "Edit", "Delete"]
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.reloadData()
    }
    
    //MARK:- initWithStory
    class func initWithStory(preferredFrame size : CGSize,on host : UIView , pagetype: PageType) -> PopOverVC{
        let infoWindow: PopOverVC  = UIStoryboard(name: "Hassan", bundle: nil).instantiateViewController(withIdentifier: "PopOverVC") as! PopOverVC
        infoWindow.pageType = pagetype
        infoWindow.preferredContentSize = size
        infoWindow.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = infoWindow

        popover.sourceView = host
    
     
        popover.backgroundColor = .appWhiteColor
       // popover.permittedArrowDirections = pagetype == .calls ? UIPopoverArrowDirection.up : pagetype == .presentation ?  UIPopoverArrowDirection.up :  UIPopoverArrowDirection.down
        popover.permittedArrowDirections = pagetype == .HomeGraph || pagetype == .customMarker ? UIPopoverArrowDirection.down :  UIPopoverArrowDirection.up
        
        return infoWindow
    }

    
}
extension PopOverVC : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
extension UIViewController{
//    func showPopOver(on host : UIView, isForTP: Bool){
//        let infoWindow = PopOverVC
//            .initWithStory(preferredFrame: CGSize(width: self.view.frame.width,
//                                                  height: 100),
//                           on: host, pagetype: isForTP ? .TP : .HomeGraph)
//        infoWindow.modalPresentationStyle = .fullScreen
//        self.present(infoWindow, animated: true) {
//        //    infoWindow.toLOadData()
//        }
//    }
}




extension PopOverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTVC = tableView.dequeueReusableCell(withIdentifier: "InfoTVC", for: indexPath) as! InfoTVC
        cell.titleLbl.text = strArr[indexPath.row]
        cell.titleLbl.textColor = .appTextColor
        cell.titleLbl.setFont(font: .bold(size: .BODY))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.didTapRow(indexPath.row, self.selectedIndex)
            self.delegate = nil
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch self.pageType {

        case .TP:
            return 40
        case .HomeGraph:
            return UITableView.automaticDimension
        case .calls:
            return 40
        case .presentation:
            return 40
        case .profile:
            return 0
        case .customMarker:
            return 0
        case .events:
            return 40
        }
        
   
    }
    
    
}


class InfoTVC: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
