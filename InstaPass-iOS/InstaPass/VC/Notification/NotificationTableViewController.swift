//
//  NotificationTableViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    var parentVC: UserTableViewController?
    
    var defaultCommunity: Community?
    
    var titles: [Community] = []
    var notificationDictionary = [Community: [Notification]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadNotificationData()
        tableView.dataSource = self
        tableView.delegate = self
        
        if defaultCommunity != nil && titles.contains(defaultCommunity!) {
            tableView.scrollToRow(at: IndexPath(row: titles.firstIndex(of: defaultCommunity!)!, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        parentVC?.renderData()
        MainTabViewController.instance?.refreshBadge()
    }
    
    func loadNotificationData() {
        for notif in NotificationManager.notifications {
            if notificationDictionary[notif.from] != nil {
                notificationDictionary[notif.from]!.append(notif)
            } else {
                notificationDictionary[notif.from] = [notif]
                titles.append(notif.from)
            }
        }
        
        for (title, _) in notificationDictionary {
            notificationDictionary[title]?.sort(by: { lhs, rhs in
                return lhs.releaseTime > rhs.releaseTime
            })
        }
        
        for (title, _) in notificationDictionary {
            notificationDictionary[title]?.sort(by: { lhs, rhs in
                return !lhs.stale && rhs.stale
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return notificationDictionary.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notificationDictionary[titles[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return  "来自「\(titles[section].name)」的通知"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell

        let notification = notificationDictionary[titles[indexPath.section]]?[indexPath.row]
        cell.authorLabel.text = "由「\(notification?.author ?? "管理员")」发布"
        cell.contentLabel.text = notification?.content ?? "无内容"
        cell.releaseTimeLabel.text = dateToString(notification?.releaseTime ?? Date.init(timeIntervalSince1970: 0), dateFormat: "MM 月 dd 日 HH:mm")
        cell.newMessagePrompt.isHidden = notification?.stale ?? true
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        notificationDictionary[titles[indexPath.section]]![indexPath.row].stale = true
        let toStaleNotification = notificationDictionary[titles[indexPath.section]]![indexPath.row]
        NotificationManager.staleNotification(notification: toStaleNotification)
        (tableView.cellForRow(at: indexPath) as? NotificationTableViewCell)?.newMessagePrompt.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var strings: [String] = []
        for title in titles {
            strings.append(title.name)
        }
        return strings
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        var index: Int = 0
        for community in titles {
            if community.name == title {
                return index
            }
            index += 1
        }
        return 0
    }

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

}
