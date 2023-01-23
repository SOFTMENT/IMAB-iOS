//
//  Constants.swift
//  eventkreyol
//
//  Created by Vijay Rathore on 18/07/21.
//

import Foundation
import UIKit
import CoreLocation

struct Constants {
   
    
    struct StroyBoard {
        
        static let signInViewController = "signInVC"
        static let tabBarViewController = "tabbarVC"
        static let hostProfileViewController = "hostProfileVC"
        
    }
    
    struct SocialMedia {
        static let Facebook = "Facebook"
        static let Instagram = "Instagram"
        static let Linkedin = "Linkedin"
        static let Pintrest  = "Pintrest"
        static let Reddit = "Reddit"
        static let Snapchat = "Snapchat"
        static let TikTok = "TikTok"
        static let Twitter = "Twitter"
        static let YouTube = "YouTube"
        
    }

    public static var currentDate = Date()
    public static var selectedIndex = 0
    
    public static var latitude = 0.0
    public static var longitude = 0.0

}


