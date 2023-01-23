//
//  AddEventViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 15/01/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import GeoFire

class AddEventViewController : UIViewController {
    
    
    @IBOutlet weak var ticketLinkTF : UITextField!
    
    
    @IBOutlet weak var doneBtn: UIImageView!
    
    @IBOutlet weak var eventNameTF: UITextField!
    
    @IBOutlet weak var eventDateTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addEventBtn: UIButton!
    var places : [Place] = []
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var isLocationSelected : Bool = false
    let startDatePicker = UIDatePicker()
    let startTimePicker = UIDatePicker()
    var startDate : Date = Date()
    var eventModel = EventModel()
    override func viewDidLoad() {
        
        addEventBtn.layer.cornerRadius = 8
        doneBtn.isUserInteractionEnabled = true
        doneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        eventNameTF.delegate = self
        eventDateTF.delegate = self
        addressTF.delegate = self
        ticketLinkTF.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addressTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        createStartDatePicker()
        
        let id = Firestore.firestore().collection("Events").document().documentID
        eventModel.id = id
        
    }
    func createStartDatePicker() {
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDoneBtnTapped))
        toolbar.setItems([done], animated: true)
        
        eventDateTF.inputAccessoryView = toolbar
        
        startDatePicker.datePickerMode = .date
        startDatePicker.minimumDate = Date()
        eventDateTF.inputView = startDatePicker
    }
    
    @objc func startDateDoneBtnTapped() {
        view.endEditing(true)
        let date = startDatePicker.date
        startDate = date
        createStartTimePicker()
        eventDateTF.becomeFirstResponder()
    }
    

    
    func createStartTimePicker() {
        if #available(iOS 13.4, *) {
           startTimePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeDoneBtnTapped))
        toolbar.setItems([done], animated: true)
        
        eventDateTF.inputAccessoryView = toolbar
        
        startTimePicker.datePickerMode = .time
        
        eventDateTF.inputView = startTimePicker
    }
    
    @objc func startTimeDoneBtnTapped() {
        view.endEditing(true)
        let startTime = startTimePicker.date
        createStartDatePicker()
        
        let date = convertDateFormater(startDate)
        let time = convertDateIntoTimeForRecurringVoucher(startTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
        let string = date + " " + time
        let finalDate = dateFormatter.date(from: string)
        eventModel.date = finalDate
        eventDateTF.text = convertDateAndTimeFormater(finalDate ?? Date())
        
    }
    
    
    @objc func textFieldDidChange(textField : UITextField){
        guard let query = textField.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.places.removeAll()
        
            self.tableView.reloadData()
            return
        }
        
        
        GooglePlacesManager.shared.findPlaces(query: query ) { result in
            switch result {
            case .success(let places) :
                self.places = places
                print(self.places)
                self.tableView.reloadData()
                break
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    @objc func locationCellClicked(myGesture : MyGest){
        tableView.isHidden = true
        view.endEditing(true)
    

        let place = places[myGesture.position]
        addressTF.text = place.name ?? ""
        eventModel.address = place.name ?? ""
        
        self.isLocationSelected = true
     
    
        GooglePlacesManager.shared.resolveLocation(for: place) { result in
            switch result {
            case .success(let coordinates) :
                self.latitude = coordinates.latitude
                self.longitude = coordinates.longitude
               
                break
            case .failure(let error) :
                print(error)
                
            }
        }
    }
    
    public func updateTableViewHeight(){
        
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.tableView.layoutIfNeeded()
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func doneBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func addEventBtnClicked(_ sender: Any) {
        let sEventName = eventNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sTicketLink = ticketLinkTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if sEventName == "" {
            self.showSnack(messages: "Enter Event Name")
        }
        else if eventModel.date == nil {
            self.showSnack(messages: "Select Event Date")
        }
        else if !isLocationSelected {
            self.showSnack(messages: "Select Event Location")
           
        }
        else {
            let location  = CLLocationCoordinate2D(latitude: self.latitude , longitude: self.longitude)
            let hash = GFUtils.geoHash(forLocation: location)
            eventModel.geoHash = hash
            eventModel.eventCreateDate = Date()
            eventModel.latitude = self.latitude
            eventModel.longitude = self.longitude
            eventModel.name = sEventName
            eventModel.uid = Auth.auth().currentUser!.uid
            eventModel.ticketLink = sTicketLink
            
            
            
            UserModel.data!.geoHash = hash
            UserModel.data!.address = eventModel.address
            UserModel.data!.eventDate = Date()
            UserModel.data!.totalEvents = (UserModel.data!.totalEvents ?? 0) + 1
            UserModel.data!.latitude = latitude
            UserModel.data!.longitude = longitude
            
            try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!, merge : true)
            
            ProgressHUDShow(text: "")
            try? Firestore.firestore().collection("Events").document(eventModel.id!).setData(from: eventModel) { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Event Added")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        self.dismiss(animated: true)
                    }
                }
            }
            
            
        }
    }
}

extension AddEventViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}



extension AddEventViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placescell", for: indexPath) as? Google_Places_Cell {
            
            
            cell.name.text = places[indexPath.row].name ?? "Something Went Wrong"
            cell.mView.isUserInteractionEnabled = true
            
            let myGesture = MyGest(target: self, action: #selector(locationCellClicked(myGesture:)))
            myGesture.position = indexPath.row
            cell.mView.addGestureRecognizer(myGesture)
            
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if(indexPath.row == totalRow - 1)
            {
                DispatchQueue.main.async {
                    self.updateTableViewHeight()
                }
            }
            return cell
        }
        
        return Google_Places_Cell()
    }
    
    
    
}
