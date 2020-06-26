//
//  User.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

struct User {
    init(name: String, nickName: String, telePhone: String, emailAddress: String) {
        self.name = name
        self.nickName = nickName
        self.telePhone = telePhone
        self.emailAddress = emailAddress
    }

    var name: String
    var nickName: String
    var telePhone: String
    var emailAddress: String
}
