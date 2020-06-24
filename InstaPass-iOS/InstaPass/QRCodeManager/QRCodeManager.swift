//
//  QRCodeManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import EFQRCode
// import Foundation
import UIKit

class QRCodeManager {
    fileprivate static var qrCodeSecret: String?

    static var lastRefreshTime: Date?

    static let qrCodeColor = UIColor(red: 0.390625, green: 0.8203125, blue: 0.46484375, alpha: 1.0)

    static func getQRCodeImage() -> UIImage? {
        if qrCodeSecret != nil && qrCodeSecret! != "" {
            if let cgImage = EFQRCode.generate(
                content: qrCodeSecret!,
                backgroundColor: UIColor.clear.cgColor,
                foregroundColor: qrCodeColor.cgColor
            ) {
                return UIImage(cgImage: cgImage)
            } else {
                return nil
            }
        }
        return nil
    }

    static func refreshQrCode(id: Int, success: @escaping (String, Date) -> Void, failure: @escaping (String) -> Void) {
        RequestManager.request(type: .get,
                               feature: .qrcode,
                               params: ["community_id": id],
                               success: { jsonObject in
                                   let secret = jsonObject["secret"].stringValue
                                   let lastRefreshTime = jsonObject["last_refresh_time"].doubleValue
                                   qrCodeSecret = secret
                                   success(secret, Date(timeIntervalSince1970: lastRefreshTime))
                               }, failure: { errorMsg in
                                    qrCodeSecret = nil
                                   failure(errorMsg)
        })
    }
}
