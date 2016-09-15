//
//  GameScene.swift
//  PlatformGame
//
//  Created on 2016-01-03.
//  Copyright (c) 2015 2D Game World. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

//DEFINE THE COLLISION CATEGORIES
let birdCategory:UInt32 = 0x1 << 0
let pipeCategory:UInt32 = 0x1 << 1

//CREATE THE BIRD ATLAS FOR ANIMATION
let birdAtlas = SKTextureAtlas(named:"player.atlas")
var birdSprites = Array<SKTexture>()
var bird = SKSpriteNode()
    
//CREATE THE FLOOR AND THE PIPES
var myFloor1 = SKSpriteNode()
var myFloor2 = SKSpriteNode()
var bottomPipe1 = SKSpriteNode()
var bottomPipe2 = SKSpriteNode()
var topPipe1 = SKSpriteNode()
var topPipe2 = SKSpriteNode()

//CREATE AN OUTLINE OF THE PIPES FOR COLLISION PURPOSES
let myPipesTexture = SKTexture(imageNamed: "pipe")

//CREATE THE BACKGROUND
var myBackground = SKSpriteNode()

//SET AN INITIAL VARIABLE FOR THE RANDOM PIPE SIZE
var pipeHeight = CGFloat(200)

//DETERMINE IF THE GAME HAS STARTED OR NOT
var start = Bool(false)
var birdIsActive = Bool(false)
    
    override func didMoveToView(view: SKView) {
        
        //CREATE A BORDER AROUND THE SCREEN
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //REQUIRED TO DETECT SPECIFIC COLLISIONS
        self.physicsWorld.contactDelegate = self
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("player1"))
        birdSprites.append(birdAtlas.textureNamed("player2"))
        birdSprites.append(birdAtlas.textureNamed("player3"))
        birdSprites.append(birdAtlas.textureNamed("player4"))
        
        //SET UP THE BACKGROUND IMAGE AND MAKE IT STATIC
        myBackground = SKSpriteNode(imageNamed: "background-image-2")
        myBackground.anchorPoint = CGPointZero;
        myBackground.size = self.frame.size
        myBackground.position = CGPointMake(0, 0);
        
        //BLEND THE BACKGROUND IMAGE WITH THE SAME BACKGROUND COLOR
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        //SET UP THE BIRD'S INITIAL POSITION AND IMAGE
        bird = SKSpriteNode(texture:birdSprites[0])
        bird.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        bird.size.width = bird.size.width / 10
        bird.size.height = bird.size.height / 10
        
        //SET UP THE FLOOR AND PIPES INITIAL POSITION AND IMAGE
        myFloor1 = SKSpriteNode(imageNamed: "floor")
        myFloor2 = SKSpriteNode(imageNamed: "floor")
        bottomPipe1 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe2 = SKSpriteNode(imageNamed: "bottomPipe")
        topPipe1 = SKSpriteNode(imageNamed: "topPipe")
        topPipe2 = SKSpriteNode(imageNamed: "topPipe")
        myFloor1.anchorPoint = CGPointZero;
        myFloor1.position = CGPointMake(0, 20);
        
        myFloor1.size.width = self.frame.size.width;
        myFloor2.size.width = self.frame.size.width;
        
        
        myFloor2.anchorPoint = CGPointZero;
        myFloor2.position = CGPointMake(myFloor1.size.width-1, 20);
        
        bottomPipe1.position = CGPointMake(800, 200);
        bottomPipe1.size.height = bottomPipe1.size.height / 2
        bottomPipe1.size.width = bottomPipe1.size.width / 2
        bottomPipe1.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe1.physicsBody?.contactTestBitMask = birdCategory
        
        bottomPipe2.position = CGPointMake(1600, 200);
        bottomPipe2.size.height = bottomPipe2.size.height / 2
        bottomPipe2.size.width = bottomPipe2.size.width / 2
        bottomPipe2.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe2.physicsBody?.contactTestBitMask = birdCategory
        
        topPipe1.position = CGPointMake(800, 200 * 5);
        topPipe1.size.height = topPipe1.size.height / 2
        topPipe1.size.width = topPipe1.size.width / 2
        topPipe1.physicsBody?.categoryBitMask = pipeCategory
        topPipe1.physicsBody?.contactTestBitMask = birdCategory
        
        topPipe2.position = CGPointMake(1600, 200 * 5);
        topPipe2.size.height = topPipe2.size.height / 2
        topPipe2.size.width = topPipe2.size.width / 2
        topPipe2.physicsBody?.categoryBitMask = pipeCategory
        topPipe2.physicsBody?.contactTestBitMask = birdCategory
        
        //ADD THE BACKGROUND TO THE SCENE
        addChild(self.myBackground)
        
        //ADD THE PIPES TO THE SCENE
        addChild(self.bottomPipe1)
        addChild(self.bottomPipe2)
        addChild(self.topPipe1)
        addChild(self.topPipe2)
        
        //ADD THE FLOOR TO THE SCENE
        addChild(self.myFloor1)
        addChild(self.myFloor2)
        
        //LASTLY, ADD THE BIRD TO THE SCENE
        addChild(self.bird)
        
        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animateWithTextures(self.birdSprites, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatActionForever(animateBird)
        self.bird.runAction(repeatAction)
        
        //CREATE A PHYSICS BODY FOR THE PIPES AND FLOOR
        bottomPipe1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe1.size)
        bottomPipe2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe2.size)
        topPipe1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe1.size)
        topPipe2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe2.size)
        
        //PREVENT THE PIPES FROM MOVING AROUND
        bottomPipe1.physicsBody?.dynamic = false
        bottomPipe2.physicsBody?.dynamic = false
        topPipe1.physicsBody?.dynamic = false
        topPipe2.physicsBody?.dynamic = false
        
        myFloor1.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        myFloor2.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
        //KEEP THE BIRD CENTERED IN THE MIDDLE OF THE SCREEN
        bird.position.x = self.frame.width / 2
        bird.physicsBody?.allowsRotation = false
        
        //POSITION THE FLOOR
        myFloor1.position = CGPointMake(myFloor1.position.x-8, myFloor1.position.y);
        myFloor2.position = CGPointMake(myFloor2.position.x-8, myFloor2.position.y);
        
        //REPEAT THE FLOOR IN A CONTINIOUS LOOP
        if (myFloor1.position.x < -myFloor1.size.width ){
            myFloor1.position = CGPointMake(myFloor2.position.x + myFloor2.size.width, myFloor1.position.y);
            print("1111 \(myFloor1.position.x) ")
        }
        if (myFloor2.position.x < -myFloor2.size.width) {
            myFloor2.position = CGPointMake(myFloor1.position.x + myFloor1.size.width, myFloor2.position.y);
            print("222 \(myFloor2.position.x) ")
        }
        
        //IF THE GAME HAS STARTED, BEGIN SHOWING THE PIPES
        if (start) {
            bottomPipe1.position = CGPointMake(bottomPipe1.position.x-8, 200);
            bottomPipe2.position = CGPointMake(bottomPipe2.position.x-8, bottomPipe2.position.y);
            topPipe1.position = CGPointMake(topPipe1.position.x-8, 800);
            topPipe2.position = CGPointMake(topPipe2.position.x-8, 700);
            
            if (bottomPipe1.position.x < -bottomPipe1.size.width + 600 / 2){
                bottomPipe1.position = CGPointMake(bottomPipe2.position.x + bottomPipe2.size.width * 4, pipeHeight);
                topPipe1.position = CGPointMake(topPipe2.position.x + topPipe2.size.width * 4, pipeHeight);
            }
            
            if (bottomPipe2.position.x < -bottomPipe2.size.width + 600 / 2) {
                bottomPipe2.position = CGPointMake(bottomPipe1.position.x + bottomPipe1.size.width * 4, pipeHeight);
                topPipe2.position = CGPointMake(topPipe1.position.x + topPipe1.size.width * 4, pipeHeight);
            }
            
            if (bottomPipe1.position.x < self.frame.width/2)
            {
                //GENERATE A RANDOM NUMBER BETWEEN 100 AND 240 (THE MAXIMUM SIZE OF THE PIPES)
                pipeHeight = randomBetweenNumbers(100, secondNum: 240)
            }
        }
    }
    
    //RANDOM NUMBER GENERATOR
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        //USER HAS TOUCHED THE SCREEN, BEGIN THE GAME
        start = true
        
        if (birdIsActive)
        {
        self.bird.physicsBody!.applyImpulse(CGVectorMake(0, 150))
        }
        else
        {
        createBirdPhysics()
        }
    }
    
    //CREATE A PHYSICS BODY FOR THE BIRD
    func createBirdPhysics()
    {
        //MAKE A CIRCULAR BORDER AROUND THE BIRD
        bird.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.bird.size.width / 2))
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //CREATE A BIT MASK AROUND THE BIRD
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = pipeCategory
        birdIsActive = true
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //GAMEOVER = TRUE
        print("BIRD HAS MADE CONTACT")
    }
}
