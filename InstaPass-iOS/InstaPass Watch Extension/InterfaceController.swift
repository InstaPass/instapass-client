//
//  InterfaceController.swift
//  InstaPass Watch Extension
//
//  Created by 法好 on 2020/5/11.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        refreshImmediately()
    }

    @IBOutlet var imageField: WKInterfaceImage!
    @IBOutlet var lastRefreshTime: WKInterfaceLabel!
    @IBOutlet var refreshButton: WKInterfaceButton!

    var isLoading: Bool = false

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func refreshImmediately() {
        if isLoading {
            return
        }

        isLoading = true

        refreshButton.setEnabled(false)
        QRCodeManager.refreshQrCode(success: { _, time in
            self.flushQRCode()
            self.lastRefreshTime.setText("最後更新 \(dateToString(time, dateFormat: "HH:mm"))")
            self.refreshButton.setEnabled(true)
            self.scroll(to: self.imageField, at: WKInterfaceScrollPosition.top, animated: true)
            self.isLoading = false
        }, failure: { error in
            // show ${error} message
            self.flushQRCode()
            self.lastRefreshTime.setText("请求失败：\(error)")
            self.refreshButton.setEnabled(true)
            self.isLoading = false
        })
    }

    func flushQRCode() {
        let image = QRCodeManager.getQRCodeImage()
        
        if image == nil {
            imageField.setImage(UIImage(systemName: "questionmark.square.fill"))
        } else {
            imageField.setImage(image)
        }
    }
}
