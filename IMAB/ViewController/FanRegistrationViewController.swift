//
//  RegistrationViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit


class FanRegistrationViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginNow: UILabel!
    
  
    
    override func viewDidLoad() {
        

       
        
        fullName.setLeftPaddingPoints(16)
        fullName.setRightPaddingPoints(10)
        fullName.setLeftView(image: UIImage(named: "avatar-4")!)
        fullName.delegate = self
        
 
        emailAddress.setLeftPaddingPoints(16)
        emailAddress.setRightPaddingPoints(10)
        emailAddress.setLeftView(image: UIImage(named: "email-5")!)
        emailAddress.delegate = self
        
        password.setLeftPaddingPoints(16)
        password.setRightPaddingPoints(10)
        password.setLeftView(image: UIImage(named: "padlock-3")!)
        password.delegate = self
        
        loginNow.isUserInteractionEnabled = true
        loginNow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginBtnClicked)))
        
        
        registerBtn.layer.cornerRadius = 12
        registerBtn.dropShadow()
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 12
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func loginBtnClicked(){
        performSegue(withIdentifier: "fanSignInSeg", sender: nil)
    }
    
   
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        
        let sFullName = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword  == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            
            self.ProgressHUDShow(text: "Creating Account...")
            
            FirebaseStoreManager.auth.createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                self.ProgressHUDHide()
                if error == nil {
                    let userData = UserModel()
                    userData.host = false
                    userData.fullName = sFullName
                    userData.email = sEmail
                    userData.uid = FirebaseStoreManager.auth.currentUser!.uid
                    userData.registredAt = Date()
                    userData.regiType = "custom"
                    self.ProgressHUDShow(text: "")
                    self.addUserData(userData: userData)
                   
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
           
        }
        
    }

 
}

extension FanRegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}

