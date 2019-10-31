//
//  UdacityUser.swift
//  onTheMapVer2
//
//  Created by Hema on 10/28/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation

struct UdacityUser: Codable {
    
    let last_name: String
    let nickname: String
    enum CodingKeys: String, CodingKey {
        case last_name = "last_name"
        case nickname = "nickname"
        
    }
    
}


