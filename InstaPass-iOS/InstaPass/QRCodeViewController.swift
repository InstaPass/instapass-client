//
//  QRCodeViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import QRCode

class QRCodeViewController: UIViewController {

    @IBOutlet weak var loadingRingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var QRCodeView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://google.com.hk")!
        var qrCode = QRCode(url)
        qrCode?.color = CIColor(rgba: "64d277")
        QRCodeView.image = qrCode?.image
    }

    @IBAction func onRefreshButtonTapped(_ sender: UIButton) {
        
    }
    
}

