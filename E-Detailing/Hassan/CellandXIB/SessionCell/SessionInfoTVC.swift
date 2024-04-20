//
//  SessionInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 10/11/23.
//

import UIKit
//import 

protocol SessionInfoTVCDelegate: AnyObject {
    func remarksAdded(remarksStr: String, index: Int)
}

extension SessionInfoTVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type here.."
            textView.textColor = UIColor.lightGray
        }
        self.remarks = textView.text == "Type here.." ? "" : textView.text
        delegate?.remarksAdded(remarksStr: self.remarks ?? "", index: self.selectedIndex ?? 0)
    //    self.remarks = textView.text == "Type here.." ? "" : textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.remarks = textView.text == "Type here.." ? "" : textView.text
     
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Type here.."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
      
        return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.contentView.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
class SessionInfoTVC: UITableViewCell {
    
    
    @IBOutlet var remarksHolderView: UIView!
    @IBOutlet var remarksHeight: NSLayoutConstraint!
    
    @IBOutlet var remarksTFholder: UIView!
    
    @IBOutlet var remarksTV: UITextView!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    
    @IBOutlet var overallContentsHolder: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    
    ///Worktype outlets
    @IBOutlet var worktyprTitle: UILabel!
    
    @IBOutlet weak var workTypeView: UIView!
    
    @IBOutlet weak var workselectionHolder: UIView!
    
    @IBOutlet var lblWorkType: UILabel!
    
    ///cluster type outlets
    
    @IBOutlet var clusterTitle: UILabel!
    @IBOutlet weak var clusterView: UIView!
    
  
    
    @IBOutlet weak var clusterselectionHolder: UIView!
    
    
    @IBOutlet var lblCluster: UILabel!
    
  
    ///headQuaters type outlets

    @IBOutlet var headQuartersTitle: UILabel!
    @IBOutlet var headQuatersView: UIView!
    
    @IBOutlet var headQuatersSelectionHolder: UIView!
    
    @IBOutlet var lblHeadquaters: UILabel!
    
    
    ///jointCall type outlets
    
    @IBOutlet var jointCallTitle: UILabel!
    @IBOutlet var jointCallView: UIView!
    
    @IBOutlet var jointCallSelectionHolder: UIView!
    
    
    @IBOutlet var lblJointCall: UILabel!

    ///listedDoctor type outlets
    
    @IBOutlet var listedDocTitle: UILabel!
    @IBOutlet var listedDoctorView: UIView!
    
    @IBOutlet var listedDoctorSelctionHolder: UIView!
    
    @IBOutlet var lblListedDoctor: UILabel!
    
    
    ///chemist type outlets
    
    @IBOutlet var chemistTitle: UILabel!
    @IBOutlet var chemistView: UIView!
    
    @IBOutlet var chemistSelectionHolder: UIView!
    
    @IBOutlet var lblChemist: UILabel!
    
    
    ///Stockists type outlets
   
    @IBOutlet var stockistTitle: UILabel!
    @IBOutlet var stockistView: UIView!
    
    @IBOutlet var stockistSectionHolder: UIView!
    
    @IBOutlet var lblStockist: UILabel!
    
  
    ///New customers type outlets
    
    @IBOutlet var newCustomersTitle: UILabel!
    @IBOutlet var newCustomersView: UIView!
    
    @IBOutlet var newCustomersSectionHolder: UIView!
    
    @IBOutlet var lblNewCustomers: UILabel!
   
    
    weak var delegate : SessionInfoTVCDelegate?
    var remarks: String?
    var keybordenabled = Bool()
    var selectedIndex: Int? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        //remarksTV.placeholder = "Type here.."
        [chemistSelectionHolder,listedDoctorSelctionHolder,jointCallSelectionHolder,headQuatersSelectionHolder, clusterselectionHolder, workselectionHolder, stockistSectionHolder, newCustomersSectionHolder, overallContentsHolder, remarksTFholder].forEach { view in
            view?.layer.borderColor = UIColor.appSelectionColor.cgColor //AppColors.primaryColorWith_40per_alpha.cgColor
            view?.layer.borderWidth = view == overallContentsHolder ? 0 : 0.5
            view?.layer.cornerRadius = 5
            view?.elevate(1)
        }
        configureTextField()
        initNotifications()
        setupUI()
        
        
    }
    
    func setupUI() {
        
        let labels : [UILabel] = [lblWorkType, lblCluster, lblHeadquaters, lblJointCall, lblListedDoctor, lblChemist, lblStockist, lblNewCustomers]
        labels.forEach { label in
            label.textColor = .appTextColor
            label.setFont(font: .medium(size: .BODY))
        }
        
        let titleLabels : [UILabel] = [worktyprTitle, clusterTitle, headQuartersTitle, jointCallTitle, listedDocTitle,  chemistTitle, stockistTitle, newCustomersTitle]
        titleLabels.forEach { label in
            label.textColor = .appLightTextColor
            label.setFont(font: .bold(size: .SMALL))
        }
        remarksTV.textColor = .appTextColor
        remarksTV.font = UIFont(name: "Satoshi-Medium", size: 14)
        
        lblName.textColor = .appTextColor
        lblName.setFont(font: .bold(size: .SUBHEADER))
        
        
        overallContentsHolder.backgroundColor = .appGreyColor.withAlphaComponent(0.5)
            //.appSelectionColor
       // lblName.setFont(font: .bold(size: .SUBHEADER))
        
        
       
    }
    
    override func prepareForReuse() {
       /// deinit {
        //    NotificationCenter.default.removeObserver(self)
       /// }
    }
    
    func initNotifications() {
      //   NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         
       //  NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if(keybordenabled == false){
        adjustInsetForKeyboardShow(show: true, notification: notification)
              keybordenabled = true
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
         keybordenabled = false

        adjustInsetForKeyboardShow(show: false, notification: notification)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if show {
                if self.frame.origin.y == 0 {
                    self.frame.origin.y -= keyboardSize.height
                    //+ CGFloat((selectedIndex * 620))
                }
            } else {
                if self.frame.origin.y != 0 {
                          self.frame.origin.y = 0
                      }
            }
            //  contentView.bottom += adjustment
            //  contentView.scrollIndicatorInsets.bottom += adjustment
            self.contentView.layoutIfNeeded()
        }
    }
    
    func configureTextField() {
        remarksTV.delegate = self
        //remarksTV.text == "" ? "Type here.." : remarksTV.text
        remarksTV.textColor =  remarksTV.text == "Type here.." ? UIColor.lightGray : UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
