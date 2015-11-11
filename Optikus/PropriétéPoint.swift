//
//  PointIncidence.swift
//  Lens1
//
//  Created by Sylvain on 2015-08-19.
//  Copyright (c) 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

struct PropriétéPoint {
    var indice: CGFloat = 1.0
    var point = CGPointZero
    var normale = CGPointZero
    var directionRayon = CGPointZero
    
    init() {
        
    }
    
    init(indice: CGFloat, point: CGPoint, directionRayon: CGPoint) {
        self.indice = indice
        self.point = point
        self.directionRayon = directionRayon
    }
}