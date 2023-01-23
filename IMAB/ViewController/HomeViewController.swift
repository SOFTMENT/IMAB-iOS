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
import Firebase

class HomeViewController : UIViewController {
    
    var locationManager : CLLocationManager!
    var i = 0;
    let radiusInM: Double = 3000 * 1000
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var mDate: UILabel!
   
    @IBOutlet weak var notifications: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var hostModels = Array<HostModel>()
    
    @IBOutlet weak var no_hosts_available: UILabel!
    
    override func viewDidLoad() {
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        searchTF.changePlaceholderColour()
        searchTF.delegate = self
        
        mProfile.layer.cornerRadius = 8
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mDate.isUserInteractionEnabled = true
        mDate.text = self.convertDateFormater(Date())
        
        
        guard let userModel = UserModel.data else{
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        if let profileURL = userModel.profilePic, !profileURL.isEmpty {
            mProfile.sd_setImage(with: URL(string: profileURL), placeholderImage: UIImage(named: "placeholder"), progress: .none)
        }
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        ProgressHUDShow(text: "")
        
        notifications.isUserInteractionEnabled = true
        notifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationClicked)))
    }
    
    @objc func notificationClicked(){
        
    }
    
    func getAllHosts(){
    
      
        let center = CLLocationCoordinate2D(latitude: Constants.latitude, longitude: Constants.longitude)
      
        
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        
        
        var queries : [Query]!
        
      
         
            queries = queryBounds.map { bound -> Query in
              
                return Firestore.firestore().collection("Users")
                    .order(by: "geoHash")
                    .whereField("host", isEqualTo: true)
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
            }
        

        
        
        hostModels.removeAll()
    
        for query in queries {
          
            query.getDocuments(completion: getDocumentsCompletion)
        }
    
        self.ProgressHUDHide()
    }
    func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
       
        guard let documents = snapshot?.documents else {
            self.showError(error!.localizedDescription)
            return
        }
        
       
        for document in documents {
       
            let lat = document.data()["latitude"] as? Double ?? 0
            let lng = document.data()["longitude"] as? Double ?? 0
         
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: Constants.latitude, longitude: Constants.longitude)
            
            // We have to filter out a few false positives due to GeoHash accuracy, but
            // most will match
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            if distance <= radiusInM {
                if let hostModel = try? document.data(as: HostModel.self) {
                    
                    self.hostModels.removeAll { host in
                        if hostModel.uid == host.uid {
                            return true
                        }
                       return false
                    }

              
                    if let totalEvent = hostModel.totalEvents , totalEvent > 0 {
                        
                        hostModels.append(hostModel)
                        
                        
                    }
                  
                }
            }
        }
        
        tableView.reloadData()

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHostSeg" {
            if let vc = segue.destination as? ShowHostProfileViewController {
                if let hostModel = sender as? HostModel {
                    vc.hostModel = hostModel
                }
            }
        }
    }
    @objc func cellClicked(gest : MyGest) {
        let host = hostModels[gest.position]
        performSegue(withIdentifier: "showHostSeg", sender: host)
    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    func refreshTableViewHeight(){
       
    
        self.tableViewHeight.constant = CGFloat((120)) * CGFloat(hostModels.count)
        
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
        self.no_hosts_available.isHidden = hostModels.count > 0 ? true : false
        return hostModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath) as? HostTableViewCell {
            
            cell.mView.layer.cornerRadius = 8
            cell.mViewProfile.layer.cornerRadius = 8
            cell.mProfile.layer.cornerRadius = 8
            let hostModel = hostModels[indexPath.row]
            if let profilePath = hostModel.profilePic, !profilePath.isEmpty {
                cell.mProfile.sd_setImage(with: URL(string: profilePath), placeholderImage: UIImage(named: "profile-placeholder"), progress: .none)
            }
            cell.mName.text = hostModel.fullName ?? ""
            cell.mAddress.text = hostModel.address ?? ""
            
            let myGest = MyGest(target: self, action: #selector(cellClicked(gest: )))
            myGest.position = indexPath.row
            cell.mView.isUserInteractionEnabled = true
            cell.mView.addGestureRecognizer(myGest)
            
            refreshTableViewHeight()
            cell.layoutIfNeeded()
            
            return cell
        }
        return HostTableViewCell()
        
    }
    
    
    
    
}
extension  HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        
        
        switch status {
        case .notDetermined, .restricted, .denied:
            
            self.showSnack(messages: "Enable Location Permission")
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
        
        
        self.getAllHosts()
        
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
           
        }
        
    }
}
