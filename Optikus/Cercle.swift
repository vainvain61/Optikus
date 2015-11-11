//
//  Cercle.swift
//  Lens1
//
//  Created by Sylvain on 2015-08-17.
//  Copyright (c) 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

class Cercle: Optique, OutilsOptique {
    let rayon:CGFloat
    var cadre: CGRect {
        let origine = centre - CGPoint(x: rayon, y: rayon)
        let side = 2.0 * rayon
        
        return CGRectMake(origine.x, origine.y, side, side)
    }
    
    override var description: String {
        return super.description + ", rayon: \(rayon)"
    }
    
    init(centre: CGPoint, indice: CGFloat, rayon: CGFloat) {
        self.rayon = rayon
        super.init(centre: centre, indice: indice)
    }
    
    // Pour être conforme avec le protocole 'OutilsOptique'
    func pointsContact(ptAvantContact: PropriétéPoint) -> [PropriétéPoint] {
        return super.pointsContact(ptAvantContact, outils: self)
    }
    
    // Pour être conforme avec le protocole 'OutilsOptique'
    func pointContact(ptAvantContact: PropriétéPoint) -> PropriétéPoint? {
        var pointResult: PropriétéPoint?
        var contact = CGPointZero
        var normal = CGPointZero
        let ptStart = ptAvantContact.point + ptAvantContact.directionRayon * 1.0001
        let vIncidence = ptAvantContact.directionRayon
        let ptEnd = vIncidence * kExtrapolationDroite + ptStart
        let d = ptEnd - ptStart
        let f = ptStart - centre
        
        let a = d.lengthSquared()
        let epsilon:CGFloat = 0.00001
        if (a > epsilon) {
            let b = 2*d.dot(f)
            let c = f.lengthSquared() - rayon*rayon
            
            let discriminent = sqrt(b*b - 4*a*c)
            
            let t1 = (-b + discriminent)/(2*a)
            let t2 = (-b - discriminent)/(2*a)
            
            if (t1 < 1 && t1 > 0) || (t2 < 1 && t2 > 0) {
                pointResult = PropriétéPoint()

                let p1 = d*t1 + ptStart
                let p2 = d*t2 + ptStart
                
                if t1 > 0 && t2 < 0 {
                    contact = p1
                } else if t2 > 0 && t1 < 0 {
                    contact = p2
                } else if t1 > 0 && t2 > 0 && t1 < t2 {
                    contact = p1
                } else {
                    contact = p2
                }
                
                normal = centre - contact
                if ptAvantContact.indice == 1.0 {
                    normal = -normal
                }
                
                pointResult?.point = contact
                pointResult?.normale = normal.normalized()
            }
            
        }

        return pointResult
    }

    override func isPointInsideOptic(s: CGPoint) -> Bool {
        let diff:CGPoint = s - centre
        let r = diff.length()
        if r < rayon {
            return true
        } else {
            return false
        }
    }
    
}


