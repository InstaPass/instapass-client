//
//  AttendCommunityViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/27.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import SPAlert
import QRCodeReader

class AttendCommunityViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    var parentVC: QRCodePageViewController?

    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)

            // Configure the view controller (optional)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
//            $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }

        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTapView.isUserInteractionEnabled = true
        let tapViewTap = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        addTapView.addGestureRecognizer(tapViewTap)
        
        redrawPageShadow()
    }
    
    @IBOutlet weak var addTapView: UIVisualEffectView!

    
    func redrawPageShadow() {
        addTapView.layer.cornerRadius = 20
        addTapView.layer.shadowColor = globalTintColor.cgColor
        addTapView.layer.shadowOffset = CGSize(width: 0, height: 3)
        addTapView.layer.shadowRadius = 20
        addTapView.layer.shadowOpacity = 0.8
//        cardView.clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        redrawPageShadow()
    }
    
    
    // MARK: - QRCodeReaderViewController Delegate Methods

    @objc func addButtonTapped() {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self

        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result == nil {
                return
            }
            print("scan qrcode content: \(result!.value)")
            
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Scan Result", message: String(describing: result), preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Copy", style: .cancel, handler: nil))
//
//                self.present(alert, animated: true)
//            }
            let secretValue = result!.value
            if secretValue.hasPrefix("instapass{") && secretValue.hasSuffix("}") {
                RequestManager.request(type: .post,
                                       feature: .enter,
                                       subUrl: nil,
                                       params: [
                                        "secret": secretValue
                ], success: { jsonResponse in
                    DispatchQueue.main.async {
                        SPAlert.present(title: "加入成功", message: "您已成功加入「\(jsonResponse["community"].string ?? "新小区")」", image: UIImage(systemName: "checkmark.seal")!)
                    }
                    self.parentVC?.reloadCommunities()
                }, failure: { errorMsg in
                    SPAlert.present(title: "请求失败", message: "加入失败。服务器报告了一个「\(errorMsg)」错误。", image: UIImage(systemName: "multiply")!)
                })
            } else {
                SPAlert.present(title: "扫描 QR 码失败", message: "这不是一个合法的 InstaPass QR 码。", image: UIImage(systemName: "multiply")!)
            }
        }

        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet

        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
