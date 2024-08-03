//
//  TPdeviateReasonView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 02/03/24.
//

import Foundation
import UIKit

extension TPdeviateReasonView: UITextViewDelegate {
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
       // delegate?.remarksAdded(remarksStr: self.remarks ?? "", index: 0)
   
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      //  self.remarks = textView.text == "Type here.." ? "" : textView.text
     
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
            self.remarks = updatedText
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
            self.remarks = updatedText
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
      
        return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}


class TPdeviateReasonView : UIView {
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var closeIV: UIImageView!
    
    
    @IBOutlet var remarksTV: UITextView!
    
    
    @IBOutlet var btnCancel: ShadowButton!
    
    @IBOutlet var btnsend: ShadowButton!
    weak var delegate : SessionInfoTVCDelegate?
    var isForRemarks: Bool = false
    var isForRejection: Bool = false
    var productIndex: Int = 0
    weak var addedSubviewDelegate: addedSubViewsDelegate?
    var remarks: String?
    func setupui() {
        self.layer.cornerRadius = 5
        titleLbl.setFont(font: .bold(size: .BODY))
        
        btnCancel.backgroundColor = .appSelectionColor
        btnCancel.layer.borderColor = UIColor.gray.cgColor
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.cornerRadius = 5
        
        if isForRemarks {
            titleLbl.text = "Remarks"
            btnsend.setTitle("Save", for: .normal)
            btnCancel.setTitle("Skip", for: .normal)
        } else  if isForRejection {
            titleLbl.text = "Rejection Reason"
            btnsend.setTitle("Reject", for: .normal)
            btnsend.backgroundColor = .appLightPink
            btnCancel.setTitle("Cancel", for: .normal)
        }
        
        else {
            titleLbl.text = "Deviation Reason"
            btnsend.setTitle("Send", for: .normal)
            btnsend.setTitle("Cancel", for: .normal)
        }

        closeIV.addTap {
            self.addedSubviewDelegate?.didClose()
        }
        
        configureTextField()
    }
    @IBAction func didTapSend(_ sender: Any) {
            addedSubviewDelegate?.didUpdate()
            self.delegate?.remarksAdded(remarksStr: self.remarks ?? "", index: productIndex)
    }
    @IBAction func didTapCancel(_ sender: Any) {
        addedSubviewDelegate?.didClose()
        delegate?.remarksAdded(remarksStr: self.remarks ?? "", index: productIndex)
    }
    
    
    
    func configureTextField() {
        remarksTV.text =  self.remarks == nil ? "Type here.." : self.remarks
        remarksTV.backgroundColor = .appSelectionColor
        remarksTV.layer.cornerRadius = 5
        remarksTV.textColor = .appTextColor
       // remarksTV.font = UIFont(name: "Satoshi-Medium", size: 14)
        remarksTV.delegate = self
        //remarksTV.text == "" ? "Type here.." : remarksTV.text
        remarksTV.textColor =  remarksTV.text == "Type here.." ? UIColor.lightGray : UIColor.black
    }
    
}
