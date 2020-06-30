//
//  HistoryTableViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class HistoryTableViewController: UITableViewController {

    var targetCommunity: Community?
    var histories: [History] = []
    var lastOutTime: Date?
    var isOutside: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if targetCommunity != nil {
            navigationItem.title = "出入「\(targetCommunity!.name)」记录"
        } else {
            navigationItem.title = "出入记录"
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.reloadData()
        renderData()
    }
    
    func renderData() {
        if targetCommunity == nil {
            return
        }
        HistoryManager.receiveHistory(id: targetCommunity!.id) { histories, date, isOutside in
            self.histories = histories
            self.histories.sort { lhs, rhs -> Bool in
                lhs.time > rhs.time
            }
            self.lastOutTime = date
            self.isOutside = isOutside
            self.reloadDataAnimated()
        } failure: { error in
            self.histories = []
            self.lastOutTime = nil
            self.reloadDataAnimated()
        }
    }
    
    func reloadDataAnimated() {
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tableView.reloadData()
                          }, completion: nil)
    }

    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        if histories.count == 0 {
            return 1
        } else if isOutside {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if histories.count == 0 {
            return 1
        } else if isOutside {
            return section == 0 ? 1 : histories.count
        } else {
            return histories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func generateLastOutCell(at indexPath: IndexPath) -> HistoryTableViewStatusCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outingStatusCell", for: indexPath) as! HistoryTableViewStatusCell
        
        if lastOutTime != nil {
            cell.outingStatusLabel.text = isOutside ? "已外出" : "上次外出"
            let differTime = Int(Date().timeIntervalSince(lastOutTime!) / 3600)
            if differTime == 0 {
                cell.lastTimeLabel.text = "不到一小时"
            } else {
                cell.lastTimeLabel.text = "大约 \(differTime) 小时"
            }
            
            cell.approximateTimeCell.text = dateToString(lastOutTime!, dateFormat: "MM 月 dd 日 HH:mm")
        } else {
            cell.outingStatusLabel.text = ""
            cell.lastTimeLabel.text = "从未外出"
            cell.approximateTimeCell.text = ""
        }
        return cell
    }

    func generateItemCell(at indexPath: IndexPath) -> HistoryTableViewItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outingItemCell", for: indexPath) as! HistoryTableViewItemCell

        let historyObject = histories[indexPath.row]
        cell.outingTimeLabel.text = dateToString(historyObject.time, dateFormat: "MM 月 dd 日 HH:mm")
        cell.outingReasonLabel.text = historyObject.reason
        return cell

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if histories.count == 0 {
            if isOutside {
                return generateLastOutCell(at: indexPath)
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "noDataCell", for: indexPath)
            }
        } else if isOutside {
            if indexPath.section == 0 {
                return generateLastOutCell(at: indexPath)
            } else {
                return generateItemCell(at: indexPath)
            }
        } else {
            return generateItemCell(at: indexPath)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if histories.count == 0 {
            return nil
        } else if isOutside && section == 1 {
            return "全部出入记录"
        } else if !isOutside && section == 0 {
            return "全部出入记录"
        }
        return nil
    }
}
