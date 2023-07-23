//
//  EditProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 14/01/23.
//

import UIKit
import CropViewController
import RevenueCat


class UpdateProfileViewController : UIViewController {
    
    let selectCateogryPicker = UIPickerView()
    @IBOutlet weak var userName: UITextField!
    
    
    @IBOutlet weak var professionalCategory: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    var isImageSelected = false
    
    @IBOutlet weak var myDescription: UITextView!
    @IBOutlet weak var continueBtn: UIButton!
    let membershipVC = MembershipOverlayViewController()
    var offering : Offering?
    
    override func viewDidLoad() {
     
        
        guard let userModel = UserModel.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        if let image = userModel.profilePic, !image.isEmpty {
            self.isImageSelected = true
            profilePic.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"), progress: .none)
        }
        
        
        profilePic.layer.cornerRadius = 8
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
        continueBtn.layer.cornerRadius = 8
        continueBtn.dropShadow()
     
    
       
        
        userName.delegate = self
        
        professionalCategory.delegate = self
        professionalCategory.setRightIcons(icon: UIImage(named: "down-arrow")!)
        professionalCategory.rightView?.isUserInteractionEnabled = false
        
        selectCateogryPicker.delegate = self
        selectCateogryPicker.dataSource = self
        
        // ToolBar
        let selectCategoryBar = UIToolbar()
        selectCategoryBar.barStyle = .default
        selectCategoryBar.isTranslucent = true
        selectCategoryBar.tintColor = .link
        selectCategoryBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(categoryPickerDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(categoryPickerCancelClicked))
        selectCategoryBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        selectCategoryBar.isUserInteractionEnabled = true
        professionalCategory.inputAccessoryView = selectCategoryBar
        professionalCategory.inputView = selectCateogryPicker
    
        myDescription.text = userModel.myDescription ?? ""
        myDescription.layer.cornerRadius = 8
        myDescription.layer.borderWidth = 1
        myDescription.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        myDescription.contentInset = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 6)
        
       
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        Purchases.shared.getCustomerInfo { (customerInfo, error) in
                if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                  
                }
                else {
                    Purchases.shared.getOfferings { (offerings, error) in
                        if let offer = offerings?.current, error == nil  {
                            self.offering = offer
                        }
                            
                    }
                }
                
        }
      
    }
    @objc func categoryPickerDoneClicked(){
        professionalCategory.resignFirstResponder()
        let row = selectCateogryPicker.selectedRow(inComponent: 0)
        professionalCategory.text = Constants.professionalCategories[row]
      
    }
    
    @objc func categoryPickerCancelClicked(){
        self.view.endEditing(true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        let sUsername = userName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sProfessionalCategory = professionalCategory.text
        let sDescription = myDescription.text
        
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Picture")
        }
        else if sUsername == "" {
            self.showSnack(messages: "Enter Username")
        }
        else if sProfessionalCategory == "" {
            self.showSnack(messages: "Enter Professional Category")
        }
        else if sDescription == "" {
            self.showSnack(messages: "Enter Description")
        }
        else  {
            ProgressHUDShow(text: "")
          
            FirebaseStoreManager.db.collection("Users").whereField("userName", isEqualTo: sUsername!).getDocuments { snapshot, error in
          
                if let snapshot = snapshot {
                    if snapshot.isEmpty {
                        UserModel.data!.professionalCat = sProfessionalCategory
                        UserModel.data!.myDescription = sDescription
                        UserModel.data!.userName = sUsername
                      
                        self.uploadImageOnFirebase(uid: UserModel.data!.uid ?? "123") { downloadURL in
                          
                            if !downloadURL.isEmpty {
                                UserModel.data!.profilePic = downloadURL
                                
                                try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!, merge: true,completion: { error in
                                    self.ProgressHUDHide()
                                    if let error = error {
                                        self.showError(error.localizedDescription)
                                    }
                                    else {
                                        Constants.expireDate = Date().addingTimeInterval(1000000);
                                        self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                                        
                    //                    self.membershipVC.modalPresentationStyle = .custom
                    //                    self.membershipVC.transitioningDelegate = self
                    //                    self.present(self.membershipVC, animated: true, completion: nil)
                                    }
                                })

                            }
                            
                        }
                    }
                    else {
                        self.ProgressHUDHide()
                        self.showSnack(messages: "Username already linked with different account.")
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
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func restorePurchase() {
        ProgressHUDShow(text: "Restoring...")
    
        Purchases.shared.restorePurchases { (customerInfo, error) in
            self.ProgressHUDHide()
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                Constants.expireDate = customerInfo?.entitlements.all["Premium"]?.expirationDate ?? Date()
                self.performSegue(withIdentifier: "successSeg", sender: nil)
            }
            else {
                self.showSnack(messages: "There is no active subscription found")
            }
        }
    }
    
    func purchaseMembershipBtnTapped() {
            
      
            purchase()
      

    }
    
    func purchase(){
        
        if let offering = self.offering {
            if offering.availablePackages.count > 0 {
                if let firstPack =  offering.availablePackages.first {
                    self.ProgressHUDShow(text: "Purchasing...")
                    Purchases.shared.purchase(package: firstPack) { (transaction, customerInfo, error, userCancelled) in
                        self.ProgressHUDHide()
                        if !userCancelled && error == nil {
                            Constants.expireDate = customerInfo?.entitlements.all["Premium"]?.expirationDate ?? Date()
                            self.performSegue(withIdentifier: "successSeg", sender: nil)
                        }
                        else {
                            self.showError(error!.localizedDescription)
                        }
                    }
                    
                }
            }
            
            
        }
    }
    
}

extension UpdateProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == professionalCategory
        {
            return false
        }
        
        
        return true
        
    }
}
extension UpdateProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.professionalCategories.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        
            return Constants.professionalCategories[row]
        

    }

}
extension UpdateProfileViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {


        return MembershipPresentationController(presentedViewController: presented, presenting: presenting,updateProfile: self)

    }

    
}
extension UpdateProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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

