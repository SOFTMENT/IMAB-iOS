//
//  FavouritesViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 17/05/23.
//

import UIKit

class FavouritesViewController : UIViewController {
    
    @IBOutlet weak var noFollowersAvailable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var followModels = Array<FollowModel>()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        ProgressHUDShow(text: "")
        FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Follow").order(by: "name").addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.followModels.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let hostModel = try? qdr.data(as: FollowModel.self) {
                            self.followModels.append(hostModel)
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favHostViewSeg" {
            if let VC = segue.destination as? ShowHostProfileViewController {
                if let hostModel = sender as? UserModel {
                    VC.hostModel = hostModel
                }
            }
        }
    }
    
    @objc func cellClicked(value : MyGesture){
        performSegue(withIdentifier: "favHostViewSeg", sender: value.userModel!)
    }
    
}
extension FavouritesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noFollowersAvailable.isHidden = followModels.count > 0 ? true : false
        return followModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath) as? HostTableViewCell {
            
            let followModel = followModels[indexPath.row]
            cell.mProfile.layer.cornerRadius = 8
            cell.mView.layer.cornerRadius = 8
            
            getHostData(uid: followModel.uid ?? "123") { hostModel, error in
                if let hostModel = hostModel {
                    
                    if let disable = hostModel.disable, disable {
                        self.followModels.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                    else {
                        if let path = hostModel.profilePic, !path.isEmpty {
                            cell.mProfile.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
                        }
                        cell.mName.text = hostModel.fullName ?? ""
                        cell.professional.text = hostModel.professionalCat ?? ""
                        
                        cell.mView.isUserInteractionEnabled = true
                        let myGest = MyGesture(target: self, action: #selector(self.cellClicked(value: )))
                        myGest.userModel = hostModel
                        cell.mView.addGestureRecognizer(myGest)
                    }
                    
                  
                }
                else {
                    FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Follow").document(followModel.uid ?? "123").delete { error in
                        self.tableView.reloadData()
                    }
                }
            }
            
            return cell
        }
        return HostTableViewCell()
    }
    
    
    
    
}
