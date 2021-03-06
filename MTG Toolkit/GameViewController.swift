//
//  GameViewController.swift
//  MTG Toolkit
//
//  Created by Jeezy on 2/11/18.
//  Copyright © 2018 Jeezy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    static let ip : String = "180.131.244.199"
    //static let ip : String = "192.168.1.100"
    static let baseUrl: String = "http://\(GameViewController.ip)/magic/"
    static let imageUrl: String = "http://\(GameViewController.ip)/magic/images/decks/"
    
    @IBOutlet var carousel: iCarousel!
    public static var screenScale: CGFloat = 1.0
    
    static var cc = CardCollectionModel()
    static var dc = DeckCollectionModel()
    static var loaded = false
    
    var firstTap = true
    var card = UIImageView()
    var viewDeckButton = UIImageView()
    var cardFronts = [UIImage]()
    var deckFronts = [UIImage]()
    static var cardFrontWidth: CGFloat = 0
    static var cardFrontHeight: CGFloat = 0
    static var cardFrontX: CGFloat = 0
    static var cardFrontY: CGFloat = 0
    static var cardFrameWidth: CGFloat = 0
    static var cardFrameHeight: CGFloat = 0
    static var cardFrameX = CGFloat(0)
    static var cardFrameY = CGFloat(0)
    
    static var cardTypeDescriptions = [String]()
    static var cardTypeStrings = [String]()
    static let cardTypes = [
        "Vigilance": "A creature with vigilance doesn't tap to attack. (Vigilance doesn't allow a tapped creature or a creature that entered the battlefield this turn to attack, though.)",
        "Untap": "Untap a tapped card by turning it right side up. When you untap your permanents at the beginning of your turn, it means that you can use (tap) them again.",
        "Tap": "This symbol means 'tap this card.' It appears only as a cost to activate an ability.",
        "Trample": "If a creature with trample would assign enough damage to its blockers to destroy them, you may have it assign the rest of its damage to the player or planeswalker it's attacking.",
        "Token": "Some cards create token creatures. You can use token cards from booster packs, glass beads, dice, or anything else to represent them.",
        "Target": "If a spell uses the word ìtarget,î you choose what the spell will affect when you cast it. The same is true for abilities you activate.",
        "Surge": "You may pay the ability cost rather than pay this spell's mana cost as you cast this spell if you or one of your teammates has cast another spell this turn.",
        "Scry": "To scry X, a player looks at the top X cards of his library, then puts any number of them on the bottom of his library and the rest on top of his library in any order.",
        "Sacrifice": "Move it from the battlefield to your graveyard. You can't regenerate it or save it in any way.",
        "Regenerate": "Regenerating a creature keeps it from being destroyed. Instead of being destroyed, the creature gets tapped, it's removed from combat (if it's in combat), and all its damage is healed.",
        "Reach": "A creature with reach can block creatures with flying (and creatures without flying).",
        "Prowess": "Prowess is a triggered ability. A creature with prowess gets +1/+1 whenever a noncreature spell is cast.",
        "Protection": "A creature with protection from a color can't be blocked, dealt damage, enchanted, or targeted by anything of that color.",
        "Permanent": "Lands, creatures, artifacts, enchantments, and planeswalkers are permanents. They enter the battlefield after you cast them. Token creatures are also permanents.",
        "Monstrosity": "If a creature is not monstrous yet, this ability makes that creature monstrous and it gets X +1/+1 counters.",
        "Menace": "A creature with menace cannot be blocked except by two or more creatures.",
        "Lifelink": "If a creature with lifelink deals damage, its controller also gains that much life.",
        "Landfall": "The Landfall ability lets many things happen when a land enters the battlefield. Your creatures may get stronger, or certain abilities can trigger.",
        "Intimidate": "A creature with intimidate can't be blocked except by artifact creatures and/or creatures that share a color with it.",
        "Ingest": "Whenever this creature deals combat damage to a player, that player exiles the top card of his or her library.",
        "Infect": "Creatures with infect deal damage to other creatures in the form of -1/-1 counters and to players in the form of poison counters. A player who receives 10 poison counters loses the game.",
        "Indestructible": "An indestructible permanent can't be destroyed by damage or by effects that say destroy. It can still be sacrificed or exiled.",
        "Hexproof": "A creature with hexproof can't be the target of spells or abilities your opponents control, including Aura spells. Your spells and abilities can still target it.",
        "Haste": "A creature with haste can attack and you can activate its oT abilities as soon as it comes under your control.",
        "Flying": "A creature with flying can be blocked only by other creatures with flying and creatures with reach.",
        "Flash": "You may cast a spell with flash any time you could cast an instant, even in response to other spells.",
        "First strike": "A creature with first strike deals its damage in combat before creatures without first strike or double strike.",
        "Fight": "When two creatures fight, each deals damage equal to its power to the other. This is different from creatures dealing damage in combat.",
        "Exile": "If an ability exiles a card, it's removed from the battlefield and set aside. An exiled card isn't a permanent and isn't in the graveyard.",
        "Equip": "If you have an Equipment card on the battlefield, you can pay its equip cost to attach it to one of your creatures on the battlefield. If the equipped creature leaves the battlefield, the Equipment card stays.",
        "Enchant": "An Aura is an enchantment that enchants (attaches to) another card on the battlefield. If that creature leaves the battlefield, the Aura is put into the graveyard.",
        "Double strike": "A creature with double strike deals damage twice each combat: once before creatures without first strike or double strike, and then again when creatures normally deal damage.",
        "Discard": "To discard a card, choose a card from your hand and put it into your graveyard.",
        "Dies": "Another way to say a creature has been put into a graveyard from the battlefield.",
        "Destroy": "A permanent that's destroyed is put into the graveyard. Creatures that are dealt damage at least equal to their toughness in a single turn are destroyed. Spells and abilities can also destroy permanents.",
        "Defender": "A creature with defender can't attack.",
        "Deathtouch": "A creature dealt damage by a creature with deathtouch is destroyed.",
        "Damage": "Creatures deal damage equal to their power during combat. Spells can also deal damage to creatures and players.",
        "Counter": "If a card counters a spell, you can cast it in response to a spell your opponent is casting. The countered spell has no effect, and it's put into the graveyard.",
        "Control": "You control the creatures and other permanents that you have on the battlefield, unless your opponent uses a spell or ability to gain control of one of your permanents.",
        "Cast": "You cast a spell by paying its mana cost and putting it onto the stack.",
        "Bestow": "A creature with bestow gives the player the option to cast it as an Aura that enchants a creature, granting that creature its power, toughness, and abilities.",
        "Awaken": "If this spell's awaken cost was paid, put X +1/+1 counters on target land you control. That land becomes a 0/0 Elemental creature with haste. It's still a land.",
        "+1/+1": "A bonus applied to a creature giving +1 to its power and +1 to its toughness. The numbers can be any value, including negative numbers."
    ]
    
    @objc func turnOffCarousel(_ sender: UITapGestureRecognizer) {
        GameScene.viewingDecks = false
        GameScene.cardIsHidden = false
        carousel.isHidden = true
        card.isHidden = false
    }
    
    func pumpDeckButton() {
        self.viewDeckButton.startAnimating()
    }
    
    @objc func toggleDeckCarousel(_ sender: UITapGestureRecognizer) {
        pumpDeckButton()
        
        if(CardCollectionModel.loaded && DeckCollectionModel.loaded && !GameViewController.loaded) {
            self.loadCardImages()
        }
        
        if(GameViewController.loaded) {
            GameScene.viewingDecks = !GameScene.viewingDecks
            carousel.reloadData()
            if(!GameScene.viewingDecks) {
                print("Exited deck viewing mode.")
                GameScene.cardIsHidden = false
                carousel.isHidden = true
                card.isHidden = false
            } else {
                print("Now viewing decks.")
                GameScene.cardIsHidden = true
                carousel.isHidden = false
                card.isHidden = true
                
                if(!carousel.isHidden) {
                    carousel.scrollToItem(at: 0, animated: true)
                }
                
                for c in GameViewController.cc.cards {
                    print("Key => \(c.key), Value: ", terminator:"")
                    print(c.value.cardName!)
                }
            }
        } else {
            print("Still downloading decks...")
        }
    }
    
    @objc func increaseCurrentDeck(_ sender: UISwipeGestureRecognizer) {
        pumpDeckButton()
        if(GameScene.viewingDecks) {
            if(DeckCollectionModel.deckIterator + 1 < DeckCollectionModel.allIds.count) {
                DeckCollectionModel.deckIterator += 1
            } else {
                DeckCollectionModel.deckIterator = 0
            }
            loadCardImages()
            print("Deck iterator changed to \(DeckCollectionModel.deckIterator)")
            carousel.scrollToItem(at: 0, animated: true)
        }
    }
    
    @objc func decreaseCurrentDeck(_ sender: UISwipeGestureRecognizer) {
        pumpDeckButton()
        if(GameScene.viewingDecks) {
            if(DeckCollectionModel.deckIterator - 1 >= 0) {
                DeckCollectionModel.deckIterator -= 1
            } else {
                DeckCollectionModel.deckIterator = DeckCollectionModel.allIds.count-1
            }
            loadCardImages()
            print("Deck iterator changed to \(DeckCollectionModel.deckIterator)")
            carousel.scrollToItem(at: 0, animated: true)
        }
    }
    
    @objc func toggleCardCarousel(_ sender: UITapGestureRecognizer) {
        GameScene.viewingDecks = false
        GameScene.cardIsHidden = true
        carousel.isHidden = false
        card.isHidden = true
        carousel.reloadData()
    
        if(!carousel.isHidden && firstTap) {
            firstTap = false
            carousel.scrollToItem(at: GameViewController.cardTypes.count/2, animated: true)
        }
    }
    
    func loadCardImages() {
        print("Loading card images from deck \(DeckCollectionModel.deckIterator)...", terminator:"")
        if(DeckCollectionModel.currentDeckNum != DeckCollectionModel.deckIterator) {
            GameViewController.loaded = false
            DeckCollectionModel.currentDeckNum = DeckCollectionModel.deckIterator
        }
        
        if(CardCollectionModel.loaded && DeckCollectionModel.loaded && !GameViewController.loaded) {
            GameViewController.dc.setCurrentDeck(DeckCollectionModel.allIds[DeckCollectionModel.deckIterator])
            deckFronts.removeAll()
            for d in GameViewController.dc.decks {
                if(d.value.deckId == DeckCollectionModel.currentDeckId) {
                    let c = GameViewController.cc.cards[d.value.cardId!]!
                    c.quantity = d.value.quantity
                    let tempImage = UIImage(named: c.imageURL!)
                    let scale = (tempImage!.size.height / card.frame.height) *
                        ((UIDevice.current.model == "iPhone") ? 0.5 : 1.0) // was 0.72
                    let resized = tempImage!.scaleImage(toSize: CGSize(
                        width: tempImage!.size.width*scale,
                        height: tempImage!.size.height*scale))!
                    let withQuantity = textToImage(drawText: "x\(c.quantity!)", inImage: resized, atPoint: CGPoint(x: resized.size.width/2-10, y: resized.size.height/2-20))
                    deckFronts.append(withQuantity)
                }
            }
            GameViewController.loaded = true
            print("complete.")
        } else {
            print("cards loaded: \(CardCollectionModel.loaded), decks loaded: \(DeckCollectionModel.loaded)")
        }
        
        carousel.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController.cc.initHomeModel()
        GameViewController.dc.initHomeModel()
        
        if(UIDevice.current.model == "iPhone") {
            GameViewController.screenScale = 0.35
        } else {
            GameViewController.screenScale = 0.5
        }
        
        for i in 1...GameScene.numCardFronts {
            let tempImage = UIImage(named: "images/cardFront\(i).png")
            cardFronts.append(tempImage!.scaleImage(toSize: CGSize(
                width: tempImage!.size.width*GameViewController.screenScale,
                height: tempImage!.size.height*GameViewController.screenScale))!)
        }
        
        let image = UIImage(named: "images/cardBack.png")
        let resizedImage = image?.scaleImage(toSize: CGSize(width: image!.size.width*GameViewController.screenScale, height: image!.size.height*GameViewController.screenScale))
        card = UIImageView(image: resizedImage!)
        card.isUserInteractionEnabled = true
        card.contentMode = .center
        card.center = self.view.center
        self.view.addSubview(card)
        
        let image2 = UIImage(named: "images/decks.png")
        var deckButtonScale = GameViewController.screenScale*0.5
        if(UIDevice.current.model == "iPhone") {
            deckButtonScale = GameViewController.screenScale*0.2
        }
        let resizedImage2 = image2?.scaleImage(toSize: CGSize(width: image2!.size.width*deckButtonScale, height: image2!.size.height*deckButtonScale))
        viewDeckButton = UIImageView(image: resizedImage2!)
        viewDeckButton.isUserInteractionEnabled = true
        viewDeckButton.contentMode = .center
        if(UIDevice.current.model == "iPhone") {
            viewDeckButton.center = CGPoint(x: self.view.frame.width - 25, y: 17)
        } else {
            viewDeckButton.center = CGPoint(x: self.view.frame.width - 80, y: 40)
        }
        self.view.addSubview(viewDeckButton)
        
        GameViewController.cardFrameHeight = card.image!.size.height
        GameViewController.cardFrameWidth = card.image!.size.width
        GameViewController.cardFrameX = card.frame.origin.x
        GameViewController.cardFrameY = card.frame.origin.y
        
        let imageF = UIImage(named: "images/cardFront1.png")
        let tempCardF = UIImageView(image: imageF!)
        tempCardF.contentMode = .center
        tempCardF.center = self.view.center
        GameViewController.cardFrontHeight = tempCardF.frame.size.height
        GameViewController.cardFrontWidth = tempCardF.frame.size.width
        GameViewController.cardFrontX = tempCardF.frame.origin.x
        GameViewController.cardFrontY = tempCardF.frame.origin.y
        
        self.viewDeckButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleDeckCarousel(_:))))
        self.carousel.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.turnOffCarousel(_:))))
        self.card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleCardCarousel(_:))))
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.increaseCurrentDeck(_:)))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 2 // 2 finger swipe
        self.carousel.addGestureRecognizer(gesture)
        
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(self.decreaseCurrentDeck(_:)))
        gesture2.direction = .down
        gesture2.numberOfTouchesRequired = 2 // 2 finger swipe
        self.carousel.addGestureRecognizer(gesture2)
        
        let sortedKeys = Array(GameViewController.cardTypes.keys).sorted(by: <)
        for name in sortedKeys {
            GameViewController.cardTypeStrings.append(name)
            GameViewController.cardTypeDescriptions.append(GameViewController.cardTypes[name]!)
        }

        carousel.type = .coverFlow
        carousel.center = self.view.center
        carousel.isHidden = true
        carousel.reloadData()
        
        //play "pump" animation
        let imagesListArray: NSMutableArray = []
        let deckImage1  = UIImage(named: "images/decks.png")
        let resizedDeckImage1 = deckImage1?.scaleImage(toSize: CGSize(width: deckImage1!.size.width*deckButtonScale, height: deckImage1!.size.height*deckButtonScale))
        imagesListArray.add(resizedDeckImage1!)
        
        let deckImage2  = UIImage(named: "images/decks2.png")
        let resizedDeckImage2 = deckImage2?.scaleImage(toSize: CGSize(width: deckImage2!.size.width*deckButtonScale, height: deckImage2!.size.height*deckButtonScale))
        imagesListArray.add(resizedDeckImage2!)
        
        self.viewDeckButton.animationImages = imagesListArray as? [UIImage]
        self.viewDeckButton.animationDuration = 0.3
        self.viewDeckButton.animationRepeatCount = 1
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if(GameScene.viewingDecks) {
            return deckFronts.count
        } else {
            return GameViewController.cardTypes.keys.count
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView
        if(GameScene.viewingDecks) {
            //reuse view if available, otherwise create a new view
            if let view = view as? UIImageView {
                itemView = view
            } else {
                //don't do anything specific to the index within
                //this `if ... else` statement because the view will be
                //recycled and used with other index values later
                itemView = UIImageView(frame: CGRect(x: 100, y: 0, width: 315, height: 450))
                itemView.contentMode = .center
            }
            
            itemView.image = deckFronts[index]
            
            return itemView
        } else {
            var cardType: UILabel
            var cardDescription: UILabel
            let randomIndex = Int(arc4random_uniform(UInt32(GameScene.numCardFronts)))
            
            //reuse view if available, otherwise create a new view
            if let view = view as? UIImageView {
                itemView = view
                //get a reference to the label in the recycled view
                cardType = itemView.viewWithTag(1) as! UILabel
                cardDescription = itemView.viewWithTag(2) as! UILabel
            } else {
                //don't do anything specific to the index within
                //this `if ... else` statement because the view will be
                //recycled and used with other index values later
                itemView = UIImageView(frame: CGRect(x: 100, y: 0, width: 315, height: 450))
                itemView.image = cardFronts[randomIndex]
                itemView.contentMode = .center
                
                //cardType
                let scale = CGFloat((UIDevice.current.model == "iPhone") ? 0.7 : 1.0)
                let fontSize = CGFloat((UIDevice.current.model == "iPhone") ? 14 : 21)
                let xOffset = CGFloat((UIDevice.current.model == "iPhone") ? 40 : 0)
                let yOffset = CGFloat((UIDevice.current.model == "iPhone") ? -4 : 0)
                let yOffsetType = CGFloat((UIDevice.current.model == "iPhone") ? 21 : 0)
                
                cardType = UILabel(frame: CGRect(x: 315/11+xOffset,
                                                 y: 154+yOffsetType,
                                                 width: (315 - 315/6)*scale,
                                                 height: 450/2*scale))
                cardType.backgroundColor = .clear
                cardType.textAlignment = .left
                cardType.font = UIFont(name: "Magic:the Gathering", size: fontSize)
                cardType.tag = 1
                itemView.addSubview(cardType)
                
                //cardDescription
                cardDescription = UILabel(frame: CGRect(x: 315/12+xOffset,
                                                        y: 235+yOffset,
                                                        width: (315 - 315/6 - 5)*scale,
                                                        height: 450/2*scale))
                cardDescription.backgroundColor = .clear
                cardDescription.textAlignment = .left
                cardDescription.font = UIFont(name: "Magic:the Gathering", size: fontSize-1)
                cardDescription.tag = 2
                cardDescription.numberOfLines = 6
                cardDescription.preferredMaxLayoutWidth = CGFloat((GameViewController.cardFrontWidth - 70)*scale)
                itemView.addSubview(cardDescription)
            }
            
            cardType.text = GameViewController.cardTypeStrings[index]
            cardDescription.text = GameViewController.cardTypeDescriptions[index]
            
            return itemView
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Magic:the Gathering", size: 32)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
