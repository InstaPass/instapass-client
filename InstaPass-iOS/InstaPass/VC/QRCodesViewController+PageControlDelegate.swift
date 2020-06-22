//
//  QRCodesViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/22.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Pageboy
import UIKit

class QRCodesViewController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    var pgDelegate: PageControlDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 3 {
            viewControllers.append((storyboard?.instantiateViewController(withIdentifier: "QrCodeChildVC"))!)
        }
        
        delegate = self
        dataSource = self
    }

    var viewControllers: [UIViewController] = []

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        pgDelegate?.setNumberOfPages(number: viewControllers.count)
        return viewControllers.count
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: NavigationDirection,
                               animated: Bool) {
        
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        // idiot PageBoy
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        // idiot PageBoy
    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        pgDelegate?.setCurrentPage(current: index)
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
}

protocol PageControlDelegate {
    func setNumberOfPages(number: Int) -> Void
    func setCurrentPage(current: Int) -> Void
}
