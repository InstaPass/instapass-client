//
//  NotificationManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

class NotificationManager {
    
    static var mutex = DispatchSemaphore(value: 1)
    
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
    
    
    static func getTotalNotificationCount(communityId: Int) -> Int {
        var count = 0
        for notification in notifications {
            if notification.from.id == communityId {
                count += 1
            }
        }
        return count
    }
    
    static func staleNotification(notification: Notification) {
        if notifications.contains(notification) {
            let index = notifications.firstIndex(of: notification)!
            notifications[index].stale = true
        }
    }
    
    static func retrieveNotifications(success: @escaping ([Notification]) -> Void,
                                      failure: @escaping (String) -> Void) {
        if NotificationManager.mutex.wait(timeout: DispatchTime(uptimeNanoseconds: 1000)) == DispatchTimeoutResult.timedOut {
            failure("操作频率过快")
            return
        }
//        notifications.removeAll()
        RequestManager.request(type: .get,
                               feature: .notify,
                               subUrl: nil,
                               params: nil,
                               success: { jsonObject in
                                for notiObject in jsonObject["notifications"].arrayValue {
                                    let newNotification = Notification(from: Community(id: notiObject["community_id"].intValue, name: notiObject["community"].stringValue, address: notiObject["address"].stringValue, temporary: false),
                                                                      author: notiObject["author"].stringValue,
                                                                      releaseTime: Date(timeIntervalSince1970: notiObject["release_time"].doubleValue), content: notiObject["content"].stringValue, stale: false)
                                    if !notifications.contains(newNotification) {
                                        notifications.append(newNotification)
                                    }
                                }
                                
                                RequestManager.request(type: .get,
                                                       feature: .notify,
                                                       subUrl: nil,
                                                       params: ["all": 1],
                                                       success: { jsonObject in
                                                        for notiObject in jsonObject["notifications"].arrayValue {
                                                            let staleNotification = Notification(from: Community(id: notiObject["community_id"].intValue, name: notiObject["community"].stringValue, address: notiObject["address"].stringValue, temporary: false),
                                                                                                 author: notiObject["author"].stringValue,
                                                                                                 releaseTime: Date(timeIntervalSince1970: notiObject["release_time"].doubleValue), content: notiObject["content"].stringValue, stale: true)
                                                            
                                                            if !notifications.contains(staleNotification) {
                                                                notifications.append(staleNotification)
                                                            }
                                                        }
                                                        NotificationManager.mutex.signal()
                                                        success(notifications)
                                                        MainTabViewController.instance?.refreshBadge()
                                                       }, failure: { errorMsg in
                                                        failure(errorMsg)
                                                        NotificationManager.mutex.signal()
                                                       })
                               }, failure: { errorMsg in
                                failure(errorMsg)
                                NotificationManager.mutex.signal()
                               })
    }
}
