//
//  MyEventViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 17/05/23.
//

import UIKit
import EventKit

class MyEventViewController : UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var liveEvent: UIStackView!
    
    @IBOutlet weak var onlineLine: UIView!
    @IBOutlet weak var liveLine: UIView!

    @IBOutlet weak var allLine: UIView!
    
    @IBOutlet weak var allEvents: UIStackView!
    @IBOutlet weak var onlineContent: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noEventsAvailable: UILabel!
    var eventModels = Array<EventModel>()
    var filterModels = Array<EventModel>()
    var type : String = "live"
    override func viewDidLoad() {
    
        dateView.layer.cornerRadius = 8
        dateView.dropShadow()
        
        clearAllLine(eventType: .LIVE)
        
        liveLine.layer.cornerRadius = 4
        
        onlineLine.layer.cornerRadius = 4
        
        allLine.layer.cornerRadius = 4
      
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.locale = .current
        
        liveEvent.isUserInteractionEnabled = true
        liveEvent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(liveEventClicked)))
        
        onlineContent.isUserInteractionEnabled = true
        onlineContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onlineEventClicked)))
        
        allEvents.isUserInteractionEnabled = true
        allEvents.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allEventsClicked)))
        
        
        let startDate = Date().setTime(hour: 0, min: 0)
        let endDate = Date().setTime(hour: 23, min: 59)
       getEventForDate(startDate: startDate ?? Date(), endDate: endDate ?? Date())
        
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    func getEventForDate(startDate : Date, endDate : Date){
        self.ProgressHUDShow(text: "")
        FirebaseStoreManager.db.collection("Events").order(by: "dateTime").whereField("dateTime", isGreaterThanOrEqualTo: startDate).whereField("dateTime", isLessThanOrEqualTo: endDate).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.eventModels.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let eventModel = try? qdr.data(as: EventModel.self) {
                            self.eventModels.append(eventModel)
                        }
                    }
                }
                self.filterEvents(type: self.type)
            }
        }
        
       
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        
        print(datePicker.date)
        let startDate = picker.date.setTime(hour: 0, min: 0)
        let endDate = picker.date.setTime(hour: 23, min: 59)
       getEventForDate(startDate: startDate ?? Date(), endDate: endDate ?? Date())
    }
    
    func filterEvents(type : String){
        filterModels.removeAll()
        if type == "online" {
            filterModels.append(contentsOf: self.eventModels.filter({ eventModel in
                if eventModel.eventType == "online" {
                    return true
                }
                return false
            }))
        }
        else if type == "live" {
            filterModels.append(contentsOf: self.eventModels.filter({ eventModel in
                if eventModel.eventType == "live" {
                    return true
                }
                return false
            }))
        }
        else {
            self.filterModels.append(contentsOf: eventModels)
        }
        self.tableView.reloadData()
    }
    
    @objc func liveEventClicked(){
        type = "live"
        filterEvents(type: type)
        clearAllLine(eventType: .LIVE)
    }
    
    @objc func onlineEventClicked(){
        type = "online"
        filterEvents(type: type)
        clearAllLine(eventType: .ONLINE)
    }
    
    @objc func allEventsClicked() {
        type = "all"
        filterEvents(type: type)
        clearAllLine(eventType: .ALL)
    }
    @objc func buyTicketsClicked(value : MyGesture){
        guard let url = URL(string: self.makeValidURL(urlString: eventModels[value.index].ticketLink ?? "")) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func addToCalendar(gest : MyGesture) {
      
        
        let eventStore : EKEventStore = EKEventStore()
              
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {
              
              let eventModel = self.eventModels[gest.index]
              let event : EKEvent = EKEvent(eventStore: eventStore)
              
              var dayComponent    = DateComponents()
              dayComponent.minute    = -5 // For removing one day (yesterday): -1
              let theCalendar     = Calendar.current
              let previousDate        = theCalendar.date(byAdding: dayComponent, to: eventModel.date ?? Date())
              
              dayComponent.minute    =  1// For removing one day (yesterday): -1
              let nextDate        = theCalendar.date(byAdding: dayComponent, to: eventModel.date ?? Date())
              
              let predicate = eventStore.predicateForEvents(withStart: previousDate ?? Date(),  end: nextDate ?? Date(), calendars: nil)
              let existingEvents = eventStore.events(matching: predicate)

              let eventAlreadyExists = existingEvents.contains(where: {event in (eventModel.name ?? "") == event.title && event.startDate == eventModel.date ?? Date()})
              
              if eventAlreadyExists {
                  DispatchQueue.main.async {
                      self.showSnack(messages: "Event Already Added")
                  }
              }
              else {
                  event.title = eventModel.name ?? ""
                  event.startDate = eventModel.date ?? Date()
                  event.endDate = nextDate ?? Date()
                  event.notes = eventModel.eventAddress ?? ""
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
    
    func clearAllLine(eventType : EventType){
        liveLine.backgroundColor = .clear
        onlineLine.backgroundColor = .clear
        allLine.backgroundColor = .clear
        
        switch eventType {
        case .LIVE:
            liveLine.backgroundColor = UIColor(red: 247/255, green: 79/255, blue: 85/255, alpha: 1)
        case .ONLINE:
            onlineLine.backgroundColor = UIColor(red: 247/255, green: 79/255, blue: 85/255, alpha: 1)
        case .ALL:
            allLine.backgroundColor = UIColor(red: 247/255, green: 79/255, blue: 85/255, alpha: 1)
        }
    }
    @objc func cellClicked(gest : MyGesture) {
        performSegue(withIdentifier: "calendarEventDetailsSeg", sender: filterModels[gest.index])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarEventDetailsSeg" {
            if let VC = segue.destination as? EventDetailsViewController {
                if let eventModel = sender as? EventModel {
                    VC.eventModel = eventModel
                }
            }
        }
    }
}

extension MyEventViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noEventsAvailable.isHidden = filterModels.count > 0 ? true : false
        return filterModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? Event_TableView_Cell {
            
            
            
            cell.mView.layer.cornerRadius = 8
            cell.mView.isUserInteractionEnabled = true
            let myGest = MyGesture(target: self, action: #selector(cellClicked(gest: )))
            myGest.index = indexPath.row
            cell.mView.addGestureRecognizer(myGest)
            
            let eventModel = filterModels[indexPath.row]
            cell.eventName.text = eventModel.name ?? ""
            
            cell.addEventToCalendar.isUserInteractionEnabled = true
            cell.addEventToCalendar.layer.cornerRadius = 8
            let calendarGest = MyGesture(target: self, action: #selector(addToCalendar(gest:)))
            calendarGest.index = indexPath.row
            cell.addEventToCalendar.addGestureRecognizer(calendarGest)
            
            if let ticket = eventModel.ticketLink, !ticket.isEmpty {
                cell.buyTickets.isHidden = false
            }
            else {
                cell.buyTickets.isHidden = true
            }
            
            cell.buyTickets.isUserInteractionEnabled = true
            cell.buyTickets.layer.cornerRadius = 8
            let ticketGest = MyGesture(target: self, action: #selector(buyTicketsClicked(value: )))
            ticketGest.index = indexPath.row
            cell.buyTickets.addGestureRecognizer(ticketGest)
            
            cell.eventDate.text = self.convertDateFormater(eventModel.date ?? Date())
            if let time = eventModel.time {
                cell.eventTime.text = self.convertDateIntoTimeForRecurringVoucher(time)
            }
            else {
                cell.eventTime.isHidden = true
            }
         
            if eventModel.eventType == "online" {
                cell.eventAddress.text = "Online"
            }
            else {
                cell.eventAddress.text = eventModel.eventAddress ?? ""
            }
            
            cell.eventImage.layer.cornerRadius = 8
           
            if let path = eventModel.eventImage, !path.isEmpty {
                cell.eventImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "placeholder"))
            }
           
           
            
            return cell
            
        }
        return Event_TableView_Cell()
        
    }
    
    
    
    
}
                 


enum EventType {
    case LIVE
    case ONLINE
    case ALL
}
