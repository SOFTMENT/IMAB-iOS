//
//  AddSocialMediaViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 14/01/23.
//

import UIKit
import Firebase

class AddSocialMediaViewController : UIViewController {
    
    @IBOutlet weak var doneBtn: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var profileLinkTF: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
      
        nameTF.delegate = self
        profileLinkTF.delegate = self
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        doneBtn.isUserInteractionEnabled = true
        doneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneBtnClicked)))
        
        nameTF.isUserInteractionEnabled = true
        nameTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mediaNameClicked)))
        
        saveBtn.layer.cornerRadius = 8
    }
    
    @objc func mediaNameClicked(){
        let alert = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
      
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Facebook , style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Facebook
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Instagram, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Instagram
        }))
     
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Linkedin, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Linkedin
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Pintrest, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Pintrest
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Reddit, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Reddit
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Snapchat, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Snapchat
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.TikTok, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.TikTok
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.Twitter, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.Twitter
        }))
        alert.addAction(UIAlertAction(title: Constants.SocialMedia.YouTube, style: .default, handler: { action in
            self.nameTF.text = Constants.SocialMedia.YouTube
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
    }
    
    @objc func doneBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        let sName = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sUrl = profileLinkTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sName == "" {
            self.showSnack(messages: "Select Media")
        }
        else if sUrl == "" {
            self.showSnack(messages: "Enter Media Name")
        }
        else {
            ProgressHUDShow(text: "")
            let socialMediaModel = SocialMediaModel()
            socialMediaModel.link = sUrl
            socialMediaModel.name = sName
            try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(sName ?? "123").setData(from: socialMediaModel,merge : true, completion: { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showSnack(messages: error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Profile Added")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        self.dismiss(animated: true)
                    }
                }
            })
        }
    }
    
}

extension AddSocialMediaViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            return false;
        }
        return true
    }
}
