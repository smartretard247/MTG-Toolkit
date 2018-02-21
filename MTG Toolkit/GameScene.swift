//
//  GameScene.swift
//  MTG Toolkit
//
//  Created by Jeezy on 2/11/18.
//  Copyright © 2018 Jeezy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    public static let numCardFronts: Int = 4
    private var spinnyNode : SKShapeNode?
    
    public static var cardIsHidden = false
    public static var viewingDecks = false
    
    //var cardFront = [SKSpriteNode]()
    var background = SKSpriteNode(imageNamed: "images/background.jpg")
    var pOne = SKSpriteNode(imageNamed: "images/pone20.png")
    var pTwo = SKSpriteNode(imageNamed: "images/ptwo20.png")
    var pOneUpOne = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pOneUpThree = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pTwoUpOne = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pTwoUpThree = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pOneLabelOne: SKLabelNode!
    var pOneLabelThree: SKLabelNode!
    var pTwoLabelOne: SKLabelNode!
    var pTwoLabelThree: SKLabelNode!
    var pOneDownOne = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pOneDownThree = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pTwoDownOne = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pTwoDownThree = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var pOneLabelDownOne: SKLabelNode!
    var pOneLabelDownThree: SKLabelNode!
    var pTwoLabelDownOne: SKLabelNode!
    var pTwoLabelDownThree: SKLabelNode!
    var pOneHiddenLabel: SKLabelNode!
    var pTwoHiddenLabel: SKLabelNode!
    
    var pOneLoyalty = SKSpriteNode(imageNamed: "images/loyalty.png")
    var pTwoLoyalty = SKSpriteNode(imageNamed: "images/loyalty.png")
    var pOneLoyaltyLabel: SKLabelNode!
    var pTwoLoyaltyLabel: SKLabelNode!
    var pOneLoyaltyUp = SKSpriteNode(imageNamed: "images/loyaltyup.png")
    var pOneLoyaltyDown = SKSpriteNode(imageNamed: "images/loyaltydown.png")
    var pTwoLoyaltyUp = SKSpriteNode(imageNamed: "images/loyaltyup.png")
    var pTwoLoyaltyDown = SKSpriteNode(imageNamed: "images/loyaltydown.png")
    
    var resetButton = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var rollButton = SKSpriteNode(imageNamed: "images/buttons.jpg")
    var labelReset: SKLabelNode!
    var labelRoll: SKLabelNode!
    
    var pOneHealth = 20
    var pTwoHealth = 20
    var pOnePlainswalkerHealth = 0
    var pTwoPlainswalkerHealth = 0
    
    override func didMove(to view: SKView) {
        // Create shape node to use during mouse interaction
        var backgroundScaleOffset: CGFloat = 0.0
        if(UIDevice.current.model == "iPhone") {
            backgroundScaleOffset = 0.1
        }
        
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(
            rectOf: CGSize.init(width: w*GameViewController.screenScale,
                                height: w*GameViewController.screenScale),
                                cornerRadius: w * 0.3 * GameViewController.screenScale)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        //background image
        background.zPosition = -1
        background.xScale = frame.width/background.frame.width + backgroundScaleOffset
        if(UIDevice.current.model == "iPhone") {
            background.yScale = background.frame.height/frame.height + backgroundScaleOffset
        }
        addChild(background)
        
        //player one health
        pOne.zPosition = 0.05
        pOne.position.x -= GameViewController.cardFrontWidth/1.5
        addChild(pOne)
        
        //player two health
        pTwo.zPosition = 0.05
        pTwo.position.x += GameViewController.cardFrontWidth/1.5
        addChild(pTwo)
        
        //loyalty health
        let loyaltyOffset = CGFloat(70)
        
        pOneLoyalty.zPosition = 0.05
        pOneLoyalty.position.x -= GameViewController.cardFrontWidth
        pOneLoyalty.position.y -= GameViewController.cardFrontHeight/2.1
        if(UIDevice.current.model == "iPhone") {
            pOneLoyalty.position.y += loyaltyOffset
        }
        addChild(pOneLoyalty)
        
        pTwoLoyalty.zPosition = 0.05
        pTwoLoyalty.position.x += GameViewController.cardFrontWidth
        pTwoLoyalty.position.y -= GameViewController.cardFrontHeight/2.1
        if(UIDevice.current.model == "iPhone") {
            pTwoLoyalty.position.y += loyaltyOffset
        }
        addChild(pTwoLoyalty)
        
        // loyalty health buttons
        pOneLoyaltyUp.zPosition = 0.05
        pOneLoyaltyUp.position.x -= GameViewController.cardFrontWidth
        pOneLoyaltyUp.position.y += -GameViewController.cardFrontHeight/2.2 + pOneLoyalty.frame.height/1.4
        if(UIDevice.current.model == "iPhone") {
            pOneLoyaltyUp.position.y += loyaltyOffset
        }
        addChild(pOneLoyaltyUp)
        
        pTwoLoyaltyUp.zPosition = 0.05
        pTwoLoyaltyUp.position.x += GameViewController.cardFrontWidth
        pTwoLoyaltyUp.position.y += -GameViewController.cardFrontHeight/2.2 + pTwoLoyalty.frame.height/1.4
        if(UIDevice.current.model == "iPhone") {
            pTwoLoyaltyUp.position.y += loyaltyOffset
        }
        addChild(pTwoLoyaltyUp)
        
        pOneLoyaltyDown.zPosition = 0.05
        pOneLoyaltyDown.position.x -= GameViewController.cardFrontWidth
        pOneLoyaltyDown.position.y += -GameViewController.cardFrontHeight/2 - pOneLoyalty.frame.height/1.4
        if(UIDevice.current.model == "iPhone") {
            pOneLoyaltyDown.position.y += loyaltyOffset
        }
        addChild(pOneLoyaltyDown)
        
        pTwoLoyaltyDown.zPosition = 0.05
        pTwoLoyaltyDown.position.x += GameViewController.cardFrontWidth
        pTwoLoyaltyDown.position.y += -GameViewController.cardFrontHeight/2 - pTwoLoyalty.frame.height/1.4
        if(UIDevice.current.model == "iPhone") {
            pTwoLoyaltyDown.position.y += loyaltyOffset
        }
        addChild(pTwoLoyaltyDown)
        
        // text on loyalty health
        pOneLoyaltyLabel = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneLoyaltyLabel.zPosition = 0.06
        pOneLoyaltyLabel.horizontalAlignmentMode = .center
        pOneLoyaltyLabel.fontColor = .white
        pOneLoyaltyLabel.fontSize = 22
        pOneLoyaltyLabel.text = "\(pOnePlainswalkerHealth)"
        pOneLoyaltyLabel.position.x -= GameViewController.cardFrontWidth
        pOneLoyaltyLabel.position.y -= GameViewController.cardFrontHeight/2.1 + pOneLoyaltyLabel.frame.height/2
        if(UIDevice.current.model == "iPhone") {
            pOneLoyaltyLabel.position.y += loyaltyOffset
        }
        addChild(pOneLoyaltyLabel)
        
        pTwoLoyaltyLabel = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoLoyaltyLabel.zPosition = 0.06
        pTwoLoyaltyLabel.horizontalAlignmentMode = .center
        pTwoLoyaltyLabel.fontColor = .white
        pTwoLoyaltyLabel.fontSize = 22
        pTwoLoyaltyLabel.text = "\(pOnePlainswalkerHealth)"
        pTwoLoyaltyLabel.position.x += GameViewController.cardFrontWidth
        pTwoLoyaltyLabel.position.y -= GameViewController.cardFrontHeight/2.1 + pTwoLoyaltyLabel.frame.height/2
        if(UIDevice.current.model == "iPhone") {
            pTwoLoyaltyLabel.position.y += loyaltyOffset
        }
        addChild(pTwoLoyaltyLabel)
        
        // text on health buttons
        pOneLabelOne = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneLabelOne.zPosition = 0.06
        pOneLabelOne.text = "+"
        pOneLabelOne.position.x -= GameViewController.cardFrontWidth/1.5
        pOneLabelOne.position.y += pOne.frame.height/1.4 - 7
        addChild(pOneLabelOne)
        
        // health buttons
        pOneUpOne.zPosition = 0.05
        pOneUpOne.position.x -= GameViewController.cardFrontWidth/1.5
        pOneUpOne.position.y += pOne.frame.height/1.4
        addChild(pOneUpOne)
        
        // text on health buttons
        pOneLabelThree = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneLabelThree.zPosition = 0.06
        pOneLabelThree.text = "3+"
        pOneLabelThree.position.x -= GameViewController.cardFrontWidth/1.5
        pOneLabelThree.position.y += pOne.frame.height/1.4 - 5 + pOneLabelOne.frame.height*2 + 2
        addChild(pOneLabelThree)
        
        // health buttons
        pOneUpThree.zPosition = 0.05
        pOneUpThree.position.x -= GameViewController.cardFrontWidth/1.5
        pOneUpThree.position.y += pOne.frame.height/1.4 + pOneLabelOne.frame.height*2 + 2
        addChild(pOneUpThree)
        
        // text on health buttons
        pOneLabelDownOne = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneLabelDownOne.zPosition = 0.06
        pOneLabelDownOne.text = "="
        pOneLabelDownOne.position.x -= GameViewController.cardFrontWidth/1.5
        pOneLabelDownOne.position.y -= pOne.frame.height/1.4 + 7
        addChild(pOneLabelDownOne)
        
        // health buttons
        pOneDownOne.zPosition = 0.05
        pOneDownOne.position.x -= GameViewController.cardFrontWidth/1.5
        pOneDownOne.position.y -= pOne.frame.height/1.4
        addChild(pOneDownOne)
        
        // text on health buttons
        pOneLabelDownThree = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneLabelDownThree.zPosition = 0.06
        pOneLabelDownThree.text = "3="
        pOneLabelDownThree.position.x -= GameViewController.cardFrontWidth/1.5
        pOneLabelDownThree.position.y -= pOne.frame.height/1.4 + 5 + pOneLabelOne.frame.height*2 + 2
        addChild(pOneLabelDownThree)
        
        // health buttons
        pOneDownThree.zPosition = 0.05
        pOneDownThree.position.x -= GameViewController.cardFrontWidth/1.5
        pOneDownThree.position.y -= pOne.frame.height/1.4 + pOneLabelOne.frame.height*2 + 2
        addChild(pOneDownThree)
        
        // text on health buttons
        pTwoLabelOne = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoLabelOne.zPosition = 0.06
        pTwoLabelOne.text = "+"
        pTwoLabelOne.position.x += GameViewController.cardFrontWidth/1.5
        pTwoLabelOne.position.y += pOne.frame.height/1.4 - 7
        addChild(pTwoLabelOne)
        
        // health buttons
        pTwoUpOne.zPosition = 0.05
        pTwoUpOne.position.x += GameViewController.cardFrontWidth/1.5
        pTwoUpOne.position.y += pOne.frame.height/1.4
        addChild(pTwoUpOne)
        
        // text on health buttons
        pTwoLabelThree = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoLabelThree.zPosition = 0.06
        pTwoLabelThree.text = "3+"
        pTwoLabelThree.position.x += GameViewController.cardFrontWidth/1.5
        pTwoLabelThree.position.y += pOne.frame.height/1.4 - 5 + pOneLabelOne.frame.height*2 + 2
        addChild(pTwoLabelThree)
        
        // health buttons
        pTwoUpThree.zPosition = 0.05
        pTwoUpThree.position.x += GameViewController.cardFrontWidth/1.5
        pTwoUpThree.position.y += pOne.frame.height/1.4 + pOneLabelOne.frame.height*2 + 2
        addChild(pTwoUpThree)
        
        // text on health buttons
        pTwoLabelDownOne = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoLabelDownOne.zPosition = 0.06
        pTwoLabelDownOne.text = "="
        pTwoLabelDownOne.position.x += GameViewController.cardFrontWidth/1.5
        pTwoLabelDownOne.position.y -= pOne.frame.height/1.4 + 7
        addChild(pTwoLabelDownOne)
        
        // health buttons
        pTwoDownOne.zPosition = 0.05
        pTwoDownOne.position.x += GameViewController.cardFrontWidth/1.5
        pTwoDownOne.position.y -= pOne.frame.height/1.4
        addChild(pTwoDownOne)
        
        // text on health buttons
        pTwoLabelDownThree = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoLabelDownThree.zPosition = 0.06
        pTwoLabelDownThree.text = "3="
        pTwoLabelDownThree.position.x += GameViewController.cardFrontWidth/1.5
        pTwoLabelDownThree.position.y -= pOne.frame.height/1.4 + 5 + pOneLabelOne.frame.height*2 + 2
        addChild(pTwoLabelDownThree)
        
        // health buttons
        pTwoDownThree.zPosition = 0.05
        pTwoDownThree.position.x += GameViewController.cardFrontWidth/1.5
        pTwoDownThree.position.y -= pOne.frame.height/1.4 + pOneLabelOne.frame.height*2 + 2
        addChild(pTwoDownThree)
        
        // text on reset button
        labelReset = SKLabelNode(fontNamed: "Magic:the Gathering")
        labelReset.zPosition = 0.06
        labelReset.text = "Reset"
        if(UIDevice.current.model == "iPhone") {
            labelReset.xScale = GameViewController.screenScale
            labelReset.yScale = GameViewController.screenScale
            labelReset.position.x -= GameViewController.cardFrameWidth/2
            labelReset.position.y -= (GameViewController.cardFrameHeight + resetButton.frame.height)
                * (GameViewController.screenScale + 0.23) - resetButton.frame.height/4 - 1
        } else {
            labelReset.position.x -= GameViewController.cardFrameWidth/2
            labelReset.position.y -= GameViewController.cardFrameHeight/2 + resetButton.frame.height/2 + 16
        }
        addChild(labelReset)
        
        // reset buttons
        resetButton.zPosition = 0.05
        if(UIDevice.current.model == "iPhone") {
            resetButton.xScale = GameViewController.screenScale
            resetButton.yScale = GameViewController.screenScale
            resetButton.position.x -= GameViewController.cardFrameWidth/2
            resetButton.position.y -= (GameViewController.cardFrameHeight + resetButton.frame.height)
                * (GameViewController.screenScale + 0.23)
        } else {
            resetButton.position.x -= GameViewController.cardFrameWidth/2
            resetButton.position.y -= GameViewController.cardFrameHeight/2 + resetButton.frame.height/2 + 4
        }
        addChild(resetButton)
        
        // text on roll buttons
        labelRoll = SKLabelNode(fontNamed: "Magic:the Gathering")
        labelRoll.zPosition = 0.06
        labelRoll.text = "Roll"
        if(UIDevice.current.model == "iPhone") {
            labelRoll.xScale = GameViewController.screenScale
            labelRoll.yScale = GameViewController.screenScale
            labelRoll.position.x = -labelReset.position.x
            labelRoll.position.y = labelReset.position.y
        } else {
            labelRoll.position.x = -labelReset.position.x
            labelRoll.position.y = labelReset.position.y
        }
        addChild(labelRoll)
        
        // roll buttons
        rollButton.zPosition = 0.05
        if(UIDevice.current.model == "iPhone") {
            rollButton.xScale = GameViewController.screenScale
            rollButton.yScale = GameViewController.screenScale
            rollButton.position.x = -resetButton.position.x
            rollButton.position.y = resetButton.position.y
        } else {
            rollButton.position.x = -resetButton.position.x
            rollButton.position.y = resetButton.position.y
        }
        addChild(rollButton)
        
        // hidden behind player health
        pOneHiddenLabel = SKLabelNode(fontNamed: "Magic:the Gathering")
        pOneHiddenLabel.zPosition = 0.04
        pOneHiddenLabel.fontSize = 42
        pOneHiddenLabel.text = ""
        pOneHiddenLabel.position.x -= GameViewController.cardFrontWidth/1.5
        addChild(pOneHiddenLabel)
        
        // hidden behind player health
        pTwoHiddenLabel = SKLabelNode(fontNamed: "Magic:the Gathering")
        pTwoHiddenLabel.zPosition = 0.04
        pTwoHiddenLabel.fontSize = 42
        pTwoHiddenLabel.text = ""
        pTwoHiddenLabel.position.x += GameViewController.cardFrontWidth/1.5
        addChild(pTwoHiddenLabel)
    }
    
    func rollAnimation(_ node: SKNode) {
        node.run(.sequence([
            .rotate(byAngle: .pi * 2, duration: 0.4)
        ]))
    }
    
    func pumpAnimation(_ node: SKNode) {
        node.run(.sequence([
            .scale(to: 1.7, duration: 0.3),
            .scale(to: 1, duration: 0.3),
        ]))
    }
    
    func pressAnimation(_ node: SKNode) {
        node.run(.sequence([
            .scale(to: 1.1, duration: 0.1),
            .scale(to: 1, duration: 0.1),
            ]))
    }
    
    func flipAnimation(_ node: SKNode) {
        node.run(.sequence([
            .rotate(byAngle: .pi * 2, duration: 0.2)
        ]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        if(!GameScene.cardIsHidden &&
            pos.x > (rollButton.position.x - rollButton.frame.width/2) &&
            pos.x <= (rollButton.position.x + rollButton.frame.width/2) &&
            pos.y > (rollButton.position.y - rollButton.frame.height/2) &&
            pos.y <= (rollButton.position.y + rollButton.frame.height/2)) {
            pressAnimation(rollButton)
            pOneHealth = Int(arc4random_uniform(20)) + 1
            pTwoHealth = Int(arc4random_uniform(20)) + 1
            print("Roll button clicked: P1 rolled a \(pOneHealth), P2 rolled a \(pTwoHealth)")
            pOneHiddenLabel.text = ""
            pTwoHiddenLabel.text = ""
            pOne.isHidden = false
            pTwo.isHidden = false
            pOne.texture = SKTexture(imageNamed: "images/pone\(pOneHealth).png")
            pTwo.texture = SKTexture(imageNamed: "images/ptwo\(pTwoHealth).png")
            rollAnimation(pOne)
            rollAnimation(pTwo)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (resetButton.position.x - resetButton.frame.width/2) &&
            pos.x <= (resetButton.position.x + resetButton.frame.width/2) &&
            pos.y > (resetButton.position.y - resetButton.frame.height/2) &&
            pos.y <= (resetButton.position.y + resetButton.frame.height/2)) {
            pressAnimation(resetButton)
            print("Reset button clicked.")
            pOneHiddenLabel.text = ""
            pTwoHiddenLabel.text = ""
            pOne.isHidden = false
            pTwo.isHidden = false
            pOneHealth = 20
            pTwoHealth = 20
            pOnePlainswalkerHealth = 0
            pTwoPlainswalkerHealth = 0
            pOneLoyaltyLabel.text = "\(pOnePlainswalkerHealth)"
            pTwoLoyaltyLabel.text = "\(pTwoPlainswalkerHealth)"
            pOne.texture = SKTexture(imageNamed: "images/pone20.png")
            pTwo.texture = SKTexture(imageNamed: "images/ptwo20.png")
            rollAnimation(pOne)
            rollAnimation(pTwo)
            pumpAnimation(pOneLoyaltyLabel)
            pumpAnimation(pTwoLoyaltyLabel)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneUpOne.position.x - pOneUpOne.frame.width/2) &&
            pos.x <= (pOneUpOne.position.x + pOneUpOne.frame.width/2) &&
            pos.y > (pOneUpOne.position.y - pOneUpOne.frame.height/2) &&
            pos.y <= (pOneUpOne.position.y + pOneUpOne.frame.height/2)) {
            pressAnimation(pOneUpOne)
            print("P1 increased by 1 health.")
            pOneHealth += 1
            if(pOneHealth < 21) {
                pOne.isHidden = false
                pOne.texture = SKTexture(imageNamed: "images/pone\(pOneHealth).png")
                rollAnimation(pOne)
            } else {
                pOneHiddenLabel.text = "\(pOneHealth)"
                pOne.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneDownOne.position.x - pOneDownOne.frame.width/2) &&
            pos.x <= (pOneDownOne.position.x + pOneDownOne.frame.width/2) &&
            pos.y > (pOneDownOne.position.y - pOneDownOne.frame.height/2) &&
            pos.y <= (pOneDownOne.position.y + pOneDownOne.frame.height/2)) {
            pressAnimation(pOneDownOne)
            print("P1 decreased by 1 health.")
            pOneHealth -= 1
            if(pOneHealth < 21 && pOneHealth > 0) {
                pOne.isHidden = false
                pOne.texture = SKTexture(imageNamed: "images/pone\(pOneHealth).png")
                rollAnimation(pOne)
            } else if(pOneHealth > 20) {
                pOneHiddenLabel.text = "\(pOneHealth)"
                pOne.isHidden = true
            } else {
                pOneHiddenLabel.text = "You = Lose"
                pOne.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneUpThree.position.x - pOneUpThree.frame.width/2) &&
            pos.x <= (pOneUpThree.position.x + pOneUpThree.frame.width/2) &&
            pos.y > (pOneUpThree.position.y - pOneUpThree.frame.height/2) &&
            pos.y <= (pOneUpThree.position.y + pOneUpThree.frame.height/2)) {
            pressAnimation(pOneUpThree)
            print("P1 increased by 3 health.")
            pOneHealth += 3
            if(pOneHealth < 21) {
                pOne.isHidden = false
                pOne.texture = SKTexture(imageNamed: "images/pone\(pOneHealth).png")
                rollAnimation(pOne)
            } else {
                pOneHiddenLabel.text = "\(pOneHealth)"
                pOne.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneDownThree.position.x - pOneDownThree.frame.width/2) &&
            pos.x <= (pOneDownThree.position.x + pOneDownThree.frame.width/2) &&
            pos.y > (pOneDownThree.position.y - pOneDownThree.frame.height/2) &&
            pos.y <= (pOneDownThree.position.y + pOneDownThree.frame.height/2)) {
            pressAnimation(pOneDownThree)
            print("P1 decreased by 3 health.")
            pOneHealth -= 3
            if(pOneHealth < 21 && pOneHealth > 0) {
                pOne.isHidden = false
                pOne.texture = SKTexture(imageNamed: "images/pone\(pOneHealth).png")
                rollAnimation(pOne)
            } else if(pOneHealth > 20) {
                pOneHiddenLabel.text = "\(pOneHealth)"
                pOne.isHidden = true
            } else {
                pOneHiddenLabel.text = "You = Lose"
                pOne.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoUpOne.position.x - pTwoUpOne.frame.width/2) &&
            pos.x <= (pTwoUpOne.position.x + pTwoUpOne.frame.width/2) &&
            pos.y > (pTwoUpOne.position.y - pTwoUpOne.frame.height/2) &&
            pos.y <= (pTwoUpOne.position.y + pTwoUpOne.frame.height/2)) {
            pressAnimation(pTwoUpOne)
            print("P2 increased by 1 health.")
            pTwoHealth += 1
            if(pTwoHealth < 21) {
                pTwo.isHidden = false
                pTwo.texture = SKTexture(imageNamed: "images/ptwo\(pTwoHealth).png")
                rollAnimation(pTwo)
            } else {
                pTwoHiddenLabel.text = "\(pTwoHealth)"
                pTwo.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoDownOne.position.x - pTwoDownOne.frame.width/2) &&
            pos.x <= (pTwoDownOne.position.x + pTwoDownOne.frame.width/2) &&
            pos.y > (pTwoDownOne.position.y - pTwoDownOne.frame.height/2) &&
            pos.y <= (pTwoDownOne.position.y + pTwoDownOne.frame.height/2)) {
            pressAnimation(pTwoDownOne)
            print("P2 decreased by 1 health.")
            pTwoHealth -= 1
            if(pTwoHealth < 21 && pTwoHealth > 0) {
                pTwo.isHidden = false
                pTwo.texture = SKTexture(imageNamed: "images/ptwo\(pTwoHealth).png")
                rollAnimation(pTwo)
            } else if(pTwoHealth > 20) {
                pTwoHiddenLabel.text = "\(pTwoHealth)"
                pTwo.isHidden = true
            } else {
                pTwoHiddenLabel.text = "You = Lose"
                pTwo.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoUpThree.position.x - pTwoUpThree.frame.width/2) &&
            pos.x <= (pTwoUpThree.position.x + pTwoUpThree.frame.width/2) &&
            pos.y > (pTwoUpThree.position.y - pTwoUpThree.frame.height/2) &&
            pos.y <= (pTwoUpThree.position.y + pTwoUpThree.frame.height/2)) {
            pressAnimation(pTwoUpThree)
            print("P2 increased by 3 health.")
            pTwoHealth += 3
            if(pTwoHealth < 21) {
                pTwo.isHidden = false
                pTwo.texture = SKTexture(imageNamed: "images/ptwo\(pTwoHealth).png")
                rollAnimation(pTwo)
            } else {
                pTwoHiddenLabel.text = "\(pTwoHealth)"
                pTwo.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoDownThree.position.x - pTwoDownThree.frame.width/2) &&
            pos.x <= (pTwoDownThree.position.x + pTwoDownThree.frame.width/2) &&
            pos.y > (pTwoDownThree.position.y - pTwoDownThree.frame.height/2) &&
            pos.y <= (pTwoDownThree.position.y + pTwoDownThree.frame.height/2)) {
            pressAnimation(pTwoDownThree)
            print("P2 decreased by 3 health.")
            pTwoHealth -= 3
            if(pTwoHealth < 21 && pTwoHealth > 0) {
                pTwo.isHidden = false
                pTwo.texture = SKTexture(imageNamed: "images/ptwo\(pTwoHealth).png")
                rollAnimation(pTwo)
            } else if(pTwoHealth > 20) {
                pTwoHiddenLabel.text = "\(pTwoHealth)"
                pTwo.isHidden = true
            } else {
                pTwoHiddenLabel.text = "You = Lose"
                pTwo.isHidden = true
            }
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneLoyaltyUp.position.x - pOneLoyaltyUp.frame.width/2) &&
            pos.x <= (pOneLoyaltyUp.position.x + pOneLoyaltyUp.frame.width/2) &&
            pos.y > (pOneLoyaltyUp.position.y - pOneLoyaltyUp.frame.height/2) &&
            pos.y <= (pOneLoyaltyUp.position.y + pOneLoyaltyUp.frame.height/2)) {
            pressAnimation(pOneLoyaltyUp)
            print("P1 plainswalker gained health.")
            pOnePlainswalkerHealth += 1
            pOneLoyaltyLabel.text = "\(pOnePlainswalkerHealth)"
            pumpAnimation(pOneLoyaltyLabel)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pOneLoyaltyDown.position.x - pOneLoyaltyDown.frame.width/2) &&
            pos.x <= (pOneLoyaltyDown.position.x + pOneLoyaltyDown.frame.width/2) &&
            pos.y > (pOneLoyaltyDown.position.y - pOneLoyaltyDown.frame.height/2) &&
            pos.y <= (pOneLoyaltyDown.position.y + pOneLoyaltyDown.frame.height/2)) {
            pressAnimation(pOneLoyaltyDown)
            print("P1 plainswalker lost health.")
            pOnePlainswalkerHealth -= 1
            pOneLoyaltyLabel.text = "\(pOnePlainswalkerHealth)"
            pumpAnimation(pOneLoyaltyLabel)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoLoyaltyUp.position.x - pTwoLoyaltyUp.frame.width/2) &&
            pos.x <= (pTwoLoyaltyUp.position.x + pTwoLoyaltyUp.frame.width/2) &&
            pos.y > (pTwoLoyaltyUp.position.y - pTwoLoyaltyUp.frame.height/2) &&
            pos.y <= (pTwoLoyaltyUp.position.y + pTwoLoyaltyUp.frame.height/2)) {
            pressAnimation(pTwoLoyaltyUp)
            print("P2 plainswalker gained health.")
            pTwoPlainswalkerHealth += 1
            pTwoLoyaltyLabel.text = "\(pTwoPlainswalkerHealth)"
            pumpAnimation(pTwoLoyaltyLabel)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (pTwoLoyaltyDown.position.x - pTwoLoyaltyDown.frame.width/2) &&
            pos.x <= (pTwoLoyaltyDown.position.x + pTwoLoyaltyDown.frame.width/2) &&
            pos.y > (pTwoLoyaltyDown.position.y - pTwoLoyaltyDown.frame.height/2) &&
            pos.y <= (pTwoLoyaltyDown.position.y + pTwoLoyaltyDown.frame.height/2)) {
            pressAnimation(pTwoLoyaltyDown)
            print("P2 plainswalker lost health.")
            pTwoPlainswalkerHealth -= 1
            pTwoLoyaltyLabel.text = "\(pTwoPlainswalkerHealth)"
            pumpAnimation(pTwoLoyaltyLabel)
        } else if(!GameScene.cardIsHidden &&
            pos.x > (GameViewController.cardFrameX) &&
            pos.x <= (GameViewController.cardFrameX + GameViewController.cardFrameWidth) &&
            pos.y > (GameViewController.cardFrameY) &&
            pos.y <= (GameViewController.cardFrameY + GameViewController.cardFrameHeight)) {
            GameScene.cardIsHidden = true
        } else {
            //do nothing while carousel is displayed
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
