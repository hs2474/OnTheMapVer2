//
//  File.swift
//  onTheMapVer2
//
//  Created by Hema on 10/16/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
