//
//  Géométrie.swift
//  Lens1
//
//  Created by Sylvain on 2015-09-24.
//  Copyright © 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import UIKit

// Trouve la valeur de t pour le segment du rayon de lumière
func contactSegment(segmentLumière:Segment, segmentCible:Segment) -> CGFloat {
    let a = segmentLumière.start
    let b = segmentLumière.end
    let c = segmentCible.start
    let d = segmentCible.end
    var valeurT:CGFloat = 10.0
    let D = (b.x - a.x)*(d.y - c.y) - (b.y - a.y)*(d.x - c.x)
    if D != 0.0 {
        let numérateur = (c.x - a.x)*(d.y - c.y) - (c.y - a.y)*(d.x - c.x)
        valeurT = numérateur/D
        
        let valeurU = ((a.x - c.x) + (b.x - a.x) * valeurT) / (d.x - c.x)
        if !(valeurU > 0 && valeurU < 1) || (valeurT < 0.001) {
            valeurT = 10.0
        }
    }
    
    return valeurT
}