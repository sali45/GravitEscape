//
//  MainScene.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    var firstPlanetPosition: CGFloat = 50
    let distanceBetweenPlanets: CGFloat = 30

    var scrollSpeed: CGFloat = 10
    
    weak var hero: Character?
    
    weak var _gamePhysicsNode: CCPhysicsNode!
    weak var _background1: CCSprite!
    weak var _background2: CCSprite!
    
    var backgrounds: [CCSprite] = []
    var planets: [CCNode] = []
    var isGameOver = false
    
    func didLoadFromCCB() {
        backgrounds.append(_background1)
        backgrounds.append(_background2)
        userInteractionEnabled = true
        _gamePhysicsNode.collisionDelegate = self
        hero = CCBReader.load("Character") as! Character
        _gamePhysicsNode.addChild(hero)
        
        for i in 1...3 {
            spawnNewPlanet()
        }
    }
    
    override func update(delta: CCTime) {
        if (!isGameOver) {
            hero?.position = ccp(hero!.position.x, hero!.position.y + scrollSpeed * CGFloat(delta))
            
            _gamePhysicsNode.position = ccp(_gamePhysicsNode.position.x, _gamePhysicsNode.position.y + scrollSpeed * CGFloat(delta))
            
            let scale = CCDirector.sharedDirector().contentScaleFactor
            
            _gamePhysicsNode.position = ccp(round(_gamePhysicsNode.position.x * scale) / scale, round(_gamePhysicsNode.position.y * scale) / scale)
            
            
            for background in backgrounds {
                // get the world position of the ground
                let backgroundWorldPosition = _gamePhysicsNode.convertToWorldSpace(background.position)
                // get the screen position of the ground
                let backgroundScreenPosition = convertToNodeSpace(backgroundWorldPosition)
                // if the left corner is one complete width off the screen, move it to the right
                if backgroundScreenPosition.y <= (-background.contentSize.height) {
                    background.position = ccp(background.position.x, background.position.y + background.contentSize.height * 2)
                }
            }
            
            for planet in planets.reverse() {
                let planetWorldPosition = _gamePhysicsNode.convertToWorldSpace(planet.position)
                let planetScreenPosition = convertToNodeSpace(planetWorldPosition)
                
                //obstacle moved past left side of screen
                if planetScreenPosition.x < (-planet.contentSize.height) {
                    planet.removeFromParent()
                    
                    planets.removeAtIndex(planets.indexOf(planet)!)
                    
                    // for each removed obstacle, add a new one
                    spawnNewPlanet()
                }
            }
            
        }
    }
    
    func spawnNewPlanet() {
        var prevPlanetPos = firstPlanetPosition
        if planets.count > 0 {
            prevPlanetPos = planets.last!.position.x
        }
        
        //create and add a new obstacle
        let planet = CCBReader.load("Planet") as! Planet
        planet.position = ccp(0, prevPlanetPos + distanceBetweenPlanets)
        planet.setRandomPosition()
        planet.setRandomArea()
        planet.setRandomColor()
        planets.append(planet)
        
        //add to scene
    }

}
