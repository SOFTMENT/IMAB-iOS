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
    var date : Date?
    var time : Date?
    var dateTime : Date?
    var eventLinkName : String?
    var eventLink : String?
    var eventAddress : String?
    
    var latitude : Double?
    var longitude : Double?
    var geoHash : String?  
 
    var uid : String?
    var hostName : String?
    var eventCreateDate : Date?
    var ticketLink : String?
    var fontType : String?
    var eventType : String?
    var eventImage : String?
    
}
