//
//  HostModel.swift
//  IMAB
//
//  Created by Vijay Rathore on 17/01/23.
//


import UIKit

class HostModel : NSObject, Codable {
    
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
    private static var hostData : HostModel?
   
    static var data : HostModel? {
        set(hostData) {
            self.hostData = hostData
        }
        get {
            return hostData
        }
    }


    override init() {
        
    }
    
}
