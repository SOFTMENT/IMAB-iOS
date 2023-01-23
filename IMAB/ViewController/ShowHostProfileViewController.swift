//
//  ShowHostProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 18/01/23.
//

import UIKit
import Firebase
import CoreLocation
import GeoFire
import EventKit

class ShowHostProfileViewController : UIViewController {
    
    
    @IBOutlet weak var addAllEventsToCalendar: UILabel!
    
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
 
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followersView: UIView!
    
    @IBOutlet weak var mDescription: UILabel!


    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var twitterView: UIView!
    
    @IBOutlet weak var linkedinView: UIView!
    
    @IBOutlet weak var redditView: UIView!
    
    @IBOutlet weak var facebookView: UIView!
    
    @IBOutlet weak var instagramView: UIView!
    
    @IBOutlet weak var snapchatView: UIView!
    
    @IBOutlet weak var youtubeView: UIView!
    
    @IBOutlet weak var tiktokView: UIView!
    
    @IBOutlet weak var pintrestView: UIView!
    
    var facebookURL = ""
    var twitterURL = ""
    var linkedinURL = ""
    var redditURL = ""
    var instagramURL = ""
    var snapchatURL = ""
    var youtubeURL = ""
    var tiktokURL = ""
    var pintrestURL = ""
    
    var socialMediaModels : Array<SocialMediaModel>?
    var eventModels = Array<EventModel>()
    var hostModel : HostModel?
    override func viewDidLoad() {
        
        guard let hostModel = hostModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        profileImg.layer.cornerRadius = 8
        
        if let image = hostModel.profilePic, !image.isEmpty {
            profileImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"), progress: .none)
        }
        
    
        website.text = hostModel.websiteURL ?? ""
        website.isUserInteractionEnabled = true
        website.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(websiteClicked)))
        
        profileName.text = hostModel.fullName ?? ""
        mDescription.text = hostModel.myDescription ?? ""
        
        followersView.layer.cornerRadius = 6
      
        
        facebookView.isUserInteractionEnabled = true
        facebookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookViewClicked)))
        
        instagramView.isUserInteractionEnabled = true
        instagramView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramViewClicked)))
        
        twitterView.isUserInteractionEnabled = true
        twitterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterViewClicked)))
        
        tiktokView.isUserInteractionEnabled = true
        tiktokView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tikTokViewClicked)))
        
        youtubeView.isUserInteractionEnabled = true
        youtubeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtubeViewClicked)))
        
        pintrestView.isUserInteractionEnabled = true
        pintrestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pintrestViewClicked)))
        
        redditView.isUserInteractionEnabled = true
        redditView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redditViewClicked)))
        
        snapchatView.isUserInteractionEnabled = true
        snapchatView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(snapchatViewClicked)))
        
        linkedinView.isUserInteractionEnabled = true
        linkedinView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedinViewClicked)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        backView.layer.cornerRadius = 8
        
      
        
        ProgressHUDShow(text: "")
        self.getAllSocialMedia(uid:hostModel.uid ?? "123") { sModel in
            self.ProgressHUDHide()
            if let socialMediaModel = sModel {
                self.socialMediaModels = sModel
                for model in socialMediaModel {
                
                    if let name = model.name {
                        if name.contains(Constants.SocialMedia.Facebook) {
                            self.facebookView.isHidden = false
                            self.facebookURL = model.link ?? ""
                        
                        }
                        else if name.contains(Constants.SocialMedia.YouTube) {
                            self.youtubeView.isHidden = false
                            self.youtubeURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Twitter) {
                            self.twitterView.isHidden = false
                            self.twitterURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.TikTok) {
                            self.tiktokView.isHidden = false
                            self.tiktokURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Snapchat) {
                            self.snapchatView.isHidden = false
                            self.snapchatURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Reddit) {
                            self.redditView.isHidden = false
                            self.redditURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Pintrest) {
                            self.pintrestView.isHidden = false
                            self.pintrestURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Instagram) {
                            self.instagramView.isHidden = false
                            self.instagramURL = model.link ?? ""
                        }
                        else if name.contains(Constants.SocialMedia.Linkedin) {
                            self.linkedinView.isHidden = false
                            self.linkedinURL = model.link ?? ""
                        }
                        
                    }
                }
            }

        }
        
        followersView.isUserInteractionEnabled = true
        followersView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followClicked)))
        
        

        addAllEventsToCalendar.isUserInteractionEnabled = true
        addAllEventsToCalendar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAllEventsToCalendarClicked)))
        
        getAllEvents(uid: hostModel.uid ?? "123") { eModels in
            self.eventModels.removeAll()
            if let eventModels = eModels {
                self.eventModels = eventModels
            }
            self.tableView.reloadData()
        }
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Follow").document(hostModel.uid ?? "123").getDocument { snapshot, error in
            if error == nil {
                if let snapshot = snapshot, snapshot.exists{
                    self.followersView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
                    self.followersLabel.text = "Following"
                }
            }
        }
        
    }
    
    @objc func addAllEventsToCalendarClicked() {
       
            let eventStore : EKEventStore = EKEventStore()
                  
            // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

            eventStore.requestAccess(to: .event) { (granted, error) in
              
                if (granted) && (error == nil) {
                    
                    for eventModel in self.eventModels {
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
                        
                        if !eventAlreadyExists {
                            event.title = eventModel.name ?? ""
                            event.startDate = eventModel.date ?? Date()
                            event.endDate = nextDate ?? Date()
                            event.notes = eventModel.address ?? ""
                            event.calendar = eventStore.defaultCalendarForNewEvents
                            do {
                                
                                try eventStore.save(event, span: .thisEvent)
                                
                            } catch let error as NSError {
                                print("failed to save event with error : \(error)")
                            }
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.showSnack(messages: "Events Added")
                    }
                }
            
        }
        
    }
    
    @objc func followClicked(){
        if followersLabel.text == "Follow" {
            followersView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            followersLabel.text = "Following"
            addFollow()
        }
        else {
            followersView.backgroundColor = UIColor(red: 240/255 , green: 19/255, blue: 70/255, alpha: 1)
            followersLabel.text = "Follow"
            removeFollow()
        }
        
    }
    
    func addFollow(){
        let followModel =  FollowModel()
        followModel.name = hostModel!.fullName ?? ""
        followModel.uid = hostModel!.uid ?? "123"
        try? Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Follow").document(hostModel!.uid ?? "123").setData(from: followModel)
        
        followModel.name = UserModel.data!.fullName ?? ""
        followModel.uid = UserModel.data!.uid ?? "123"
        try? Firestore.firestore().collection("Users").document(hostModel!.uid ?? "123").collection("Following").document(Auth.auth().currentUser!.uid).setData(from: followModel)
    }
    
    func removeFollow(){
       
      Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Follow").document(hostModel!.uid ?? "123").delete()
        Firestore.firestore().collection("Users").document(hostModel!.uid ?? "123").collection("Following").document(Auth.auth().currentUser!.uid).delete()
    }
    
    @objc func addToCalendar(gest : MyGest) {
      
        
        let eventStore : EKEventStore = EKEventStore()
              
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {
              
              let eventModel = self.eventModels[gest.position]
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
                  event.notes = eventModel.address ?? ""
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
    
    @objc func websiteClicked(){
        guard let url = URL(string: website.text ?? "") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func backViewClicked(){
        Constants.selectedIndex = 3
        self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
        
    }
    
    @objc func editProfileClicked(){
        performSegue(withIdentifier: "hostEditSeg", sender: nil)
    }
    
    public func updateTableViewHeight(){
        
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.tableView.layoutIfNeeded()
    }
    
  
    
    @objc func facebookViewClicked(){
        guard let url = URL(string: facebookURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func instagramViewClicked(){
        guard let url = URL(string: instagramURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func twitterViewClicked(){
        guard let url = URL(string: twitterURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func tikTokViewClicked(){
        guard let url = URL(string: tiktokURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func youtubeViewClicked(){
        guard let url = URL(string: youtubeURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func pintrestViewClicked(){
        guard let url = URL(string: pintrestURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redditViewClicked(){
        guard let url = URL(string: redditURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func snapchatViewClicked(){
        guard let url = URL(string: snapchatURL) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func linkedinViewClicked(){
        guard let url = URL(string: linkedinURL) else { return}
        UIApplication.shared.open(url)
    }
    

    @objc func cellClicked(value : MyGest){
        let eventModel = eventModels[value.position]
        
        if let buyTicket = eventModel.ticketLink, !buyTicket.isEmpty {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Buy Ticket", style: .default,handler: { action in
                guard let url = URL(string: buyTicket) else { return}
                UIApplication.shared.open(url)
            }))
            
            alert.addAction(UIAlertAction(title: "Open Map", style: .default, handler: { action in
                self.showOpenMapPopup(latitude: eventModel.latitude ?? 0, longitude: eventModel.longitude ?? 0)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
        else {
            self.showOpenMapPopup(latitude: eventModel.latitude ?? 0, longitude: eventModel.longitude ?? 0)
        }
       
    }
    

    
    func showOpenMapPopup(latitude : Double, longitude : Double){
        let alert = UIAlertController(title: "Open in maps", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { action in
            
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "Shop Location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }))
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { action in
                
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}



extension ShowHostProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? Event_TableView_Cell {
            
            
            
            cell.mView.layer.cornerRadius = 8
            cell.mapView.layer.cornerRadius = 6
            
            cell.mView.isUserInteractionEnabled = true
            let myGest = MyGest(target: self, action: #selector(cellClicked(value: )))
            myGest.position = indexPath.row
            cell.mView.addGestureRecognizer(myGest)
            
            let eventModel = eventModels[indexPath.row]
            cell.eventName.text = eventModel.name ?? ""
            cell.eventDate.text = self.convertDateFormater(eventModel.date ?? Date())
            cell.eventTime.text = self.convertTimeFormater(eventModel.date ?? Date())
            cell.eventAddress.text = eventModel.address ?? ""
            let coordinate = CLLocationCoordinate2D(latitude: eventModel.latitude ?? 0, longitude: eventModel.longitude ?? 0)
            cell.setCoordinatesOnMap(with: coordinate)
            cell.mapView.delegate = self
            cell.mapView.isUserInteractionEnabled = true
            
            cell.addToCalendarView.isUserInteractionEnabled = true
            cell.addToCalendarView.layer.cornerRadius = 8
            cell.addToCalendarView.layer.borderColor = UIColor.gray.cgColor
            cell.addToCalendarView.layer.borderWidth = 0.8
            
            let calendarGest = MyGest(target: self, action: #selector(addToCalendar(gest: )))
            calendarGest.position = indexPath.row
            cell.addToCalendarView.addGestureRecognizer(calendarGest)
            
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if(indexPath.row == totalRow - 1)
            {
                DispatchQueue.main.async {
                    self.updateTableViewHeight()
                }
            }
            return cell
            
        }
        return Event_TableView_Cell()
        
    }
    
    
    
    
}

extension ShowHostProfileViewController : MKMapViewDelegate  {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            self.showOpenMapPopup(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            
        }
        
    }
}
