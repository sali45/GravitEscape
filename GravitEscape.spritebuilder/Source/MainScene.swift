//
//  MainScene.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class MainScene: CCScene, CCPhysicsCollisionDelegate {
    
    var firstPlanetPosition: CGFloat = 50
    let distanceBetweenPlanets: CGFloat = 30

    var scrollSpeed: CGFloat = 1000
    
    weak var hero: Character?
    
    weak var _gamePhysicsNode: CCPhysicsNode!
    weak var _background1: CCSprite!
    weak var _background2: CCSprite!
    weak var _planetsLayer: CCNode!
    weak var _restartButton: CCNode!
    weak var _scoreLabel: CCLabelTTF!
    var points:Int = 0
    
    var backgrounds: [CCSprite] = []
    var planets: [CCNode] = []
    var isGameOver = false
    var isTouched = false
    var lastTouch: CCTouch!
    
    func didLoadFromCCB() {
        backgrounds.append(_background1)
        backgrounds.append(_background2)
        userInteractionEnabled = true
        _gamePhysicsNode.collisionDelegate = self
        hero = CCBReader.load("Character") as? Character
        _gamePhysicsNode.addChild(hero)
        if (!isGameOver) {
            for _ in 1...4 {
                spawnNewPlanet()
            }
        }
        
        self.schedule(Selector("spawnNewPlanet"), interval: 0.5)
    }
    
    override func update(delta: CCTime) {
        if (!isGameOver) {            
            _background1.position = ccp(_background1.position.x, _background1.position.y - scrollSpeed * CGFloat(delta))
            _background2.position = ccp(_background2.position.x, _background2.position.y - scrollSpeed * CGFloat(delta))
            
            for background in backgrounds {
                // get the world position of the background
                let backgroundWorldPosition = _gamePhysicsNode.convertToWorldSpace(background.position)
                // get the screen position of the background
                let backgroundScreenPosition = convertToNodeSpace(backgroundWorldPosition)
                // if the left corner is one complete width off the screen, move it to the right
                if backgroundScreenPosition.y <= (-background.contentSize.height) {
                    background.position = ccp(background.position.x, background.position.y + background.contentSize.height * 2)
                }
            }
            
            for planet in planets.reverse() {
                let planetWorldPosition = _gamePhysicsNode.convertToWorldSpace(planet.position)
                let planetScreenPosition = convertToNodeSpace(planetWorldPosition)
                //planet moved past top of screen
                if planetScreenPosition.y > (self.contentSize.height + planet.contentSize.height) {
                    planet.removeFromParent()
                    
                    planets.removeAtIndex(planets.indexOf(planet)!)
                    
                    // for each removed planet, add a new one
                    spawnNewPlanet()
                }
            }
            if (isTouched) {
                let touchPoint = lastTouch.locationInWorld()
                if Int(touchPoint.x) > (Int(UIScreen.mainScreen().bounds.width) / 2) {
                    let moveRight = CCActionMoveBy.init(duration: delta, position: ccp(CGFloat(100*delta),0))
                    if Int(hero!.position.x) < Int(UIScreen.mainScreen().bounds.width) {
                        hero?.runAction(moveRight)
                    }
                } else {
                    let moveLeft = CCActionMoveBy.init(duration: delta, position: ccp(CGFloat(-100*delta),0))
                    if Int(hero!.position.x) > 0 {
                        hero?.runAction(moveLeft)
                    }
                }
            }
        }
    }
    
    func spawnNewPlanet() {
        //create and add a new planet
        let planet = CCBReader.load("Planet") as! Planet
        planets.append(planet)
        planet.setRandomPosition(UIScreen.mainScreen().bounds.height)
        //add to scene
        _planetsLayer.addChild(planet)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        isTouched = true
        lastTouch = touch
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        lastTouch = touch
    }
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        isTouched = false
    }
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, level: CCNode!) -> Bool {
        gameOver()
        return true
    }
    func gameOver() {
        if (isGameOver == false) {
            //prevents update() in gamePlayScene from being called
            isGameOver = true
            
            //make the button show up
            _restartButton.visible = true
            
            //stop scrolling
            scrollSpeed = 0
            
            //stop all hero action
            hero?.stopAllActions()
            
            //shake the screen
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.1, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
}