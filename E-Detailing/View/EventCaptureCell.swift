//
//  EventCaptureCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 26/09/23.
//

import Foundation
import UIKit


protocol EventCaptureCellDelegate: AnyObject {
    func didUpdate(title: String, description: String, index: Int)
}

class EventCaptureCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var capturedImageHolder: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet var nameTFholder: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet var descriptionHolder: UIView!
    var delegate: EventCaptureCellDelegate?
    var remarks: String?
    var title: String?
    var indexpath: Int? = nil
    var eventCapture : EventCaptureViewModel! {
        didSet {
            self.imgView.image = eventCapture.image
            self.txtName.text = eventCapture.title
            self.txtDescription.text = eventCapture.description
            
            if eventCapture.description == "" {
                self.txtDescription.text = "Description"
                self.txtDescription.textColor = .lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        capturedImageHolder.layer.cornerRadius = 5
        capturedImageHolder.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        nameTFholder.layer.cornerRadius = 5
        nameTFholder.layer.borderWidth = 1
        nameTFholder.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
        
       // descriptionHolder.layer.cornerRadius = 5
       // descriptionHolder.layer.borderWidth = 1
       // descriptionHolder.layer.borderColor = UIColor.appLightTextColor.withAlphaComponent(0.1).cgColor
        
        configureTextField()
        txtName.delegate = self
    }
    
    
    func configureTextField() {
        txtDescription.text =  self.remarks == nil ? "Description" : self.remarks
        txtDescription.backgroundColor = .appTextColor.withAlphaComponent(0.05)
        txtDescription.layer.cornerRadius = 5
        txtDescription.textColor = .appTextColor
        txtDescription.font = UIFont(name: "Satoshi-Bold", size: 14)
        txtDescription.delegate = self
        //remarksTV.text == "" ? "Description" : remarksTV.text
        txtDescription.textColor =  txtDescription.text == "Description" ? UIColor.lightGray : UIColor.black
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtName:
            // Construct the new text after replacement
            let currentText = textField.text ?? "1"
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Update the text immediately
            title = currentText
            self.delegate?.didUpdate(title: title ?? "", description: txtDescription.text ?? "", index: indexpath ?? 0)
   
            return true
        default:
            return false
        }
    }

    
}

extension EventCaptureCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
        self.remarks = textView.text == "Description" ? "" : textView.text
       // delegate?.remarksAdded(remarksStr: self.remarks ?? "", index: 0)
        delegate?.didUpdate(title: title ?? "", description: textView.text, index: indexpath ?? 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.remarks = textView.text == "Description" ? "" : textView.text
     
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Description"
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
        if self.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
