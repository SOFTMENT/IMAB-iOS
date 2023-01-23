//
//  RegistrationViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit
import Firebase
import CropViewController

class RegistrationViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var fullName: UITextField!
    

    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginNow: UILabel!
    
    var isImageSelected = false
    
    override func viewDidLoad() {
        
        profilePic.layer.cornerRadius = 12
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
       
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
        loginNow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        registerBtn.layer.cornerRadius = 12
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 12
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
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
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Picture")
        }
        else if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword  == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "Creating Account...")
            Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                self.ProgressHUDHide()
                if error == nil {
                    let userData = UserModel()
                    userData.fullName = sFullName
                    userData.email = sEmail
                    userData.uid = Auth.auth().currentUser!.uid
                    userData.registredAt = Date()
                    userData.regiType = "custom"
                    self.ProgressHUDShow(text: "")
                   
                    self.uploadImageOnFirebase(uid: Auth.auth().currentUser!.uid) { downloadURL in
                        self.ProgressHUDHide()
                        if !downloadURL.isEmpty {
                            userData.profilePic = downloadURL
                            self.addUserData(userData: userData)
                        }
                        
                    }
                
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
        
    }

    @objc func imageViewClicked(){
        chooseImageFromPhotoLibrary()
    }
    
    func chooseImageFromPhotoLibrary(){
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        self.present(image,animated: true)
    }
    
}

extension RegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}

extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1  , height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
            isImageSelected = true
            profilePic.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("ProfilePicture").child(uid).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        uploadData = (self.profilePic.image?.jpegData(compressionQuality: 0.5))!
        
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
}
