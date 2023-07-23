//
//  TabBarViewController.swift
//  IMAB
//
//  Created by Vijay Rathore on 12/12/22.
//

import UIKit

class TabBarViewController : UITabBarController, UITabBarControllerDelegate {
    
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self

        
        let selectedImage1 = UIImage(named: "home-15")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "home-14")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "heart-2")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "heart-1")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "schedule-3")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "schedule-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3

        let selectedImage4 = UIImage(named: "avatar-10")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "avatar-9")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
  
        
        selectedIndex = Constants.selectedIndex
        
       

    }
    
}
