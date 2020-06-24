//
//  MainTabViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/23.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    var strongDelegate = TabBarDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SceneDelegate.mainVC = self
        updateShortcutPage()
        
        delegate = strongDelegate
    }
    
    func updateShortcutPage() {

        switch AppDelegate.defaultPage {
        case .qrcode:
            selectedIndex = 0
            break
        case .history:
            selectedIndex = 1
            break
        case .person:
            selectedIndex = 2
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
