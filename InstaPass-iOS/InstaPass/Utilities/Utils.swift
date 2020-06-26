//
//  Utils.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import Foundation

let globalTintColor = UIColor(red: 0.34375, green: 0.58203125, blue: 0.671875, alpha: 1.0)

func dateToString(_ date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    return formatter.string(from: date)
}

#if os(iOS)

enum Page {
    case qrcode
    case history
    case person
}

extension UIAlertController {

    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
//        ActivityIndicatorData.activityIndicator.color = UIColor.white
        ActivityIndicatorData.activityIndicator.startAnimating()
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }

    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}

extension UIView {    
    func setTintColor(color: UIColor = globalTintColor) -> Void {
        for view in subviews {
            view.tintColor = color
            view.setTintColor(color: color)
        }
    }
}
#endif
