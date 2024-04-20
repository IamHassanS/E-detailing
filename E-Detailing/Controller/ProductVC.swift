////
////  ProductVC.swift
////  E-Detailing
////
////  Created by SANEFORCE on 09/08/23.
////
//
//import Foundation
//import UIKit
//import Alamofire
////import Toast_Swift
//import CoreData
//
//class ProductVC : UIViewController {
//    
//   
//    @IBOutlet weak var txtSearchForProduct: UITextField!
//    @IBOutlet weak var txtSearchForInput: UITextField!
//    @IBOutlet weak var txtSearchForAdditionalCall: UITextField!
//    
//    
//    @IBOutlet weak var txtRcpaQty: UITextField!
//    @IBOutlet weak var txtRcpaRate: UITextField!
//    @IBOutlet weak var txtRcpaTotal: UITextField!
//    
//    
//    @IBOutlet weak var txtPob: UITextField!
//    
//    
//    @IBOutlet weak var txtRemarks: UITextView!
//    
//    @IBOutlet weak var txtFeedback: UITextField!
//    
//    @IBOutlet weak var lblChemistName: UILabel!
//    @IBOutlet weak var lblProductName: UILabel!
//    
//    
//    @IBOutlet weak var btnAddCompetitor: UIButton!
//    @IBOutlet weak var btnRcpaChemist: UIButton!
//    @IBOutlet weak var btnRcpaProduct: UIButton!
//    
//    
//    @IBOutlet weak var viewSegmentControl: UIView!
//    
//    
//    @IBOutlet weak var ProductTableView: UITableView!
//    @IBOutlet weak var productSampleTableView: UITableView!
//    
//    
//    @IBOutlet weak var inputListTableView: UITableView!
//    @IBOutlet weak var inputSampleTableView: UITableView!
//    
//    
//    @IBOutlet weak var detailledListTableView: UITableView!
//    
//    @IBOutlet weak var additionalCallListTableView: UITableView!
//    @IBOutlet weak var additionalCallSelectedTableView: UITableView!
//    
//    
//    @IBOutlet weak var additionalCallSampleInputTableView: UITableView!
//    
//    @IBOutlet weak var rcpaCompetitorTableView: UITableView!
//    @IBOutlet weak var rcpaAddedListTableView: UITableView!
//    
//    
//    @IBOutlet weak var eventCaptureTableView: UITableView!
//    
//    
//    @IBOutlet weak var jointWorkTableView: UITableView!
//    
//    @IBOutlet weak var selectionTableView: UITableView!
//    
//    @IBOutlet weak var singleSelectionTableView: UITableView!
//    
//    @IBOutlet weak var viewProduct: UIView!
//    @IBOutlet weak var viewInput: UIView!
//    @IBOutlet weak var viewJointWork: UIView!
//    @IBOutlet weak var viewAdditionalCalls: UIView!
//    @IBOutlet weak var viewRCPA: UIView!
//    @IBOutlet weak var viewFeedback: UIView!
//    
//    
//    @IBOutlet weak var viewRcpaChemist: UIView!
//    @IBOutlet weak var viewRcpaProduct: UIView!
//    
//    @IBOutlet weak var viewRcpa: UIView!
//    
//    @IBOutlet weak var viewAdditionalCallSampleInput: UIView!
//    
//    @IBOutlet weak var viewAdditionalCallSegmentControl: UIView!
//
//    @IBOutlet weak var viewSelectionList: UIView!
//    
//    @IBOutlet weak var viewSingleSelection: UIView!
//    
//    @IBOutlet weak var viewEventCapture: UIView!
//    
//    @IBOutlet weak var viewJointWorkLists: UIView!
//    
//    @IBOutlet weak var viewPob: UIView!
//    
//    @IBOutlet weak var viewFeedbackSelection: UIView!
//
//    @IBOutlet weak var viewRemarks: UIView!
//    
//    @IBOutlet weak var viewPobAndFeedbackCollection: UIView!
//    
//    
//    @IBOutlet weak var widthViewPobConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var widthViewEventCaptureConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var trailingViewJointWorkListsConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var leadingViewJointWorkListsConstraint: NSLayoutConstraint!
//    
//    
//    @IBOutlet weak var leadingViewFeedbackConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var trailingViewFeedbackConstraint: NSLayoutConstraint!
//    
//    
//    @IBOutlet weak var widthViewPobAndFeedbackCollectionConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var leadingViewRemarksConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var trailingViewRemarksConstraint: NSLayoutConstraint!
//    
//    @IBOutlet var detailsHolder: UIView!
//    
//    private var productSegmentControl : UISegmentedControl!
//    
//    private var SampleInputSegmentControl : UISegmentedControl!
//    
//    var userStatisticsVM : UserStatisticsVM?
//    
//    var dcrCall : CallViewModel!
//    
//    var feedback = [Feedback]()
//    
//    var selectedChemistRcpa : AnyObject!
//    
//    var selectedProductRcpa : AnyObject!
//    
//    var searchText : String = ""
//    
//    var selectedFeedback : AnyObject!
//    
//    
//    var selectedDoctorIndex : Int = 0
//    
//    
//    private var productSelectedListViewModel = ProductSelectedListViewModel()
//    private var inputSelectedListViewModel = InputSelectedListViewModel()
//    private var jointWorkSelectedListViewModel = JointWorksListViewModel()
//    private var additionalCallListViewModel = AdditionalCallsListViewModel()
//    
//    private var eventCaptureListViewModel = EventCaptureListViewModel()
//    
//    private var rcpaAddedListViewModel = RcpaAddedListViewModel()
//    
//    private var rcpaCallListViewModel = RcpaListViewModel()
//    
//    
//    func setupUI() {
//        detailsHolder.layer.cornerRadius = 5
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
//        self.userStatisticsVM = UserStatisticsVM()
//        self.registerTableViewCell()
//        
//    //    self.updateDisplay()
//        
//        
//        [txtSearchForProduct,txtSearchForInput,txtSearchForAdditionalCall].forEach { txtfield in
//            txtfield.setIcon(UIImage(imageLiteralResourceName: "searchIcon"))
//        }
//        
//        [viewRcpaChemist,viewRcpaProduct,txtRcpaQty,txtRcpaRate,txtRcpaTotal,txtRemarks,txtPob,txtFeedback].forEach { view in
//            view.layer.borderColor = AppColors.primaryColorWith_40per_alpha.cgColor
//            view.layer.borderWidth = 1.5
//            view.layer.cornerRadius = 8
//        }
//        
//        self.txtSearchForProduct.addTarget(self, action: #selector(productSearchFilterAction(_:)), for: .editingChanged)
//        self.txtSearchForInput.addTarget(self, action: #selector(inputSearchFilterAction(_:)), for: .editingChanged)
//        self.txtSearchForAdditionalCall.addTarget(self, action: #selector(additionalCallSearchFilterAction(_:)), for: .editingChanged)
//        
//        self.txtPob.delegate = self
//        self.txtRemarks.delegate = self
//        self.txtRemarks.text = "Enter the remarks"
//        self.txtRemarks.textColor = UIColor.lightGray
//        
//        self.feedback = DBManager.shared.getFeedback()
//        
//        self.singleSelectionTableView.reloadData()
//        
//        updateSegment()
//        
//        updateSampleInputSegment()
//        
//    }
//    
//    
//    @objc func networkModified(_ notification: NSNotification) {
//        
//        print(notification.userInfo ?? "")
//        if let dict = notification.userInfo as NSDictionary? {
//               if let status = dict["Type"] as? String{
//                   DispatchQueue.main.async {
//                       if status == "No Connection" {
//                           self.toCreateToast("Please check your internet connection.")
//                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
//                       } else if  status == "WiFi" || status ==  "Cellular"   {
//                           
//                           self.toCreateToast("You are now connected.")
//                           LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
//              
//                          
//                       }
//                   }
//               }
//           }
//    }
//    
//    @objc func productSearchFilterAction (_ sender : UITextField){
//        print(sender.text!)
//        self.searchText = sender.text ?? ""
//        self.ProductTableView.reloadData()
//    }
//    
//    @objc func inputSearchFilterAction (_ sender : UITextField){
//        print(sender.text!)
//        self.searchText = sender.text ?? ""
//        self.inputListTableView.reloadData()
//    }
//    
//    @objc func additionalCallSearchFilterAction (_ sender : UITextField){
//        print(sender.text!)
//        self.searchText = sender.text ?? ""
//        self.additionalCallListTableView.reloadData()
//    }
//    
//    func updateDisplay () {
//        self.viewEventCapture.isHidden = true
//        self.widthViewEventCaptureConstraint.isActive = false
//        self.trailingViewJointWorkListsConstraint.isActive = false
//        self.leadingViewJointWorkListsConstraint.constant = 0
//        self.viewEventCapture.widthAnchor.constraint(equalToConstant: 0).isActive = true
//        
//        self.viewJointWorkLists.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.465).isActive = true
//        
//        
////        self.viewPob.isHidden = true
////        self.widthViewPobConstraint.isActive = false
////        self.trailingViewFeedbackConstraint.isActive = false
////        self.leadingViewFeedbackConstraint.constant = 0
////        self.viewPob.widthAnchor.constraint(equalToConstant: 0).isActive = true
////        
////        self.viewFeedbackSelection.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.24).isActive = true
////        
////        self.widthViewPobAndFeedbackCollectionConstraint.isActive = false
////        self.viewPobAndFeedbackCollection.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.24).isActive = true
////        self.viewRemarks.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.465).isActive = true
////        self.trailingViewRemarksConstraint.isActive = false
//        
//        
////        self.viewFeedbackSelection.isHidden = true
////        self.widthViewPobAndFeedbackCollectionConstraint.isActive = false
////        self.widthViewPobConstraint.isActive = false
////        self.viewRemarks.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.465).isActive = true
////        self.trailingViewRemarksConstraint.isActive = false
////        
////        self.viewPob.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.24).isActive = true
////        self.viewPobAndFeedbackCollection.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.24).isActive = true
//        
//        
//        self.viewPobAndFeedbackCollection.isHidden = true
//        self.widthViewPobAndFeedbackCollectionConstraint.isActive = false
//        self.widthViewPobConstraint.isActive = false
//        self.viewPobAndFeedbackCollection.widthAnchor.constraint(equalToConstant: 0).isActive = true
//    //    self.viewRemarks.widthAnchor.constraint(equalTo: self.viewFeedback.widthAnchor, multiplier: 0.465).isActive = true
//    //    self.trailingViewRemarksConstraint.isActive = false
//        self.leadingViewRemarksConstraint.constant = 0
//        
//    }
//    
//    func registerTableViewCell() {
//        
//        self.ProductTableView.register(UINib(nibName: "ProductNameWithSampleTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameWithSampleTableViewCell")
//        
//        self.detailledListTableView.register(UINib(nibName: "ProductRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductRatingTableViewCell")
//        
//        self.productSampleTableView.register(UINib(nibName: "ProductSampleTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductSampleTableViewCell")
//        
//        self.inputListTableView.register(UINib(nibName: "ProductNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameTableViewCell")
//        
//        self.inputSampleTableView.register(UINib(nibName: "InputSampleTableViewCell", bundle: nil), forCellReuseIdentifier: "InputSampleTableViewCell")
//        
//        self.jointWorkTableView.register(UINib(nibName: "JointWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "JointWorkTableViewCell")
//        
//        
//        self.additionalCallListTableView.register(UINib(nibName: "ProductNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameTableViewCell")
//        
//        self.additionalCallSelectedTableView.register(UINib(nibName: "AdditionalCallSampleInputTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalCallSampleInputTableViewCell")
//        
//        self.rcpaCompetitorTableView.register(UINib(nibName: "RcpaTableViewCell", bundle: nil), forCellReuseIdentifier: "RcpaTableViewCell")
//        
//        self.rcpaAddedListTableView.register(UINib(nibName: "RcpaAddedListTableViewCell", bundle: nil), forCellReuseIdentifier: "RcpaAddedListTableViewCell")
//        
//        self.eventCaptureTableView.register(UINib(nibName: "EventCaptureCell", bundle: nil), forCellReuseIdentifier: "EventCaptureCell")
//        
//        self.selectionTableView.register(UINib(nibName: "ProductNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameTableViewCell")
//        
//        detailledListTableView.register(UINib(nibName: "ProductdetailsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProductdetailsHeader")
//        
//        
//        productSampleTableView.register(UINib(nibName: "ProductsInfoHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProductsInfoHeader")
//        
//        
//        additionalCallSelectedTableView.register(UINib(nibName: "AdditionalCallSampleEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalCallSampleEntryTableViewCell")
//        
//        additionalCallSampleInputTableView.register(UINib(nibName: "AdditionalCallSampleEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalCallSampleEntryTableViewCell")
//    }
//    
//    
//    deinit {
//        print("ProductVC deinit")
//    }
//    
//    private func updateSampleInputSegment() {
//        let segments = ["Products","Inputs"]
//        
//        self.SampleInputSegmentControl = UISegmentedControl(items: segments)
//        
//        self.SampleInputSegmentControl.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.SampleInputSegmentControl.selectedSegmentIndex = 0
//        self.SampleInputSegmentControl.addTarget(self, action: #selector(sampleInputSegmentControlAction(_:)), for: .valueChanged)
//        
//        self.viewAdditionalCallSegmentControl.addSubview(self.SampleInputSegmentControl)
//        
//        let font = UIFont(name: "Satoshi-Bold", size: 15)!
//        
//        self.SampleInputSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
//        self.SampleInputSegmentControl.highlightSelectedSegment1()
//        
//        self.SampleInputSegmentControl.topAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.topAnchor,constant: 10).isActive = true
//        self.SampleInputSegmentControl.leadingAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.leadingAnchor, constant: 20).isActive = true
//        self.SampleInputSegmentControl.trailingAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.centerXAnchor).isActive = true
//        self.SampleInputSegmentControl.heightAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.heightAnchor, multiplier: 0.5).isActive = true
//        
//        
//        let lblUnderLine = UILabel()
//        lblUnderLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//        lblUnderLine.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.viewAdditionalCallSegmentControl.addSubview(lblUnderLine)
//        
//        lblUnderLine.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
//        
//        lblUnderLine.topAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.bottomAnchor, constant: -6).isActive = true
//        lblUnderLine.leadingAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.leadingAnchor, constant: 20).isActive = true
//        lblUnderLine.trailingAnchor.constraint(equalTo: self.viewAdditionalCallSegmentControl.trailingAnchor, constant: -20).isActive = true
//    }
//    
//    
//    private func updateSegment() {
//        
//        var segments = [String]()
//        
//        switch dcrCall.type {
//        case .doctor:
//            
//            segments.append("Detailed")
//            
//            if dcrCall.type.productNeed == 0 {
//                segments.append("Products")
//            }
//            
//            
//            segments.append("Inputs")
//            segments.append("Additional Calls")
//            segments.append("RCPA")
//            segments.append("JFW/Others")
//            
//           // segments = ["Detailed","Products", "Inputs", "Additional Calls" , "RCPA" ,"JFW/Others"]
//            
//            
//        default :
//            segments = ["Detailed","Products", "Inputs","JFW/Others"]
//        }
//        
//    //    segments = ["Detailed","Products", "Inputs", "Additional Calls" , "RCPA" ,"JFW/Others"]
//        
//        self.productSegmentControl = UISegmentedControl(items: segments)
//        
//        self.productSegmentControl.translatesAutoresizingMaskIntoConstraints = false
//        self.productSegmentControl.selectedSegmentIndex = 0
//        self.productSegmentControl.addTarget(self, action: #selector(segmentControlAction(_:)), for: .valueChanged)
//        
//        self.viewSegmentControl.addSubview(self.productSegmentControl)
//        
//        let font = UIFont(name: "Satoshi-Bold", size: 15)!
//        self.productSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
//        self.productSegmentControl.highlightSelectedSegment1()
//         
//        
//        self.productSegmentControl.topAnchor.constraint(equalTo: self.viewSegmentControl.topAnchor).isActive = true
//        self.productSegmentControl.leadingAnchor.constraint(equalTo: self.viewSegmentControl.leadingAnchor,constant: 20).isActive = true
//        self.productSegmentControl.heightAnchor.constraint(equalTo: self.viewSegmentControl.heightAnchor,multiplier: 0.7).isActive = true
//        
//        let lblUnderLine = UILabel()
//        lblUnderLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//        lblUnderLine.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.viewSegmentControl.addSubview(lblUnderLine)
//        
//        lblUnderLine.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
//        
//        lblUnderLine.topAnchor.constraint(equalTo: self.productSegmentControl.bottomAnchor, constant: -6).isActive = true
//        lblUnderLine.leadingAnchor.constraint(equalTo: self.viewSegmentControl.leadingAnchor, constant: 20).isActive = true
//        lblUnderLine.trailingAnchor.constraint(equalTo: self.viewSegmentControl.trailingAnchor, constant: -20).isActive = true
//    }
//    
//    @objc func sampleInputSegmentControlAction (_ sender : UISegmentedControl) {
//        self.SampleInputSegmentControl.underlinePosition()
//        
//        self.additionalCallSampleInputTableView.reloadData()
//    }
//    
//    @objc func segmentControlAction (_ sender : UISegmentedControl){
//        self.productSegmentControl.underlinePosition()
//        
//        
//        switch self.productSegmentControl.selectedSegmentIndex {
//            case 0:
//                self.viewJointWork.isHidden = false
//                [viewProduct,viewInput,viewAdditionalCalls,viewRCPA,viewFeedback].forEach({$0.isHidden = true})
//            case 1 :
//                self.viewProduct.isHidden = false
//                [viewInput,viewJointWork,viewAdditionalCalls,viewRCPA,viewFeedback].forEach({$0.isHidden = true})
//
//            case 2 :
//                self.viewInput.isHidden = false
//                [viewProduct,viewJointWork,viewAdditionalCalls,viewRCPA,viewFeedback].forEach({$0.isHidden = true})
//            case 3:
//                switch dcrCall.type{
//                case .doctor:
//                    self.viewAdditionalCalls.isHidden = false
//                    [viewProduct,viewInput,viewJointWork,viewRCPA,viewFeedback].forEach({$0.isHidden = true})
//                default:
//                    self.viewFeedback.isHidden = false
//                    [viewProduct,viewInput,viewJointWork,viewRCPA,viewAdditionalCalls].forEach({$0.isHidden = true})
//                }
//            case 4 :
//                self.viewRCPA.isHidden = false
//                [viewProduct,viewInput,viewJointWork,viewAdditionalCalls,viewFeedback].forEach({$0.isHidden = true})
//            case 5:
//                self.viewFeedback.isHidden = false
//                [viewProduct,viewInput,viewJointWork,viewRCPA,viewAdditionalCalls].forEach({$0.isHidden = true})
//            default:
//                break
//        }
//    }
//    
//    
//    @IBAction func backAction(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    @IBAction func saveJointWorkAction(_ sender: UIButton) {
//        self.jointWorkTableView.reloadData()
//        UIView.animate(withDuration: 1.5) {
//            self.viewSelectionList.isHidden = true
//        }
//    }
//    
//    @IBAction func feedbackAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 1.5) {
//            self.viewSingleSelection.isHidden = false
//        }
//    }
//    
//    @IBAction func closeRcpaAction(_ sender: UIButton) {
//        self.rcpaAddedListTableView.reloadData()
//        UIView.animate(withDuration: 1.5) {
//            self.viewRcpa.isHidden = true
//        }
//    }
//    
//    
//    @IBAction func closeAdditionalCallAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 1.5) {
//            self.viewAdditionalCallSampleInput.isHidden = true
//        }
//    }
//    
//    @IBAction func saveAdditionalCalls(_ sender: UIButton) {
//        
//        self.additionalCallSelectedTableView.reloadData()
//        UIView.animate(withDuration: 1.5) {
//            self.viewAdditionalCallSampleInput.isHidden = true
//        }
//    }
//    
//    @IBAction func closeSelectionViewAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 1.5) {
//            self.viewSelectionList.isHidden = true
//        }
//    }
//    
//    @IBAction func closeSingleSelectionViewAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 1.5) {
//            self.viewSingleSelection.isHidden = true
//        }
//    }
//    
//    
//    @IBAction func rcpaSaveAction(_ sender: UIButton) {
//        
////        if self.rcpaCallListViewModel.numberOfCompetitorRows() == 0 {
////            print("Add Competitor")
////            return
////        }
//        
//        UIView.animate(withDuration: 1.5) {
//            self.viewRcpa.isHidden = true
//        }
//        self.rcpaAddedListTableView.reloadData()
//    }
//    
//    @IBAction func submitAction(_ sender: UIButton) {
//   
//        let appsetup = AppDefaults.shared.getAppSetUp()
//        
//        let urlStr = appMainURL + "save/dcr"
//        
//        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
//        
//        
//   //     let timesLine = ["sTm" : "" , "eTm" : ""]
//        
//        let slides : [String : Any] = ["Slide" : "", "SlidePath" : "", "SlideRemarks" : "", "SlideType" : "", "SlideRating" : "", "Times" : "times"]
//        
////let times = ["eTm" : "", "sTm" : ""]
//        
//    //    let product : [String : Any] = ["Code" : "" , "Name" : "", "Group" : "", "ProdFeedbk" : "", "Rating" : "", "Timesline" : "timesLine", "Appver" : "", "Mod" : "", "SmpQty" : "", "RxQty" : "" , "prdfeed" : "", "Type" : "", "StockistName" : "", "StockistCode" : "", "Slides" : "slides"]
//        
//        
//        
//        var productData = [[String : Any]]()
//        var inputData = [[String : Any]]()
//        var jointWorkData = [[String : Any]]()
//        var additionalCallData = [[String : Any]]()
//        var rcpaData = [[String : Any]]()
//        
//        let productValue = self.productSelectedListViewModel.productData()
//        let inputValue = self.inputSelectedListViewModel.inputData()
//        let jointWorkValue = self.jointWorkSelectedListViewModel.getJointWorkData()
//        let additionalCallValue = self.additionalCallListViewModel.getAdditionalCallData()
//        
//        let rcpaValue = self.rcpaAddedListViewModel.getRcpas()
//        
//        for product in productValue {
//            let product : [String : Any] = ["Code" : product.code , "Name" : product.name, "Group" : "", "ProdFeedbk" : "", "Rating" : "", "Timesline" : "timesLine", "Appver" : "", "Mod" : "", "SmpQty" : product.sampleCount, "RxQty" : product.rxCount , "prdfeed" : "", "Type" : "", "StockistName" : "", "StockistCode" : "", "Slides" : slides]
//            productData.append(product)
//        }
//        
//        for input in inputValue{
//            let input = ["Code" : input.code , "Name" : input.name, "IQty" : input.inputCount]
//            inputData.append(input)
//        }
//        
//        for jointWork in jointWorkValue{
//            let jointWork = ["Code" : jointWork.code , "Name" : jointWork.name]
//            jointWorkData.append(jointWork)
//        }
//        
//        for call in additionalCallValue {
//            
//            let products = call.productSelectedListViewModel.productData()
//            
//            let inputs = call.inputSelectedListViewModel.inputData()
//            
//            var callProductData = [[String : Any]]()
//            var callInputData = [[String : Any]]()
//            
//            for input in inputs{
//                let input = ["Code" : input.code , "Name" : input.name, "IQty" : input.inputCount]
//                callInputData.append(input)
//            }
//            
//            for product in products {
//                let product : [String : Any] = ["Code" : product.code , "Name" : product.name,"SmpQty" : product.sampleCount]
//                callProductData.append(product)
//            }
//            
//            let adcuss : [String : Any] = ["Code" : call.docCode, "Name" : call.docName,"town_code" : call.docTownCode ,"town_name" : call.docTownName, "Products" : callProductData , "Inputs" : callInputData]
//            additionalCallData.append(adcuss)
//        }
//        
//        for rcpa in rcpaValue {
//            
//            let rcpaChemist = ["Name" : rcpa.chemistName , "Code" : rcpa.chemistCode]
//            
//            for i in 0..<rcpa.rcpaChemist.products.count{
//                
//                var competitorData = [[String : Any]]()
//                var productCode : String = ""
//                var productName : String = ""
//                
//                for j in 0..<rcpa.rcpaChemist.products[i].rcpas.count {
//                    productCode = rcpa.rcpaChemist.products[i].rcpas[j].product?.code ?? ""
//                    productName = rcpa.rcpaChemist.products[i].rcpas[j].product?.name ?? ""
//                    
//                    let competitors  = [ "CPQty" : rcpa.rcpaChemist.products[i].rcpas[j].competitorQty,
//                                         "CPRate" : rcpa.rcpaChemist.products[i].rcpas[j].competitorRate,
//                                         "CPValue" : rcpa.rcpaChemist.products[i].rcpas[j].competitorTotal,
//                                         "CompCode" : rcpa.rcpaChemist.products[i].rcpas[j].competitorCompanyCode,
//                                         "CompName" : rcpa.rcpaChemist.products[i].rcpas[j].competitorCompanyName,
//                                         "CompPCode" : rcpa.rcpaChemist.products[i].rcpas[j].competitorBrandCode,
//                                         "CompPName" : rcpa.rcpaChemist.products[i].rcpas[j].competitorBrandName,
//                                         "Chemname" : rcpa.chemistName,
//                                         "Chemcode" : rcpa.chemistCode,
//                                         "CPRemarks" : rcpa.rcpaChemist.products[i].rcpas[j].remarks
//                    ]
//                    
//                    competitorData.append(competitors)
//                }
//                
//                let rcpa : [String : Any] = [ "Chemists" : [rcpaChemist],
//                             "OPCode" : productCode, //rcpa.rcpaChemist.products[i].product.code ?? "",
//                             "OPName" : productName, // rcpa.rcpaChemist.products[i].product.name ?? "",
//                             "OPQty" : rcpa.rcpaChemist.products[i].quantity,
//                             "OPRate" : rcpa.rcpaChemist.products[i].rate,
//                             "OPValue" : rcpa.rcpaChemist.products[i].total,
//                             "Competitors" : competitorData
//                ]
//                
//                rcpaData.append(rcpa)
//                
//            }
//             // rcpaData.append(rcpa)
//        }
//        print(rcpaData)
//        
//        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")
//        
//        var cusType : String = "" 
//        
//        switch dcrCall.type {
//            case .doctor:
//                cusType = "1"
//            case .chemist:
//                cusType = "2"
//            case .stockist:
//                cusType = "3"
//            case .unlistedDoctor:
//                cusType = "4"
//            case .hospital:
//                cusType = "5"
//            case .cip:
//                cusType = "6"
//        }
//        
//        
//        //      {"JointWork":[{"Code":"MGR1454","Name":"DEMO MD"}],"Inputs":[{"Code":"171","Name":"BELT","IQty":"4"}],"Products":[{"Code":"767","Name":"Paracetamal sale","Group":"0","ProdFeedbk":"","Rating":"","Timesline":{"sTm":"2023-10-12 00:00:00","eTm":"2023-10-12 00:00:00"},"Appver":"V2.0.10","Mod":"Android-Edet","SmpQty":"00","RxQty":"2","prdfeed":"","Type":"D","StockistName":"Stockist","StockistCode":"StockistCode","Slides":[]},{"Code":"768","Name":"Alegra sample","Group":"0","ProdFeedbk":"","Rating":"","Timesline":{"sTm":"2023-10-12 00:00:00","eTm":"2023-10-12 00:00:00"},"Appver":"V2.0.10","Mod":"Android-Edet","SmpQty":"3","RxQty":"00","prdfeed":"","Type":"D","StockistName":"Stockist","StockistCode":"StockistCode","Slides":[]}],"AdCuss":[],"CateCode":"1","CusType":"1","CustCode":"1384629","CustName":"CHIRIS","CustCategory":"A","Entry_location":"13.0299965:80.2414513","address":"No 4, Pasumpon Muthuramalinga Thevar Rd, Nandanam Extension, Nandanam, Chennai, Tamil Nadu 600035, India","sfcode":"MR5115","Rsf":"MR5115","sf_type":"1","Designation":"MR","state_code":"24","subdivision_code":"35,","division_code":"1","AppUserSF":"MR5115","SFName":"HELAN","SpecCode":"3","mappedProds":"","mode":"0","Appver":"V2.0.10","Mod":"Android-Edet","WT_code":"6","WTName":"Field Work","FWFlg":"F","town_code":"129569","town_name":"ANNANAGAR","ModTime":"2023-10-12 12:09:10","ReqDt":"2023-10-12 12:09:10","vstTime":"2023-10-12 12:09:10","Remarks":"test","amc":"","RCPAEntry":[{"Chemists":[{"Name":"AAA PHARMA","Code":"950840"}],"OPCode":"767","OPName":"Paracetamal sale","OPQty":"2","OPRate":"50.0","OPValue":"100.0","Competitors":[{"CPQty":"3","CPRate":"50.0","CPValue":"150.0","CompCode":"19176","CompName":"APPOLO","CompPCode":"3596","CompPName":"Para Feroon","Chemname":"AAA PHARMA,","Chemcode":"950840,","CPRemarks":"gud"},{"CPQty":"4","CPRate":"50.0","CPValue":"200.0","CompCode":"19221","CompName":"MOUNT","CompPCode":"3596","CompPName":"Para Helan","Chemname":"AAA PHARMA,","Chemcode":"950840,","CPRemarks":"gud"}]}],"ActivityDCR":[],"sample_validation":"0","input_validation":"0","sign_path":"","filepath":"","EventCapture":"false","EventImageName":"","SignImageName":"","DCSUPOB":"5","Drcallfeedbackcode":""}
//
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        var params = [String : Any]()
//        params["tableName"] = "postDCRdata"
//        params["JointWork"] = jointWorkData
//        params["Inputs"] = inputData
//        params["Products"] = productData
//        params["AdCuss"] = additionalCallData
//        params["RCPAEntry"] = rcpaData
//        params["CateCode"] = dcrCall.cateCode
//        params["CusType"] = cusType
//        params["CustCode"] = dcrCall.code
//        params["CustName"] = dcrCall.name
//        params["Entry_location"] = "0.0:0.0"
//        params["address"] = "Address not Found"
//        params["sfcode"] = appsetup.sfCode ?? ""
//        params["Rsf"] = appsetup.sfCode ?? ""
//        params["sf_type"] = "\(appsetup.sfType ?? 0)"
//        params["Designation"] = appsetup.dsName ?? ""
//        params["state_code"] = appsetup.stateCode ?? ""
//        params["subdivision_code"] = appsetup.subDivisionCode ?? ""
//        params["division_code"] = divisionCode
//        params["AppUserSF"] = appsetup.sfCode ?? ""
//        params["SFName"] = appsetup.sfName ?? ""
//        params["SpecCode"] = dcrCall.specialityCode
//        params["mappedProds"] = ""
//        params["mode"]  = "0"
//        params["Appver"] = "iEdet.1.1"
//        params["Mod"] = "ios-Edet-New"
//        params["WT_code"] = "2748"
//        params["WTName"] = "Field Work"
//        params["FWFlg"] = "F"
//        params["town_code"] = dcrCall.townCode
//        params["town_name"] = dcrCall.townName
//        params["ModTime"] = date
//        params["ReqDt"] = date
//        params["vstTime"] = date
//        params["Remarks"] = self.txtRemarks.textColor == .lightGray ? "" : self.txtRemarks.text ?? ""
//        params["amc"] = ""
//        params["sign_path"] = ""
//        params["SignImageName"] = ""
//        params["filepath"] = ""
//        params["EventCapture"] = ""
//        params["EventImageName"] = ""
//        params["DCSUPOB"] = self.txtPob.text ?? ""
//        params["Drcallfeedbackcode"] = (self.selectedFeedback == nil) ? "" : (self.selectedFeedback.code ?? "") ?? ""
//        params["sample_validation"] = "0"
//        params["input_validation"] = "0"
//        
//        
//        
//        print(urlStr)
//        print(params)
//        
//        let param = ["data" : params.toString()]
//        
//        print(param)
//        
//        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
//        var toSendData = [String : Any]()
//      
//        toSendData["data"] = jsonDatum
//        
//        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
//            Shared.instance.showLoaderInWindow()
//            postDCTdata(toSendData, paramData: params) { result in
//                switch result {
//                case .success(let response):
//                    if response.msg == "Call Already Exists" {
//                        self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: params)
//                        self.toCreateToast(response.msg ?? "Call Already Exists")
//                    } else {
//                        self.saveCallsToDB(issussess: true, appsetup: appsetup, cusType: cusType, param: params)
//                    }
//                    Shared.instance.removeLoaderInWindow()
//                case .failure(let error):
//                    self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: params)
//                    Shared.instance.removeLoaderInWindow()
//                    self.toCreateToast("\(error)")
//                    print(error)
//                    Shared.instance.removeLoaderInWindow()
//                }
//                self.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
//            }
//        } else {
//            self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: params)
//           // Shared.instance.removeLoaderInWindow()
//            self.toCreateToast("Unable to connect to internet")
//            self.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
//        }
//        
//
//        
//    }
//    
//    func postDCTdata(_ param: [String: Any], paramData: JSON, _ completion : @escaping (Result<DCRCallesponseModel, UserStatisticsError>) -> Void)  {
//       
//        userStatisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
//            completion(result)
//        }
//    }
//    
//    
//    func saveParamoutboxParamtoDefaults(param: JSON) {
//        
//        var callsByDay: [String: [[String: Any]]] = [:]
//        
//        let paramdate = param["vstTime"]
//        var dayString = String()
//        
//        // Create a DateFormatter to parse the vstTime
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        if let date = dateFormatter.date(from: paramdate as! String) {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//             dayString = dateFormatter.string(from: date)
//            
//            // Check if the day key exists in the dictionary
//            if callsByDay[dayString] == nil {
//                callsByDay[dayString] = [param]
//            } else {
//                callsByDay[dayString]?.append(param)
//            }
//        }
//        
//        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: callsByDay)
//        
////        var jsonDatum = Data()
////
////        do {
////            let jsonData = try JSONSerialization.data(withJSONObject: callsByDay, options: [])
////            jsonDatum = jsonData
////            // Convert JSON data to a string
////            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
////                print(tempjsonString)
////
////            }
////        } catch {
////            print("Error converting parameter to JSON: \(error)")
////        }
//        
//        
//        // LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
//        
//        let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.outboxParams)
//        if paramData.isEmpty {
//            LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
//            return
//        }
//        var localParamArr = [String: [[String: Any]]]()
//      //  var paramArr = [String: [[String: Any]]]()
//        do {
//            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
//            dump(localParamArr)
//        } catch {
//            self.toCreateToast("unable to retrive")
//        }
//        
//        
//        var matchFound = Bool()
//        for (_, calls) in localParamArr {
//            for call in calls {
//                // if let vstTime = call["vstTime"] as? String,
//                if  let custCode = call["CustCode"] as? String,
//                    //   vstTime == param["vstTime"] as? String,
//                    custCode == param["CustCode"] as? String {
//                    // Match found, do something with the matching call
//                    matchFound = true
//                    print("Match found for CustCode: \(custCode)")
//                    // vstTime: \(vstTime),
//                    
//                }
//            }
//        }
//        
//        if !matchFound {
//            // Check if the day key exists in the dictionary
//            if localParamArr[dayString] == nil {
//                localParamArr[dayString] = [param]
//            } else {
//                localParamArr[dayString]?.append(param)
//            }
//            let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
//          //  var jsonDatum = Data()
//            
//           
//            
////            do {
////                let jsonData = try JSONSerialization.data(withJSONObject: callsByDay, options: [])
////                jsonDatum = jsonData
////                // Convert JSON data to a string
////                if let tempjsonString = String(data: jsonData, encoding: .utf8) {
////                    print(tempjsonString)
////
////                }
////            } catch {
////                print("Error converting parameter to JSON: \(error)")
////            }
//            
//            LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
//        }
//    }
//    
//    func saveCallsToDB(issussess: Bool, appsetup: AppSetUp, cusType : String, param: [String: Any]) {
//        var dbparam = [String: Any]()
//        dbparam["CustCode"] = dcrCall.code
//        dbparam["CustType"] = cusType
//        dbparam["FW_Indicator"] = "F"
//        dbparam["Dcr_dt"] = Date().toString(format: "yyyy-MM-dd")
//        dbparam["month_name"] = Date().toString(format: "MMMM")
//        dbparam["Mnth"] = Date().toString(format: "MM")
//        dbparam["Yr"] =  Date().toString(format: "YYYY")
//        dbparam["CustName"] = dcrCall.name
//        dbparam["town_code"] = ""
//        dbparam["town_name"] = ""
//        dbparam["Dcr_flag"] = ""
//        dbparam["SF_Code"] = appsetup.sfCode
//        dbparam["Trans_SlNo"] = ""
//        dbparam["AMSLNo"] = ""
//        dbparam["isDataSentToAPI"] = issussess == true ?  "1" : "0"
//        var dbparamArr = [[String: Any]]()
//        dbparamArr.append(dbparam)
//        let masterData = DBManager.shared.getMasterData()
//        var HomeDataSetupArray = [HomeData]()
//        for (index,homeData) in dbparamArr.enumerated() {
//
//             let identifier = homeData["CustCode"] as? String // Assuming "identifier" is a unique identifier in HomeData
//             let existingHomeData = masterData.homeData?.first { ($0 as! HomeData).custCode == identifier }
//
//            if existingHomeData == nil {
//                let contextNew = DBManager.shared.managedContext()
//                let HomeDataEntity = NSEntityDescription.entity(forEntityName: "HomeData", in: contextNew)
//                let HomeDataSetupItem = HomeData(entity: HomeDataEntity!, insertInto: contextNew)
//                HomeDataSetupItem.setValues(fromDictionary: homeData)
//                HomeDataSetupItem.index = Int16(index)
//                HomeDataSetupArray.append(HomeDataSetupItem)
//            }
//        }
//
//        HomeDataSetupArray.forEach{ (type) in
//            masterData.addToHomeData(type)
//        }
//        DBManager.shared.saveContext()
//        
//        if !issussess {
//            saveParamoutboxParamtoDefaults(param: param)
//        }
//    }
//    
//    private func popToBack<T>(_ VC : T) {
//        let mainVC = navigationController?.viewControllers.first{$0 is T}
//        
//        if let vc = mainVC {
//            self.navigationController?.popToViewController(vc, animated: true)
//        }
//    }
//    
//    
//    @IBAction func cancelAction(_ sender: UIButton) {
//      self.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
//    }
//    
//    
//    @IBAction func addRcpaAction(_ sender: UIButton) {
//        
//        self.selectedChemistRcpa = nil
//        
//        self.selectedProductRcpa = nil
//        
//        self.txtRcpaQty.text = ""
//        
//        self.txtRcpaTotal.text = ""
//        
//        self.txtRcpaTotal.text = ""
//        
//        self.lblChemistName.text = ""
//        self.lblProductName.text = ""
//        
//        self.rcpaCallListViewModel.removeAll()
//        
//        self.rcpaCompetitorTableView.reloadData()
//        
//        self.btnRcpaChemist.isHidden = false
//        self.btnRcpaProduct.isHidden = false
//        
//        UIView.animate(withDuration: 1.5) {
//            self.viewRcpa.isHidden = false
//        }
//    }
//    
//    @IBAction func addJointWork(_ sender: UIButton) {
//        
//        UIView.animate(withDuration: 1.5) {
//            self.viewSelectionList.isHidden = false
//        }
//        
//        self.selectionTableView.reloadData()
//        
////        let jointWorkVC = UIStoryboard.multiSelectionVC
////        jointWorkVC.modalPresentationStyle = .custom
////        jointWorkVC.transitioningDelegate = self
////        self.navigationController?.pushViewController(jointWorkVC, animated: true)
//        
//    }
//    
//    
//    @IBAction func eventCaptureAction(_ sender: UIButton) {
//        
//        let pickerVC = UIImagePickerController()
//        pickerVC.sourceType = .camera
//        pickerVC.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        
//        self.present(pickerVC, animated: true)
//        
//    }
//    
//    
//    @IBAction func chemistRcpaAction(_ sender: UIButton) {
//        
//        if self.rcpaCallListViewModel.numberOfCompetitorRows() != 0 {
//            return
//        }
//        let chemists = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
//        
//        let selectionVC = UIStoryboard.singleSelectionVC
//        selectionVC.selectionData = chemists
//        selectionVC.didSelectCompletion { selectedIndex in
//            self.lblChemistName.text = chemists[selectedIndex].name
//            
//            self.selectedChemistRcpa = chemists[selectedIndex]
//        }
//        self.present(selectionVC, animated: true)
//    }
//    
//    
//    @IBAction func productRcpaAction(_ sender: UIButton) {
//        
//        let products = DBManager.shared.getProduct()
//        
//        
//        let selectionVC = UIStoryboard.singleSelectionVC
//        selectionVC.selectionData = products
//        selectionVC.didSelectCompletion { selectedIndex in
//            self.lblProductName.text = products[selectedIndex].name
//            
//            self.selectedProductRcpa = products[selectedIndex]
//            
//            self.txtRcpaQty.text = ""
//            self.txtRcpaRate.text = ""
//            self.txtRcpaTotal.text = ""
//            
//            print(products[selectedIndex])
//        }
//        self.present(selectionVC, animated: true)
//    }
//    
//    
//    @IBAction func rcpaAddCompetitorAction(_ sender: UIButton) {
//        
//        
//        if self.rcpaCallListViewModel.numberOfCompetitorRows() != 0 {
//            self.btnRcpaChemist.isHidden = true
//        }
//        
//        if self.selectedChemistRcpa == nil {
//            return
//        }
//        
//        if self.selectedProductRcpa == nil {
//            return
//        }
//        
//        if self.txtRcpaQty.text! == "" {
//            return
//        }
//        
//        let code = self.selectedChemistRcpa.code ?? ""
//        
//        if self.rcpaAddedListViewModel.isChemistAdded(code ?? "") {
//            
//            let productCode = self.selectedProductRcpa.code ?? ""
//            
//            let index = self.rcpaAddedListViewModel.chemistAtSection(code ?? "", productCode: productCode ?? "")
//            
//            print(index)
//            
//            if index.productIndex == -1 {
//                self.rcpaAddedListViewModel.addRcpaProductAtSection(index.chemistIndex, product: rcpaProduct(product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", isViewTapped: false))
//                
//                
//                let ProductIndex = self.rcpaAddedListViewModel.chemistAtSection(code ?? "", productCode: productCode ?? "")
//                
//                self.rcpaAddedListViewModel.addRcpaCompetitorProductAtProduct(index.chemistIndex, row: ProductIndex.productIndex, product: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "", competitorCompanyCode: "", competitorBrandName: "", competitorBrandCode: "", competitorRate: "", competitorTotal: "", competitorQty: "",remarks: ""))
//                
//            }else {
//                self.rcpaAddedListViewModel.addRcpaCompetitorProductAtProduct(index.chemistIndex, row: index.productIndex, product: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "", competitorCompanyCode: "", competitorBrandName: "",competitorBrandCode: "", competitorRate: "", competitorTotal: "", competitorQty: "",remarks: ""))
//                
//                
//                    let value = self.rcpaAddedListViewModel.fetchAtSection(index.chemistIndex)
//                
//                    print(value.rcpaChemist.products[index.productIndex].rcpas.count)
//            }
//        }else {
//            self.rcpaAddedListViewModel.addRcpaChemist(RcpaAddedViewModel(rcpaChemist: RcpaChemist(chemist: self.selectedChemistRcpa)))
//            
//            let productCode = self.selectedProductRcpa.code ?? ""
//            
//            let index = self.rcpaAddedListViewModel.chemistAtSection(code ?? "", productCode: productCode ?? "")
//            
//            if index.productIndex == -1 {
//                self.rcpaAddedListViewModel.addRcpaProductAtSection(index.chemistIndex, product: rcpaProduct(product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", isViewTapped: false))
//                
//                let ProductIndex = self.rcpaAddedListViewModel.chemistAtSection(code ?? "", productCode: productCode ?? "")
//                
//                self.rcpaAddedListViewModel.addRcpaCompetitorProductAtProduct(index.chemistIndex, row: ProductIndex.productIndex, product: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "", competitorCompanyCode: "", competitorBrandName: "", competitorBrandCode: "", competitorRate: "", competitorTotal: "", competitorQty: "",remarks: ""))
//            }else{
//                self.rcpaAddedListViewModel.addRcpaCompetitorProductAtProduct(index.chemistIndex, row: index.productIndex, product: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "", competitorCompanyCode: "", competitorBrandName: "", competitorBrandCode: "", competitorRate: "", competitorTotal: "", competitorQty: "",remarks: ""))
//            }
//            
//            
////            self.rcpaAddedListViewModel.addRcpaProductAtSection(0, product: rcpaProduct(product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? ""))
////            
////            self.rcpaAddedListViewModel.addRcpaCompetitorProductAtProduct(0, row: 0, product: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "DOLO", competitorCompanyCode: "", competitorBrandName: "", competitorBrandCode: "DOLO", competitorRate: "5", competitorTotal: "50", competitorQty: "10",remarks: ""))
//            
//        }
//       
//        self.rcpaCallListViewModel.addRcpaCompetitor(RcpaViewModel(rcpaHeaderData: RcpaHeaderData(chemist: self.selectedChemistRcpa, product: self.selectedProductRcpa, quantity: self.txtRcpaQty.text ?? "", total: self.txtRcpaTotal.text ?? "", rate: self.txtRcpaRate.text ?? "", competitorCompanyName: "", competitorCompanyCode: "", competitorBrandName: "", competitorBrandCode: "", competitorRate: "", competitorTotal: "", competitorQty: "",remarks: "")))
//
//        self.rcpaCompetitorTableView.reloadData()
//        
//    }
//    
//    
//    @IBAction func addAdditionalCallSampleInput(_ sender: UIButton) {
//        
//        switch self.SampleInputSegmentControl.selectedSegmentIndex{
//        case 0:
//            self.additionalCallListViewModel.addProductAtIndex(self.selectedDoctorIndex, vm: ProductViewModel(product: ProductData(product: nil, isDetailed: false, sampleCount: "", rxCount:"", rcpaCount: "", availableCount: "", totalCount: "")))
//            self.additionalCallSampleInputTableView.reloadData()
//            break
//        case 1:
//            self.additionalCallListViewModel.addInputAtIndex(self.selectedDoctorIndex, vm: InputViewModel(input: InputData(input: nil, availableCount: "", inputCount: "")))
//            self.additionalCallSampleInputTableView.reloadData()
//            break
//        default:
//            break
//        }
//    }
//    
//    
//    public func getStatus(json:Any?, isShowToast:Bool = true) -> (isOk:Bool, info:[String:Any]) {
//        guard let info:[String:Any] = json as? [String:Any] else {
//            return (false, [:])
//        }
//        var status = false
//        if let statusBool = info["success"] as? Bool {
//            status = statusBool
//        }
//        if status {
//            if let errormsg = info["msg"] as? String{
//                if isShowToast {
//                   // let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                    ConfigVC().showToast(controller: self, message: errormsg, seconds: 2)
//                    
//                   // appdelegate.window?.rootViewController?.showToast(with: errormsg)
//                }
//            }else if let errormsg = info["Msg"] as? String{
//                if isShowToast {
//                   // let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                    
//                    ConfigVC().showToast(controller: self, message: errormsg, seconds: 2)
//                   // appdelegate.window?.rootViewController?.showToast(with: errormsg)
//                }
//            }
//            return (true, info)
//        }
//        else {
//            
//            if let errormsg = info["msg"] as? String{
//                if isShowToast {
////                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
////                    appdelegate.window?.rootViewController?.showToast(with: errormsg)
//                    
//                    ConfigVC().showToast(controller: self, message: errormsg, seconds: 2)
//                    //showAlert(title: "", message: errormsg, style: .alert, buttons: ["OK"], controller: nil, completion: nil)
//                }
//            }else if let errormsg = info["Msg"] as? String{
//                if isShowToast {
////                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
////                    appdelegate.window?.rootViewController?.showToast(with: errormsg)
//                    
//                    ConfigVC().showToast(controller: self, message: errormsg, seconds: 2)
//                    //showAlert(title: "", message: errormsg, style: .alert, buttons: ["OK"], controller: nil, completion: nil)
//                }
//            }
//            return (false, info)
//        }
//    }
//}
//
//
//extension ProductVC : tableViewProtocols {
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let appsetup = AppDefaults.shared.getAppSetUp()
//        switch tableView {
//        case self.ProductTableView :
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameWithSampleTableViewCell", for: indexPath) as! ProductNameWithSampleTableViewCell
//            cell.product =  self.productSelectedListViewModel.fetchProductData(indexPath.row, searchText: self.searchText, type: dcrCall.type,selectedDoctorCode: dcrCall.code)
//            cell.btnSelected.addTarget(self, action: #selector(productSelectionAction(_:)), for: .touchUpInside)
//            return cell
//            
//        case self.productSampleTableView :
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSampleTableViewCell", for: indexPath) as! ProductSampleTableViewCell
//            cell.productSample = self.productSelectedListViewModel.fetchDataAtIndex(indexPath.row)
//            cell.btnDelete.addTarget(self, action: #selector(deleteProduct(_:)), for: .touchUpInside)
//            cell.btnDelete.tag = indexPath.row
//            cell.txtRxQty.tag = indexPath.row
//            cell.txtRcpaQty.tag = indexPath.row
//            cell.txtSampleQty.tag = indexPath.row
//            cell.txtRxQty.addTarget(self, action: #selector(updateProductRxQty(_:)), for: .editingChanged)
//            cell.txtRcpaQty.addTarget(self, action: #selector(updateProductRcpaQty(_:)), for: .editingChanged)
//            cell.txtSampleQty.addTarget(self, action: #selector(updateProductSampleQty(_:)), for: .editingChanged)
//            cell.btnDeviation.addTarget(self, action: #selector(productDetailedSelection(_:)), for: .touchUpInside)
//            cell.txtSampleQty.delegate = self
//            cell.txtRxQty.delegate = self
//            cell.txtRcpaQty.delegate = self
//            if appsetup.sampleValidation != 1 {
//              //  cell.viewStock.isHidden = true
//            }
//            return cell
//        case self.inputListTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell", for: indexPath) as! ProductNameTableViewCell
//            cell.input = self.inputSelectedListViewModel.fetchInputData(indexPath.row, searchText: self.searchText)
//            cell.btnSelected.addTarget(self, action: #selector(inputSelectionAction(_:)), for: .touchUpInside)
//            return cell
//        case self.inputSampleTableView:
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InputSampleTableViewCell", for: indexPath) as! InputSampleTableViewCell
//            cell.inputSample = self.inputSelectedListViewModel.fetchDataAtIndex(indexPath.row)
//            cell.btnDelete.addTarget(self, action: #selector(deleteInput(_:)), for: .touchUpInside)
//            cell.txtSampleQty.addTarget(self, action: #selector(updateInputSampleQty(_ :)), for: .editingChanged)
//            cell.txtSampleQty.delegate = self
//            if appsetup.inputValidation != 1 {
//               // cell.viewSampleQty.isHidden = true
//            }
//            
//            return cell
//        case self.jointWorkTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "JointWorkTableViewCell", for: indexPath) as! JointWorkTableViewCell
//            cell.jointWorkSample = self.jointWorkSelectedListViewModel.fetchDataAtIndex(indexPath.row)
//            cell.btnDelete.addTarget(self, action: #selector(deleteJointWork(_:)), for: .touchUpInside)
//            return cell
//        case self.additionalCallListTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell", for: indexPath) as! ProductNameTableViewCell
//            cell.additionalCall = self.additionalCallListViewModel.fetchAdditionalCallData(indexPath.row, searchText: self.searchText)
//            cell.btnSelected.addTarget(self, action: #selector(additionalCallSelectionAction(_:)), for: .touchUpInside)
//            return cell
//        case self.additionalCallSelectedTableView :
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalCallSampleInputTableViewCell", for: indexPath) as! AdditionalCallSampleInputTableViewCell
//            cell.additionalCall = self.additionalCallListViewModel.fetchDataAtIndex(indexPath.row)
//            cell.btnAddProductInput.addTarget(self, action: #selector(addProductInputAction(_:)), for: .touchUpInside)
//            cell.btnDelete.addTarget(self, action: #selector(deleteAdditionalCall(_:)), for: .touchUpInside)
//            cell.btnEdit.addTarget(self, action: #selector(editAdditionalCallSampleInput(_:)), for: .touchUpInside)
//            cell.btnDownArrow.addTarget(self, action: #selector(additionalCallDownArrowAction(_:)), for: .touchUpInside)
//            cell.btnEdit.tag = indexPath.row
//            cell.btnAddProductInput.tag = indexPath.row
//            if self.additionalCallListViewModel.numberOfProductsInSection(indexPath.row) != 0 || self.additionalCallListViewModel.numberOfInputsInSection(indexPath.row) != 0 {
//                cell.viewProductInputButton.isHidden = true
//            }else {
//                cell.viewProductInputButton.isHidden = false
//            }
//            cell.btnDelete.tag = indexPath.row
//            return cell
//            
//        case self.additionalCallSampleInputTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalCallSampleEntryTableViewCell", for: indexPath) as! AdditionalCallSampleEntryTableViewCell
//            switch self.SampleInputSegmentControl.selectedSegmentIndex {
//                case 0:
//                    cell.product = self.additionalCallListViewModel.fetchProductAtIndex(self.selectedDoctorIndex, index: indexPath.row)
//                case 1:
//                    cell.input = self.additionalCallListViewModel.fetchInputAtIndex(self.selectedDoctorIndex, index: indexPath.row)
//                default:
//                    break
//            }
//            cell.btnProduct.addTarget(self, action: #selector(additionalCallSampleInputSelection(_:)), for: .touchUpInside)
//            cell.btnDelete.addTarget(self, action: #selector(deleteAdditionalCallSampleInput(_:)), for: .touchUpInside)
//            cell.txtSampleStock.addTarget(self, action: #selector(updateSampleInputQty(_:)), for: .editingChanged)
//            return cell
//        case self.rcpaCompetitorTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RcpaTableViewCell", for: indexPath) as! RcpaTableViewCell
//            cell.btnCompetitorCompany.addTarget(self, action: #selector(rcpaCompetitorCompany(_:)), for: .touchUpInside)
//            cell.btnCompetitorBrand.addTarget(self, action: #selector(rcpaCompetitorBrand(_:)), for: .touchUpInside)
//            cell.btnDelete.addTarget(self, action: #selector(deleteRcpa(_:)), for: .touchUpInside)
//            cell.txtRcpaQty.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorQty
//            cell.txtRcpaRate.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorRate
//            cell.txtRcpaTotal.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorTotal
//            cell.lblCompetitorCompany.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyName
//            cell.lblCompetitorBrand.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandName
//            cell.lblProduct.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).productName
//            cell.txtViewRemarks.text = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).rcpaHeaderData.remarks
//            cell.txtRcpaQty.addTarget(self, action: #selector(rcpaCompetitorQtyEdit(_:)), for: .editingChanged)
//            cell.txtRcpaRate.addTarget(self, action: #selector(rcpaCompetitorRateEdit(_:)), for: .editingChanged)
//            cell.txtRcpaTotal.addTarget(self, action: #selector(rcpaCompetitorTotalEdit(_:)), for: .editingChanged)
//            cell.txtViewRemarks.delegate = self
//            cell.txtViewRemarks.tag = indexPath.row
//            return cell
//        case self.rcpaAddedListTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RcpaAddedListTableViewCell", for: indexPath) as! RcpaAddedListTableViewCell
//            cell.rcpaProduct = self.rcpaAddedListViewModel.fetchAtRowIndex(indexPath.section, row: indexPath.row)
//          //  cell.btnEdit.addTarget(self, action: #selector(editRcpaProduct(_:)), for: .touchUpInside)
//            cell.btnDelete.addTarget(self, action: #selector(deleteRcpaProduct(_:)), for: .touchUpInside)
//          // cell.btnPlus.addTarget(self, action: #selector(plusRcpaProduct(_:)), for: .touchUpInside)
//            return cell
//        case self.eventCaptureTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCaptureCell", for: indexPath) as! EventCaptureCell
//            cell.eventCapture = self.eventCaptureListViewModel.fetchAtIndex(indexPath.row)
//            cell.btnDelete.addTarget(self, action: #selector(deleteEventCapture(_:)), for: .touchUpInside)
//            cell.txtName.addTarget(self, action: #selector(imageTitleEdit(_:)), for: .editingChanged)
//            cell.txtName.tag = indexPath.row
//            cell.btnDelete.tag =  indexPath.row
//            cell.txtDescription.tag = indexPath.row
//            cell.txtDescription.delegate = self
//            return cell
//        case self.detailledListTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell",for: indexPath) as! ProductRatingTableViewCell
//            cell.selectionStyle = .none
//            return cell
//        case self.selectionTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell",for: indexPath) as! ProductNameTableViewCell
//            cell.jointWork = self.jointWorkSelectedListViewModel.fetchJointWorkData(indexPath.row)
//            cell.btnSelected.addTarget(self, action: #selector(jointworkSelectionAction(_:)), for: .touchUpInside)
//            return cell
//        case self.singleSelectionTableView:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionTableViewCell",for: indexPath) as! SingleSelectionTableViewCell
//            cell.lblName.text = self.feedback[indexPath.row].name
//            return cell
//        default :
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell",for: indexPath) as! ProductNameTableViewCell
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView {
//        case self.ProductTableView :
//            return self.productSelectedListViewModel.numberOfProducts(searchText: self.searchText)
//        case self.productSampleTableView :
//            return self.productSelectedListViewModel.numberOfRows()
//        case self.inputListTableView:
//            return self.inputSelectedListViewModel.numberOfInputs(searchText: self.searchText)
//        case self.inputSampleTableView:
//            return self.inputSelectedListViewModel.numberOfRows()
//        case self.jointWorkTableView:
//            return self.jointWorkSelectedListViewModel.numberofSelectedRows()
//        case self.additionalCallListTableView:
//            return self.additionalCallListViewModel.numberofAdditionalCalls(searchText: self.searchText)
//        case self.additionalCallSelectedTableView:
//            return self.additionalCallListViewModel.numberOfSelectedRows()
//        case self.additionalCallSampleInputTableView:
//            switch self.SampleInputSegmentControl.selectedSegmentIndex {
//                case 0:
//                    return self.additionalCallListViewModel.numberOfProductsInSection(self.selectedDoctorIndex)
//                case 1:
//                    return self.additionalCallListViewModel.numberOfInputsInSection(self.selectedDoctorIndex)
//                default:
//                    return 0
//            }
//        case self.rcpaCompetitorTableView:
//            return self.rcpaCallListViewModel.numberOfCompetitorRows()
//        case self.rcpaAddedListTableView:
//            return self.rcpaAddedListViewModel.numberofRowsInSection(section)
//        case self.eventCaptureTableView :
//            return self.eventCaptureListViewModel.numberOfRows()
//        case self.selectionTableView:
//            return self.jointWorkSelectedListViewModel.numbersOfJointWorks()
//        case self.singleSelectionTableView:
//            return self.feedback.count
//        default :
//            return 10
//        }
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch tableView {
//        case self.rcpaAddedListTableView:
//            return self.rcpaAddedListViewModel.numberofSections()
//        default:
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch tableView {
//        case self.ProductTableView :
////            let productValue = self.productSelectedListViewModel.fetchProductData(indexPath.row, searchText: self.searchText,type: dcrCall.type,selectedDoctorCode: dcrCall.code)
////            if productValue.isSelected {
////                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameWithSampleTableViewCell {
////                    cell.btnSelected.isSelected = false
////                }
////                self.productSelectedListViewModel.removeById(productValue.Object.code ?? "")
////                self.productSampleTableView.reloadData()
////            }else {
////                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameWithSampleTableViewCell {
////                    cell.btnSelected.isSelected = true
////                }
////                
////                let productStocks = DBManager.shared.getStockBalance()
////                
////                var productAvailableQty = [ProductStockBalance]()
////                
////                guard let productStockValue = productStocks , let productLists = productStockValue.product?.allObjects as? [ProductStockBalance] else {
////                    return
////                }
////                
////                productAvailableQty = productLists
////                
////                let selectedProduct = productValue.Object as? Product
////                
////                let selectedProdcutCode = selectedProduct?.code
////                
////                let product = productAvailableQty.filter{$0.code == selectedProdcutCode}
////                
////                var count = ""
////                
////                if !product.isEmpty {
////                    count = "\(product.first!.balanceStock <= 0 ? 0 : product.first!.balanceStock)"
////                }
////                
////                self.productSelectedListViewModel.addProductViewModel(ProductViewModel(product: ProductData(product: productValue.Object as? Product, isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: count, totalCount: count)))
////                
////           //     self.productSelectedListViewModel.addProductViewModel(ProductViewModel(product: ProductData(product: productValue.Object as? Product, isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "")))
////                self.productSampleTableView.reloadData()
////            }
//            break
//        case self.productSampleTableView:
//            break
//        case self.inputListTableView:
//            
//            let inputValue =  self.inputSelectedListViewModel.fetchInputData(indexPath.row, searchText: self.searchText)
//            if inputValue.isSelected {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                    cell.btnSelected.isSelected = false
//                }
//                self.inputSelectedListViewModel.removebyId(inputValue.Object.code ?? "")
//                self.inputSampleTableView.reloadData()
//            }else {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                    cell.btnSelected.isSelected = true
//                }
//                
//                let appsetup = AppDefaults.shared.getAppSetUp()
//                
//                if appsetup.inputValidation == 0 {
//                    
//                    let inputStocks = DBManager.shared.getStockBalance()
//                    
//                    var inputAvailableQty = [InputStockBalance]()
//                    
//                    var productAvailableQty = [ProductStockBalance]()
//                    
//                    guard let inputStockValue = inputStocks, let inputLists = inputStockValue.input?.allObjects as? [InputStockBalance] else {
//                        return
//                    }
//                    
//                    guard let productStockValue = inputStocks , let productLists = productStockValue.product?.allObjects as? [ProductStockBalance] else {
//                        return
//                    }
//                    
//                    inputAvailableQty = inputLists
//                    
//                    productAvailableQty = productLists
//                    
//                    print(productAvailableQty.first?.name)
//                    print(productAvailableQty.first?.code)
//                    
//                    print(inputAvailableQty)
//                    
//                    print(inputAvailableQty.first?.name)
//                    print(inputAvailableQty.first!.code)
//                    
//                    
//                    self.inputSelectedListViewModel.addInputViewModel(InputViewModel(input: InputData(input: inputValue.Object as? Input, availableCount: "", inputCount: "1")))
//                    
//                    self.inputSampleTableView.reloadData()
//                    
//                }else{
//                    
//                    self.inputSelectedListViewModel.addInputViewModel(InputViewModel(input: InputData(input: inputValue.Object as? Input, availableCount: "", inputCount: "1")))
//                    
//                    self.inputSampleTableView.reloadData()
//                }
//                
//            }
//        case self.selectionTableView :
//            let jointWorkValue = self.jointWorkSelectedListViewModel.fetchJointWorkData(indexPath.row)
//
//            if jointWorkValue.isSelected {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                    cell.btnSelected.isSelected = false
//                }
//                self.jointWorkSelectedListViewModel.removeById(id: jointWorkValue.Object.code ?? "")
//                self.selectionTableView.reloadData()
//            }else {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                    cell.btnSelected.isSelected = true
//                }
//                self.jointWorkSelectedListViewModel.addJointWorkViewModel(JointWorkViewModel(jointWork: jointWorkValue.Object as! JointWork))
//                self.selectionTableView.reloadData()
//            }
//            
//        case self.additionalCallListTableView:
//            let additionalCallValue = self.additionalCallListViewModel.fetchAdditionalCallData(indexPath.row, searchText: self.searchText)
//            if additionalCallValue.isSelected {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                    cell.btnSelected.isSelected = false
//                }
//                self.additionalCallListViewModel.removeById(id: additionalCallValue.Object.code ?? "")
//                self.additionalCallSelectedTableView.reloadData()
//            }else {
//                if let cell = tableView.cellForRow(at: indexPath) as? ProductNameTableViewCell{
//                    cell.btnSelected.isSelected = true
//                }
//                
////                self.addittionalCallListViewModel.addAdditionalCallViewModel(AdditionalCallViewModel(additionalCall: AdditionalCallSampleInputDetails(doctor: additionalCallValue.Object as! DoctorFencing)))
//                self.additionalCallListViewModel.addAdditionalCallViewModel(AdditionalCallViewModel(additionalCall: additionalCallValue.Object as! DoctorFencing, isView: false))
//                self.additionalCallSelectedTableView.reloadData()
//            }
//        case self.singleSelectionTableView:
//            self.selectedFeedback = self.feedback[indexPath.row]
//            self.txtFeedback.text = self.feedback[indexPath.row].name
//            UIView.animate(withDuration: 1.5) {
//                self.viewSingleSelection.isHidden = true
//            }
//            break
//        default :
//            break
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        switch tableView {
//        case self.rcpaAddedListTableView:
//            return 50
//        case self.detailledListTableView:
//            return 50
//        case self.productSampleTableView:
//            return 50
//        case self.inputSampleTableView:
//            return 50
//        case self.additionalCallSelectedTableView:
//            return 50
//        case self.additionalCallSampleInputTableView:
//            return 40
//        default :
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let appsetup = AppDefaults.shared.getAppSetUp()
//        switch tableView {
//        case self.detailledListTableView:
//
//            // Dequeue the header view
//            guard let headerView = detailledListTableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductdetailsHeader") as? ProductdetailsHeader else {
//     
//                return UIView()
//            }
//
//
//
//            return headerView
//         
//            
//        case self.productSampleTableView:
//            
//            // Dequeue the header view
//            guard let headerView = productSampleTableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductsInfoHeader") as? ProductsInfoHeader else {
//     
//                return UIView()
//            }
//
//
//
//            return headerView
//            
//            
//            
//       
//            
//        case self.inputSampleTableView:
//            
//            let view = UIStackView()
//            view.axis = .vertical
//            
//            let lblName = UILabel()
//            lblName.text = "Input Name"
//            lblName.textColor = AppColors.primaryColor
//            lblName.font = UIFont(name: "Satoshi-Bold", size: 20)
//            lblName.translatesAutoresizingMaskIntoConstraints  = true
//            
//            let lblStock = UILabel()
//            lblStock.text = "Stock"
//            lblStock.textColor = AppColors.primaryColor
//            lblStock.font = UIFont(name: "Satoshi-Bold", size: 20)
//            lblStock.translatesAutoresizingMaskIntoConstraints  = true
//            if appsetup.inputValidation != 1 {
//              //  lblStock.isHidden = true
//            }
//            
//            let lblQty = UILabel()
//            lblQty.text = "Qty"
//            lblQty.textColor = AppColors.primaryColor
//            lblQty.font = UIFont(name: "Satoshi-Bold", size: 20)
//            lblQty.textAlignment = .left
//            lblQty.translatesAutoresizingMaskIntoConstraints  = true
//            
//            let lbl = UILabel()
//            lbl.translatesAutoresizingMaskIntoConstraints = true
//            
//            let lblLine = UILabel()
//            lblLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//            
//            let vStackView : UIStackView = {
//                let view = UIStackView(arrangedSubviews: [lblName,lblStock,lblQty,lbl])
//                view.backgroundColor = .white
//                view.axis = .horizontal
//                view.translatesAutoresizingMaskIntoConstraints = true
//               return view
//            }()
//            
//            lblName.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor).isActive = true
//            lblName.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblStock.leadingAnchor.constraint(equalTo: lblName.trailingAnchor, constant: 10).isActive = true
//            lblStock.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblQty.leadingAnchor.constraint(equalTo: lblStock.trailingAnchor, constant: 10).isActive = true
//            lblQty.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lbl.leadingAnchor.constraint(equalTo: lblQty.trailingAnchor, constant: 10).isActive = true
//            lbl.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblName.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.35).isActive = true
//            lblStock.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//            lblQty.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//            
//            view.addArrangedSubview(vStackView)
//            view.addArrangedSubview(lblLine)
//            
//            lblLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
//            lblLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//            lblLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//            lblLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//            
//            return view
//        
//        case self.additionalCallSelectedTableView :
//            let view = UIStackView()
//            view.axis = .vertical
//            view.backgroundColor = .white
//            
//            let lblName = UILabel()
//            lblName.text = "Cust.Name"
//            lblName.textColor = AppColors.primaryColor
//            lblName.font = UIFont(name: "Satoshi-Bold", size: 20)
//            
//            let lblProductName = UILabel()
//            lblProductName.text = "Product Name"
//            lblProductName.textColor = AppColors.primaryColor
//            lblProductName.font = UIFont(name: "Satoshi-Bold", size: 20)
//            
//            let lblQty = UILabel()
//            lblQty.text = "Qty"
//            lblQty.textColor = AppColors.primaryColor
//            lblQty.font = UIFont(name: "Satoshi-Bold", size: 20)
//            
//            let lblInput = UILabel()
//            lblInput.text = "Input"
//            lblInput.textColor = AppColors.primaryColor
//            lblInput.font = UIFont(name: "Satoshi-Bold", size: 20)
//            
//            let lblInputQty = UILabel()
//            lblInputQty.text = "Qty"
//            lblInputQty.textColor = AppColors.primaryColor
//            lblInputQty.font = UIFont(name: "Satoshi-Bold", size: 20)
//            
//            let lbl = UILabel()
//            lbl.translatesAutoresizingMaskIntoConstraints = true
//            
//            let lblLine = UILabel()
//            lblLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//            
//            let vStackView : UIStackView = {
//                let view = UIStackView(arrangedSubviews: [lblName,lblProductName,lblQty,lblInput,lblInputQty,lbl])
//                view.backgroundColor = .white
//                view.axis = .horizontal
//               return view
//            }()
//            
//            lblName.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor).isActive = true
//            lblName.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblProductName.leadingAnchor.constraint(equalTo: lblName.trailingAnchor, constant: 10).isActive = true
//            lblProductName.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            
//            lblQty.leadingAnchor.constraint(equalTo: lblProductName.trailingAnchor, constant: 10).isActive = true
//            lblQty.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblInput.leadingAnchor.constraint(equalTo: lblQty.trailingAnchor, constant: 10).isActive = true
//            lblInput.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblInputQty.leadingAnchor.constraint(equalTo: lblInput.trailingAnchor, constant: 10).isActive = true
//            lblInputQty.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lbl.leadingAnchor.constraint(equalTo: lblInputQty.trailingAnchor, constant: 10).isActive = true
//            lbl.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//            
//            lblName.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//            lblProductName.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//            lblQty.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.15).isActive = true
//            lblInput.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.15).isActive = true
//            lblInputQty.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.15).isActive = true
//            
//            view.addArrangedSubview(vStackView)
//            view.addArrangedSubview(lblLine)
//            
//            lblLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
//            lblLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//            lblLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//            lblLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//            
//            return view
//        case self.additionalCallSampleInputTableView:
//            
//            
//            switch self.SampleInputSegmentControl.selectedSegmentIndex {
//            case 0:
//                
//                let view = UIStackView()
//                view.axis = .vertical
//                view.backgroundColor = .white
//                
//                let lblName = UILabel()
//                lblName.text = "Product Name"
//                lblName.textColor = AppColors.primaryColor
//                lblName.font = UIFont(name: "Satoshi-Bold", size: 18)
//                
//                let lblStock = UILabel()
//                lblStock.text = "Stock"
//                lblStock.textColor = AppColors.primaryColor
//                lblStock.font = UIFont(name: "Satoshi-Bold", size: 18)
//                
//                let lblQty = UILabel()
//                lblQty.text = "Qty"
//                lblQty.textColor = AppColors.primaryColor
//                lblQty.font = UIFont(name: "Satoshi-Bold", size: 18)
//                lblQty.textAlignment = .left
//                
//                let lbl = UILabel()
//                lbl.translatesAutoresizingMaskIntoConstraints = true
//                
//                let lblLine = UILabel()
//                lblLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//                
//                let vStackView : UIStackView = {
//                    let view = UIStackView(arrangedSubviews: [lblName,lblStock,lblQty,lbl])
//                    view.backgroundColor = .white
//                    view.axis = .horizontal
//                   return view
//                }()
//                
//                lblName.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor).isActive = true
//                lblName.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lblStock.leadingAnchor.constraint(equalTo: lblName.trailingAnchor, constant: 10).isActive = true
//                lblStock.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                
//                lblQty.leadingAnchor.constraint(equalTo: lblStock.trailingAnchor, constant: 10).isActive = true
//                lblQty.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lbl.leadingAnchor.constraint(equalTo: lblQty.trailingAnchor, constant: 10).isActive = true
//                lbl.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lblName.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.5).isActive = true
//                lblStock.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//                lblQty.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.15).isActive = true
//                
//                view.addArrangedSubview(vStackView)
//                view.addArrangedSubview(lblLine)
//                
//                lblLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
//                lblLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//                lblLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//                lblLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//                
//                return view
//            default:
//                
//                let view = UIStackView()
//                view.axis = .vertical
//                view.backgroundColor = .white
//                
//                let lblName = UILabel()
//                lblName.text = "Input Name"
//                lblName.textColor = AppColors.primaryColor
//                lblName.font = UIFont(name: "Satoshi-Bold", size: 18)
//                
//                let lblStock = UILabel()
//                lblStock.text = "Stock"
//                lblStock.textColor = AppColors.primaryColor
//                lblStock.font = UIFont(name: "Satoshi-Bold", size: 18)
//                
//                let lblQty = UILabel()
//                lblQty.text = "Qty"
//                lblQty.textColor = AppColors.primaryColor
//                lblQty.font = UIFont(name: "Satoshi-Bold", size: 18)
//                lblQty.textAlignment = .left
//                
//                let lbl = UILabel()
//                lbl.translatesAutoresizingMaskIntoConstraints = true
//                
//                let lblLine = UILabel()
//                lblLine.backgroundColor = AppColors.primaryColorWith_25per_alpha
//                
//                let vStackView : UIStackView = {
//                    let view = UIStackView(arrangedSubviews: [lblName,lblStock,lblQty,lbl])
//                    view.backgroundColor = .white
//                    view.axis = .horizontal
//                   return view
//                }()
//                
//                lblName.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor).isActive = true
//                lblName.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lblStock.leadingAnchor.constraint(equalTo: lblName.trailingAnchor, constant: 10).isActive = true
//                lblStock.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lblQty.leadingAnchor.constraint(equalTo: lblStock.trailingAnchor, constant: 10).isActive = true
//                lblQty.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lbl.leadingAnchor.constraint(equalTo: lblQty.trailingAnchor, constant: 10).isActive = true
//                lbl.centerYAnchor.constraint(equalTo: vStackView.centerYAnchor).isActive = true
//                
//                lblName.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.5).isActive = true
//                lblStock.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.2).isActive = true
//                lblQty.widthAnchor.constraint(equalTo: vStackView.widthAnchor, multiplier: 0.15).isActive = true
//                
//                view.addArrangedSubview(vStackView)
//                view.addArrangedSubview(lblLine)
//                
//                lblLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
//                lblLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//                lblLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//                lblLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//                
//                return view
//            }
//            
//        case self.rcpaAddedListTableView:
//            let view = ShadowView()
//            view.backgroundColor = .white
//            
//            
//            let textField = UITextField()
//            textField.text = self.rcpaAddedListViewModel.fetchAtSection(section).chemistName
//            textField.font = UIFont(name: "Satoshi-Bold", size: 18)
//            textField.textColor = AppColors.primaryColor
//            textField.translatesAutoresizingMaskIntoConstraints = false
//            textField.backgroundColor = AppColors.primaryColorWith_10per_alpha
//            textField.isUserInteractionEnabled = false
//            textField.layer.cornerRadius = 5
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = AppColors.primaryColorWith_10per_alpha.cgColor
//            
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
//            
//            textField.leftView = paddingView
//            textField.leftViewMode = .always
//            
//            let deleteButton = UIButton()
//            deleteButton.tag = section
//            deleteButton.setImage(UIImage(imageLiteralResourceName: "DeleteBinIcon"), for: .normal)
//            deleteButton.frame.size = CGSize(width: 25, height: 25)
//            deleteButton.translatesAutoresizingMaskIntoConstraints = false
//            deleteButton.addTarget(self, action: #selector(deleteRcpaChemistAction(_:)), for: .touchUpInside)
//            
//            view.addSubview(textField)
//            view.addSubview(deleteButton)
//            
//            deleteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
//            
//            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//            textField.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15).isActive = true
//            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//            
//            return view
//        default :
//            return nil
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        switch tableView{
//        case self.ProductTableView:
//            
//            return 60
//            
//        case self.inputSampleTableView:
//            return 70
//        case self.rcpaCompetitorTableView:
//            return UITableView.automaticDimension
//        case self.rcpaAddedListTableView:
//            return UITableView.automaticDimension
//        case self.eventCaptureTableView:
//            return 150
//        case self.additionalCallSelectedTableView:
//            return UITableView.automaticDimension
//        default:
//            return 70 // UITableView.automaticDimension
//        }
//    }
//    
//    
//    @objc func deleteRcpaChemistAction(_ sender : UIButton){
//        let tag = sender.tag
//        
//        self.rcpaAddedListViewModel.deleteSection(tag)
//        self.rcpaAddedListTableView.reloadData()
//    }
//    
//    @objc func editRcpaProduct(_ sender : UIButton) {
//        let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.rcpaAddedListTableView)
//        guard let indexPath = self.rcpaAddedListTableView.indexPathForRow(at: buttonPosition) else {
//            return
//        }
//        
//        let chemist = self.rcpaAddedListViewModel.fetchAtSection(indexPath.section)
//        
//        let products = self.rcpaAddedListViewModel.fetchAtRowIndex(indexPath.section, row: indexPath.row)
//        
//        let rcpas = products.rcpas
//        
//        
//        self.selectedChemistRcpa = chemist.rcpaChemist.chemist
//        
//        self.selectedProductRcpa = products.product
//        
//        self.txtRcpaQty.text = products.quantity
//        
//        self.txtRcpaTotal.text = products.total
//        
//        self.txtRcpaTotal.text = products.total
//        
//        self.lblChemistName.text = chemist.rcpaChemist.chemist.name ?? ""
//        self.lblProductName.text = products.product.name ?? ""
//        
//        self.rcpaCallListViewModel.removeAll()
//        
//        self.btnRcpaChemist.isHidden = true
//        self.btnRcpaProduct.isHidden = true
//        
//        for i in 0..<rcpas.count {
//            
//            self.rcpaCallListViewModel.addRcpaCompetitor(RcpaViewModel(rcpaHeaderData: RcpaHeaderData(chemist: chemist.rcpaChemist.chemist, product: products.product, quantity: products.quantity, total: products.total, rate: products.rate, competitorCompanyName: rcpas[i].competitorCompanyName, competitorCompanyCode: rcpas[i].competitorCompanyCode, competitorBrandName: rcpas[i].competitorBrandName, competitorBrandCode: rcpas[i].competitorBrandCode, competitorRate: rcpas[i].rate, competitorTotal: rcpas[i].competitorTotal, competitorQty: rcpas[i].competitorQty,remarks: "")))
//        }
//        
//        
//        self.rcpaCompetitorTableView.reloadData()
//        
//        UIView.animate(withDuration: 1.5) {
//            self.viewRcpa.isHidden = false
//        }
//        
//        print(indexPath)
//    }
//    
//    @objc func deleteRcpaProduct(_ sender : UIButton) {
//        let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.rcpaAddedListTableView)
//        guard let indexPath = self.rcpaAddedListTableView.indexPathForRow(at: buttonPosition) else {
//            return
//        }
//        
//        let products = self.rcpaAddedListViewModel.fetchAtSection(indexPath.section)
//        
//        if products.rcpaChemist.products.count == 1{
//            self.rcpaAddedListViewModel.deleteSection(indexPath.section)
//            self.rcpaAddedListTableView.reloadData()
//            return
//        }
//        
//        self.rcpaAddedListViewModel.deleteAtRows(indexPath.section, row: indexPath.row)
//        self.rcpaAddedListTableView.reloadData()
//    }
//    
//    @objc func plusRcpaProduct(_ sender : UIButton){
//        let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.rcpaAddedListTableView)
//        guard let indexPath = self.rcpaAddedListTableView.indexPathForRow(at: buttonPosition) else {
//            return
//        }
//        
//        let rcpa = self.rcpaAddedListViewModel.fetchAtRowIndex(indexPath.section, row: indexPath.row)
//        
//        let isTapped = rcpa.isViewTapped
//        
//        self.rcpaAddedListViewModel.updateProductIsViewTapped(indexPath.section, row: indexPath.row, isTapped: !isTapped)
//        self.rcpaAddedListTableView.reloadData()
//    }
//    
//    @objc func rcpaCompetitorCompany(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        print(indexPath)
//        
//        var competitors = DBManager.shared.getCompetitor()
//        
//        print(competitors)
//        
//        let selectedProductCode = self.selectedProductRcpa.code ?? ""
//        
//        print(selectedProductCode!)
//        competitors = competitors.filter{$0.ourProductCode == selectedProductCode}
//        
//        if competitors.isEmpty {
//            print("No Mapped Product")
//            return
//        }else {
//            print(competitors)
//        }
//        
//        var companyName = [String]()
//        var companyCode = [String]()
//        
//        for competitor in competitors {
//            
//            let name = competitor.compName?.components(separatedBy: "/")
//            let code = competitor.compSlNo?.components(separatedBy: "/")
//            
//            
//            companyName = companyName + (name ?? [])
//            companyCode = companyCode + (code ?? [])
//        }
//        
//        var data = [SelectionList]()
//        
//        for i in 0..<companyName.count-1 {
//            data.append(SelectionList(name: companyName[i], code: companyCode[i]))
//        }
//        
//        var out = [SelectionList]()
//
//        for element in data {
//            let itms=out.filter { $0.code == element.code}
//            if itms.count<1 {
//                out.append(element)
//            }
//        }
//        
//        data = out
//        
//        let selectionVC = UIStoryboard.singleSelectionVC
//        selectionVC.searchTitle = "Select Competitor Company"
//        selectionVC.selectionList = data
//        selectionVC.isFromStruct = true
//        selectionVC.didSelectCompletion { selectedIndex in
//            
//            
//            if let cell = self.rcpaCompetitorTableView.cellForRow(at: indexPath) as? RcpaTableViewCell {
//                cell.lblCompetitorCompany.text = data[selectedIndex].name // competitors[selectedIndex].compName
//            }
//            
//            let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//            
//            let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//            
//            let chemistCode = self.selectedChemistRcpa.code ?? ""
//            
//            let productCode = self.selectedProductRcpa.code ?? ""
//            
//            let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//            
//            print(index)
//            
//            self.rcpaCallListViewModel.setCompetitorCompanyAtIndex(indexPath.row, name: data[selectedIndex].name, code: data[selectedIndex].code)
//            
//            self.rcpaAddedListViewModel.setCompetitorCompanyAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, name: data[selectedIndex].name, code: data[selectedIndex].code)
//            
//            self.rcpaCompetitorTableView.reloadData()
//        }
//        self.present(selectionVC, animated: true)
//    }
//    
//    @objc func rcpaCompetitorBrand(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let competitors = DBManager.shared.getCompetitor()
//        
//        print(competitors)
//        
//        let competitorCompanyCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//        
//        let selectedProductCode = self.selectedProductRcpa.code ?? ""
//        
//        let selectedCompetitor = competitors.filter{$0.ourProductCode == selectedProductCode}
//        
//        print(selectedCompetitor)
//        
//        let companycode = selectedCompetitor.first?.compSlNo ?? ""
//        
//        let compantCodeArray = companycode.components(separatedBy: "/")
//        
//        var indexArray = [Int]()
//        
//        for i in 0..<compantCodeArray.count {
//            if compantCodeArray[i] == competitorCompanyCode {
//                indexArray.append(i)
//            }
//        }
//        
//        print(companycode)
//        
//        let code = selectedCompetitor.first?.compProductSlNo ?? ""
//        
//        let name = selectedCompetitor.first?.compProductName ?? ""
//        
//        var productCode = code.components(separatedBy: "/")
//        
//        print(productCode)
//        
//        productCode.removeLast()
//        
//        var productName = name.components(separatedBy: "/")
//        
//        productName.removeLast()
//        
//        var filteredCode = [String]()
//        var filterName = [String]()
//        
//        for index in indexArray {
//            filteredCode.append(productCode[index])
//            filterName.append(productName[index])
//        }
//        
//        productCode = filteredCode
//        productName = filterName
//        
//        print(productName)
//        
//        let products = self.rcpaCallListViewModel.fetchAtProduct(code: selectedProductCode!)
//        
//        for i in 0..<products.count {
//            
//            productCode.removeAll { code in
//                code.contains(products[i].competitorBrandCode)
//            }
//            productName.removeAll { name in
//                name.contains(products[i].competitorBrandName)
//            }
//        }
//        
//        print(productCode)
//        print(productName)
//        
//        let SelectedCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row)
//        
//        print(code)
//        print(name)
//        print(SelectedCode)
//        
//        var data = [SelectionList]()
//        
//        for i in 0..<productCode.count{
//            data.append(SelectionList(name: productName[i], code: productCode[i]))
//        }
//        
//        let selectionVC = UIStoryboard.singleSelectionVC
//        selectionVC.selectionList = data
//        selectionVC.isFromStruct = true
//        selectionVC.didSelectCompletion { selectedIndex in
//            
//            if let cell = self.rcpaCompetitorTableView.cellForRow(at: indexPath) as? RcpaTableViewCell {
//                cell.lblCompetitorBrand.text = productName[selectedIndex]
//            }
//            
//            let code = productCode[selectedIndex]
//           
//            let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//            
//            let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//            
//            let chemistCode = self.selectedChemistRcpa.code ?? ""
//            
//            let productCod = self.selectedProductRcpa.code ?? ""
//            
//            let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCod!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//            
//            print(index)
//            
//            self.rcpaCallListViewModel.setCompetitorBrandAtIndex(indexPath.row, name: productName[selectedIndex], code: productCode[selectedIndex])
//            
//            
//            self.rcpaAddedListViewModel.setCompetitorBrandAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, name: productName[selectedIndex], code: code)
//            
////            if index.rcpaIndex == -1 {
////                self.rcpaAddedListViewModel.setCompetitorBrandAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex + 1, name: productName[selectedIndex], code: code)
////                
////            }else {
////                self.rcpaAddedListViewModel.setCompetitorBrandAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, name: productName[selectedIndex], code: code)
////            }
//            
//            self.rcpaCompetitorTableView.reloadData()
//        }
//        self.present(selectionVC, animated: true)
//        print(indexPath)
//    }
//    
//    @objc func deleteRcpa(_ sender : UIButton) {
//        let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//        
//        let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//        
//        let chemistCode = self.selectedChemistRcpa.code ?? ""
//        
//        let productCode = self.selectedProductRcpa.code ?? ""
//        
//        let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//        
//        self.rcpaAddedListViewModel.deleteAtRcpa(index.chemistIndex, row: index.productIndex, index: index.rcpaIndex)
//        
//        let product = self.rcpaAddedListViewModel.fetchAtRowIndex(index.chemistIndex, row: index.productIndex)
//        
//        if product.rcpas.count == 0 {
//            self.rcpaAddedListViewModel.deleteAtRows(index.chemistIndex, row: index.productIndex)
//            
//            if self.rcpaAddedListViewModel.fetchAtSection(index.chemistIndex).rcpaChemist.products.count == 0 {
//                self.rcpaAddedListViewModel.deleteSection(index.chemistIndex)
//            }
//        }
//        
//        self.rcpaCallListViewModel.removeAtIndex(indexPath.row)
//        self.rcpaCompetitorTableView.reloadData()
//    }
//    
//    @objc func rcpaCompetitorQtyEdit (_ sender : UITextField) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//        
//        let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//        
//        let chemistCode = self.selectedChemistRcpa.code ?? ""
//        
//        let productCode = self.selectedProductRcpa.code ?? ""
//        
//        let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//        
//        print(index)
//        
//        let text = sender.text ?? ""
//        
//        self.rcpaAddedListViewModel.setCompetitorBrandQtyAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, qty: text)
//    }
//    
//    @objc func rcpaCompetitorRateEdit(_ sender : UITextField) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//        
//        let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//        
//        let chemistCode = self.selectedChemistRcpa.code ?? ""
//        
//        let productCode = self.selectedProductRcpa.code ?? ""
//        
//        let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//        
//        print(index)
//        
//        let text = sender.text ?? ""
//        
//        self.rcpaAddedListViewModel.setCompetitorBrandRateAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, rate: text)
//    }
//    
//    @objc func rcpaCompetitorTotalEdit(_ sender : UITextField) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.rcpaCompetitorTableView)
//        guard let indexPath = self.rcpaCompetitorTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorCompanyCode
//        
//        let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(indexPath.row).competitorBrandCode
//        
//        let chemistCode = self.selectedChemistRcpa.code ?? ""
//        
//        let productCode = self.selectedProductRcpa.code ?? ""
//        
//        let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//        
//        print(index)
//        
//        let text = sender.text ?? ""
//        
//        self.rcpaAddedListViewModel.setCompetitorBrandTotalAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, total: text)
//    }
//    
//    
//    
//    @objc func productSelectionAction(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.ProductTableView)
//        guard let indexPath = self.ProductTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//     
//        let productValue = self.productSelectedListViewModel.fetchProductData(indexPath.row, searchText: self.searchText,type: dcrCall.type,selectedDoctorCode: dcrCall.code)
//        if productValue.isSelected {
//            if let cell = self.ProductTableView.cellForRow(at: indexPath) as? ProductNameWithSampleTableViewCell {
//                cell.btnSelected.isSelected = false
//            }
//            self.productSelectedListViewModel.removeById(productValue.Object.code ?? "")
//            self.productSampleTableView.reloadData()
//        }else {
//            if let cell = self.ProductTableView.cellForRow(at: indexPath) as? ProductNameWithSampleTableViewCell{
//                cell.btnSelected.isSelected = true
//            }
//            self.productSelectedListViewModel.addProductViewModel(ProductViewModel(product: ProductData(product: productValue.Object as? Product, isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "")))
//            self.productSampleTableView.reloadData()
//        }
//    }
//    
//    @objc func productDetailedSelection(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.productSampleTableView)
//        guard let indexPath = self.productSampleTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let isDetailed = self.productSelectedListViewModel.fetchDataAtIndex(indexPath.row).isDetailed
//        
//        self.productSelectedListViewModel.setIsDetailedProductAtIndex(indexPath.row, isDetailed: !isDetailed)
//        
//        self.productSampleTableView.reloadData()
//    }
//    
//    
//    @objc func deleteProduct(_ sender: UIButton) {
//        
//        self.productSelectedListViewModel.removeAtIndex(sender.tag)
//        self.productSampleTableView.reloadData()
//        self.ProductTableView.reloadData()
//    }
//    
//    
//    @objc func inputSelectionAction(_ sender : UIButton){
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.inputListTableView)
//        guard let indexPath = self.inputListTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let inputValue =  self.inputSelectedListViewModel.fetchInputData(indexPath.row, searchText: self.searchText)
//        if inputValue.isSelected {
//            if let cell = self.inputListTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                cell.btnSelected.isSelected = false
//            }
//            self.inputSelectedListViewModel.removebyId(inputValue.Object.code ?? "")
//            self.inputSampleTableView.reloadData()
//        }else {
//            if let cell = self.inputListTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                cell.btnSelected.isSelected = true
//            }
//            self.inputSelectedListViewModel.addInputViewModel(InputViewModel(input: InputData(input: inputValue.Object as? Input, availableCount: "", inputCount: "1")))
//            self.inputSampleTableView.reloadData()
//        }
//    }
//    
//    @objc func deleteInput(_ sender : UIButton){
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.inputSampleTableView)
//        guard let indexPath = self.inputSampleTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        self.inputSelectedListViewModel.removeAtIndex(indexPath.row)
//        self.inputSampleTableView.reloadData()
//        self.inputListTableView.reloadData()
//    }
//    
//    @objc func jointworkSelectionAction(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.selectionTableView)
//        guard let indexPath = self.selectionTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let jointWorkValue = self.jointWorkSelectedListViewModel.fetchJointWorkData(indexPath.row)
//
//        if jointWorkValue.isSelected {
//            if let cell = self.selectionTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                cell.btnSelected.isSelected = false
//            }
//            self.jointWorkSelectedListViewModel.removeById(id: jointWorkValue.Object.code ?? "")
//           // self.selectionTableView.reloadData()
//        }else {
//            if let cell = self.selectionTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                cell.btnSelected.isSelected = true
//            }
//            self.jointWorkSelectedListViewModel.addJointWorkViewModel(JointWorkViewModel(jointWork: jointWorkValue.Object as! JointWork))
//           // self.selectionTableView.reloadData()
//        }
//    }
//    
//    @objc func deleteJointWork (_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.jointWorkTableView)
//        guard let indexPath = self.jointWorkTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        self.jointWorkSelectedListViewModel.removeAtindex(indexPath.row)
//        self.jointWorkTableView.reloadData()
//    }
//    
//    @objc func additionalCallSelectionAction(_ sender : UIButton){
//        //additionalCallSelectedTableView
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallListTableView)
//        guard let indexPath = self.additionalCallListTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        let additionalCallValue = self.additionalCallListViewModel.fetchAdditionalCallData(indexPath.row, searchText: self.searchText)
//        if additionalCallValue.isSelected {
//            if let cell = self.additionalCallListTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell {
//                cell.btnSelected.isSelected = false
//            }
//            self.additionalCallListViewModel.removeById(id: additionalCallValue.Object.code ?? "")
//            self.additionalCallSelectedTableView.reloadData()
//        }else {
//            if let cell = self.additionalCallListTableView.cellForRow(at: indexPath) as? ProductNameTableViewCell{
//                cell.btnSelected.isSelected = true
//            }
//            
////                self.addittionalCallListViewModel.addAdditionalCallViewModel(AdditionalCallViewModel(additionalCall: AdditionalCallSampleInputDetails(doctor: additionalCallValue.Object as! DoctorFencing)))
//            self.additionalCallListViewModel.addAdditionalCallViewModel(AdditionalCallViewModel(additionalCall: additionalCallValue.Object as! DoctorFencing, isView: false))
//            self.additionalCallSelectedTableView.reloadData()
//        }
//    }
//    
//    @objc func addProductInputAction(_ sender: UIButton) {
//        //additionalCallSelectedTableView
//        print("sender Tag == \(sender.tag)")
//        self.selectedDoctorIndex = sender.tag
//        self.additionalCallSampleInputTableView.reloadData()
//        UIView.animate(withDuration: 1.5) {
//            self.viewAdditionalCallSampleInput.isHidden = false
//        }
//    }
//    
//    @objc func editAdditionalCallSampleInput(_ sender : UIButton) {
//        //additionalCallSelectedTableView
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSelectedTableView)
//        guard let indexPath = self.additionalCallSelectedTableView.indexPathForRow(at: buttonPosition) else {
//            return
//        }
//        
//        self.selectedDoctorIndex = sender.tag
//        self.additionalCallSampleInputTableView.reloadData()
//        UIView.animate(withDuration: 1.5){
//            self.viewAdditionalCallSampleInput.isHidden = false
//        }
//    }
//    
//    @objc func additionalCallDownArrowAction(_ sender : UIButton) {
//        //additionalCallSelectedTableView
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSelectedTableView)
//        guard let indexPath = self.additionalCallSelectedTableView.indexPathForRow(at: buttonPosition) else {
//            return
//        }
//        
//        let isView = self.additionalCallListViewModel.fetchDataAtIndex(indexPath.row).isView
//        
//        self.additionalCallListViewModel.updateInCallSection(indexPath.row, isView: !isView)
//        
//        print(isView)
//        
//        self.additionalCallSelectedTableView.reloadData()
//        
//    }
//    
//    @objc func additionalCallSampleInputSelection(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
//        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        switch self.SampleInputSegmentControl.selectedSegmentIndex{
//            case 0:
//                let products = DBManager.shared.getProduct()
//                
//                let selectionVC = UIStoryboard.singleSelectionVC
//                selectionVC.selectionData = products
//                selectionVC.didSelectCompletion { selectedIndex in
//                    
//                    if let cell = self.additionalCallSampleInputTableView.cellForRow(at: indexPath) as? AdditionalCallSampleEntryTableViewCell {
//                        cell.lblName.text = products[selectedIndex].name
//                    }
//                    
//                    self.additionalCallListViewModel.updateProductAtSection(self.selectedDoctorIndex, index: indexPath.row, product: products[selectedIndex])
//                    
//                }
//                self.present(selectionVC, animated: true)
//            
//            case 1:
//                
//                let inputs = DBManager.shared.getInput()
//                
//                let selectionVC = UIStoryboard.singleSelectionVC
//                selectionVC.selectionData = inputs
//                selectionVC.didSelectCompletion { selectedIndex in
//                    if let cell = self.additionalCallSampleInputTableView.cellForRow(at: indexPath) as? AdditionalCallSampleEntryTableViewCell {
//                        cell.lblName.text = inputs[selectedIndex].name
//                    }
//                    self.additionalCallListViewModel.updateInputAtSection(self.selectedDoctorIndex, index: indexPath.row, input: inputs[selectedIndex])
//                }
//                self.present(selectionVC, animated: true)
//            default:
//                break
//        }
//    }
//    
//    @objc func deleteAdditionalCallSampleInput(_ sender : UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
//        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        switch self.SampleInputSegmentControl.selectedSegmentIndex {
//            case 0:
//                self.additionalCallListViewModel.deleteProductAtIndex(self.selectedDoctorIndex, index: indexPath.row)
//                self.additionalCallSampleInputTableView.reloadData()
//            case 1:
//                self.additionalCallListViewModel.deleteInputAtIndex(self.selectedDoctorIndex, index: indexPath.row)
//                self.additionalCallSampleInputTableView.reloadData()
//                break
//            default:
//                break
//        }
//    }
//    
//    @objc func updateSampleInputQty(_ sender : UITextField) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSampleInputTableView)
//        guard let indexPath = self.additionalCallSampleInputTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        switch self.SampleInputSegmentControl.selectedSegmentIndex {
//            case 0:
//                self.additionalCallListViewModel.updateProductQtyAtSection(self.selectedDoctorIndex, index: indexPath.row, qty: sender.text ?? "")
//                break
//            case 1:
//                self.additionalCallListViewModel.updateInputAtSection(self.selectedDoctorIndex, index: indexPath.row, qty: sender.text ?? "")
//                break
//            default:
//                break
//        }
//    }
//    
//    @objc func deleteAdditionalCall (_ sender : UIButton) {
//        //additionalCallSelectedTableView
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.additionalCallSelectedTableView)
//        guard let indexPath = self.additionalCallSelectedTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        
//        self.additionalCallListViewModel.removeAtindex(indexPath.row)
//        self.additionalCallSelectedTableView.reloadData()
//        self.additionalCallListTableView.reloadData()
//    }
//    
//    @objc func deleteEventCapture(_ sender : UIButton){
//        self.eventCaptureListViewModel.removeAtIndex(sender.tag)
//        self.eventCaptureTableView.reloadData()
//    }
//    
//    @objc func imageTitleEdit(_ sender : UITextField){
//        self.eventCaptureListViewModel.updateTitleAtIndex(sender.tag, name: sender.text ?? "")
//    }
//    
//    @objc func updateProductSampleQty(_ sender : UITextField){
//        
//        let product = self.productSelectedListViewModel.fetchDataAtIndex(sender.tag)
//        
//        print(product.name)
//        print(product.sampleCount)
//        print(product.availableCount)
//        print(product.totalCount)
//        print(product.code)
//        
//        if product.totalCount == "0" {
//            
//        }
//        
//        self.productSelectedListViewModel.setSampleCountAtIndex(sender.tag, qty: sender.text ?? "")
//    }
//    
//    @objc func updateProductRxQty(_ sender : UITextField){
//        self.productSelectedListViewModel.setRxCountAtIndex(sender.tag, qty: sender.text ?? "")
//    }
//    
//    @objc func updateProductRcpaQty(_ sender : UITextField){
//        self.productSelectedListViewModel.setRcpaCountAtIndex(sender.tag, qty: sender.text ?? "")
//    }
//    
//    @objc func updateInputSampleQty(_ sender : UITextField){
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.inputSampleTableView)
//        guard let indexPath = self.inputSampleTableView.indexPathForRow(at: buttonPosition) else{
//            return
//        }
//        self.inputSelectedListViewModel.setInputCodeAtIndex(indexPath.row, samQty: sender.text ?? "")
//    }
//}
//
//extension ProductVC : UIViewControllerTransitioningDelegate{
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        let presenter = CustomPresentationController(presentedViewController: presented, presenting: presenting)
//        presenter.presentedViewFrame = presented.view.frame
//        return presenter
//    }
//}
//
//extension ProductVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//        
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
//            return
//        }
//        
//        self.eventCaptureListViewModel.addEventCapture(EventCaptureViewModel(eventCapture: EventCapture(image: image,title: "",description: "")))
//        self.eventCaptureTableView.reloadData()
//    }
//}
//
//
//extension ProductVC : UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let compSepByCharInSet = string.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        let maxLength = 6
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return string == numberFiltered && newString.length <= maxLength 
//    }
//}
//
//extension ProductVC : UITextViewDelegate {
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = AppColors.primaryColor
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        
//        if self.viewFeedback.isHidden == false {
//            if textView.text.isEmpty {
//                textView.text = "Description"
//                textView.textColor = UIColor.lightGray
//            }
//            return
//        }
//        
//        if textView.text.isEmpty {
//            textView.text = "Enter the remarks"
//            textView.textColor = UIColor.lightGray
//        }
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        
//        if self.viewFeedback.isHidden == false {
//            switch textView {
//            case self.txtRemarks:
//                break
//            default:
//                let text = textView.text ?? ""
//                
//                self.eventCaptureListViewModel.updateDescription(textView.tag, remark: text)
//                break
//            }
//            return
//        }
//        
//        let text = textView.text ?? ""
//        
//        let rcpaCompanyCode  = self.rcpaCallListViewModel.fetchAtIndex(textView.tag).competitorCompanyCode
//        
//        let rcpaCompanyBrandCode = self.rcpaCallListViewModel.fetchAtIndex(textView.tag).competitorBrandCode
//        
//        let chemistCode = self.selectedChemistRcpa.code ?? ""
//        
//        let productCode = self.selectedProductRcpa.code ?? ""
//        
//        let index = self.rcpaAddedListViewModel.rcpaAtSectionIndex(chemistCode!, productCode: productCode!, rcpaCompanyCode: rcpaCompanyCode, rcpaBrandCode: rcpaCompanyBrandCode)
//        
//        self.rcpaAddedListViewModel.setCompetitorBrandRemarksAtSectionIndex(index.chemistIndex, row: index.productIndex, compRow: index.rcpaIndex, remarks: text)
//        
//    }
//}
//
//
//
//class selectionData {
//
//    var selectionList : SelectionList
//
//    init(selectionList: SelectionList) {
//        self.selectionList = selectionList
//    }
//
//    var name : String {
//        return self.selectionList.name
//    }
//
//    var code : String {
//        return self.selectionList.code
//    }
//
//}


struct SelectionList{

    var name : String
    var code : String

}
