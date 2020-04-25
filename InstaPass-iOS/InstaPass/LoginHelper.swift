//
//  LoginHelper.swift
//  InstaPass
//
//  Created by 法好 on 2020/4/25.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Foundation
import Alamofire_SwiftyJSON

class LoginHelper {
    
    // always assume login until one request gets unauthorized
    static var isLogin: Bool = true;
    
    static func login(username: String, password: String, handler: (RequestResponse) -> ()) {
        
        isLogin = true
    }
    
    static func logout(handler: (RequestResponse) -> ()) {
        
        isLogin = false
    }
    
    static func requestQR(handler: (RequestResponse, String?) -> ()) {
        
    }
}
