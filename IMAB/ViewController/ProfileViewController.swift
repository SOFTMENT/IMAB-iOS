//
//  ProfileViewControlelr.swift
//  IMAB
//
//  Created by Vijay Rathore on 13/01/23.
//

import UIKit
import Firebase
import RevenueCat

class ProfileViewController : UIViewController {
    
    
    @IBOutlet weak var hostView: UIView!
    
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var shareAppView: UIView!
    
    @IBOutlet weak var privacyView: UIView!
    
    
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var version: UILabel!
    var offering : Offering?
    @IBOutlet weak var goPremiumView: UIView!
    @IBOutlet weak var goPremiumText: UILabel!
    @IBOutlet weak var goPremiumLogo: UIImageView!
    let membershipVC = MembershipOverlayViewController()

    
    override func viewDidLoad() {
        hostView.layer.cornerRadius = 8
        helpView.layer.cornerRadius = 8
        privacyView.layer.cornerRadius = 8
        deleteView.layer.cornerRadius = 8
        logoutView.layer.cornerRadius = 8
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "Version - \(appVersion ?? "1.0")"
        
        privacyView.isUserInteractionEnabled = true
        privacyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        helpView.isUserInteractionEnabled = true
        helpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helpCentreBtnClicked)))
        
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnClicked)))
        
        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountBtnClicked)))
        
        shareAppView.isUserInteractionEnabled = true
        shareAppView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriendBtnClicked)))
        
        goPremiumView.layer.cornerRadius = 6
        goPremiumView.isUserInteractionEnabled = true
        goPremiumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMembershipClicked)))
        
        hostView.isUserInteractionEnabled = true
        hostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hostBtnClicked)))
     
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                 let expireDate = customerInfo?.entitlements.all["Premium"]?.expirationDate ?? Date()
                let daysleft = self.membershipDaysLeft(currentDate: Date(), expireDate: expireDate) + 1
                self.goPremiumLogo.image = UIImage(named: "clock")
                if daysleft > 1 {
                    self.goPremiumText.text = "\(daysleft) Days Left"
                   
                }
                else {
                    self.goPremiumText.text = "\(daysleft) Day Left"
                    
                }
              
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
    
    @objc func hostBtnClicked(){
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                                self.membershipVC.modalPresentationStyle = .custom
                                self.membershipVC.transitioningDelegate = self
                                self.present(self.membershipVC, animated: true, completion: nil)
            }
            else {
                if let userModel = UserModel.data, let mDesc = userModel.myDescription , !mDesc.isEmpty {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.hostProfileViewController)
                }
                else {
                    self.performSegue(withIdentifier: "editProfileSeg", sender: nil)
                }
            }
        }
        
    }
    
    func restorePurchase() {
        ProgressHUDShow(text: "Restoring...")
    
        Purchases.shared.restorePurchases { (customerInfo, error) in
            self.ProgressHUDHide()
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                self.showSnack(messages: "Restored")
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
                            UserModel.data!.host = true
                            try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!, merge : true)
                            self.showSnack(messages: "Purchased")
                        }
                        else {
                            self.showError(error!.localizedDescription)
                        }
                    }
                    
                }
            }
            
            
        }
    }
    @objc func goMembershipClicked(){
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Premium"]?.isActive != true {
                                self.membershipVC.modalPresentationStyle = .custom
                                self.membershipVC.transitioningDelegate = self
                                self.present(self.membershipVC, animated: true, completion: nil)
            }
            
        }
    }
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func inviteFriendBtnClicked(){
        
        let someText:String = "Check Out IMAB App Now."
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/imab/id1659287178?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
    @objc func logoutBtnClicked(){
        
        let alert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
      
    }

    @objc func deleteAccountBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            if let user = Auth.auth().currentUser {
                
                self.ProgressHUDShow(text: "Account Deleting...")
                let userId = user.uid
                
                        Firestore.firestore().collection("Users").document(userId).delete { error in
                           
                            if error == nil {
                                user.delete { error in
                                    self.ProgressHUDHide()
                                    if error == nil {
                                        self.logout()
                                        
                                    }
                                    else {
                                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                                    }
    
                                
                                }
                                
                            }
                            else {
                       
                                self.showError(error!.localizedDescription)
                            }
                        }
                    
                }
            
            
        }))
        present(alert, animated: true)
    }
       
}
extension ProfileViewController : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
     
        return MembershipPresentationController(presentedViewController: presented, presenting: presenting,profileVC: self)

       
 
    }

}
