//
//  GameScene.swift
//  TestSpriteKit
//
//  Created by Sylvain on 2015-09-27.
//  Copyright (c) 2015 Sylvain Lambert. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var suiviLumière = [[PropriétéPoint]]()
    var optics = [Optique]()
    var départ = [PropriétéPoint]()
    var unPrisme = Prisme(centre: CGPoint(x: 150, y: 150), indice: 1.5, side: 200, angle: 0.0)
    var cercle1: Cercle!
    var unBloc = Bloc(frame: CGRectMake(400, 100, 100, 100), indice: 1.5)
    var goalView:UIView!
    let segmentGoal = Segment(start: CGPoint(x: 800.0, y: kFrameDevice.size.height-10),
        end: CGPoint(x: 650.0, y: kFrameDevice.size.height-10))
    
    var tabPoints = [CGPoint]()
    var rayonLaser : LaserShape?
    var edge:SKShapeNode?
    var edgeRect:CGRect?
    
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        physicsWorld.contactDelegate = self
        
        view.showsPhysics = true
        
        let ptDépart = CGPoint(x: 0, y: 100)
        let direction = CGPoint(x: 1, y: 0)
        départ = [PropriétéPoint(indice: 1.0, point: ptDépart, directionRayon: direction)]
        
        let centreCercle = CGPoint(x: 200, y: 200)
        cercle1 = Cercle(centre: centreCercle, indice: 1.5, rayon: 50)
        let sphere1 = Sphere(imageNamed: "sphere")
        sphere1.position = centreCercle
        self.addChild(sphere1)
        
        let sphere2 = Sphere(imageNamed: "sphere")
        sphere2.position = CGPoint(x: 400, y: 600)
        self.addChild(sphere2)
        
        edgeRect = CGRect(x: 50, y: 50, width: 100, height: 400)
        let edgePB = SKPhysicsBody(edgeLoopFromRect: edgeRect!)
        edge = SKShapeNode(rect: edgeRect!)
        edge?.fillColor = UIColor.lightGrayColor()
        edge!.physicsBody = edgePB
        self.addChild(edge!)
        
        let ptLointain = pointLointain(ptDépart: ptDépart, direction: direction)
        tabPoints = [ptDépart, ptLointain]
        rayonLaser = LaserShape(points: tabPoints)
        self.addChild(rayonLaser!)
        
        let disque = SKShapeNode(rect: CGRect(x: 300, y: 300, width: 100, height: 100), cornerRadius: 16)
        disque.fillColor = UIColor.redColor()        
        self.addChild(disque)

        
        // Ajout au tableau [optics]
//        optics.append(unPrisme)
        optics.append(cercle1)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
            for node in nodes {
                if node is SpriteOptique {
                    node.position = location
                    cercle1.centre = location
                    if cercle1.centre.x < 200 {
                        cercle1.centre.x = 200
                    }
                    
                    suiviLumière = []
                    suiviLumière.append(départ)
                    
                    var dernierPointOptique:PropriétéPoint
                    for item in optics {
                        dernierPointOptique = (suiviLumière.last?.last)!
                        if let prisme = item as? Prisme {
                            let tabPts = prisme.pointsContact(dernierPointOptique)
                            if !tabPts.isEmpty {
                                suiviLumière.append(tabPts)
                                //                        print(suiviLumière)
                            }
                        }
                        if let cercle = item as? Cercle {
                            let tabPts = cercle.pointsContact(dernierPointOptique)
                            if !tabPts.isEmpty {
                                suiviLumière.append(tabPts)
                            }
                        }
                    }
                    
                    tabPoints = [CGPoint]()
                    for tabPtsPropriété in suiviLumière {
                        for pt in tabPtsPropriété {
                            tabPoints.append(pt.point)
                        }
                    }
                    
                    if let dernierPoint = suiviLumière.last?.last {
                        let ptEnd = pointLointain(ptDépart: dernierPoint.point, direction: dernierPoint.directionRayon)
                        //                        let segmentRayon = Segment(start: dernierPoint.point, end: ptEnd)
                        //                        let valeurT = contactSegment(segmentRayon, segmentCible: segmentGoal)
                        //                        if valeurT > 0 && valeurT < 1 {
                        //                            goalView.backgroundColor = UIColor.redColor()
                        //                        } else {
                        //                            goalView.backgroundColor = UIColor.greenColor()
                        //                        }
                        tabPoints.append(ptEnd)
                    }
                    rayonLaser?.tabPoints = tabPoints
                    
                    break
                }
            }

//            if touchedNode.physicsBody?.categoryBitMask == 1 {
//                touchedNode.position = location
//                let tabPt = [CGPoint(x: 50, y: 100), CGPoint(x: 120, y: location.y)]
//                rayonLaser?.tabPoints = tabPt
//            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
//        let firstNode = contact.bodyA.node;
//        let secondNode = contact.bodyB.node;
//        
//        let collision = firstNode!.physicsBody!.categoryBitMask | secondNode!.physicsBody!.categoryBitMask;
//        print(contact.contactPoint)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
