//
//  EditSocialMediaViewContoller.swift
//  IMAB
//
//  Created by Vijay Rathore on 15/01/23.
//

import UIKit
import Firebase

class EditSocialMediaViewContoller : UIViewController {
    
    
    
    @IBOutlet weak var doneBtn: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var profileLinkTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    
    var name : String?
    var link : String?
    
    override func viewDidLoad() {
        
        guard let name = name, let link = link else {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
      
        nameTF.delegate = self
        profileLinkTF.delegate = self
        
        nameTF.text = name
        profileLinkTF.text = link
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        doneBtn.isUserInteractionEnabled = true
        doneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneBtnClicked)))
        
        
        
        saveBtn.layer.cornerRadius = 8
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
                    self.showSnack(messages: "Profile Updated")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        self.dismiss(animated: true)
                    }
                }
            })
        }
    }
    
}

extension EditSocialMediaViewContoller : UITextFieldDelegate {
    
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
