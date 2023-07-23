//
//  EventDetailsViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 23/06/23.
//

import UIKit
import EventKit

class EventDetailsViewController : UIViewController {
    
    var eventModel : EventModel?
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var eventLinkStack: UIStackView!
    
    @IBOutlet weak var eventLinkName: UILabel!
    
    @IBOutlet weak var eventLink: UILabel!
    
  
    @IBOutlet weak var buyTicketBtn: UIView!
    
    @IBOutlet weak var hostView: UIView!
    
    @IBOutlet weak var hostProfile: UIImageView!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostUsername: UILabel!
   
    @IBOutlet weak var addToCalendar: UIView!
    
    @IBOutlet weak var viewHostProfileBtn: UIView!
    
    
    override func viewDidLoad() {
        
        guard let eventModel = eventModel else {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
            
        }
        
        addToCalendar.isUserInteractionEnabled = true
        addToCalendar.layer.cornerRadius = 8
        addToCalendar.dropShadow()
        addToCalendar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCalendarClicked)))
        
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
       
        eventLink.isUserInteractionEnabled = true
        eventLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eventLinkClicked)))
       
        buyTicketBtn.layer.cornerRadius = 8
        buyTicketBtn.isUserInteractionEnabled = true
        buyTicketBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buyTicketLinkClicked)))
        
        eventName.text = eventModel.name ?? ""
        
        startDate.text = self.convertDateFormater(eventModel.date ?? Date())
        if let time = eventModel.time {
            startTime.text = self.convertDateIntoTimeForRecurringVoucher(time)
        }
        else {
            startTime.isHidden = true
        }
     
        if eventModel.eventType == "online" {
            address.text = "Online"
            eventLinkStack.isHidden = false
            eventLinkName.text = eventModel.eventLinkName ?? "NIL"
            eventLink.text = eventModel.eventLink ?? "NIL"
        }
        else {
            eventLinkStack.isHidden = true
          address.text = eventModel.eventAddress ?? ""
        }
        
        if let buyTicketLink = eventModel.ticketLink, !buyTicketLink.isEmpty {
            buyTicketBtn.isHidden = false
           
        }
        else {
            buyTicketBtn.isHidden = true
        }
        
        eventImage.layer.cornerRadius = 8
       
        if let path = eventModel.eventImage, !path.isEmpty {
            eventImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "placeholder"))
        }
        
        self.hostView.layer.cornerRadius = 8
        self.hostProfile.layer.cornerRadius = 8
        
        self.viewHostProfileBtn.layer.cornerRadius = 8
        self.ProgressHUDShow(text: "")
        getHostData(uid: eventModel.uid ?? "123") { hostModel, error in
            self.ProgressHUDHide()
            if error != nil {
                self.dismiss(animated: true)
            }
            else {
                if let hostModel = hostModel {
                    let gest = MyGesture(target: self, action: #selector(self.hostViewClicked(value: )))
                    gest.userModel = hostModel
                    self.hostView.isUserInteractionEnabled = true
                    self.hostView.addGestureRecognizer(gest)
                    if let profilePath = hostModel.profilePic, !profilePath.isEmpty {
                        self.hostProfile.sd_setImage(with: URL(string: profilePath), placeholderImage: UIImage(named: "profile-placeholder"))
                    }
                    self.hostName.text = hostModel.fullName ?? ""
                    self.hostUsername.text = "@\(hostModel.userName ?? "")"
                    
                }
            }
        }
    }

    @objc func addToCalendarClicked(){
        let eventStore : EKEventStore = EKEventStore()
              
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                
                
                let event : EKEvent = EKEvent(eventStore: eventStore)
                
                var dayComponent    = DateComponents()
                dayComponent.minute    = -5 // For removing one day (yesterday): -1
                let theCalendar     = Calendar.current
                let previousDate        = theCalendar.date(byAdding: dayComponent, to: self.eventModel!.date ?? Date())
                
                dayComponent.minute    =  1// For removing one day (yesterday): -1
                let nextDate        = theCalendar.date(byAdding: dayComponent, to: self.eventModel!.date ?? Date())
                
                let predicate = eventStore.predicateForEvents(withStart: previousDate ?? Date(),  end: nextDate ?? Date(), calendars: nil)
                let existingEvents = eventStore.events(matching: predicate)
                
                let eventAlreadyExists = existingEvents.contains(where: {event in (self.eventModel!.name ?? "") == event.title && event.startDate == self.eventModel!.date ?? Date()})
                
                if eventAlreadyExists {
                    DispatchQueue.main.async {
                        self.showSnack(messages: "Event Already Added")
                    }
                }
                else {
                    event.title = self.eventModel!.name ?? ""
                    event.startDate = self.eventModel!.date ?? Date()
                    event.endDate = nextDate ?? Date()
                    event.notes = self.eventModel!.eventAddress ?? ""
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        
                        try eventStore.save(event, span: .thisEvent)
                        
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    DispatchQueue.main.async {
                        self.showSnack(messages: "Event Added")
                    }
                    
                }
                
            }
            else{
                
                self.showError("failed to save event with error : \(error!.localizedDescription) or access not granted")
            }
        }
    }
    
    @objc func buyTicketLinkClicked(){
        guard let url = URL(string: self.makeValidURL(urlString: eventModel!.ticketLink ?? "")) else { return}
        UIApplication.shared.open(url)
    }
    @objc func eventLinkClicked(){
        guard let url = URL(string: self.makeValidURL(urlString: eventModel!.eventLink ?? "")) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func hostViewClicked(value : MyGesture){
        performSegue(withIdentifier: "hostViewSeg", sender: value.userModel!)
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hostViewSeg" {
            if let VC = segue.destination as? ShowHostProfileViewController{
                if let hostModel = sender as? UserModel {
                    VC.hostModel = hostModel
                }
            }
        }
    }
}
