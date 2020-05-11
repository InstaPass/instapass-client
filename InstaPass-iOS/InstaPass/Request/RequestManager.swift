//
//  RequestManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import Foundation
import SwiftyJSON

class RequestManager {
    // MARK: - stop doing anything stupid

    static var baseUrl = URL(string: "http://47.100.50.175:8288")!
    
//    static var jwtToken: String?

    static func request(type requestType: RequestType, feature featureType: FeatureType,
                        params parameters: Parameters?,
                        success successHandler: @escaping (JSON) -> Void, failure failureHandler: @escaping (String) -> Void) {
        var method: HTTPMethod!

        if requestType == .get {
            method = .get
        } else if requestType == .post {
            method = .post
        } else {
            // fallback
            method = .get
        }
        Alamofire.request(URL.init(string: featureType.rawValue, relativeTo: baseUrl)!,
                          method: method,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: ["Jwt-Token" : UserPrefInitializer.jwtToken ]).responseSwiftyJSON(completionHandler: { responseJSON in
            if responseJSON.error != nil {
                failureHandler(responseJSON.error!.localizedDescription)
            } else {
                let jsonResp = responseJSON.value
                if jsonResp == nil {
                    failureHandler("bad response")
                } else {
                    if jsonResp!["status"].stringValue != "ok" && jsonResp!["jwt_token"].stringValue == "" {
                        // TODO: fix status msg
                        failureHandler(jsonResp!["msg"].stringValue)
                    } else {
                        successHandler(jsonResp!)
                    }
                }
            }
        })
    }
}

