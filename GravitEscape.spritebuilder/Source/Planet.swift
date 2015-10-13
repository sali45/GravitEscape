//
//  Planet.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Planet: CCNode {
    
    let minimumYPosition:CGFloat = 200
    let maximumYPosition:CGFloat = 380
    
    let minimumXPosition:CGFloat = 200
    let maximumXPosition:CGFloat = 380
    
    let minimumRadius:Float = 15
    let maximumRadius:Float = 50
    
    func setRandomPosition() {
        let random:CGFloat = (CGFloat(rand()) / CGFloat(RAND_MAX))
        let rangeY:CGFloat = maximumYPosition - minimumYPosition
        let rangeX:CGFloat = maximumXPosition - minimumXPosition
        self.position = CGPoint(x:minimumXPosition + (random * rangeX), y:minimumYPosition + (random * rangeY))
    }
    
    func setRandomArea() {
        let random = (Float(rand()) / Float(RAND_MAX))
        let range = maximumRadius - minimumRadius
        self.scale = (minimumRadius + (random * range))
    }
    
    func setRandomColor() {
        let random = (Float(rand()) / Float(RAND_MAX))
        self.color = CCColor.init(red: 1 / random, green: 1 / random, blue: 1 / random)
    }
    
    func didLoadFromCCB() {
        self.physicsBody.sensor = true
    }
}
