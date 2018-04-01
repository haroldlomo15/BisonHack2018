//
//  MainTapBarController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit

class MainTapBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[0].title = nil
        tabBarItems[0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
       
       
        tabBarItems[1].title = nil
        tabBarItems[1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
      
        tabBarItems[2].title = nil
        tabBarItems[2].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        // Do any additional setup after loading the view.
    }

   



}
