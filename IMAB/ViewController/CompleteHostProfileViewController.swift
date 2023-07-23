//
//  CompleteHostProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 06/05/23.
//

import UIKit
import CropViewController

class CompleteHostProfileViewController : UIViewController {
    
   
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var continueBtn: UIButton!
    var isImageSelected = false
 
    override func viewDidLoad() {
      
        profilePic.layer.cornerRadius = 8
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
        userName.setLeftPaddingPoints(16)
        userName.setRightPaddingPoints(10)
        userName.setLeftView(image: UIImage(named: "avatar-4")!)
        userName.delegate = self
        
        continueBtn.layer.cornerRadius = 8
        continueBtn.dropShadow()
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        let sUsername = userName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Picture")
        }
        else if sUsername == "" {
            showSnack(messages: "Enter Username")
        }
        else {
            ProgressHUDShow(text: "")
            
            FirebaseStoreManager.db.collection("Users").whereField("userName", isEqualTo: sUsername!).getDocuments { snapshot, error in
                
                if let snapshot = snapshot {
                    if snapshot.isEmpty {
                        self.uploadImageOnFirebase(uid: UserModel.data!.uid ?? "123") { downloadURL in
                            self.ProgressHUDHide()
                            if !downloadURL.isEmpty {
                                UserModel.data!.userName = sUsername
                                UserModel.data!.profilePic = downloadURL
                                
                                if UserModel.data!.professionalCat == "" {
                                   
                                }
                                else {
                                    self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                                }
                              
                                
                            }
                            
                        }
                    }
                    else {
                        self.ProgressHUDHide()
                        self.showSnack(messages: "Username is already linked with different account.")
                    }
                    
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
extension CompleteHostProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
extension CompleteHostProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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

