//
//  Event_TableView_Cell.swift
//  IMAB
//
//  Created by Vijay Rathore on 16/01/23.
//

import UIKit
import MapKit

class Event_TableView_Cell : UITableViewCell{
    
    
    
    @IBOutlet weak var mView: UIView!
    
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var addToCalendarView: UIView!
    override class func awakeFromNib() {
        
    }
    
    func setCoordinatesOnMap(with coordinates : CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
    
        let anonation = mapView.annotations
        mapView.removeAnnotations(anonation)
        
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(
                            center: coordinates,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.02,
                                longitudeDelta: 0.02)),
                            animated: true)
        mapView.isScrollEnabled = false
        
        
        
    }
}
