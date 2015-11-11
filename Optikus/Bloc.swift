//
//  Bloc.swift
//  Lens1
//
//  Created by Sylvain on 2015-09-18.
//  Copyright © 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

class Bloc:Optique {
    let cadre:CGRect
    var sommets:[CGPoint] {
        let s1 = cadre.origin
        let s2 = CGPointMake(cadre.origin.x + cadre.size.width, cadre.origin.y)
        let s3 = CGPointMake(cadre.origin.x + cadre.size.width, cadre.origin.y + cadre.size.height)
        let s4 = CGPointMake(cadre.origin.x, cadre.origin.y + cadre.size.height)
        
        return [s1, s2, s3, s4]
    }
    var côtés:[Segment] {
        let seg1:Segment = Segment(start: sommets[0], end: sommets[1])
        let seg2:Segment = Segment(start: sommets[1], end: sommets[2])
        let seg3:Segment = Segment(start: sommets[2], end: sommets[3])
        let seg4:Segment = Segment(start: sommets[3], end: sommets[0])
        
        return [seg1, seg2, seg3, seg4]
    }
    
    init(frame: CGRect, indice: CGFloat) {
        let centreCG = CGPointMake(frame.origin.x + frame.size.width/2.0, frame.origin.y + frame.size.height/2.0)
        self.cadre = frame

        super.init(centre: centreCG, indice: indice)        
    }
    
}

struct Segment {
    let start:CGPoint
    let end: CGPoint
    var direction:CGPoint { // vecteur pointant vers 'end'
        return end - start
    }
    
    init(start:CGPoint, end:CGPoint) {
        self.start = start
        self.end = end
    }
}