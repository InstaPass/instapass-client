//
//  QRCodeViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import EFQRCode
import SPAlert
import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet var loadingRingIndicator: UIActivityIndicatorView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var lastUpdateTextField: UILabel!

    // var targetUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // targetUrl = URL(string: "https://en.wikipedia.org/wiki/Death")
        flushQRCode()
        refreshQRCode()
    }

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

    func refreshQRCode() {
        if !refreshButton.isEnabled {
            return
        }
        refreshButton.isEnabled = false
        QRCodeManager.refreshQrCode(success: { _, time in
            self.flushQRCode()
            self.lastUpdateTextField.text = "最後更新 \(dateToString(time, dateFormat: "HH:mm"))"
            self.refreshButton.isEnabled = true
        }, failure: { error in
            // show ${error} message
            self.flushQRCode()
            self.lastUpdateTextField.text = "请求失败"
            SPAlert.present(title: "请求 QR 码失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
            self.refreshButton.isEnabled = true

        })
    }
}
