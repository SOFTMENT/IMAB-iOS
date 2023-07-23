//
//  SignInviewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit

import AuthenticationServices
import CryptoKit
import FBSDKCoreKit
import FBSDKLoginKit

fileprivate var currentNonce: String?
class SignInviewController : UIViewController {
    
    @IBOutlet weak var backBtn: UIView!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
  
    @IBOutlet weak var remeberMeCheck: UIButton!

    override func viewDidLoad() {
   
        backBtn.layer.cornerRadius = 8
        backBtn.dropShadow()
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
   
        emailAddress.setLeftPaddingPoints(16)
        emailAddress.setRightPaddingPoints(10)
        emailAddress.setLeftView(image: UIImage(named: "email-5")!)
        emailAddress.delegate = self
        
    
        password.setLeftPaddingPoints(16)
        password.setRightPaddingPoints(10)
        password.setLeftView(image: UIImage(named: "padlock-3")!)
        password.delegate = self
        
        loginBtn.layer.cornerRadius = 8
        loginBtn.dropShadow()
        
    
        //RESET PASSWORD
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordClicked)))
        
  
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
        
        
        let rememberMeFlag = UserDefaults.standard.bool(forKey: "REMEMBER_USER")
        remeberMeCheck.isSelected = rememberMeFlag
        if rememberMeFlag {
            emailAddress.text = UserDefaults.standard.string(forKey: "USER_EMAIL")
            password.text = UserDefaults.standard.string(forKey: "PASSWORD")
                
        }
    }
  
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func rememberMeClicked(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
        
    }
    
  
  
    @objc func forgotPasswordClicked() {
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else {
            ProgressHUDShow(text: "")
            FirebaseStoreManager.auth.sendPasswordReset(withEmail: sEmail!) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "RESET PASSWORD", message: "We have sent reset password link on your mail address.", shouldDismiss: false)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let sEmail = emailAddress.text?.trimmingCharacters(in: .nonBaseCharacters)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "")
            FirebaseStoreManager.auth.signIn(withEmail: sEmail!, password: sPassword!) { authResult, error in
                self.ProgressHUDHide()
                if error == nil {
                    if self.remeberMeCheck.isSelected {
                        UserDefaults.standard.set(true, forKey: "REMEMBER_USER")
                        UserDefaults.standard.set(sEmail, forKey:"USER_EMAIL")
                        UserDefaults.standard.set(sPassword, forKey:"PASSWORD")
                    }
                    else {
                        UserDefaults.standard.set(false, forKey: "REMEMBER_USER")
                        UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
                        UserDefaults.standard.removeObject(forKey: "PASSWORD")
                    }
                    self.getUserData(uid: FirebaseStoreManager.auth.currentUser!.uid, showProgress: true)
        
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
        
    }
    
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
    
}

extension SignInviewController  : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hidekeyboard()
        return true
    }
}

