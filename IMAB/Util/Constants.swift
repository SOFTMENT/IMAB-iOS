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
        static let entryViewController = "entryVC"
        static let updateHostProfileController = "updateHostProfileVC"
    }
    
 

    public static var currentDate = Date()
    public static var expireDate : Date?
    public static var selectedIndex = 0
    
    public static var latitude = 0.0
    public static var longitude = 0.0

    public static var professionalCategories = ["Actor","Auther", "Business/Brand","Business Professional","Comedian","Entrepreneur","Influencer","Musician","Podcast Host","Politician","Religious Speaker"]
}


enum SocialMedia : String{
   
    
    case Twitter
    case Instagram
    case TikTok
    case Facebook
    case YouTube
    case Rumble
    case Twitch
    case Reddit
    case Substack
    case Tumblr
    case Discord
    case Telegram
    case TruthSocial = "Truth Social"
    case Mastodon
    case Pinterest
    case Etsy
    case LinkedIn
    case Whatsapp
 
}
