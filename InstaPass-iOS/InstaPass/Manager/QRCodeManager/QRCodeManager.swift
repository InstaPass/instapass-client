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

    static let qrCodeColor = globalTintColor

//    static func getQRCodeImage() -> UIImage? {
//        if qrCodeSecret != nil && qrCodeSecret! != "" {
//            if let cgImage = EFQRCode.generate(
//                content: qrCodeSecret!,
//                backgroundColor: UIColor.clear.cgColor,
//                foregroundColor: qrCodeColor.cgColor
//            ) {
//                return UIImage(cgImage: cgImage)
//            } else {
//                return nil
//            }
//        }
//        return nil
//    }
    
    static func getQRCodeImage(secret: String?) -> UIImage? {
        if secret != nil && secret! != "" {
            if let cgImage = EFQRCode.generate(
                content: secret!,
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
                               subUrl: ["\(id)"],
                               params: nil,
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
