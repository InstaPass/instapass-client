//
//  QRCodeChildPageViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/22.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert

class QRCodeChildPageViewController: UIViewController {
    
    @IBOutlet var cardView: UIVisualEffectView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var lastUpdateTextField: UILabel!
    @IBOutlet weak var communityNameLabel: UILabel!
    
    var communityInfo: Community!
    
    func initCommunityInfo(community: Community) {
        communityInfo = community
    }
    
//    func initCommunityInfo(id: Int, name: String, address: String? = nil) {
//        communityId = id
//        communityName = name
//        communityAddress = address
//    }

    
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redrawPageShadow()
        
        timer = Timer(timeInterval: 10, target: self, selector: #selector(refreshQRCodeWrapped), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
        communityNameLabel.text = "「\(communityInfo.name)」出入 QR 码"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func redrawPageShadow() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.label.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOpacity = 0.22
//        cardView.clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        redrawPageShadow()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        flushQRCode()
        refreshQRCode()
    }

    func flushQRCode() {
        //        let style = traitCollection.userInterfaceStyle

        QRCodeView.image = QRCodeManager.getQRCodeImage()

        if QRCodeView.image == nil {
            QRCodeView.image = UIImage(systemName: "questionmark.square.fill")
        }
    }

    //
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //        flushQRCode()
    //    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
//        refreshQRCode()
        let alertController = UIAlertController(title: "「\(communityInfo.name)」小区",
                                                message: "位于「\(communityInfo.address)」",
                                                preferredStyle: .actionSheet)
        
        alertController.view.setTintColor()
        var refreshAction: UIAlertAction!
        if canRefresh {
            refreshAction = UIAlertAction(title: "更新 QR 码",
                                          style: .default,
                                          handler: { _ in
                                            self.refreshQRCode()
                                          })
        } else {
            refreshAction = UIAlertAction(title: "更新 QR 码中…",
                                          style: .default,
                                          handler: nil)
            refreshAction.isEnabled = false
        }
        
        let retrieveNotificationsAction = UIAlertAction(title: "检视通知",
                                                  style: .default,
                                                  handler: { _ in
                                                    self.performSegue(withIdentifier: "showNotificationsSegue", sender: self)
                                                  })
        
        let contactAction = UIAlertAction(title: "联系「\(communityInfo.name)」的管理员",
                                          style: .default,
                                          handler: { _ in
                                            // TODO: add contact feature
                                          })
        
        let leaveAction = UIAlertAction(title: "离开「\(communityInfo.name)」",
                                        style: .destructive,
                                        handler: { _ in
                                            // TODO: leave community feature
                                        })
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(refreshAction)
        
        if NotificationManager.getTotalNotificationCount(communityId: communityInfo.id) != 0 {
            alertController.addAction(retrieveNotificationsAction)
        }
        alertController.addAction(contactAction)
        alertController.addAction(leaveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc func refreshQRCodeWrapped() {
        canRefresh = true
        if LoginHelper.isLogin {
            refreshQRCode()
        }
    }
    
    var canRefresh: Bool = true

    func refreshQRCode() {
        if !canRefresh {
            return
        }

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.sendJwtToken(token: UserPrefInitializer.jwtToken)

        canRefresh = false
        QRCodeManager.refreshQrCode(id: communityInfo.id, success: { _, time in
            self.flushQRCode()
            self.lastUpdateTextField.text = "已于 \(dateToString(time, dateFormat: "HH:mm")) 更新"
            self.canRefresh = true
            LoginHelper.isLogin = true
        }, failure: { error in
            // show ${error} message
            self.flushQRCode()
            self.lastUpdateTextField.text = "请求失败"
//            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            self.canRefresh = true
            LoginHelper.isLogin = false
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotificationsSegue" {
            (segue.destination as? NotificationTableViewController)?.defaultCommunity = communityInfo
        }
    }
}
