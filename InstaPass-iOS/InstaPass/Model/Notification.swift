//
//  Notification.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

struct Notification: Equatable {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.content == rhs.content
            && lhs.from == rhs.from
            && lhs.author == rhs.author
            && lhs.releaseTime == rhs.releaseTime
    }
    
    init(from: Community, author: String, releaseTime: Date, content: String, stale: Bool) {
        self.from = from
        self.author = author
        self.releaseTime = releaseTime
        self.content = content
        self.stale = stale
    }
    var stale: Bool
    var from: Community
    var author: String
    var releaseTime: Date
    var content: String
}
