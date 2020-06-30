//
//  HistoryManager.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/27.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

class HistoryManager {

    static var mutex = DispatchSemaphore(value: 1)
    
    static var history: [History] = []
    
    static func receiveHistory(id: Int, success: @escaping ([History], Date?, Bool) -> Void,
                                      failure: @escaping (String) -> Void) {
        if NotificationManager.mutex.wait(timeout: DispatchTime(uptimeNanoseconds: 1000)) == DispatchTimeoutResult.timedOut {
            failure("操作频率过快")
            return
        }
//        notifications.removeAll()
        RequestManager.request(type: .get,
                               feature: .history,
                               subUrl: ["\(id)"],
                               params: nil,
                               success: { jsonObject in
                                var history: [History] = []
                                var isOutside: Bool = false
                                var latestOutTime: Date?
                                if jsonObject["current_status"].stringValue == "outside" {
                                    isOutside = true
                                }
                                
                                let latestOutTimeTick = jsonObject["last_exit_time"].double
                                
                                if latestOutTimeTick != nil && latestOutTimeTick != 0 {
                                    latestOutTime = Date(timeIntervalSince1970: latestOutTimeTick!)
                                }
                            
                                for hisObject in jsonObject["history"].arrayValue {
                                    history.append(History(time: Date(timeIntervalSince1970: hisObject["time"].doubleValue),
                                                           reason: hisObject["reason"].stringValue, inside: hisObject["where"].stringValue == "inside"))
                                }
                                success(history, latestOutTime, isOutside)
                                NotificationManager.mutex.signal()
                               }, failure: { errorMsg in
                                failure(errorMsg)
                                NotificationManager.mutex.signal()
                               })
    }
}


