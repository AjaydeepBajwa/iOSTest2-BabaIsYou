//
//  GameScene.swift
//  BabaIsYou-F19
//
//  Created by Parrot on 2019-10-17.
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var baba:SKSpriteNode!
    var flag:SKSpriteNode!
    var wall:SKSpriteNode!
    var stopBlock:SKSpriteNode!
    var winBlock:SKSpriteNode!
    var wallBlock:SKSpriteNode!
    var flagBlock:SKSpriteNode!
    var isBlock:SKSpriteNode!
    
    var congratsMessage:SKLabelNode!
    var touchCount = 0
    let baba_speed:CGFloat = 20
    
    //Strings to store win/stop conditions of thingBlocks i.e walls and flag
    var wallStopRuleString:String = ""
    var wallWinRuleString: String = ""
    var flagStopRuleString:String = ""
    var flagWinRuleString:String = ""
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.baba = self.childNode(withName: "baba") as! SKSpriteNode
        
        self.flag = self.childNode(withName: "flag") as! SKSpriteNode
        self.enumerateChildNodes(withName: "wall") {
            (node, stop) in
            self.wall = node as! SKSpriteNode
        }

        self.stopBlock = self.childNode(withName: "stopblock") as! SKSpriteNode
        self.winBlock = self.childNode(withName: "winblock") as! SKSpriteNode
        self.wallBlock = self.childNode(withName: "wallblock") as! SKSpriteNode
        self.flagBlock = self.childNode(withName: "flagblock") as! SKSpriteNode
        self.isBlock = self.childNode(withName: "isblock") as! SKSpriteNode

    }
   
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA == nil || nodeB == nil) {
            return
        }
        
        if (nodeA!.name == "baba" && nodeB!.name == "wall") {
            self.checkWallWinCondition()
        }
        if (nodeA!.name == "wall" && nodeB!.name == "baba") {
            self.checkWallWinCondition()
        }
        
        if (nodeA!.name == "baba" && nodeB!.name == "flag") {
            self.checkFlagWinCondition()
        
        }
        if (nodeA!.name == "flag" && nodeB!.name == "baba") {
            self.checkFlagWinCondition()
            
        }
        print("Something collided!")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //self.blockConnectRules
        //self.changeCollisionMask()
//        print("x of wall : \(self.wallBlock.position.x)")
//        print("x of is: \(self.isBlock.position.x)")
    }
    
    func changeCollisionMask(){
        if (self.wallStopRuleString == "wall is stop"){
            self.baba.physicsBody?.collisionBitMask = 22  // 6+16
        }
        if (self.wallStopRuleString == ""){
            self.baba.physicsBody?.collisionBitMask = 14  
        }
        if (self.flagStopRuleString == "flag is stop"){
            self.baba.physicsBody?.collisionBitMask = 14
        }
        
        print("Collision mask of baba: \(self.baba.physicsBody?.collisionBitMask)")
        
    }
    
    func checkWallWinCondition(){
        if (self.wallWinRuleString == "wall is win"){
            self.congratsMessage = SKLabelNode(text: "Congratulations, You Won!")
            self.congratsMessage.fontSize = 50
            self.congratsMessage.fontName = "Avenir"
            self.congratsMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(self.congratsMessage)
            scene!.view?.isPaused = true
        }
        
    }
    func checkFlagWinCondition(){
        if (self.flagWinRuleString == "flag is win"){
            self.congratsMessage = SKLabelNode(text: "Congratulations, You Won!")
            self.congratsMessage.fontSize = 50
            self.congratsMessage.fontName = "Avenir"
            self.congratsMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(self.congratsMessage)
            scene!.view?.isPaused = true
        }
    }
    
    func blockConnectRules(){

        //Get both of the 'is' Blocks
        self.enumerateChildNodes(withName: "isblock") {
            (node, stop) in
            let isblock = node as! SKSpriteNode
            
        
        //Set X coordinate range where the thingBlock (i.e Wall or flag) can be connected to isBlock
        let thingBlockAcceptableXRange = (isblock.position.x - isblock.size.width*1.5)...(self.isBlock.position.x)
        
        // Set X coordinate range where the resultBlock can be connected to isBlock to get acceptable Rule.
        let resultBlockAcceptableXRange = (isblock.position.x)...(isblock.position.x + isblock.size.width*1.5)
        
        //Set Y coordinate range in which any block can be sai to be connected to the isBlock
        let BlockAcceptableYRange = (isblock.position.y - isblock.size.height*0.5)...(isblock.position.y + isblock.size.height*0.5)
        
            
            //Check if the wall block is connected to the 'is' block
        if (thingBlockAcceptableXRange.contains(self.wallBlock.position.x))&&(BlockAcceptableYRange.contains(self.wallBlock.position.y)){
            
            //check if stop block is connected to the 'is' block on right
            if (resultBlockAcceptableXRange.contains(self.stopBlock.position.x))&&(BlockAcceptableYRange.contains(self.stopBlock.position.y)){
                print("Wall is stop Rule Active")
                self.wallStopRuleString = "wall is stop"
            }
            else{
                print("Wall is stop Rule Deactivated")
                self.wallStopRuleString = ""
            }
            
            //check if win block is connected to isBlock
            if (resultBlockAcceptableXRange.contains(self.winBlock.position.x))&&(BlockAcceptableYRange.contains(self.winBlock.position.y)){
                print("Wall is win rule Active")
                self.wallWinRuleString = "wall is win"
            }
            else{
                print("Wall is win rule Deactivated")
                self.wallWinRuleString = ""
            }
            
            
        }
        //check if flag block is connected to isBlock on left
        if (thingBlockAcceptableXRange.contains(self.flagBlock.position.x))&&(BlockAcceptableYRange.contains(self.flagBlock.position.y)){
            
            //check if win block is connected to isBlock on right
            if (resultBlockAcceptableXRange.contains(self.winBlock.position.x))&&(BlockAcceptableYRange.contains(self.winBlock.position.y)){
                print("Flag is win rule Active")
                self.flagWinRuleString = "flag is win"
            }
            else{
                print("Flag is win rule Deactivated")
                self.flagWinRuleString = ""
            }
            
            //check if stop Block is connected to isBlock on right
            if (resultBlockAcceptableXRange.contains(self.stopBlock.position.x))&&(BlockAcceptableYRange.contains(self.stopBlock.position.y)){
                print("Flag is stop Rule Active")
                self.flagStopRuleString = "flag is stop"
            }
            else{
                print("Flag is stop Rule Deactivated")
                self.flagStopRuleString = ""
            }
            
        }
        
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let mouseTouch = touches.first
        if (mouseTouch == nil) {
            return
        }
        let location = mouseTouch!.location(in: self)
        print("touched at x: \(location.x)")

        let nodeTouched = atPoint(location).name
        
        if (nodeTouched == "up") {
            // move up
            self.baba.position.y = self.baba.position.y + baba_speed
        }
        else if (nodeTouched == "down") {
            // move down
            self.baba.position.y = self.baba.position.y - baba_speed
        }
        else if (nodeTouched == "left") {
            // move left
            self.baba.position.x = self.baba.position.x - baba_speed
        }
        else if (nodeTouched == "right") {
            // move right
            self.baba.position.x = self.baba.position.x + baba_speed
        }
        print("x of 'wallBlock' : \(self.wallBlock.position.x)")
        print("x of 'isBlock': \(self.isBlock.position.x)")
        print("width of is : \(self.isBlock.size.width)")
        
        self.blockConnectRules()
        self.changeCollisionMask()
        
        //Number of times the screen is touched.
        self.touchCount = self.touchCount + 1
        print("Count : \(self.touchCount)")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
