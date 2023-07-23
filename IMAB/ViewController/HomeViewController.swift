//
//  HomeViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 12/12/22.
//

import UIKit
import SDWebImage
import GeoFire
import CoreLocation
import FirebaseFirestoreSwift
import Firebase


class HomeViewController : UIViewController {
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var searchView: UIView!
    
    
    @IBOutlet weak var headHomeLabel: UILabel!
    @IBOutlet weak var letSearchStack: UIStackView!
    @IBOutlet weak var searchFakeView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager : CLLocationManager!
    var i = 0;
    let radiusInM: Double = 3000 * 1000
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var eventModels =  Array<EventModel>()
    var searchModels =  Array<EventModel>()
    
    @IBOutlet weak var no_hosts_available: UILabel!
    
    override func viewDidLoad() {
        
        guard UserModel.data != nil else{
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        searchFakeView.layer.cornerRadius = 8
        searchFakeView.dropShadow()
        searchFakeView.isUserInteractionEnabled = true
        searchFakeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchFakeClicked)))
        
        
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.delegate = self
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        ProgressHUDShow(text: "")
        getEventData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refresh(_ sender: AnyObject) {
       getEventData()
    }
    
    func getEventData(){
      
        getAllEventsForFan { eventModels in
            self.refreshControl.endRefreshing()
            self.ProgressHUDHide()
            self.searchModels.removeAll()
            self.eventModels.removeAll()
            
            if let eventModels = eventModels {
                self.eventModels.append(contentsOf: eventModels)
                self.searchModels.append(contentsOf: eventModels)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func searchFakeClicked(){
        
        UIView.transition(with:searchBar, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.searchFakeView.isHidden = true
            self.headHomeLabel.isHidden = false
            
            self.letSearchStack.isHidden = true
            self.searchView.isHidden = false
            
            self.searchBar.becomeFirstResponder()
            
            
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.searchTextField.tintColor = .darkGray
        self.searchBar.searchTextField.leftView?.tintColor = UIColor.red
        self.searchBar.searchTextField.font = UIFont(name: "montregular", size: 9)
        self.searchBar.frame.size.height = 38
        self.searchBar.reloadInputViews()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailsSeg" {
            if let VC = segue.destination as? EventDetailsViewController {
                if let eventModel = sender as? EventModel {
                    VC.eventModel = eventModel
                }
            }
        }
    }
    @objc func cellClicked(gest : MyGesture) {
        performSegue(withIdentifier: "eventDetailsSeg", sender: searchModels[gest.index])
    }
    
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }

}

extension HomeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.no_hosts_available.isHidden = eventModels.count > 0 ? true : false
        return searchModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? Event_TableView_Cell {
            
       
            let eventModel = searchModels[indexPath.row]
            cell.eventImage.layer.cornerRadius = 8
            if let path = eventModel.eventImage, !path.isEmpty {
                cell.eventImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "placeholder"))
            }
            
            getHostData(uid: eventModel.uid ?? "123") { hostModel, error in
                if let hostModel = hostModel {
                  
                    if let disable = hostModel.disable, disable {
                        self.eventModels.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                    else {
                        cell.eventName.text = hostModel.fullName ?? ""
                    }
                }
                else {
                    self.eventModels.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
            
          
            
            
            if eventModel.fontType == "light" {
                cell.eventName.textColor = UIColor.white
                cell.eventDate.textColor = UIColor.white
                cell.eventTime.textColor = UIColor.white
              
                
                cell.clockIcon.tintColor = UIColor.white
           
            }
            else {
                cell.eventName.textColor = UIColor.black
                cell.eventDate.textColor = UIColor.black
                cell.eventTime.textColor = UIColor.black
              
                
                cell.clockIcon.tintColor = UIColor.black
               
            }
            
            if let startTime = eventModel.time {
                cell.eventTime.isHidden = false
                cell.eventTime.text = self.convertDateIntoTimeForRecurringVoucher(startTime)
            }
            else {
                cell.eventTime.isHidden = true
            }
            
            cell.eventDate.text = self.convertDateFormater(eventModel.date ?? Date())
           

            cell.mView.isUserInteractionEnabled = true
            let gest = MyGesture(target: self, action: #selector(cellClicked(gest: )))
            gest.index = indexPath.row
            cell.mView.addGestureRecognizer(gest)
            
           
            return cell
        }
        return Event_TableView_Cell()
        
    }
    
    
    
    
}
extension  HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        
        
        switch status {
        case .notDetermined, .restricted, .denied:
            print("LOCATIO DENIED")
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
        @unknown default:
            print("ERROR")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let userLocation = locations[0] as CLLocation
        Constants.latitude = userLocation.coordinate.latitude
        Constants.longitude = userLocation.coordinate.longitude
        
        UserModel.data!.latitude = userLocation.coordinate.latitude
        UserModel.data!.longitude = userLocation.coordinate.longitude
        
        let location  = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
        let hash = GFUtils.geoHash(forLocation: location)
        UserModel.data!.geoHash = hash
        try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!,merge:true)
        
        
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }
}

extension HomeViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchView.isHidden = true
        self.searchBar.searchTextField.text = ""
        self.searchBar.resignFirstResponder()
        UIView.transition(with:searchBar, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.searchFakeView.isHidden = false
            self.headHomeLabel.isHidden = true
            
            self.letSearchStack.isHidden = false
            
            
            
        })
        
        searchModels.removeAll()
        searchModels.append(contentsOf: eventModels)
        tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchModels.removeAll()
        if let sValue = searchBar.text, !sValue.isEmpty {
            for model in eventModels {
                if (model.name!.uppercased()).contains(sValue.uppercased()) || (model.hostName!.uppercased().contains(sValue.uppercased())) {
                    self.searchModels.append(model)
                }
            }
        }
        else {
            searchModels.append(contentsOf: eventModels)
        }
        tableView.reloadData()

    }
    
    
}

