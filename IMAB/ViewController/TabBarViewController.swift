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

        
        let selectedImage1 = UIImage(named: "home-5")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "home-4")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "heart-4")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "heart-5")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
//        let selectedImage3 = UIImage(named: "calendar-3")?.withRenderingMode(.alwaysOriginal)
//        let deSelectedImage3 = UIImage(named: "calendar")?.withRenderingMode(.alwaysOriginal)
//        tabBarItems = self.tabBar.items![2]
//        tabBarItems.image = deSelectedImage3
//        tabBarItems.selectedImage = selectedImage3
//

        
        let selectedImage4 = UIImage(named: "avatar-6")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "avatar-7")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        

        
        
        selectedIndex = Constants.selectedIndex
        

    }
    
}
