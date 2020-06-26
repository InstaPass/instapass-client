//
//  TabBarDelegate.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//
import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(duration: 0.2)
    }
}
