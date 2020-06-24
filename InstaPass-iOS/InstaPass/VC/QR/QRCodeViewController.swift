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

class QRCodePageViewController: UIViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // var targetUrl: URL?
    @IBAction func switchToLoginPage(_ sender: UIButton) {
        tabBarController?.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blurView.isHidden = true
    }

}
