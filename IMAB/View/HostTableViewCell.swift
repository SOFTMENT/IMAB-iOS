//
//  HostTableViewCell.swift
//  IMAB
//
//  Created by Vijay Rathore on 12/12/22.
//

import UIKit

class HostTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mAddress: UILabel!
    @IBOutlet weak var mViewProfile: UIButton!
    @IBOutlet weak var mFav: UIImageView!
    @IBOutlet weak var mView: UIView!
    
    override class func awakeFromNib() {
        
    }
    
}
