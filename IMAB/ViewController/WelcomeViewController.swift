//
//  ViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit



class WelcomeViewController :  UIViewController {
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        
        //SUBSCRIBE TO TOPIC
        FirebaseStoreManager.message.subscribe(toTopic: "imab"){ error in
            if error == nil{
                print("Subscribed to topic")
            }
            else{
                print("Not Subscribed to topic")
            }
        }
        
        
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            do {
                try FirebaseStoreManager.auth.signOut()
            }catch {
                
            }
            // go to beginning of app
        }
        
        if FirebaseStoreManager.auth.currentUser != nil {
            self.getUserData(uid: FirebaseStoreManager.auth.currentUser!.uid, showProgress: false)
       
        }
        else {
            gotoSignInViewController()
        }
        
        
        
        
    }
    
    func gotoSignInViewController(){
        DispatchQueue.main.async {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.entryViewController)
        }
    }
    
}

