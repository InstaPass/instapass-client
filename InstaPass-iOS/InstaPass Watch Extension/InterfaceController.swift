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
        
        refreshCommunity()
    }

    @IBOutlet var imageField: WKInterfaceImage!
    @IBOutlet var lastRefreshTime: WKInterfaceLabel!
    @IBOutlet var refreshButton: WKInterfaceButton!
    @IBOutlet weak var communityPicker: WKInterfacePicker!
    

    var isLoading: Bool = false

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    var secret: String?
    
    var targetCommunity: Community?

    @IBAction func onCommunityPicked(_ value: Int) {
        if value >= 0 && value < CommunityManager.communities.count {
            targetCommunity = CommunityManager.communities[value]
        } else {
            targetCommunity = nil
        }
        refreshImmediately()
    }
    
    @IBAction func refreshImmediately() {
        if UserPrefInitializer.jwtToken == "" {
            self.lastRefreshTime.setText("请先在手机端登录")
            return
        }
        if targetCommunity == nil {
            self.lastRefreshTime.setText("没有可选的小区")
            return
        }
        if isLoading {
            return
        }

        isLoading = true

        refreshButton.setEnabled(false)
        QRCodeManager.refreshQrCode(id: targetCommunity!.id, success: { secret, time in
            self.secret = secret
            self.flushQRCode()
            self.lastRefreshTime.setText("已于 \(dateToString(time, dateFormat: "HH:mm")) 更新")
            self.refreshButton.setEnabled(true)
            self.scroll(to: self.imageField, at: WKInterfaceScrollPosition.top, animated: true)
            self.isLoading = false
        }, failure: { error in
            // show ${error} message
            self.secret = nil
            self.flushQRCode()
            self.lastRefreshTime.setText("请求失败：\(error)")
            self.refreshButton.setEnabled(true)
            self.isLoading = false
        })
    }

    func flushQRCode() {
        let image = QRCodeManager.getQRCodeImage(secret: secret)
        
        if image == nil {
            imageField.setImage(UIImage(systemName: "questionmark.square.fill"))
        } else {
            imageField.setImage(image)
        }
    }
    
    func refreshCommunity() {
        CommunityManager.refreshCommunity(success: {
            if CommunityManager.communities.count > 0 {
                if self.targetCommunity == nil || !CommunityManager.communities.contains(self.targetCommunity!) {
                    self.targetCommunity = CommunityManager.communities[0]
                }
                var items: [WKPickerItem] = []
                for community in CommunityManager.communities {
                    let newItem = WKPickerItem()
                    newItem.title = community.name
                    items.append(newItem)
                }
                self.communityPicker.setItems(items)
                self.communityPicker.focus()
                self.refreshImmediately()
            }
        }, failure: { error in
            self.lastRefreshTime.setText(error)
        })
    }
}
