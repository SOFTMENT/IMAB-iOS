//
//  ProfileViewControlelr.swift
//  IMAB
//
//  Created by Vijay Rathore on 13/01/23.
//


import UIKit
import StoreKit
import CropViewController
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var switchToHost: UIView!
    @IBOutlet weak var manageProfilesAndEventsView: UIView!
    @IBOutlet weak var deleteAccountBtn: UIView!
    @IBOutlet weak var goPremiumView: UIView!
    @IBOutlet weak var goPremiumTitle: UILabel!
    @IBOutlet weak var termsOfService: UIView!
    @IBOutlet weak var privacy: UIView!
    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var inviteFriends: UIView!
    @IBOutlet weak var rateApp: UIView!
    @IBOutlet weak var helpCentre: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var logout: UIView!
    
    var isImageSelected = false
    
    
    override func viewDidLoad() {
        
        profileImage.makeRounded()
        
        
        guard let user = UserModel.data else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        
        name.text = user.fullName ?? "Full Name"
        email.text = user.email
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
        if let image = user.profilePic, image != "" {
            profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
        }
        
        
        
        rateApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateAppBtnClicked)))
        inviteFriends.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriendBtnClicked)))
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "\(appVersion ?? "1.0")"
        
        privacy.isUserInteractionEnabled = true
        privacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfService.isUserInteractionEnabled = true
        termsOfService.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        //Logout
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnClicked)))
        
        
        //HelpCentre
        helpCentre.isUserInteractionEnabled = true
        helpCentre.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helpCentreBtnClicked)))
        
        goPremiumView.layer.cornerRadius = 8
        
        //SwitchToHost
        switchToHost.isUserInteractionEnabled = true
        switchToHost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchToHostClicked)))
        
        //DELETE ACCOUNT
        
        deleteAccountBtn.isUserInteractionEnabled = true
        deleteAccountBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountBtnClicked)))
        
        
        if let expireDate = Constants.expireDate {
            
            manageProfilesAndEventsView.isUserInteractionEnabled = true
            manageProfilesAndEventsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageProfilesAndEventsViewClicked)))
            manageProfilesAndEventsView.isHidden = false
            goPremiumView.isHidden = false
            let daysleft = self.membershipDaysLeft(currentDate: Date(), expireDate: expireDate) + 1
            if daysleft > 1 {
                self.goPremiumTitle.text = "\(daysleft) Days Left"
            }
            else {
                self.goPremiumTitle.text = "\(daysleft) Day Left"
            }
            goPremiumView.isHidden = false
            manageProfilesAndEventsView.isHidden = false
        }
        else {
            goPremiumView.isHidden = true
            manageProfilesAndEventsView.isHidden = true
        }
        
        
        if let host = user.host, host {
            switchToHost.isHidden = true
            goPremiumView.isHidden = false
            manageProfilesAndEventsView.isHidden = false
        }
        else {
            switchToHost.isHidden = false
            goPremiumView.isHidden = true
            manageProfilesAndEventsView.isHidden = true
        }
        
    }
    
    @objc func switchToHostClicked(){
        ProgressHUDShow(text: "")
        FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").setData(["host": true],merge: true) { error in
            self.ProgressHUDHide()
           
            let uid = UserModel.data!.uid ?? "123"
            UserModel.clearUserData()
            self.getUserData(uid: uid, showProgress: true)
        }
    }
    
    @objc func manageProfilesAndEventsViewClicked(){
        self.beRootScreen(mIdentifier: Constants.StroyBoard.hostProfileViewController)
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

    @objc func deleteAccountBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            if let user = Auth.auth().currentUser {
                
                self.ProgressHUDShow(text: "Account Deleting...")
                let userId = user.uid
                FirebaseStoreManager.db.collection("Users").document(userId).setData(["disable":true],merge: true) { error in
                    self.ProgressHUDHide()
                    UserModel.clearUserData()
                    if error == nil {
                        self.logout()
                        
                    }
                    else {
                      
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                    }
                    
                }
                
                
            }
            
            
        }))
        present(alert, animated: true)
    }
    
  
  
    @objc func helpCentreBtnClicked(){
        
        
        if let url = URL(string: "mailto:support@imabapp.com") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    

    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/consent/privacy_policy.pdf") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func inviteFriendBtnClicked(){
        
        let someText:String = "Check Out IMAB App Now."
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/IMAB/id1659287178?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rateAppBtnClicked(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1659287178") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func logoutBtnClicked(){
        
        let alert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    

}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
            profileImage.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String,completion : @escaping (String) -> Void ) {
        
        let storage = FirebaseStoreManager.storage.reference().child("ProfilePicture").child(uid).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        uploadData = (self.profileImage.image?.jpegData(compressionQuality: 0.5))!
        
    
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
