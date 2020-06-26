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
        
        tableContainerVC = children.first as? UserTableViewController
        tableContainerVC?.parentVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableContainerVC?.renderData()
    }
    
    func viewGotSwitched() {
        tableContainerVC?.renderData()
    }
    
    var tableContainerVC: UserTableViewController?

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserTVSegue" {
            tableContainerVC = segue.destination as? UserTableViewController
            tableContainerVC?.parentVC = self
        }
    }
}
