//
//  GradientView.swift
//  onTheMapVer2
//
//  Created by Hema on 10/16/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        gradientLayer = CAGradientLayer()
        let colorTop = UIColor.gradientTop.cgColor
        let colorBottom = UIColor.gradientBottom.cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        gradientLayer.frame = frame
    }
    
}


