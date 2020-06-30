//
//  History.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/30.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

struct History {
    init(time: Date, reason: String, inside: Bool) {
        self.time = time
        self.reason = reason
        self.inside = inside
    }
    
    var time: Date
    var reason: String
    var inside: Bool
}
