//
//  NotificationManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

class NotificationManager {
    static var notifications: [Notification] = []
    
    static func getFreshNotificationCount() -> Int {
        var count = 0
        for notification in notifications {
            if !notification.stale {
                count += 1
            }
        }
        return count
    }
    
    static func getTotalNotificationCount() -> Int {
        return notifications.count
    }
    
    static func retrieveNotifications(success: @escaping ([Notification]) -> Void,
                                      failure: @escaping (String) -> Void) {
        notifications.removeAll()
        
        RequestManager.request(type: .get,
                               feature: .notify,
                               subUrl: nil,
                               params: nil,
                               success: { jsonObject in
                                for notiObject in jsonObject["notifications"].arrayValue {
                                    notifications.append(Notification(from: Community(id: notiObject["community_id"].intValue, name: notiObject["community"].stringValue, address: notiObject["address"].stringValue),
                                                                      author: notiObject["author"].stringValue,
                                                                      releaseTime: Date(timeIntervalSince1970: notiObject["release_time"].doubleValue), content: notiObject["content"].stringValue, stale: false))
                                }
                                
                                RequestManager.request(type: .get,
                                                       feature: .notify,
                                                       subUrl: nil,
                                                       params: ["all": 1],
                                                       success: { jsonObject in
                                                        for notiObject in jsonObject["notifications"].arrayValue {
                                                            let staleNotification = Notification(from: Community(id: notiObject["community_id"].intValue, name: notiObject["community"].stringValue, address: notiObject["address"].stringValue),
                                                                                                 author: notiObject["author"].stringValue,
                                                                                                 releaseTime: Date(timeIntervalSince1970: notiObject["release_time"].doubleValue), content: notiObject["content"].stringValue, stale: true)
                                                            
                                                            if !notifications.contains(staleNotification) {
                                                                notifications.append(staleNotification)
                                                            }
                                                        }
                                                        
                                                        success(notifications)
                                                       }, failure: { errorMsg in
                                                        failure(errorMsg)
                                                       })
                               }, failure: { errorMsg in
                                failure(errorMsg)
                               })
    }
}
