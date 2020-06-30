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
    @IBOutlet weak var previousQRCodeView: UIImageView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var lastUpdateTextField: UILabel!
    @IBOutlet weak var communityNameLabel: UILabel!
    
    var parentVC: QRCodePageViewController?
    
    var communityInfo: Community!
    
    var secret: String?
    
    var isOkay: Bool = true
    
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
        QRCodeView.image = UIImage(systemName: "qrcode")
        
        timer = Timer(timeInterval: 10, target: self, selector: #selector(refreshQRCodeWrapped), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
        
        if communityInfo.temporary {
            communityNameLabel.text = "「\(communityInfo.name)」临时出入凭证"
            QRCodeView.tintColor = UIColor.secondaryLabel
            previousQRCodeView.tintColor = UIColor.secondaryLabel
        } else {
            communityNameLabel.text = "「\(communityInfo.name)」出入凭证"
        }
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
        flushQRCode()
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
        
        previousQRCodeView.alpha = 1
        QRCodeView.alpha = 0
        
        previousQRCodeView.image = QRCodeView.image
        
        if communityInfo.temporary {
            QRCodeView.image = QRCodeManager.getQRCodeImage(secret: secret, color: UIColor.secondaryLabel.cgColor)
        } else {
            QRCodeView.image = QRCodeManager.getQRCodeImage(secret: secret)
        }
        
        if QRCodeView.image == nil {
            QRCodeView.image = UIImage(systemName: "qrcode")
        }
        

        UIView.animate(withDuration: 0.1, animations: {
            self.previousQRCodeView.alpha = 0
            self.QRCodeView.alpha = 1
        })
    }

    //
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //        flushQRCode()
    //    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
//        refreshQRCode()
        var titleString = "「\(communityInfo.name)」出入凭证"
        if communityInfo.temporary {
            titleString = "「\(communityInfo.name)」临时出入凭证"
        }
        let alertController = UIAlertController(title: titleString,
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
        
        let historyAction = UIAlertAction(title: "查看出入「\(communityInfo.name)」记录",
                                          style: .default,
                                          handler: { _ in
                                            self.performSegue(withIdentifier: "showHistorySegue", sender: self)
                                          })
        
        var removeTitle: String = "移除「\(communityInfo.name)」出入凭证"
        if communityInfo.temporary {
            removeTitle = "移除「\(communityInfo.name)」临时出入凭证"
        }
        let leaveAction = UIAlertAction(title: removeTitle,
                                        style: .destructive,
                                        handler: { _ in
                                            self.confirmLeavingCommunity(community: self.communityInfo)
                                        })
        
        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(refreshAction)
        
        if NotificationManager.getTotalNotificationCount(communityId: communityInfo.id) != 0 {
            alertController.addAction(retrieveNotificationsAction)
        }
        
        if !communityInfo.temporary {
            alertController.addAction(historyAction)
        }
        alertController.addAction(leaveAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = refreshButton
        alertController.popoverPresentationController?.sourceRect = refreshButton.bounds
        
        present(alertController, animated: true, completion: nil)
    }

    @objc func refreshQRCodeWrapped() {
        canRefresh = true
        if isOkay {
            refreshQRCode()
        }
    }
    
    var canRefresh: Bool = true
    
    func confirmLeavingCommunity(community: Community) {
        if community.temporary {
            CommunityManager.leaveCommunity(id: community.id,
                                            success: {
                                                SPAlert.present(message: "已成功移除该 QR 码。", haptic: .success)
                                                self.parentVC?.reloadCommunities()
                                            }, failure: { error in
                                                SPAlert.present(message: "未能移除该 QR 码，因为一个「\(error)」错误。", haptic: .error)
                                            })
        } else {
            let alertController = UIAlertController(title: "您确认要移除「\(community.name)」发放的通行 QR 码吗？",
                                                    message: "如要进入该小区，您将需要再次申领 QR 码。",
                                                    preferredStyle: .actionSheet)
            
            alertController.view.setTintColor()
            
            let leaveAction = UIAlertAction(title: "确认移除",
                                            style: .destructive,
                                            handler: { _ in 
                                                CommunityManager.leaveCommunity(id: community.id,
                                                                                success: {
                                                                                    SPAlert.present(message: "已成功移除该 QR 码。", haptic: .success)
                                                                                    self.parentVC?.reloadCommunities()
                                                                                }, failure: { error in
                                                                                    SPAlert.present(message: "未能移除该 QR 码，因为一个「\(error)」错误。", haptic: .error)
                                                                                })
                                             })
            let cancelAction = UIAlertAction(title: "取消",
                                             style: .cancel,
                                             handler: nil)
            
            alertController.addAction(leaveAction)
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = refreshButton
            alertController.popoverPresentationController?.sourceRect = refreshButton.bounds
            
            
            present(alertController, animated: true, completion: nil)
        }
    }

    func refreshQRCode() {
        if !canRefresh {
            return
        }

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.sendJwtToken(token: UserPrefInitializer.jwtToken)

        canRefresh = false
        QRCodeManager.refreshQrCode(id: communityInfo.id, success: { secret, time in
            self.secret = secret
            self.flushQRCode()
            self.lastUpdateTextField.text = "已于 \(dateToString(time, dateFormat: "HH:mm")) 更新"
            self.canRefresh = true
            self.isOkay = true
        }, failure: { error in
            // show ${error} message
            self.secret = nil
            self.flushQRCode()
            self.lastUpdateTextField.text = "错误：\(error)"
//            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            
            self.canRefresh = true
            self.isOkay = false
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotificationsSegue" {
            (segue.destination as? NotificationTableViewController)?.defaultCommunity = communityInfo
        } else if segue.identifier == "showHistorySegue" {
            (segue.destination as? HistoryViewController)?.targetCommunity = communityInfo
        }
    }
}
