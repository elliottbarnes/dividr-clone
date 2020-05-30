//
//  GameScene.swift
//  PUSH
//
//  Created by Elliott Barnes on 2020-05-19.
//  Copyright © 2020 Elliott Barnes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var player2:SKSpriteNode!
    var initialPlayerPosition: CGPoint!
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            
            player.position.x = (self.size.width/2) - normalizedForce * (self.size.width/2-25)
            player2.position.x = (self.size.width/2) + normalizedForce * (self.size.width/2-25)
        }
        if player.position != player2.position {
            player.size = CGSize(width: 50, height: 50)
            player2.size = CGSize(width: 50, height: 50)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
        if player.position == player2.position {
            player.size = CGSize(width: 150, height: 150)
            player2.size = CGSize(width: 150, height: 150)
        }
    }
    
    
    func resetPlayerPosition(){
        player.position = initialPlayerPosition
        player2.position = initialPlayerPosition
        
    }
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        addPlayer()
        addRow(type: RowType.twoS)
        }

    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(6))
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        default:
            break
        }
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 0.6 {
            lastYieldTimeInterval = 0
            addRandomRow()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval;
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
        
    
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "PLAYER" {
            showGameOver()
            // show game over scene
        }
    }
    
    func showGameOver() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
}
