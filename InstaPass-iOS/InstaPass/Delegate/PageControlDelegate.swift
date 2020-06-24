//
//  PageControlDelegate.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/24.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

protocol PageControlDelegate {
    func setNumberOfPages(number: Int) -> Void
    func setCurrentPage(current: Int) -> Void
}
