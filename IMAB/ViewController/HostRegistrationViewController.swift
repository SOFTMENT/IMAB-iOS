//
//  RegistrationViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit

import CropViewController

class HostRegistrationViewController : UIViewController {
    
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    
    
  
    

    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginNow: UILabel!
    
    var isImageSelected = false
    
    override func viewDidLoad() {
        
        profilePic.layer.cornerRadius = 8
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
        performSegue(withIdentifier: "hostSignInSeg", sender: nil)
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
            self.showSnack(messages: "Enter Full Name")
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
                                userData.fullName = sFullName
                                userData.host = true
                                userData.email = sEmail
                                userData.uid = FirebaseStoreManager.auth.currentUser!.uid
                                userData.registredAt = Date()
                                userData.regiType = "custom"
                                self.ProgressHUDShow(text: "")
                               
                                self.uploadImageOnFirebase(uid: userData.uid ?? "123") { downloadURL in
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
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Profile Picture"
            image.delegate = self
            image.sourceType = .camera
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
            
            self.present(image,animated: true)
            
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
    }
    
}

extension HostRegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}

extension HostRegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
        
        let storage = FirebaseStoreManager.storage.reference().child("ProfilePicture").child(uid).child("\(uid).png")
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

