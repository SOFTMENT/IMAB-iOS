//
//  MembershipOverlayViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 13/01/23.
//

import UIKit

class MembershipOverlayViewController: UIViewController {

    @IBOutlet weak var activateNowBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UILabel!
    @IBOutlet weak var termsOfUseBtn: UILabel!
 
    
    @IBOutlet weak var restoreBtn: UILabel!
    @IBOutlet weak var slide: UIView!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
       
        slide.roundCorners(corners: .allCorners, radius: 10)
     
      
        activateNowBtn.isUserInteractionEnabled = true
        activateNowBtn.layer.cornerRadius = 8
        
        privacyPolicyBtn.isUserInteractionEnabled = true
        termsOfUseBtn.isUserInteractionEnabled = true
        
    
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
    
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }

}
