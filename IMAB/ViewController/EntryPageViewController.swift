//
//  EntryPageViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 18/04/23.
//

import UIKit

class EntryPageViewController : UIViewController {
    @IBOutlet weak var fanAccountBtn: UIButton!
    @IBOutlet weak var hostAccountBtn: UIButton!
    @IBOutlet weak var loginNow: UILabel!
    override func viewDidLoad() {
        fanAccountBtn.layer.cornerRadius = 8
        fanAccountBtn.dropShadow()
        
        hostAccountBtn.layer.cornerRadius = 8
        hostAccountBtn.dropShadow()
  
        loginNow.isUserInteractionEnabled = true
        loginNow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginNowBtnClicked)))
    }
    
    @objc func loginNowBtnClicked(){
        self.performSegue(withIdentifier: "signinSeg", sender: nil)
    
    }
    
    @IBAction func fanAccountClicked(_ sender: Any) {
        performSegue(withIdentifier: "signUpFanSeg", sender: nil)
    }
    
    @IBAction func hostAccountClicked(_ sender: Any) {
        performSegue(withIdentifier: "signUpHostSeg", sender: nil)
    }
    
    
    
}
