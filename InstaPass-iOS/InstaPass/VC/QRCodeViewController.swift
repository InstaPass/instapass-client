//
//  QRCodeViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import QRCode
import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet var loadingRingIndicator: UIActivityIndicatorView!
    @IBOutlet var QRCodeView: UIImageView!
    @IBOutlet var refreshButton: UIButton!

    var targetUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        targetUrl = URL(string: "https://en.wikipedia.org/wiki/Death")
        flushQRCode()
    }

    func flushQRCode() {
        if targetUrl == nil {
            return
        }

        var qrCode = QRCode(targetUrl!)
        qrCode?.color = CIColor(rgba: "64d277")

        let style = traitCollection.userInterfaceStyle
        if style == .dark {
            qrCode?.backgroundColor = CIColor.black
        } else if style == .light {
            qrCode?.backgroundColor = CIColor.white
        }

        QRCodeView.image = qrCode?.image
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        flushQRCode()
    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
        targetUrl = URL(string: "https://en.wikipedia.org/wiki/\(arc4random_uniform(1024))")
        flushQRCode()
    }
}
