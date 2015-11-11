//
//  Prisme.swift
//  Lens1
//
//  Created by Sylvain on 2015-08-17.
//  Copyright (c) 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit


class Prisme: Optique, OutilsOptique {
    let side: CGFloat
    let angle: CGFloat
    var sommets:[CGPoint] {
        let h = sqrt(3.0)*side/2.0
        let p1 = self.centre + CGPoint(x: 0, y: -2*h/3.0)
        let p2 = self.centre + CGPoint(x: -side/2, y: h/3)
        let p3 = self.centre + CGPoint(x: side/2, y: h/3)
        
        let trans = CGAffineTransformMakeTranslation(-centre.x, -centre.y)
        let rot = CGAffineTransformMakeRotation(angle)
        let transInverse = CGAffineTransformInvert(trans)
        var combinaisonTrans = CGAffineTransformConcat(trans, rot)
        combinaisonTrans = CGAffineTransformConcat(combinaisonTrans, transInverse)
        
        let s1 = CGPointApplyAffineTransform(p1, combinaisonTrans)
        let s2 = CGPointApplyAffineTransform(p2, combinaisonTrans)
        let s3 = CGPointApplyAffineTransform(p3, combinaisonTrans)
        
        return [s1, s2, s3]
    }
    var côtés:[Segment] {
        let seg1:Segment = Segment(start: sommets[0], end: sommets[1])
        let seg2:Segment = Segment(start: sommets[1], end: sommets[2])
        let seg3:Segment = Segment(start: sommets[2], end: sommets[0])
        
        return [seg1, seg2, seg3]
    }
    var cadre: CGRect {
        let w:CGFloat = 2*side/sqrt(3.0)
        let origine = centre - CGPoint(x: w, y: w)/2.0
        
        return CGRectMake(origine.x, origine.y, w, w)
    }
    
    // Initialisation
    init(centre: CGPoint, indice: CGFloat, side: CGFloat, angle: CGFloat) {
        self.angle = angle
        self.side = side
        
        super.init(centre: centre, indice: indice)
    }
    
    
    // --------------------
    // Pour être conforme avec le protocole 'OutilsOptique'
    func pointsContact(ptAvantContact: PropriétéPoint) -> [PropriétéPoint] {
        return super.pointsContact(ptAvantContact, outils: self)
    }
    
    // Trouve un point de contact avec l'optique
    func pointContact(ptAvantContact: PropriétéPoint) -> PropriétéPoint? {
        var pointResult: PropriétéPoint?
        var contact = CGPointZero
        var normal = CGPointZero
        let ptStart = ptAvantContact.point
        let vIncidence = ptAvantContact.directionRayon
        
        var t = [CGFloat](count: 3, repeatedValue: 10.0)
        let ptEnd = vIncidence * kExtrapolationDroite + ptStart
        let segRayonLumière = Segment(start: ptStart, end: ptEnd)
        
        var p:CGFloat = 10.0 // valeur de t
        var indexSide = 0 // identifie le côté
        for index in 0...2 {
            t[index] = contactSegment(segRayonLumière, segmentCible: côtés[index])
            if t[index] < p {
                p = t[index]
                indexSide = index
            }
        }
        
        if p > 0 && p < 1 { // le point est sur le segment
            let segmentContact = côtés[indexSide]
            pointResult = PropriétéPoint()
            contact = ptStart + segRayonLumière.direction * p
            
            if isContactNearVertex(contact, side: segmentContact) { // pas de contact si le point est près d'un sommet
                let contactPlus = contact + ptAvantContact.directionRayon * 15 // un peu après le point de contact
                let contactMoins = contact - ptAvantContact.directionRayon * 15 // un peu avant le point de contact
                
                // le rayon évite les coins du prisme avec le premier contact avec le prisme
                if !isPointInsideOptic(contactPlus) && !isPointInsideOptic(contactMoins) {
                    return nil
                } else {
                    pointResult?.point = contact
                    pointResult?.normale = ptAvantContact.normale
                    pointResult?.indice = -1
                }
            } else {
                normal = CGPoint(x: segmentContact.direction.y, y: -segmentContact.direction.x)
                var AC = CGPointZero
                switch indexSide {
                case 0:
                    AC = -côtés[2].direction
                case 1:
                    AC = -côtés[0].direction
                case 2:
                    AC = -côtés[1].direction
                default:
                    print("Default")
                }
                
                /*
                Si l'angle entre le vecteur normal et le vecteur AC est plus petit que 90 deg
                alors D est positif et la normale est rentrante
                si D négatif, le vecteur normal est sortant
                
                Si le point de départ du rayon est d'indice == 1.0
                la normale doit être sortante -> D < 0
                
                Si le point de départ du rayon est d'indice > 1.0
                la normale doit être rentrante -> D > 0
                */
                let D = normal.dot(AC)
                if ptAvantContact.indice == 1.0 {
                    if D > 0 {
                        normal = -normal
                    }
                } else {
                    if D < 0 {
                        normal = -normal
                    }
                }
                
                pointResult?.point = contact
                pointResult?.normale = normal.normalized()
            }
        }
        
        return pointResult
    }
    // ---------------------------------------------
    
    
    // Test si le point de contact est près d'un sommet
    private func isContactNearVertex(contact:CGPoint, side:Segment) -> Bool {
        let epsilon:CGFloat = 5.0
        let d1 = (side.start - contact).lengthSquared()
        let d2 = (side.end - contact).lengthSquared()
        if (d1 < epsilon) || (d2 < epsilon) {
            return true
        } else {
            return false
        }
    }
    
    
    
    // Détermine si un point est à l'intérieur du prisme
    override func isPointInsideOptic(s: CGPoint) -> Bool {
        let a = sommets[0]
        let b = sommets[1]
        let c = sommets[2]
        let as_x = s.x - a.x;
        let as_y = s.y - a.y;
        
        let t0 = (b.x-a.x) * as_y-(b.y-a.y) * as_x
        let test0: Bool = t0 > 0
        
        let t1 = (c.x-a.x) * as_y-(c.y-a.y) * as_x
        let test1: Bool = t1 > 0
        if test1 == test0 {
            return false
        }
        
        let t2 = (c.x-b.x)*(s.y-b.y)-(c.y-b.y)*(s.x-b.x)
        let test2: Bool = t2 > 0
        if test2 != test0 {
            return false
        }
        
        return true;
    }
    
    
}