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
    
    var communityId: Int!
    var communityName: String!
    
    func initCommunityInfo(id: Int, name: String) {
        communityId = id
        communityName = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redrawPageShadow()
        
        let timer = Timer(timeInterval: 10, target: self, selector: #selector(refreshQRCodeWrapped), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
        
        communityNameLabel.text = communityName ?? "未知社区"
    }
    
    func redrawPageShadow() {
        let layer = cardView.layer
        
        // radius seems doesn't work with UIVisualEffectView
//        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.5
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
        refreshQRCode()
    }

    @objc func refreshQRCodeWrapped() {
        if LoginHelper.isLogin {
            refreshQRCode()
        }
    }

    func refreshQRCode() {
        if !refreshButton.isEnabled {
            return
        }

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.sendJwtToken(token: UserPrefInitializer.jwtToken)

        refreshButton.isEnabled = false
        QRCodeManager.refreshQrCode(id: communityId, success: { _, time in
            self.flushQRCode()
            self.lastUpdateTextField.text = "最後更新 \(dateToString(time, dateFormat: "HH:mm"))"
            self.refreshButton.isEnabled = true
        }, failure: { error in
            // show ${error} message
            self.flushQRCode()
            self.lastUpdateTextField.text = "请求失败"
            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            self.refreshButton.isEnabled = true
            LoginHelper.isLogin = false
        })
    }
}
