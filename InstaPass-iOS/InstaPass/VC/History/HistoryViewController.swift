//
//  HistoryViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    var targetCommunity: Community?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if targetCommunity != nil {
            navigationItem.title = "出入「\(targetCommunity!.name)」记录"
        } else {
            navigationItem.title = "出入记录"
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem?.title = "出行认证 QR 码"
    }
    
    var tableContainerVC: HistoryTableViewController?

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryTVSegue" {
            tableContainerVC = segue.destination as? HistoryTableViewController
            tableContainerVC?.targetCommunity = targetCommunity
        }
    }
}
