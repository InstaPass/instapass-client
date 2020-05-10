//
//  RequestEnumerates.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

enum RequestType {
    case get
    case post
}

enum RequestResponse {
    case ok
    case noResponse
    case internalError
    case unauthorized
}

enum FeatureType: String {
    case login = "/resident/login"
    case logout = "/resident/logout"
    case qrcode = "/resident/qrcode"
    case avatar = "/resident/avatar"
    case history = "/resident/history"
    case info = "/resident/info"
    case upload = "/resident/upload"
    case notify = "/resident/notifications"
}

