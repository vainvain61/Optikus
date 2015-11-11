//
//  Optique.swift
//  Lens1
//
//  Created by Sylvain on 2015-08-17.
//  Copyright (c) 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

protocol OutilsOptique {
    func pointsContact(ptAvantContact: PropriétéPoint) -> [PropriétéPoint]
    func pointContact(ptAvantContact: PropriétéPoint) -> PropriétéPoint?
}

class Optique {
    var centre: CGPoint
    let indice: CGFloat
    var description: String {
        return "centre: \(centre), indice: \(indice)"
    }
    
    // Initialisation
    init(centre:CGPoint, indice:CGFloat) {
        self.centre = centre
        self.indice = indice
    }
    
    // Trouve tous les points de contact avec l'optique. Retourne un tableau [PropriétéPoint]
    func pointsContact(ptAvantContact: PropriétéPoint, outils:OutilsOptique) -> [PropriétéPoint] {
        var points = [PropriétéPoint]()
        
        if let pt1 = outils.pointContact(ptAvantContact) {
            var result = pt1
            vecteurRefraction(ptAvantContact, contact: &result)
            points.append(result)
            //            print("1: \(result.indice)")
            
            if let pt2 = outils.pointContact(result) {
                let oldResult = result
                result = pt2
                vecteurRefraction(oldResult, contact: &result)
                points.append(result)
                //                print("2: \(result.indice)")
                
                if let pt3 = outils.pointContact(result) {
                    let oldResult = result
                    result = pt3
                    vecteurRefraction(oldResult, contact: &result)
                    points.append(result)
                    //                    print("3: \(result.indice)")
                }
            }
        }
        
        return points
    }
    
    // Détermine la direction du rayon et l'indice de réfraction au point de contact
    func vecteurRefraction(pointAvantContact:PropriétéPoint, inout contact:PropriétéPoint)  {
        if contact.indice != -1.0 { // est une lentille
            let vIncident = pointAvantContact.directionRayon
            let normal = contact.normale
            let cosTheta1 = -(normal.dot(vIncident))
            let rapportIndice = (pointAvantContact.indice == 1.0) ? 1.0/indice : indice
            let sinTheta1 = sqrt(1 - cosTheta1 * cosTheta1)
            let critique = rapportIndice * sinTheta1 // = sinTheta2
            if critique < 1.0 {
                let cosTheta2 = sqrt(1 - rapportIndice*rapportIndice*(1 - cosTheta1*cosTheta1))
                contact.directionRayon = (cosTheta2 > 0) ? vIncident*rapportIndice + normal*(rapportIndice*cosTheta1 - cosTheta2) :
                    vIncident*rapportIndice + normal*(rapportIndice*cosTheta1 + cosTheta2)
            } else { // réflexion totale
                contact.directionRayon = vIncident + normal * (2 * cosTheta1)
            }
            
        } else { // n'est pas une lentille
            contact.directionRayon = pointAvantContact.directionRayon
        }
        
        let contactPlus = contact.point + contact.directionRayon * 1.0001
        contact.indice = isPointInsideOptic(contactPlus) ? indice : 1.0
    }
    
    func isPointInsideOptic(s: CGPoint) -> Bool {
        preconditionFailure("This method must be overridden")
    }
}