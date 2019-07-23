//
//  SendFeedbackVC.swift
//  Et3am
//
//  Created by Ahmed M. Hassan on 7/3/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SVProgressHUD

class SendFeedbackVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var remainingCharactersLabel: UILabel!
    @IBOutlet weak var feedbackImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    // Properties
    let maxCharacters: Int = 1000
    let placeholderText = "What would you like us to improve/ What went wrong?"
    
    // Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI for text view
        messageTextView.delegate = self
        messageTextView.text = placeholderText
        messageTextView.textColor = .lightGray
        messageTextView.layer.cornerRadius = 10
        
        // Dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        feedbackImageView.isHidden = true
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = false
            
            present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func messageChanged(_ sender: UITextView) {
        
        let remainingCharacters = maxCharacters - (sender.text?.characters.count)!
        remainingCharactersLabel.text = "\(remainingCharacters)/\(maxCharacters)"
        
    }
    

    @IBAction func submit(_ sender: UIButton) {
        
        if messageTextView.text == placeholderText {
            return
        }
        
        // Submit without image
        guard let image = feedbackImageView.image else {
            submitForm(with: "")
            return
        }
        
        // Submit with image
        SVProgressHUD.show(withStatus: "Uploading image...")
        ImageAPI.uploadImage(image, completionHandler: { result in
            
            if let _ = result.0, let publicId = result.1 {
                
                self.submitForm(with: publicId)
                
            } else {
                SVProgressHUD.showError(withStatus: "Can't upload image, please try again later.")
            }
        })
        
    }
    
    // Submitting user form with image id
    func submitForm(with imageId: String) {
        SVProgressHUD.show(withStatus: "Submitting form...")
        
        var inquiry = Inquiry()
        inquiry.image = imageId
        inquiry.message = self.messageTextView.text
        
        InquiryLayer.submit(inquiry: inquiry) { (result) in
            
            SVProgressHUD.dismiss()
            
            if let code = result?.id {
                self.showSuccessView(with: code)
            }
            
        }
    }
    
    func showSuccessView(with code: Int) {
        if let successView = Bundle.main.loadNibNamed("FeedbackSuccess", owner: self, options: nil)?.first as? FeedbackSuccessView {
            
            containerView.subviews.forEach{$0.removeFromSuperview()}
            containerView.addSubview(successView)
            successView.frame = containerView.bounds
            
            successView.inquiryIdLabel.text = "\(code)"
            successView.backButton.addTarget(self, action: #selector(self.backPressed), for: .touchUpInside)
        }
    }
    
    func backPressed() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - Select image from gallery
extension SendFeedbackVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            feedbackImageView.isHidden = false
            feedbackImageView.image = image
        
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Textview delegate methods
extension SendFeedbackVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let remainingCharacters = maxCharacters - textView.text.characters.count
        remainingCharactersLabel.text = "\(remainingCharacters)/\(maxCharacters)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (textView.text.characters.count > maxCharacters) ? false : true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == placeholderText && textView.textColor == .lightGray) {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
}
