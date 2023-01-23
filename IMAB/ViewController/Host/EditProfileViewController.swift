//
//  EditProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 14/01/23.
//

import UIKit
import CropViewController
import Firebase

class EditProfileViewController : UIViewController {
    
    
    @IBOutlet weak var websiteLink: UITextField!
    
    @IBOutlet weak var twitterView: UIView!
    
    @IBOutlet weak var linkedinView: UIView!
    
    @IBOutlet weak var redditView: UIView!
    
    @IBOutlet weak var facebookView: UIView!
    
    @IBOutlet weak var instagramView: UIView!
    
    @IBOutlet weak var snapchatView: UIView!
    
    @IBOutlet weak var youtubeView: UIView!
    
    @IBOutlet weak var tiktokView: UIView!
    
    @IBOutlet weak var pintrestView: UIView!
    
    @IBOutlet weak var doneBtn: UIImageView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var myDescription: UITextView!
    
    @IBOutlet weak var addSocialLinkBtn: UIButton!
    
    override func viewDidLoad() {
        
        profilePic.layer.cornerRadius = 8
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        guard let userModel = UserModel.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        if let image = userModel.profilePic, !image.isEmpty {
            profilePic.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"), progress: .none)
        }
        
        addSocialLinkBtn.layer.cornerRadius = 8
        addSocialLinkBtn.dropShadow()
        
        fullName.delegate = self
        fullName.text = userModel.fullName ?? ""
        
        websiteLink.delegate = self
        websiteLink.text = userModel.websiteURL ?? ""
        
        myDescription.text = userModel.myDescription ?? ""
        myDescription.layer.cornerRadius = 8
        myDescription.layer.borderWidth = 1
        myDescription.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        myDescription.contentInset = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 6)
        
        doneBtn.isUserInteractionEnabled = true
        doneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        facebookView.isUserInteractionEnabled = true
        facebookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookViewClicked)))
        
        instagramView.isUserInteractionEnabled = true
        instagramView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramViewClicked)))
        
        twitterView.isUserInteractionEnabled = true
        twitterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterViewClicked)))
        
        tiktokView.isUserInteractionEnabled = true
        tiktokView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tikTokViewClicked)))
        
        youtubeView.isUserInteractionEnabled = true
        youtubeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtubeViewClicked)))
        
        pintrestView.isUserInteractionEnabled = true
        pintrestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pintrestViewClicked)))
        
        redditView.isUserInteractionEnabled = true
        redditView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redditViewClicked)))
        
        snapchatView.isUserInteractionEnabled = true
        snapchatView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(snapchatViewClicked)))
        
        linkedinView.isUserInteractionEnabled = true
        linkedinView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedinViewClicked)))
        
        ProgressHUDShow(text: "")
        self.getAllSocialMedia(uid:userModel.uid ?? "123") { socialMediaModel in
            self.ProgressHUDHide()
            if let socialMediaModel = socialMediaModel {
                for model in socialMediaModel {
                    if let name = model.name {
                        if name.contains(Constants.SocialMedia.Facebook) {
                            self.facebookView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.YouTube) {
                            self.youtubeView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Twitter) {
                            self.twitterView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.TikTok) {
                            self.tiktokView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Snapchat) {
                            self.snapchatView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Reddit) {
                            self.redditView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Pintrest) {
                            self.pintrestView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Instagram) {
                            self.instagramView.isHidden = false
                        }
                        else if name.contains(Constants.SocialMedia.Linkedin) {
                            self.linkedinView.isHidden = false
                        }
                        
                    }
                }
            }
            
            
        }
    }
    
    @objc func facebookViewClicked(){
        facebookView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Facebook).delete()
    }
    
    @objc func instagramViewClicked(){
        instagramView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Instagram).delete()
    }
    
    @objc func twitterViewClicked(){
        twitterView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Twitter).delete()
    }
    
    @objc func tikTokViewClicked(){
        tiktokView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.TikTok).delete()
    }
    
    @objc func youtubeViewClicked(){
        youtubeView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.YouTube).delete()
    }
    
    @objc func pintrestViewClicked(){
        pintrestView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Pintrest).delete()
    }
    
    @objc func redditViewClicked(){
        redditView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Reddit).delete()
    }
    
    @objc func snapchatViewClicked(){
        snapchatView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Snapchat).delete()
    }
    
    @objc func linkedinViewClicked(){
        linkedinView.isHidden = true
        Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").collection("SocialMedia").document(Constants.SocialMedia.Linkedin).delete()
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func addSocialLinkClicked(_ sender: Any) {
        performSegue(withIdentifier: "addSocialMediaSeg", sender: nil)
    }
    
    @objc func doneBtnClicked(){
        let sName = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDescription = myDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sWebsite = websiteLink.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if sName == "" {
            self.showSnack(messages: "Enter Full Name")
        }
        else if sDescription == "" {
            self.showSnack(messages: "Enter Description")
        }
        else if sWebsite == "" {
            self.showSnack(messages: "Enter Website")
        }
        
        else {
            self.ProgressHUDShow(text: "")
            UserModel.data!.fullName = sName
            UserModel.data!.myDescription = sDescription
            UserModel.data!.websiteURL = sWebsite
            
            
            try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!, merge : true,completion: { error in
                if let error = error {
                    self.showSnack(messages: error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Profile Updated")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.hostProfileViewController)
                    }
                }
            })
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

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
        
            profilePic.image = image
       
        self.uploadImageOnFirebase(uid: UserModel.data!.uid ?? "123") { downloadURL in
            
            if !downloadURL.isEmpty {
                UserModel.data!.profilePic = downloadURL
                try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!,merge : true)
            }
            
        }
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
