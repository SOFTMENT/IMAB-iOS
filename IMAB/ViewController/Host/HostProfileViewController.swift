//
//  HostProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 15/01/23.
//

import UIKit
import Firebase
import MapKit

class HostProfileViewController : UIViewController{
    
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var editProfile: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followersView: UIView!
    
    @IBOutlet weak var mDescription: UILabel!
    
    @IBOutlet weak var addEventBtn: UIButton!
    
    
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
    override func viewDidLoad() {
        
        guard let userModel = UserModel.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        profileImg.layer.cornerRadius = 8
        
        if let image = userModel.profilePic, !image.isEmpty {
            profileImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"), progress: .none)
        }
        
        addEventBtn.layer.cornerRadius = 8
        
        website.text = userModel.websiteURL ?? ""
        
        profileName.text = userModel.fullName ?? ""
        mDescription.text = userModel.myDescription ?? ""
        
        followersView.layer.cornerRadius = 6
        let followers = userModel.followers ?? 0
        if followers == 0 {
            followersLabel.text = "0 Follower"
        }
        else {
            followersLabel.text = "\(followers) Followers"
        }
     
        
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
        
        editProfile.isUserInteractionEnabled = true
        editProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileClicked)))
        
        ProgressHUDShow(text: "")
        self.getAllSocialMedia(uid:userModel.uid ?? "123") { sModel in
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

        
        getAllEvents(uid: userModel.uid ?? "123") { eModels in
            self.eventModels.removeAll()
            if let eventModels = eModels {
                self.eventModels = eventModels
            }
            self.tableView.reloadData()
        }
        
        
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
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Facebook)
    }
    
    @objc func instagramViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Instagram)
    }
    
    @objc func twitterViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Twitter)
    }
    
    @objc func tikTokViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.TikTok)
    }
    
    @objc func youtubeViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.YouTube)
    }
    
    @objc func pintrestViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Pintrest)
    }
    
    @objc func redditViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Reddit)
    }
    
    @objc func snapchatViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Snapchat)
    }
    
    @objc func linkedinViewClicked(){
        performSegue(withIdentifier: "editSocialMediaSeg", sender: Constants.SocialMedia.Linkedin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEventSeg" {
            if let vc = segue.destination as? EditEventViewController{
                if let eventModel = sender as? EventModel {
                    vc.eventModel = eventModel
                }
            }
        }
        else if segue.identifier == "editSocialMediaSeg" {
            if let vc = segue.destination as? EditSocialMediaViewContoller {
                if let name = sender as? String {
                    vc.name = name
                    if Constants.SocialMedia.Facebook.elementsEqual(name) {
                        vc.link = facebookURL
                    }
                    else if Constants.SocialMedia.Twitter.elementsEqual(name) {
                        vc.link = twitterURL
                    }
                    else if Constants.SocialMedia.Linkedin.elementsEqual(name) {
                        vc.link = linkedinURL
                    }
                    else if Constants.SocialMedia.Snapchat.elementsEqual(name) {
                        vc.link = facebookURL
                    }
                    else if Constants.SocialMedia.Reddit.elementsEqual(name) {
                        vc.link = redditURL
                    }
                    else if Constants.SocialMedia.Pintrest.elementsEqual(name) {
                        vc.link = pintrestURL
                    }
                    else if Constants.SocialMedia.YouTube.elementsEqual(name) {
                        vc.link = youtubeURL
                    }
                    else if Constants.SocialMedia.TikTok.elementsEqual(name) {
                        vc.link = tiktokURL
                    }
                    else if Constants.SocialMedia.Instagram.elementsEqual(name) {
                        vc.link = instagramURL
                    }
                    
                }
            }
        }
    }
    
    
    
    @objc func cellClicked(value : MyGest){
        let eventModel = eventModels[value.position]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit Event", style: .default,handler: { action in
            self.performSegue(withIdentifier: "editEventSeg", sender: eventModel)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Event", style: .default, handler: { action in
            self.ProgressHUDShow(text: "Deleting...")
            Firestore.firestore().collection("Events").document(eventModel.id ?? "").delete { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    UserModel.data!.totalEvents = (UserModel.data!.totalEvents ?? 0) - 1
                    try? Firestore.firestore().collection("Users").document(UserModel.data!.uid ?? "123").setData(from: UserModel.data!, merge : true)
                    self.showSnack(messages: "Deleted")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func addEventBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "addEventSeg", sender: nil)
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



extension HostProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
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
            
           
            DispatchQueue.main.async {
                self.updateTableViewHeight()
            }
            
            return cell
            
        }
        return Event_TableView_Cell()
        
    }
    
    
    
    
}

extension HostProfileViewController : MKMapViewDelegate  {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            self.showOpenMapPopup(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            
        }
        
    }
}
