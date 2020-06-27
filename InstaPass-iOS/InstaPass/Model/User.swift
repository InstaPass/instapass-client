//
//  User.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

struct User {
    init(name: String, uniqueId: String) {
        self.name = name
        self.uniqueId = uniqueId
    }

    var name: String
    var uniqueId: String
}
