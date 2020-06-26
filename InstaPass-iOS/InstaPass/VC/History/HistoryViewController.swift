//
//  HistoryViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class HistoryViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableContainerVC = children.first as? HistoryTableViewController
        tableContainerVC?.parentVC = self
    }
    
    var tableContainerVC: HistoryTableViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableContainerVC?.renderData()
    }

    func viewGotSwitched() {
        tableContainerVC?.renderData()
    }

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
            tableContainerVC?.parentVC = self
        }
    }

}
