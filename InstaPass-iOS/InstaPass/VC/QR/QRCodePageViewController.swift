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
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    // var targetUrl: URL?
    @IBAction func switchToLoginPage(_ sender: UIButton) {
        tabBarController?.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blurView.isHidden = true
        
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ]
    }
    
    func setNumberOfPages(number: Int) {
        NSLog("setNumberOfPages. \(number)")
        pageControl.numberOfPages = number
    }
    
    func setCurrentPage(current: Int) {
//        NSLog("setCurrentPage. \(current)")
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

    
    var isTouching = false
    
    @IBAction func onTouchDown(_ sender: UIPageControl) {
//        NSLog("change: onPageControlChangesImmediately. \(sender.currentPage)")
        isTouching = true
    }
    
    @IBAction func onTouchUp(_ sender: UIPageControl) {
        isTouching = false
    }

    @IBAction func onValueChanged(_ sender: UIPageControl) {
        if isTouching {
            containerVC?.scrollToPage(.at(index: sender.currentPage), animated: false)
        } else {
            containerVC?.scrollToPage(.at(index: sender.currentPage), animated: true)
        }
    }
}
