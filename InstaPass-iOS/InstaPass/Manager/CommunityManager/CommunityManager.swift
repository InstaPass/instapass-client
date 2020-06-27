//
//  CommunityManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

class CommunityManager {
    
    static var mutex = DispatchSemaphore(value: 1)
    
    static var communities: [Community] = []
    
    static func refreshCommunity(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        if CommunityManager.mutex.wait(timeout: DispatchTime(uptimeNanoseconds: 1000)) == DispatchTimeoutResult.timedOut {
            failure("操作频率过快，请稍后再试。")
            return
        }
        CommunityManager.communities.removeAll()
        RequestManager.request(type: .get,
                               feature: .community,
                               subUrl: nil,
                               params: nil,
                               success: { jsonObject in
                                for commObject in jsonObject["communities"].arrayValue {
                                    CommunityManager.communities.append(
                                        Community(id: commObject["community_id"].intValue,
                                                  name: commObject["community"].stringValue,
                                                  address: commObject["address"].stringValue))
                                }
                                success()
                                CommunityManager.mutex.signal()
                               }, failure: { errorMsg in
                                CommunityManager.mutex.signal()
                                failure(errorMsg)
        })
    }
}
