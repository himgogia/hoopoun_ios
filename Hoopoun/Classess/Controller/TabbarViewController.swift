//
//  TabbarViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self 
    }

  override  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
