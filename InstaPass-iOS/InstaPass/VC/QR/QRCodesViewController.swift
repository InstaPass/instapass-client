//
//  QRCodesViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/22.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit
import Pageboy
import SPAlert

class QRCodesViewController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    var pgDelegate: PageControlDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCommunities()
        delegate = self
        dataSource = self
    }

    var viewControllers: [UIViewController] = []
    
    func refreshCommunities() {
        viewControllers.removeAll()
        
//        CommunityManager.refreshCommunity(success: { communities in
        for comm in CommunityManager.communities {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QrCodeChildVC") as! QRCodeChildPageViewController
            
            viewController.initCommunityInfo(community: comm)
            self.viewControllers.append(viewController)
        }
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QrAttendVC") as! AttendCommunityViewController
        self.viewControllers.append(viewController)
        self.reloadData()
//        }, failure: { error in
//            SPAlert.present(title: "装载数据失败", message: error, image: UIImage(systemName: "wifi.exclamationmark")!)
//        })
    }


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
        pgDelegate?.setCurrentPage(current: index)
    }
    
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        // idiot PageBoy
        pgDelegate?.setCurrentPage(current: index)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didCancelScrollToPageAt index: PageboyViewController.PageIndex, returnToPageAt previousIndex: PageboyViewController.PageIndex) {
        pgDelegate?.setCurrentPage(current: previousIndex)
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
}

