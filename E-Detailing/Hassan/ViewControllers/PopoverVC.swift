

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
        case outbox
        case events
        case presentation
        case profile
        case customMarker
        case timeLine
        case RCPA
        case hover
    }
    
    
    func toSetPageType(_ pageType: PageType) {
        contentTable.showsVerticalScrollIndicator = false
        contentTable.showsHorizontalScrollIndicator = false
        switch pageType {
            
        case .TP:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            userProfileInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            toLOadData()
        case .HomeGraph:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = true
            graphInfoView.isHidden = false
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            setupUI()
            
        case .calls, .outbox:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            toLOadData()
        case .presentation:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            toLOadData()
        case .profile:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = false
            self.contentTable.isHidden = true
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            setProfileInfo()
        case .customMarker:
            hoverView.isHidden = true
            customMarkerView.isHidden = false
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            self.contentTable.isHidden = true
            graphInfoView.isHidden = true
            print("Yet to implement")
            setCustomerInfo()
            
        case .events:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = false
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            toLOadData()
        case .timeLine:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = true
            graphInfoView.isHidden = true
            timeInfoView.isHidden = false
            rcpaInfoView.isHidden = true
            setTimeline()
        case .RCPA:
            hoverView.isHidden = true
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            self.contentTable.isHidden = true
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = false
            guard let modal = self.rcpaInfo else {return}
            setRCPAinfo(modal: modal)
        case .hover:
            self.view.backgroundColor = color
            hoverView.backgroundColor = color
            customMarkerView.isHidden = true
            userProfileInfoView.isHidden = true
            commentsTV.text = comments
            commentsTV.backgroundColor = .clear
            commentsTV.textColor = .appWhiteColor
            commentsTV.isUserInteractionEnabled = false
            contentTable.isHidden = true
            graphInfoView.isHidden = true
            timeInfoView.isHidden = true
            rcpaInfoView.isHidden = true
            hoverView.isHidden = false
        }
    }
    
    @IBOutlet var hoverView: UIView!
    
    @IBOutlet var commentsTV: UITextView!
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
    
    
    //Timeinfo
    
    @IBOutlet var timeInfoView: UIView!
    
    @IBOutlet var lblTimeINfo: UILabel!
    
    @IBOutlet var lblStartTime: UILabel!
    
    
    @IBOutlet var lblEndTime: UILabel!
    
    
    @IBOutlet var rcpaInfoView: UIView!
    
    @IBOutlet var ourProductQtyLbl: UILabel!
    
    @IBOutlet var ourProductRateLbl: UILabel!
    
    @IBOutlet var ourProductTotalLbl: UILabel!
    
    
    @IBOutlet var compProductQtyLbl: UILabel!
    
    
    @IBOutlet var compProductRateLbl: UILabel!
    
    @IBOutlet var compProductTotalLbl: UILabel!
    
    @IBOutlet var grandTotalLbl: UILabel!
    
    
    var delegate: PopOverVCDelegate?
    var strArr = [String]()
    var isExist = Bool()
    var isFromWishlist = Bool()
    var isFromHome = Bool()
    var selectedIndex = Int()
    var pageType: PageType = .TP
    var totalCalls: Int = 0
    var avgCalls: Float = 0
    var color : UIColor? = .appWhiteColor
    var comments: String = ""
    var visitViewModel : VisitViewModel?
    var startTime: String = ""
    var endTime: String = ""
    var rcpaInfo: RCPAresonseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        toSetPageType(self.pageType)
    }
    
    func setRCPAinfo(modal: RCPAresonseModel) {
        rcpaInfoView.layer.cornerRadius = 5
        rcpaInfoView.backgroundColor = .appTextColor
        
        ourProductQtyLbl.textColor = .appWhiteColor
        
        ourProductQtyLbl.text = "\(modal.opQty)"
        ourProductRateLbl.text =  "\(modal.opRate)"
        
        let productTotal = Double(modal.opQty) * modal.opRate
        
        ourProductTotalLbl.text = "\(productTotal)"
        compProductQtyLbl.text = "\(modal.cpQty)"
        
        compProductRateLbl.text = "\(modal.cpRate)"
        
        let compTotal = Double(modal.cpQty) * modal.cpRate
        
        compProductTotalLbl.text = "\(compTotal)"
        grandTotalLbl.text = "\(productTotal + compTotal)"
    }
    
    func setTimeline() {
        lblTimeINfo.text = "Timeline"
        timeInfoView.backgroundColor = color
        timeInfoView.layer.cornerRadius = 5
        lblTimeINfo.textColor = .appWhiteColor
        lblTimeINfo.setFont(font: .bold(size: .BODY))
        lblStartTime.setFont(font: .medium(size: .BODY))
        lblEndTime.setFont(font: .medium(size: .BODY))
        lblStartTime.textColor = .appWhiteColor
        lblEndTime.textColor = .appWhiteColor
        lblStartTime.text = startTime
        lblEndTime.text = endTime
        
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
        
        viewTaggedImgHolder.isHidden = LocalStorage.shared.getBool(key: .istoAllowImageTag) ? false : true
        
        viewTaggedImgHolder.isUserInteractionEnabled = LocalStorage.shared.getBool(key: .istoAllowImageTag) ? false : true

        viewTaggedImgHolder.addTap {
            self.dismissPopover()

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
        strArr = pageType == .TP ? ["Edit"] : pageType == .calls ? ["Edit", "Delete"] : pageType == .outbox ? ["Edit", "Sync", "Delete"] : pageType == .events ? ["Sync", "Delete"] : ["Play", "Edit", "Delete"]
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
        popover.permittedArrowDirections = pagetype == .HomeGraph || pagetype == .customMarker  || pagetype == .timeLine  ? UIPopoverArrowDirection.down :  UIPopoverArrowDirection.up
        
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
        case .calls, .outbox:
            return 40
        case .presentation:
            return 40
        case .profile:
            return 0
        case .customMarker:
            return 0
        case .events:
            return 40
        case .timeLine:
            return UITableView.automaticDimension
        case .RCPA:
            return UITableView.automaticDimension
        case .hover:
            return UITableView.automaticDimension
        }
        
   
    }
    
    
}


class InfoTVC: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
