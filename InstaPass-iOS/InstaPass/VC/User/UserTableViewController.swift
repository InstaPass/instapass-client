//
//  UserTableViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class UserTableViewController: UITableViewController {
    
    var parentVC: UserViewController?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNickNameField: UILabel!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var contactPhoneField: UILabel!
    @IBOutlet weak var livingPositionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        profileImageView.layer.cornerRadius = 14
    }
    
    func reloadData(success: @escaping () -> Void, failure: @escaping () -> Void) {
        CommunityManager.refreshCommunity(success: {
            NotificationManager.retrieveNotifications(success: { _ in
                success()
            }, failure: { _ in
                failure()
            })
        }, failure: { _ in
            failure()
        })
    }
    
    func renderData() {
        let unreadCount = NotificationManager.getFreshNotificationCount()
        let totalCount = NotificationManager.getTotalNotificationCount()
        if unreadCount != 0 {
            self.notificationCountLabel.text = "\(unreadCount) 未读"
        } else if totalCount != 0 {
            self.notificationCountLabel.text = "\(totalCount) 已读"
        } else {
            self.notificationCountLabel.text = "无"
        }
        
        let communityCount = CommunityManager.communities.count
        if communityCount == 0 {
            self.livingPositionLabel.text = "未知"
        } else if communityCount == 1 {
            self.livingPositionLabel.text = CommunityManager.communities.first!.address
        } else {
            self.livingPositionLabel.text = "\(CommunityManager.communities.first!.address)，和另外 \(communityCount - 1) 处"
        }
        
        self.tableView.reloadData()
    }
    
    func switchUser() {
        
        LoginHelper.logout(handler: { _ in
            // handle logout stuff
        })
        
        let alertController = UIAlertController(title: "真的要注销登录吗？",
                                                message: "您将需要重新提供身份证明来再次登录。",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()

        let logOutAction = UIAlertAction(title: "注销",
                                         style: .destructive,
                                                  handler: { _ in
                                                    self.performSegue(withIdentifier: "LogOutSegue", sender: self)
                                        })
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotificationsSegue" {
            (segue.destination as? NotificationTableViewController)?.parentVC = self
        }
    }
    // MARK: - Table view data source

    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
         return 0
     }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
         return 0
     }
     */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            
        } else if (indexPath.section == 1) {
            if NotificationManager.notifications.isEmpty {
                SPAlert.present(title: "没有任何通知", image: UIImage(systemName: "ellipsis.bubble.fill")!)
            } else {
                performSegue(withIdentifier: "showNotificationsSegue", sender: self)
            }
        } else if (indexPath.section == 2) {
            
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                // preference
            }
            else if indexPath.row == 1 {
                // switch user
                switchUser()
            }
        }
    }

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         // Configure the cell...

         return cell
     }
     */

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
}
