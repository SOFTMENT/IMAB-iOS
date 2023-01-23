//
//  EventModel.swift
//  IMAB
//
//  Created by Vijay Rathore on 16/01/23.
//

import UIKit

class EventModel : NSObject, Codable {
    
    var id : String?
    var name : String?
    var address : String?
    var latitude : Double?
    var longitude : Double?
    var geoHash : String?
    
    
    var date : Date?
    var uid : String?
    var eventCreateDate : Date?
    var ticketLink : String?
    
}
