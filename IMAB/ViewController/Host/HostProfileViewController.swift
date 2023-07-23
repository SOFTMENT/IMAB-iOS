//
//  HostProfileViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 15/01/23.
//

import UIKit

import MapKit

class HostProfileViewController : UIViewController{
    
    @IBOutlet weak var twitterCircle: CircleView!
    @IBOutlet weak var instagramCircle: CircleView!
    @IBOutlet weak var tiktokCircle: CircleView!
    @IBOutlet weak var facebookCircle: CircleView!
    @IBOutlet weak var youtubeCircle: CircleView!
    @IBOutlet weak var rumCircle: CircleView!
    @IBOutlet weak var twitchCircle: CircleView!
    @IBOutlet weak var redditCircle: CircleView!
    @IBOutlet weak var substackCircle: CircleView!
    @IBOutlet weak var tumblrCircle: CircleView!
    @IBOutlet weak var discordCircle: CircleView!
    @IBOutlet weak var telegramCircle: CircleView!
    @IBOutlet weak var truthCircle: CircleView!
    @IBOutlet weak var mastodonCircle: CircleView!
    @IBOutlet weak var pintrestCircle: CircleView!
    @IBOutlet weak var etsyCircle: CircleView!
    @IBOutlet weak var linkedinCircle: CircleView!
    @IBOutlet weak var whatsAppCircle: CircleView!
    
    
    
    
    
    
    @IBOutlet weak var noEventsAvailable: UILabel!
    
    @IBOutlet weak var addSocialMediaBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var professionalCat: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var editProfileView: UIView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var mDescription: UILabel!
    
    @IBOutlet weak var addEventBtn: UIButton!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    var eventModels = Array<EventModel>()
    
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var twitterNumber: UILabel!

    @IBOutlet weak var instagramView: UIView!
    @IBOutlet weak var instagramNumber: UILabel!
    
    @IBOutlet weak var tiktokView: UIView!
    @IBOutlet weak var tikTokNumber: UILabel!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var facebookNumber: UILabel!
    
    @IBOutlet weak var youtubeView: UIView!
    @IBOutlet weak var youtubeNumber: UILabel!
    
    @IBOutlet weak var rumView: UIView!
    @IBOutlet weak var rumNumber: UILabel!
    
    @IBOutlet weak var twitchView: UIView!
    @IBOutlet weak var twitchNumber: UILabel!
    
    @IBOutlet weak var redditView: UIView!
    @IBOutlet weak var redditNumber: UILabel!
    
    @IBOutlet weak var substackView: UIView!
    @IBOutlet weak var substackNumber: UILabel!
    
    @IBOutlet weak var tumblr: UIView!
    @IBOutlet weak var tumblrNumer: UILabel!
    
    @IBOutlet weak var discordView: UIView!
    @IBOutlet weak var discordNumber: UILabel!
    
    @IBOutlet weak var telegramView: UIView!
    @IBOutlet weak var telegramNumber: UILabel!
    
    @IBOutlet weak var truthSocialNumber: UILabel!
    @IBOutlet weak var truthSocialView: UIView!
    
    @IBOutlet weak var mastodonView: UIView!
    @IBOutlet weak var mastodonNumber: UILabel!
    
    @IBOutlet weak var pintrestView: UIView!
    @IBOutlet weak var pintrestNumber: UILabel!
    
    @IBOutlet weak var etsyView: UIView!
    @IBOutlet weak var etsyNumber: UILabel!
    
    
    @IBOutlet weak var linkedinView: UIView!
    @IBOutlet weak var linkedinNumber: UILabel!
    
    @IBOutlet weak var whatsAppView: UIView!
    @IBOutlet weak var whatsAppNumber: UILabel!

    var socialMediaModels = Array<SocialMediaModel>()
    
    
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
        addSocialMediaBtn.layer.cornerRadius = 8
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.isUserInteractionEnabled = true
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        backView.layer.cornerRadius = 8
        
        editProfileView.layer.cornerRadius = 8
        editProfileView.dropShadow()
        editProfileView.isUserInteractionEnabled = true
        editProfileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileClicked)))
        
        ProgressHUDShow(text: "")
       
        getAllEvents(uid: userModel.uid ?? "123") { eModels in
            self.ProgressHUDHide()
            self.eventModels.removeAll()
            if let eventModels = eModels {
                self.eventModels = eventModels
            }
            self.tableView.reloadData()
        }
             
        twitterView.isUserInteractionEnabled = true
        let gest1 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest1.socialType = .Twitter
        twitterView.addGestureRecognizer(gest1)
        
        instagramView.isUserInteractionEnabled = true
        let gest2 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest2.socialType = .Instagram
        instagramView.addGestureRecognizer(gest2)
        
        tiktokView.isUserInteractionEnabled = true
        let gest3 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest3.socialType = .TikTok
        tiktokView.addGestureRecognizer(gest3)
        
        facebookView.isUserInteractionEnabled = true
        let gest4 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest4.socialType = .Facebook
        facebookView.addGestureRecognizer(gest4)
        
        youtubeView.isUserInteractionEnabled = true
        let gest5 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest5.socialType = .YouTube
        youtubeView.addGestureRecognizer(gest5)
        
        rumView.isUserInteractionEnabled = true
        let gest6 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest6.socialType = .Rumble
        rumView.addGestureRecognizer(gest6)
        
        twitchView.isUserInteractionEnabled = true
        let gest7 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest7.socialType = .Twitch
        twitchView.addGestureRecognizer(gest7)
        
        redditView.isUserInteractionEnabled = true
        let gest8 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest8.socialType = .Reddit
        redditView.addGestureRecognizer(gest8)
        
        substackView.isUserInteractionEnabled = true
        let gest9 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest9.socialType = .Substack
        substackView.addGestureRecognizer(gest9)
        
        tumblr.isUserInteractionEnabled = true
        let gest10 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest10.socialType = .Tumblr
        tumblr.addGestureRecognizer(gest10)
        
        discordView.isUserInteractionEnabled = true
        let gest11 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest11.socialType = .Discord
        discordView.addGestureRecognizer(gest11)
        
        telegramView.isUserInteractionEnabled = true
        let gest12 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest12.socialType = .Telegram
        telegramView.addGestureRecognizer(gest12)
        
        truthSocialView.isUserInteractionEnabled = true
        let gest13 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest13.socialType = .TruthSocial
        truthSocialView.addGestureRecognizer(gest13)
        
        mastodonView.isUserInteractionEnabled = true
        let gest14 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest14.socialType = .Mastodon
        mastodonView.addGestureRecognizer(gest14)
        
        pintrestView.isUserInteractionEnabled = true
        let gest15 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest15.socialType = .Pinterest
        pintrestView.addGestureRecognizer(gest15)
        
        etsyView.isUserInteractionEnabled = true
        let gest16 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest16.socialType = .Etsy
        etsyView.addGestureRecognizer(gest16)
        
        linkedinView.isUserInteractionEnabled = true
        let gest17 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest17.socialType = .LinkedIn
        linkedinView.addGestureRecognizer(gest17)
        
        whatsAppView.isUserInteractionEnabled = true
        let gest18 = MyGesture(target: self, action: #selector(socialViewClicked))
        gest18.socialType = .Whatsapp
        whatsAppView.addGestureRecognizer(gest18)
        
        getAllSocialMedia(uid: userModel.uid ?? "123") { socialMediaModels in
            self.hideAllSocialMedia()
        
            if let socialMediaModels = socialMediaModels {
                self.socialMediaModels.removeAll()
                self.socialMediaModels.append(contentsOf: socialMediaModels)
                for model in socialMediaModels {
                    if model.name == SocialMedia.Twitter.rawValue {
                      
                        self.twitterView.isHidden = false
                        self.twitterNumber.text = String((Int(self.twitterNumber.text ?? "1") ?? 1) + 1)
                       
                        if (Int(self.twitterNumber.text ?? "1") ?? 1) > 1 {
                            self.twitterCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Instagram.rawValue {
                        self.instagramView.isHidden = false
                        self.instagramNumber.text = String((Int(self.instagramNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.instagramNumber.text ?? "1") ?? 1) > 1 {
                            self.instagramCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.TikTok.rawValue {
                        self.tiktokView.isHidden = false
                        self.tikTokNumber.text = String((Int(self.tikTokNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.tikTokNumber.text ?? "1") ?? 1) > 1 {
                            self.tiktokCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Facebook.rawValue {
                        self.facebookView.isHidden = false
                        self.facebookNumber.text = String((Int(self.facebookNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.facebookNumber.text ?? "1") ?? 1) > 1 {
                            self.facebookCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.YouTube.rawValue {
                        self.youtubeView.isHidden = false
                        self.youtubeNumber.text = String((Int(self.youtubeNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.youtubeNumber.text ?? "1") ?? 1) > 1 {
                            self.youtubeCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Rumble.rawValue {
                        self.rumView.isHidden = false
                        self.rumNumber.text = String((Int(self.rumNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.rumNumber.text ?? "1") ?? 1) > 1 {
                            self.rumCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Twitch.rawValue {
                        self.twitchView.isHidden = false
                        self.twitchNumber.text = String((Int(self.twitchNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.twitchNumber.text ?? "1") ?? 1) > 1 {
                            self.twitchCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Reddit.rawValue {
                        self.redditView.isHidden = false
                        self.redditNumber.text = String((Int(self.redditNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.redditNumber.text ?? "1") ?? 1) > 1 {
                            self.redditCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Substack.rawValue {
                        self.substackView.isHidden = false
                        self.substackNumber.text = String((Int(self.substackNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.substackNumber.text ?? "1") ?? 1) > 1 {
                            self.substackCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Tumblr.rawValue {
                        self.tumblr.isHidden = false
                        self.tumblrNumer.text = String((Int(self.tumblrNumer.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.tumblrNumer.text ?? "1") ?? 1) > 1 {
                            self.tumblrCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Discord.rawValue {
                        self.discordView.isHidden = false
                        self.discordNumber.text = String((Int(self.discordNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.discordNumber.text ?? "1") ?? 1) > 1 {
                            self.discordCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Telegram.rawValue {
                        self.telegramView.isHidden = false
                        self.telegramNumber.text = String((Int(self.telegramNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.telegramNumber.text ?? "1") ?? 1) > 1 {
                            self.telegramCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.TruthSocial.rawValue {
                        self.truthSocialView.isHidden = false
                        self.truthSocialNumber.text = String((Int(self.truthSocialNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.truthSocialNumber.text ?? "1") ?? 1) > 1 {
                            self.truthCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Mastodon.rawValue {
                        self.mastodonView.isHidden = false
                        self.mastodonNumber.text = String((Int(self.mastodonNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.mastodonNumber.text ?? "1") ?? 1) > 1 {
                            self.mastodonCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Pinterest.rawValue {
                        self.pintrestView.isHidden = false
                        self.pintrestNumber.text = String((Int(self.pintrestNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.pintrestNumber.text ?? "1") ?? 1) > 1 {
                            self.pintrestCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Etsy.rawValue {
                        self.etsyView.isHidden = false
                        self.etsyNumber.text = String((Int(self.etsyNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.etsyNumber.text ?? "1") ?? 1) > 1 {
                            self.etsyCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.LinkedIn.rawValue {
                        self.linkedinView.isHidden = false
                        self.linkedinNumber.text = String((Int(self.linkedinNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.linkedinNumber.text ?? "1") ?? 1) > 1 {
                            self.linkedinCircle.isHidden = false
                        }
                    }
                    else if model.name == SocialMedia.Whatsapp.rawValue {
                        self.whatsAppView.isHidden = false
                        self.whatsAppNumber.text = String((Int(self.whatsAppNumber.text ?? "1") ?? 1) + 1)
                        
                        if (Int(self.whatsAppNumber.text ?? "1") ?? 1) > 1 {
                            self.whatsAppCircle.isHidden = false
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    
    @objc func socialViewClicked(value : MyGesture){
        
        let models = socialMediaModels.filter { model in
            if model.name == value.socialType!.rawValue {
                return true
            }
            return false
        }
        
        if models.count > 1 {
            self.showAlertForEdit(models: models)
        }
        else {
            performSegue(withIdentifier: "editSocialMediaSeg", sender: models.first!)
        }
           
        
    }
    
     func showAlertForEdit(models : Array<SocialMediaModel>){
         let alert = UIAlertController(title: nil, message: "Select Account", preferredStyle: .actionSheet)
         for model in models {
             alert.addAction(UIAlertAction(title: model.link ?? "NIL", style: .default,handler: { action in
                 self.performSegue(withIdentifier: "editSocialMediaSeg", sender: model)
             }))
         }
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         present(alert, animated: true)
    }
    
    
    func hideAllSocialMedia(){
        twitterView.isHidden = true
        twitterNumber.text = "0"
        twitterCircle.isHidden = true
        
        instagramView.isHidden = true
        instagramNumber.text = "0"
        instagramCircle.isHidden = true
        
        tiktokView.isHidden = true
        tikTokNumber.text = "0"
        tiktokCircle.isHidden = true
        
        facebookView.isHidden = true
        facebookNumber.text = "0"
        facebookCircle.isHidden = true
        
        youtubeView.isHidden = true
        youtubeNumber.text = "0"
        youtubeCircle.isHidden = true
        
        rumView.isHidden = true
        rumNumber.text = "0"
        rumCircle.isHidden = true
        
        twitchView.isHidden = true
        twitchNumber.text = "0"
        twitchCircle.isHidden = true
        
        redditView.isHidden = true
        redditNumber.text = "0"
        redditCircle.isHidden = true
        
        substackView.isHidden = true
        substackNumber.text = "0"
        substackCircle.isHidden = true
        
        tumblr.isHidden = true
        tumblrNumer.text = "0"
        tumblrCircle.isHidden = true
        
        discordView.isHidden = true
        discordNumber.text = "0"
        
        telegramView.isHidden = true
        telegramNumber.text = "0"
        telegramCircle.isHidden = true
        
        truthSocialView.isHidden = true
        truthSocialNumber.text = "0"
        truthCircle.isHidden = true
        
        mastodonView.isHidden = true
        mastodonNumber.text = "0"
        mastodonCircle.isHidden = true
        
        pintrestView.isHidden = true
        pintrestNumber.text = "0"
        pintrestCircle.isHidden = true
        
        etsyView.isHidden = true
        etsyNumber.text = "0"
        etsyCircle.isHidden = true
        
        linkedinView.isHidden = true
        linkedinNumber.text = "0"
        linkedinCircle.isHidden = true
        
        whatsAppView.isHidden = true
        whatsAppNumber.text = "0"
        whatsAppCircle.isHidden = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        profileName.text = UserModel.data!.fullName ?? ""
        userName.text = "@\(UserModel.data!.userName ?? "")"
        mDescription.text = UserModel.data!.myDescription ?? ""
        professionalCat.text = UserModel.data!.professionalCat ?? ""
    }
    
    @objc func backViewClicked(){
        Constants.selectedIndex = 3
        self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
        
    }
    
    @objc func editProfileClicked(){
        performSegue(withIdentifier: "editHostProfileSeg", sender: nil)
    }
    
    public func updateTableViewHeight(){
        
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.tableView.layoutIfNeeded()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSocialMediaSeg" {
            if let vc = segue.destination as? EditSocialMediaViewContoller {
                if let socialMediaModel = sender as? SocialMediaModel {
                    vc.socialMediaModel = socialMediaModel
                }
            }
        }
        else if segue.identifier == "editEventSeg" {
            if let vc = segue.destination as? EditEventViewController {
                if let eventModel = sender as? EventModel {
                    vc.eventModel = eventModel
                }
            }
        }
      
    }
    
    @objc func cellClicked(value : MyGesture){
        let eventModel = eventModels[value.index]
        self.performSegue(withIdentifier: "editEventSeg", sender: eventModel)
    }
    
    @IBAction func addEventBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "addEventSeg", sender: nil)
    }
    
    
    @IBAction func addSocialMediaClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "addSocialMediaSeg", sender: nil)
    }
}



extension HostProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noEventsAvailable.isHidden = eventModels.count > 0 ? true : false
        return eventModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? Event_TableView_Cell {
            
            
            
            cell.mView.layer.cornerRadius = 8
            cell.mView.isUserInteractionEnabled = true
            let myGest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            myGest.index = indexPath.row
            cell.mView.addGestureRecognizer(myGest)
            
            let eventModel = eventModels[indexPath.row]
            cell.eventName.text = eventModel.name ?? ""
            
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
           
            DispatchQueue.main.async {
                self.updateTableViewHeight()
            }
            
            return cell
            
        }
        return Event_TableView_Cell()
        
    }
    
    
    
    
}
                 
