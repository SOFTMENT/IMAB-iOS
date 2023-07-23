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
    var userName : String?
    var email : String?
    var uid : String?
    var registredAt : Date?
    var regiType : String?
    var websiteURL : String? 
    var professionalCat : String?
    var myDescription : String?
    var host : Bool?
    var followers : Int?
    var latitude : Double?
    var longitude : Double?
    var geoHash : String?
    var disable : Bool?
    private static var userData : UserModel?
    
    static func clearUserData() {
        self.userData = nil
    }
    
    static var data : UserModel? {
        set(userData) {
            if self.userData == nil {
                self.userData = userData
            }
        
            
        }
        get {
            return userData
        }
    }


    override init() {
        
    }
    
}
