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

class QRCodePageViewController: UIViewController, PageControlDelegate {

    var containerVC: QRCodesViewController?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    
    func setNumberOfPages(number: Int) {
        NSLog("setNumberOfPages. \(number)")
        pageControl.numberOfPages = number
    }
    
    func setCurrentPage(current: Int) {
        NSLog("setCurrentPage. \(current)")
        pageControl.currentPage = current
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRCodeSegue" {
            containerVC = segue.destination as? QRCodesViewController
            containerVC?.pgDelegate = self
        }
    }
    
    public func updatePage(count: Int) {
        pageControl.numberOfPages = count
    }
    
    @IBAction func onPageControlChanges(_ sender: UIPageControl) {
        NSLog("onPageControlChanges. \(sender.currentPage)")
        containerVC?.scrollToPage(.at(index: sender.currentPage), animated: true)
    }
}
