//
//  Character.swift
//  GravitEscape
//
//  Created by Saqib Ali on 9/27/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Character: CCNode {
    func didLoadFromCCB() {
        self.position = CGPoint(x: 50, y: 50)
        self.scale = 0.4
    }
}