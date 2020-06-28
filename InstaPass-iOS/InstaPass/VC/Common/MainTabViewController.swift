//
//  MainTabViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/23.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    static var instance: MainTabViewController?
    
    var strongDelegate = TabBarDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        MainTabViewController.instance = self
        // Do any additional setup after loading the view.
        SceneDelegate.mainVC = self
        updateShortcutPage()
        delegate = strongDelegate
        
        NotificationManager.retrieveNotifications(success: { _ in
            
        }, failure: { _ in
            
        })
    }
    
    func refreshBadge() {
        if self.tabBar.items!.count < 2 {
            return
        }
        let freshNotificationCount = NotificationManager.getFreshNotificationCount()
        if freshNotificationCount == 0 {
            self.tabBar.items![1].badgeValue = nil
        } else {
            self.tabBar.items![1].badgeValue = "\(freshNotificationCount)"
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            ((viewControllers?.first as? UINavigationController)?.children.first as? QRCodePageViewController)?.reloadCommunities()
        } else if item.tag == 1 {
            (viewControllers?[1] as? UserViewController)?.viewGotSwitched()
        }
    }
    
    func updateShortcutPage() {
        switch AppDelegate.defaultPage {
        case .qrcode:
            selectedIndex = 0
            ((viewControllers?.first as? UINavigationController)?.children.first as? QRCodePageViewController)?.reloadCommunities()
            break
        case .history:
//            selectedIndex = 1
//            (viewControllers?[1] as? HistoryViewController)?.viewGotSwitched()
            break
        case .person:
            selectedIndex = 1
            (viewControllers?[1] as? UserViewController)?.viewGotSwitched()
            break
        case nil:
            break
        }
        AppDelegate.defaultPage = nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
