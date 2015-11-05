//
//  Character.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Character: CCSprite {
    func didLoadFromCCB() {
        self.position = CGPoint(x: 150, y: 50)
        self.scale = 0.4
    }
}