//
//  AddEventViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 15/01/23.
//

import UIKit
import GeoFire
import CropViewController

class AddEventViewController : UIViewController {
    
    var eventType : EventType = .LIVE
    @IBOutlet weak var eventImagePlaceholder: UIImageView!
    @IBOutlet weak var eventLinkNameStack: UIStackView!
    @IBOutlet weak var eventLinkStack: UIStackView!
    @IBOutlet weak var eventLocationStack: UIStackView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var onlineEventBottomView: UIView!
    @IBOutlet weak var liveEventBottomView: UIView!
    @IBOutlet weak var darkCheck: UIButton!
    @IBOutlet weak var lightCheck: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var backBtn: UIView!
    @IBOutlet weak var liveEventBtn: UIStackView!
    @IBOutlet weak var onlineEventBtn: UIStackView!
    
    @IBOutlet weak var darkFontView: UIStackView!
    @IBOutlet weak var lightFontView: UIStackView!
    @IBOutlet weak var ticketLinkTF : UITextField!
    
    @IBOutlet weak var eventNameTF: UITextField!
    
    @IBOutlet weak var eventDateTF: UITextField!
    
    @IBOutlet weak var eventTimeTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventLinkNameTF: UITextField!
    @IBOutlet weak var eventLinkTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addEventBtn: UIButton!
    
    var fontType : FontType = .LIGHT
    
    var places : [Place] = []
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var isLocationSelected : Bool = false
    let startDatePicker = UIDatePicker()
    let startTimePicker = UIDatePicker()
    var startDate : Date = Date()
    @IBOutlet weak var profileImageEventTitle: UILabel!
    var isImageSelected = false
    override func viewDidLoad() {
        
        addEventBtn.layer.cornerRadius = 8
        addImageBtn.layer.cornerRadius = 8
        
        eventImage.layer.cornerRadius = 8
  
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        eventNameTF.delegate = self
        eventDateTF.delegate = self
        eventTimeTF.delegate = self
        eventLinkTF.delegate = self
        eventLinkNameTF.delegate = self
        addressTF.delegate = self
        ticketLinkTF.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addressTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        eventNameTF.addTarget(self, action: #selector(eventTitleDidChange(extField: )), for: .editingChanged)
        
        createStartDatePicker()
        createStartTimePicker()
        
        backBtn.isUserInteractionEnabled = true
        backBtn.layer.cornerRadius = 8
        backBtn.dropShadow()
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        lightFontView.isUserInteractionEnabled = true
        lightFontView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lightFontClicked)))
        
        darkFontView.isUserInteractionEnabled = true
        darkFontView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(darkFontClicked)))
        
        liveEventBtn.isUserInteractionEnabled = true
        liveEventBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(liveEventClicked)))
        
        onlineEventBtn.isUserInteractionEnabled = true
        onlineEventBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onlineEventClicked)))
    }
    @objc func imageViewClicked(){
        chooseImageFromPhotoLibrary()
    }
    
    func chooseImageFromPhotoLibrary(){
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Profile Picture"
            image.delegate = self
            image.sourceType = .camera
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
            
            self.present(image,animated: true)
            
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
    }
    @objc func lightFontClicked(){
        fontType = .LIGHT
        darkCheck.isSelected = false
        lightCheck.isSelected = true
        profileImageEventTitle.textColor = UIColor.white
        profileImageEventTitle.layoutIfNeeded()
    }
    
    @objc func darkFontClicked(){
        fontType = .DARK
        darkCheck.isSelected = true
        lightCheck.isSelected = false
        profileImageEventTitle.textColor = UIColor.black
        profileImageEventTitle.layoutIfNeeded()
    }
    
    @objc func eventTitleDidChange(extField : UITextField) {
        profileImageEventTitle.text = extField.text ?? ""
    }
    
    @objc func liveEventClicked(){
        liveEventBottomView.backgroundColor = UIColor(red: 247/255, green: 79/255, blue: 85/255, alpha: 1)
        onlineEventBottomView.backgroundColor = .clear
        
        eventLinkNameStack.isHidden = true
        eventLinkStack.isHidden = true
        
        eventLocationStack.isHidden = false
        
        eventType = .LIVE
        
    }
    
    @objc func onlineEventClicked(){
        onlineEventBottomView.backgroundColor = UIColor(red: 247/255, green: 79/255, blue: 85/255, alpha: 1)
        liveEventBottomView.backgroundColor = .clear
        
        eventLinkNameStack.isHidden = false
        eventLinkStack.isHidden = false
        
        eventLocationStack.isHidden = true
        
        eventType = .ONLINE
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func addImageClicked(_ sender: Any) {
        imageViewClicked()
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
        eventDateTF.text = convertDateFormater(date)
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
        
        eventTimeTF.inputAccessoryView = toolbar
        
        startTimePicker.datePickerMode = .time
        
        eventTimeTF.inputView = startTimePicker
    }
    
    @objc func startTimeDoneBtnTapped() {
        view.endEditing(true)
        let startTime = startTimePicker.date
      
        eventTimeTF.text = convertDateIntoTimeForRecurringVoucher(startTime)
        
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
    
    @objc func locationCellClicked(myGesture : MyGesture){
        tableView.isHidden = true
        view.endEditing(true)
    

        let place = places[myGesture.index]
        addressTF.text = place.name ?? ""
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
        let sEventDate = eventDateTF.text
        let sEventTime = eventTimeTF.text
        let sEventLinkName = eventLinkNameTF.text
        let sEventLink = eventLinkTF.text
        let sEventLocation = addressTF.text
        let sTicketLink = ticketLinkTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if sEventName == "" {
            self.showSnack(messages: "Enter Event Name")
        }
        else if sEventDate == nil {
            self.showSnack(messages: "Select Event Date")
        }
        else if eventType == .ONLINE && sEventLinkName == "" {
            self.showSnack(messages: "Enter Event Link Name")
        }
        else if eventType == .ONLINE && sEventLink == "" {
            self.showSnack(messages: "Enter Event Link")
        }
        else if eventType == .LIVE && !isLocationSelected {
            self.showSnack(messages: "Enter Event Location")

        }
        else if !isImageSelected {
            self.showSnack(messages: "Add Event Image")
        }
        else {
            
            ProgressHUDShow(text: "")
            
            let eventModel = EventModel()
            eventModel.name = sEventName
            eventModel.date = startDatePicker.date
            eventModel.dateTime = startDatePicker.date
            
            if sEventTime != "" {
                eventModel.time = startTimePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM-dd-yyyy hh:mm a"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.timeZone = TimeZone.current
                let string = sEventDate! + " " + sEventTime!
                eventModel.dateTime = dateFormatter.date(from: string)
            }
           
                                     
            eventModel.eventLinkName = sEventLinkName
            eventModel.eventLink = sEventLink
            eventModel.eventAddress = sEventLocation
            eventModel.latitude = self.latitude
            eventModel.longitude = self.longitude
            let location  = CLLocationCoordinate2D(latitude: self.latitude , longitude: self.longitude)
            let hash = GFUtils.geoHash(forLocation: location)
            eventModel.geoHash = hash
            eventModel.ticketLink = sTicketLink
            eventModel.eventCreateDate = Date()
            eventModel.hostName = UserModel.data!.fullName
            eventModel.uid = FirebaseStoreManager.auth.currentUser!.uid
            eventModel.fontType = fontType == .LIGHT ? "light" : "dark"
            eventModel.eventType = eventType == .LIVE ? "live" : "online"
            let id = FirebaseStoreManager.db.collection("Events").document().documentID
            eventModel.id = id
            
            self.uploadImageOnFirebase(id: id) { downloadURL in
                eventModel.eventImage = downloadURL
                try? FirebaseStoreManager.db.collection("Events").document(id).setData(from: eventModel) { error in
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
            
            let myGesture = MyGesture(target: self, action: #selector(locationCellClicked(myGesture:)))
            myGesture.index = indexPath.row
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

enum FontType  {
    
    case LIGHT
    case DARK
    
}
extension AddEventViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 16  , height: 9)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
            isImageSelected = true
            eventImage.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(id : String,completion : @escaping (String) -> Void ) {
        
        let storage = FirebaseStoreManager.storage.reference().child("EventImages").child("\(id).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        uploadData = (self.eventImage.image?.jpegData(compressionQuality: 0.5))!
        
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
}
