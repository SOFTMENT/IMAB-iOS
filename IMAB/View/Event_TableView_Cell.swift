//
//  Event_TableView_Cell.swift
//  IMAB
//
//  Created by Vijay Rathore on 16/01/23.
//

import UIKit
import MapKit

class Event_TableView_Cell : UITableViewCell{
    
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var addressIcon: UIImageView!
    
    
    @IBOutlet weak var addEventToCalendar: UIView!
    @IBOutlet weak var buyTickets: UIView!
    
    override class func awakeFromNib() {
        
    }
    
}
