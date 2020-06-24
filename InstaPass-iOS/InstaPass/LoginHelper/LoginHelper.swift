//
//  LoginHelper.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import Foundation
import SwiftyJSON

class LoginHelper {
    // always assume login until one request gets unauthorized
    static var isLogin: Bool = true

    static func login(username: String, password: String, handler: @escaping (RequestResponse) -> Void) {
        let loginParams: Parameters = [
            "username": username,
            "password": password,
        ]
        RequestManager.request(type: .post,
                               feature: .login,
                               params: loginParams,
                               success: { jsonResp in
                                   LoginHelper.isLogin = true
                                   UserPrefInitializer.jwtToken = jsonResp["jwt_token"].stringValue
                                   let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                   appDelegate?.sendJwtToken(token: UserPrefInitializer.jwtToken)
                                   handler(.ok)
                               }, failure: { _ in
                                   LoginHelper.isLogin = false
                                   handler(.unauthorized)
        })
    }

    static func logout(handler: (RequestResponse) -> Void) {
        isLogin = false
        UserPrefInitializer.jwtToken = ""
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.sendJwtToken(token: "")
    }
}
