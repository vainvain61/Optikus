//
//  Utiles.swift
//  Lens1
//
//  Created by Sylvain on 2015-09-23.
//  Copyright © 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

let kExtrapolationDroite:CGFloat = 4000.0

let kFrameDevice = UIScreen.mainScreen().bounds


func pointLointain(ptDépart ptDépart:CGPoint,  direction:CGPoint) -> CGPoint {
    let directionNormalisé = direction.normalized()
    let result = directionNormalisé * kExtrapolationDroite + ptDépart
    
    return result
}

prefix func - (vector: CGPoint) -> CGPoint {
    return CGPoint(x: -vector.x, y: -vector.y)
}

extension CGPoint {
    func dot(v: CGPoint) -> CGFloat {
        return self.x * v.x + self.y * v.y
    }
}