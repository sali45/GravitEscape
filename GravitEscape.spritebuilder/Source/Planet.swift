//
//  Planet.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Planet: CCSprite {
    
    let minimumYPosition:CGFloat = 400
    let maximumYPosition:CGFloat = 700
    
    let minimumXPosition:CGFloat = 50
    let maximumXPosition:CGFloat = 400
    
    let minimumRadius:Float = 0.05
    let maximumRadius:Float = 0.1
    func didLoadFromCCB() {
        self.physicsBody.sensor = true
        setRandomArea()
        setRandomColor()
    }
    
    func setRandomPosition(y:CGFloat) {
        let random:CGFloat = (CGFloat(rand()) / CGFloat(RAND_MAX))
        let rangeX:CGFloat = maximumXPosition - minimumXPosition
        self.position = ccp(minimumXPosition + (random * rangeX), y)
    }
    
    func setRandomArea() {
        let random = (Float(rand()) / Float(RAND_MAX))
        let range = maximumRadius - minimumRadius
        self.scale = (minimumRadius + (random * range))
    }
    
    func setRandomColor() {
        let random = Float(Int(arc4random_uniform(256)))
        let random2 = Float(Int(arc4random_uniform(256)))
        let random3 = Float(Int(arc4random_uniform(256)))
        self.color = CCColor(red: random / 255, green: random2 / 255, blue: random3 / 255)
    }
}
