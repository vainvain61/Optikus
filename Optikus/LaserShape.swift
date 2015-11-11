//
//  LaserShape.swift
//  TestSpriteKit
//
//  Created by Sylvain on 2015-09-30.
//  Copyright © 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import SpriteKit

class LaserShape : SKShapeNode {
    var tabPoints = [CGPoint]() {
        didSet {
            self.path = LaserShape.chemin(self.tabPoints)
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(points:[CGPoint]) {
        self.tabPoints = points

        super.init()
        
        self.path = LaserShape.chemin(self.tabPoints)
        self.strokeColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
//        self.lineWidth = 2.0
        self.glowWidth = 2.0
        self.lineJoin = CGLineJoin.Round
    }
    
    class func chemin(points:[CGPoint]) -> CGMutablePathRef {
        let laserPath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddLines(laserPath, nil, points, points.count)
        
        return laserPath
    }
    
}
