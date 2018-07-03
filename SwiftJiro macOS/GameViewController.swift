//
//  GameViewController.swift
//  SwiftJiro macOS
//
//  Created by 한지민 on 2018. 6. 26..
//  Copyright © 2018년 HjmNP. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene.newGameScene()
        self.preferredContentSize = NSMakeSize(1280, 720)
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

