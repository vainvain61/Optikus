//
//  Sphere.swift
//  TestSpriteKit
//
//  Created by Sylvain on 2015-09-28.
//  Copyright © 2015 Sylvain Lambert. All rights reserved.
//

import Foundation
import SpriteKit

class Sphere : SpriteOptique {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(imageNamed: String) {
        let cardTexture = SKTexture(imageNamed: imageNamed)
        let tailleSphere = CGSize(width: cardTexture.size().width, height: cardTexture.size().height)
        super.init(texture: cardTexture, color: UIColor.clearColor(), size: tailleSphere)
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: tailleSphere.height*0.55)
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.collisionBitMask = 1              // 0 => pas de collision
        body.categoryBitMask = 0b1
        body.contactTestBitMask = 0b0
        body.usesPreciseCollisionDetection = false
        self.physicsBody = body
        
    }
}
