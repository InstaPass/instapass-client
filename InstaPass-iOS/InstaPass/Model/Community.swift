//
//  Community.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/26.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

struct Community: Equatable {
    static func == (lhs: Community, rhs: Community) -> Bool {
        return lhs.address == rhs.address
            && lhs.id == rhs.id
            && lhs.address == rhs.address
    }
    
    init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    var id: Int
    var name: String
    var address: String
}
