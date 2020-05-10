//
//  UserViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class UserViewController: UINavigationController, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let childVC = viewControllers.last as? UserTableViewController
        childVC?.parentVC = self
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserTVSegue" {
//            let tableContainerVC = segue.destination as! UserTableViewController
//            tableContainerVC.parentVC = self
//        }
//    }
    
    func switchUser() {
        LoginHelper.logout(handler: { _ in
            // handle logout stuff
        })
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
}
