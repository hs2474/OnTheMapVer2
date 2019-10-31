//
//  OnTheMapUser.swift
//  onTheMapVer2
//
//  Created by Hema on 10/17/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
struct Account: Codable {
    let registered: Bool
    let key:String
    
}

struct Session: Codable{
    let id: String
    let expiration: String
}

struct Userinfo:Codable{
    let account: Account
    let session: Session
}



