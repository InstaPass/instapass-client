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
    
    static func constantCommunities() -> [Community] {
        var constantCommunities: [Community] = []
        for community in communities {
            if !community.temporary {
                constantCommunities.append(community)
            }
        }
        return constantCommunities
    }
    
    static func refreshCommunity(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        if CommunityManager.mutex.wait(timeout: DispatchTime(uptimeNanoseconds: 1000)) == DispatchTimeoutResult.timedOut {
//            failure("操作频率过快，请稍后再试。")
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
                                                  address: commObject["address"].stringValue,
                                                  temporary: commObject["temporary"].boolValue))
                                }
                                success()
                                CommunityManager.mutex.signal()
                               }, failure: { errorMsg in
                                CommunityManager.mutex.signal()
                                failure(errorMsg)
        })
    }
    
    
    static func leaveCommunity(id: Int, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        RequestManager.request(type: .post,
                               feature: .leave,
                               subUrl: nil,
                               params: [
                                "community_id": id
                               ],
                               success: { jsonObject in
                                success()
                               }, failure: { errorMsg in
                                failure(errorMsg)
        })
    }
}
