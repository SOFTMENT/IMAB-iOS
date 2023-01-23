//
//  UserModel.swift
//  IMAB
//
//  Created by Vijay Rathore on 11/12/22.
//

import UIKit

class UserModel : NSObject, Codable {
    
    var profilePic : String?
    var fullName : String?
    var email : String?
    var uid : String?
    var registredAt : Date?
    var regiType : String?
    var websiteURL : String? 
    
    var myDescription : String?
    var host : Bool?
    
    var address : String?
    var geoHash : String?
    var eventDate : Date?
    var totalEvents : Int?
    var latitude : Double?
    var longitude : Double?

    var followers : Int?
    private static var userData : UserModel?
   
    static var data : UserModel? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }


    override init() {
        
    }
    
}
