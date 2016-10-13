//
//  GameScene.swift
//  PlatformGame
//
//  Created on 2016-01-03.
//  Copyright (c) 2015 2D Game World. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, AsyncServerDelegate {
    
    let server = AsyncServer()
    
    
    let pipeDiffSpace1 : CGFloat = 420
    let floorheight : CGFloat = 150
    
    let speedValue : CGFloat = 4.0
    let MAX_PIPE_HEIGHT : CGFloat = 300.0
    let MIN_PIPE_HEIGHT : CGFloat = 200.0
    
    
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
    var bottomPipe3 = SKSpriteNode()
    var topPipe3 = SKSpriteNode()
    var bottomPipe4 = SKSpriteNode()
    var topPipe4 = SKSpriteNode()
    
    
    var crashImage = SKSpriteNode()
    
    //CREATE AN OUTLINE OF THE PIPES FOR COLLISION PURPOSES
    let myPipesTexture = SKTexture(imageNamed: "pipe")
    
    //CREATE THE BACKGROUND
    var myBackground = SKSpriteNode()
    
    //SET AN INITIAL VARIABLE FOR THE RANDOM PIPE SIZE
    
    
    var btmPipeHeight1 = CGFloat(250)
    var btmPipeHeight2 = CGFloat(300)
    var btmPipeHeight3 = CGFloat(200)
    var btmPipeHeight4 = CGFloat(250)
    
    let characterEscapeSpace : CGFloat = CGFloat(250)
    
    var topPipeHeight1 = CGFloat(200)
    var topPipeHeight2 = CGFloat(250)
    var topPipeHeight3 = CGFloat(300)
    var topPipeHeight4 = CGFloat(250)
    
    var frameTopOffset = CGFloat(77)
    
    //DETERMINE IF THE GAME HAS STARTED OR NOT
    var start = Bool(false)
    var birdIsActive = Bool(false)
    
    
    var myLabel : SKLabelNode = SKLabelNode.init(fontNamed: "Arial")
    
    var guideTextLabel : SKLabelNode = SKLabelNode.init(fontNamed: "Copperplate")
    var scoreCounterLabel : SKLabelNode = SKLabelNode.init(fontNamed: "Copperplate")
    var lifeCounterLabel : SKLabelNode = SKLabelNode.init(fontNamed: "Copperplate")
    var timeCounterLabel : SKLabelNode = SKLabelNode.init(fontNamed: "Copperplate")
    
    var timeCounter : Int = 60
    
    var scoreCounter : Int = 0
    var crashCounter : Int = 0
    
    var scorePassingXoffset : CGFloat = 0.0
    
    var gameTimer : NSTimer?
    
    var isGameStopped = false
    
    var isCollided = false
    
  //  var coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coin", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    var crashAudioPlayer = AVAudioPlayer()

  //  var audioPlayer : AVAudioPlayer?
    
    
    func getYoffsetForBottomPipe(tmpPipeHeight : CGFloat) -> CGFloat {
        let yPos  =  (self.myFloor1.frame.size.height / 2.0) + (tmpPipeHeight / 2.0)
        return yPos
    }
    
    
    func getYoffsetForTopPipeFromBottomPipeHeight(tmpBtmPipeHeight : CGFloat) -> CGFloat {
        
        let heightForTopPipe =  self.frame.size.height  - ((self.myFloor1.frame.size.height / 2.0) + (tmpBtmPipeHeight / 2.0) + characterEscapeSpace)
        let yPos = ((self.myFloor1.frame.size.height / 2.0) + (tmpBtmPipeHeight)) + characterEscapeSpace + (heightForTopPipe / 2.0)-(frameTopOffset / 2.0)
        return yPos
    }
    
    
    func getHeightForTopPipeFromBottomPipeHeight(tmpBtmPipeHeight : CGFloat) -> CGFloat {
        let height  = self.frame.size.height - (frameTopOffset / 2.0) - ((self.myFloor1.frame.size.height / 2.0) + tmpBtmPipeHeight + characterEscapeSpace)
        return height
    }
    
    
    
    func initializeAllParams() -> Void {
        
    }
    
    
    // MARK: Play Audio
    
    func prepareTheAudio() {
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("jump_10", ofType: "wav")!), fileTypeHint:nil)
        } catch {
            //Handle the error
        }
        do {
            
            try crashAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("punch", ofType: "wav")!), fileTypeHint:nil)
        } catch {
            //Handle the error
        }
    }
    
    
    override func didMoveToView(view: SKView) {
        
        //CREATE A BORDER AROUND THE SCREEN
        //  self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(self.frame.origin.x, self.frame.origin.y+frameTopOffset, self.frame.size.width, self.frame.size.height-frameHeightDifference))
        dispatch_async(dispatch_get_main_queue()) {
            self.server.serviceType = "_ClientServer._tcp"
            self.server.serviceName = "tvOS"
            
            self.server.delegate = self
            self.server.start()
        }
        
        
      //audio
        
        self.prepareTheAudio()
    
    
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(self.frame.origin.x, self.frame.origin.y - (frameTopOffset/2.0), self.frame.size.width, self.frame.size.height - ( frameTopOffset)))
        
        
       
        
        
        //REQUIRED TO DETECT SPECIFIC COLLISIONS
        self.physicsWorld.gravity = CGVectorMake(0, -4.5)
        
        self.physicsWorld.contactDelegate = self
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("player1"))
        birdSprites.append(birdAtlas.textureNamed("player2"))
        birdSprites.append(birdAtlas.textureNamed("player3"))
        birdSprites.append(birdAtlas.textureNamed("player4"))
        
        //SET UP THE BACKGROUND IMAGE AND MAKE IT STATIC
        myBackground = SKSpriteNode(imageNamed: "background_5.png")
        myBackground.anchorPoint = CGPointZero;
        myBackground.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        myBackground.position = CGPointMake(0, 0);
        
        //BLEND THE BACKGROUND IMAGE WITH THE SAME BACKGROUND COLOR
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        //SET UP THE BIRD'S INITIAL POSITION AND IMAGE
        bird = SKSpriteNode(texture:birdSprites[0])
        bird.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        bird.size.width = bird.size.width / 10.0
        bird.size.height = bird.size.height / 10.0
        
        
        
        
        //SET UP THE FLOOR AND PIPES INITIAL POSITION AND IMAGE
        myFloor1 = SKSpriteNode(imageNamed: "floor")
        myFloor2 = SKSpriteNode(imageNamed: "floor")
        
        myFloor1.name = "floor1"
        myFloor2.name = "floor2"
        
        topPipe1 = SKSpriteNode(imageNamed: "topPipe")
        topPipe2 = SKSpriteNode(imageNamed: "topPipe")
        topPipe3 = SKSpriteNode(imageNamed: "topPipe")
        topPipe4 = SKSpriteNode(imageNamed: "topPipe")
        
        topPipe1.name = "topPipe1"
        topPipe2.name = "topPipe2"
        topPipe3.name = "topPip3"
        topPipe4.name = "topPipe4"
        
        
        bottomPipe1 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe2 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe3 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe4 = SKSpriteNode(imageNamed: "bottomPipe")
        
        
        
        bottomPipe1.name = "bottomPipe1"
        bottomPipe2.name = "bottomPipe2"
        bottomPipe3.name = "bottomPipe3"
        bottomPipe4.name = "bottomPipe4"
        
        myFloor1.size.width = self.frame.size.width + 100.0
        myFloor2.size.width = self.frame.size.width + 100.0
        
        myFloor1.size.height =  floorheight
        myFloor2.size.height =  floorheight
        
        
        
        myFloor1.anchorPoint = CGPointZero;
        myFloor2.anchorPoint = CGPointZero;
        myFloor1.position = CGPointMake(0,20);
        myFloor2.position = CGPointMake(myFloor1.size.width-1,20);
        
        let b1Width : CGFloat = bottomPipe1.size.width
        
        let b1X : CGFloat =  ((self.frame.size.width/2.0) + pipeDiffSpace1)
        
        let b2X : CGFloat =  (b1X + b1Width + pipeDiffSpace1)
        
        let b3X : CGFloat =   (b2X + b1Width + pipeDiffSpace1)
        let b4X : CGFloat =   (b3X + b1Width + pipeDiffSpace1)
        
        
        //   let totalViewHeight = self.frame.size.height
        
        
        
        bottomPipe1.position = CGPointMake(b1X, self.getYoffsetForBottomPipe(btmPipeHeight1))
        bottomPipe1.size.height = btmPipeHeight1
        bottomPipe1.size.width = bottomPipe1.size.width / 2
        bottomPipe1.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe1.physicsBody?.contactTestBitMask = birdCategory
        
        
        
        
        bottomPipe2.position = CGPointMake(b2X, self.getYoffsetForBottomPipe(btmPipeHeight2))
        bottomPipe2.size.height = btmPipeHeight2
        bottomPipe2.size.width = bottomPipe2.size.width / 2
        bottomPipe2.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe2.physicsBody?.contactTestBitMask = birdCategory
        
        bottomPipe3.position = CGPointMake(b3X, self.getYoffsetForBottomPipe(btmPipeHeight3))
        bottomPipe3.size.height = btmPipeHeight3
        bottomPipe3.size.width = bottomPipe3.size.width / 2
        bottomPipe3.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe3.physicsBody?.contactTestBitMask = birdCategory
        
        
        bottomPipe4.position = CGPointMake(b4X, self.getYoffsetForBottomPipe(btmPipeHeight4))
        bottomPipe4.size.height = btmPipeHeight4
        bottomPipe4.size.width = bottomPipe4.size.width / 2
        bottomPipe4.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe4.physicsBody?.contactTestBitMask = birdCategory
        
        
        
        
        topPipe1.position = CGPointMake(b1X + (pipeDiffSpace1 / 2.0), self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight1))
        topPipe1.size.height = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight1)
        topPipe1.size.width = topPipe1.size.width / 2
        topPipe1.physicsBody?.categoryBitMask = pipeCategory
        topPipe1.physicsBody?.contactTestBitMask = birdCategory
        
        topPipe2.position = CGPointMake(b2X + (pipeDiffSpace1 / 2.0), self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight2))
        topPipe2.size.height = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight2)
        topPipe2.size.width = topPipe2.size.width / 2
        topPipe2.physicsBody?.categoryBitMask = pipeCategory
        topPipe2.physicsBody?.contactTestBitMask = birdCategory
        
        
        topPipe3.position = CGPointMake(b3X + (pipeDiffSpace1 / 2.0), self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight3))
        topPipe3.size.height = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight3)
        topPipe3.size.width = topPipe3.size.width / 2
        topPipe3.physicsBody?.categoryBitMask = pipeCategory
        topPipe3.physicsBody?.contactTestBitMask = birdCategory
        
        topPipe4.position = CGPointMake(b4X + (pipeDiffSpace1 / 2.0), self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight4))
        topPipe4.size.height = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight4)
        topPipe4.size.width = topPipe4.size.width / 2
        topPipe4.physicsBody?.categoryBitMask = pipeCategory
        topPipe4.physicsBody?.contactTestBitMask = birdCategory
        
        //ADD THE BACKGROUND TO THE SCENE
        addChild(self.myBackground)
        
        //ADD THE PIPES TO THE SCENE
        addChild(self.bottomPipe1)
        addChild(self.bottomPipe2)
        addChild(self.bottomPipe3)
        addChild(self.bottomPipe4)
        
        addChild(self.topPipe1)
        addChild(self.topPipe2)
        addChild(self.topPipe3)
        addChild(self.topPipe4)
        //
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
        
        
        bottomPipe3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe3.size)
        topPipe3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe3.size)
        
        bottomPipe4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe4.size)
        topPipe4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe4.size)
        
        //PREVENT THE PIPES FROM MOVING AROUND
        bottomPipe1.physicsBody?.dynamic = false
        bottomPipe2.physicsBody?.dynamic = false
        topPipe1.physicsBody?.dynamic = false
        topPipe2.physicsBody?.dynamic = false
        bottomPipe3.physicsBody?.dynamic = false
        topPipe3.physicsBody?.dynamic = false
        
        bottomPipe4.physicsBody?.dynamic = false
        topPipe4.physicsBody?.dynamic = false
        
        myFloor1.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        myFloor2.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        
        
        // Place Labels
        
        
        timeCounterLabel.fontSize = 77.0
        self.timeCounterLabel.text = "\(timeCounter)"
        timeCounterLabel.position = CGPointMake(960,620)
        timeCounterLabel.fontColor = UIColor.yellowColor()
        addChild(timeCounterLabel)
        
        
        scoreCounterLabel.fontSize = 47.0
        self.scoreCounterLabel.text = "Score : \(scoreCounter)"
        scoreCounterLabel.position = CGPointMake(130,635)
        scoreCounterLabel.fontColor = UIColor.yellowColor()
        addChild(scoreCounterLabel)
        
        
        scorePassingXoffset = CGRectGetMidX(self.frame) - bottomPipe1.size.width / 2
        
        
        //Boom Image
        crashImage = SKSpriteNode(imageNamed: "blast")
        crashImage.position = CGPoint(x:CGRectGetMidX(self.frame), y:170.0);
        crashImage.size.width = 120.0
        crashImage.size.height = 120.0
        crashImage.hidden = true
        self.addChild(crashImage)
        
        
//        myLabel.position = CGPointMake(400,400)
//        //myLabel.size.width = 700
//        myLabel.text = "random accelerometer"
//        myLabel.fontSize = 24.0
//        myLabel.fontColor = UIColor.blackColor()
//        //myLabel.fontName = uibol
//        addChild(myLabel)
        

    }
    
    
    func getTheScoreOffsetForPipesWithXoffset(xVal : CGFloat) -> Bool {
        let birdPosXVal = self.bird.position.x
        let xDifference = birdPosXVal - xVal
        
//        double notRounded = varSmoothed_last;
//        double rounded = round (notRounded * 10.0) / 10.0;
        
        let rounded = ceil(xDifference)
        
        return ((rounded <= speedValue) && (rounded > 1.0)) ? true : false
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
        //KEEP THE BIRD CENTERED IN THE MIDDLE OF THE SCREEN
        bird.position.x = self.frame.width / 2
        bird.physicsBody?.allowsRotation = false
        
        //POSITION THE FLOOR
        myFloor1.position = CGPointMake(myFloor1.position.x-speedValue, myFloor1.position.y);
        myFloor2.position = CGPointMake(myFloor2.position.x-speedValue, myFloor2.position.y);
        
        //REPEAT THE FLOOR IN A CONTINIOUS LOOP
        if (myFloor1.position.x < -(self.frame.size.width + 200) ){
            myFloor1.position = CGPointMake(myFloor2.position.x + myFloor2.size.width, myFloor1.position.y);
            //  print("1111 \(myFloor1.frame.size.width) ")
        }
        if (myFloor2.position.x < -(self.frame.size.width + 200)) {
            myFloor2.position = CGPointMake(myFloor1.position.x + myFloor1.size.width, myFloor2.position.y);
            // print("222 \(myFloor2.frame.size.width) ")
        }
        
        //IF THE GAME HAS STARTED, BEGIN SHOWING THE PIPES
        if (start) {
            
            
            
            bottomPipe1.position = CGPointMake(bottomPipe1.position.x - speedValue, self.getYoffsetForBottomPipe(btmPipeHeight1))
            bottomPipe2.position = CGPointMake(bottomPipe2.position.x - speedValue, self.getYoffsetForBottomPipe(btmPipeHeight2))
            bottomPipe3.position = CGPointMake(bottomPipe3.position.x - speedValue, self.getYoffsetForBottomPipe(btmPipeHeight3))
            bottomPipe4.position = CGPointMake(bottomPipe4.position.x - speedValue, self.getYoffsetForBottomPipe(btmPipeHeight4))
            
            //   let totalViewHeight = self.frame.size.height
            
            topPipe1.position = CGPointMake(topPipe1.position.x - speedValue, self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight1))
            topPipe2.position = CGPointMake(topPipe2.position.x - speedValue, self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight2))
            topPipe3.position = CGPointMake(topPipe3.position.x - speedValue, self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight3))
            topPipe4.position = CGPointMake(topPipe4.position.x - speedValue, self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight4))
            
            
            
            // Upadte sscore counter
            
            if (self.getTheScoreOffsetForPipesWithXoffset(bottomPipe1.position.x) || self.getTheScoreOffsetForPipesWithXoffset(bottomPipe2.position.x) || self.getTheScoreOffsetForPipesWithXoffset(bottomPipe3.position.x) || self.getTheScoreOffsetForPipesWithXoffset(bottomPipe4.position.x)) {
                 self.scoreCounter += 1
            }
         
           // print("ssdddds\(self.scoreCounter)")
            
            if (bottomPipe1.position.x < -(bottomPipe1.size.width + (pipeDiffSpace1 / 2.0))){
                
                
                
                btmPipeHeight1 = randomBetweenNumbers(MIN_PIPE_HEIGHT, secondNum: MAX_PIPE_HEIGHT)
                bottomPipe1.size.height = btmPipeHeight1
                bottomPipe1.position = CGPointMake(bottomPipe4.position.x + bottomPipe4.size.width + pipeDiffSpace1, self.getYoffsetForBottomPipe(btmPipeHeight1))
                
                topPipeHeight1 = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight1)
                topPipe1.size.height = topPipeHeight1
                topPipe1.position = CGPointMake(topPipe4.position.x + topPipe4.size.width + pipeDiffSpace1,  self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight1))
                
            }
            
            if (bottomPipe2.position.x < -(bottomPipe2.size.width + (pipeDiffSpace1 / 2.0))) {
                
               
                
                btmPipeHeight2 = randomBetweenNumbers(MIN_PIPE_HEIGHT, secondNum: MAX_PIPE_HEIGHT)
                bottomPipe2.size.height = btmPipeHeight2
                bottomPipe2.position = CGPointMake(bottomPipe1.position.x + bottomPipe1.size.width + pipeDiffSpace1, self.getYoffsetForBottomPipe(btmPipeHeight2))
                
                topPipeHeight2 = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight2)
                topPipe2.size.height = topPipeHeight2
                topPipe2.position = CGPointMake(topPipe1.position.x + topPipe1.size.width + pipeDiffSpace1,  self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight2))
            }
            
            if (bottomPipe3.position.x < -(bottomPipe3.size.width + (pipeDiffSpace1 / 2.0))) {
                
              //  scoreCounter = scoreCounter + 1
                
                btmPipeHeight3 = randomBetweenNumbers(MIN_PIPE_HEIGHT, secondNum: MAX_PIPE_HEIGHT)
                bottomPipe3.size.height = btmPipeHeight3
                bottomPipe3.position = CGPointMake(bottomPipe2.position.x + bottomPipe2.size.width + pipeDiffSpace1, self.getYoffsetForBottomPipe(btmPipeHeight3))
                
                topPipeHeight3 = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight3)
                topPipe3.size.height = topPipeHeight3
                topPipe3.position = CGPointMake(topPipe2.position.x + topPipe2.size.width + pipeDiffSpace1,  self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight3))
            }
            
            if (bottomPipe4.position.x < -(bottomPipe4.size.width  + (pipeDiffSpace1 / 2.0))) {
                
              //  scoreCounter = scoreCounter + 1
                
                btmPipeHeight4 = randomBetweenNumbers(MIN_PIPE_HEIGHT, secondNum: MAX_PIPE_HEIGHT)
                bottomPipe4.size.height = btmPipeHeight4
                bottomPipe4.position = CGPointMake(bottomPipe3.position.x + bottomPipe3.size.width + pipeDiffSpace1, self.getYoffsetForBottomPipe(btmPipeHeight3))
                
                topPipeHeight4 = self.getHeightForTopPipeFromBottomPipeHeight(btmPipeHeight4)
                topPipe4.size.height = topPipeHeight4
                topPipe4.position = CGPointMake(topPipe3.position.x + topPipe3.size.width + pipeDiffSpace1,  self.getYoffsetForTopPipeFromBottomPipeHeight(btmPipeHeight4))
            }
            
        }
        
        self.scoreCounterLabel.text = "Score : \(scoreCounter)"
    }
    
    //RANDOM NUMBER GENERATOR
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //USER HAS TOUCHED THE SCREEN, BEGIN THE GAME
        self.startTheBirdToFly()
    }
    
    //CREATE A PHYSICS BODY FOR THE BIRD
    func createBirdPhysics()
    {
        //MAKE A CIRCULAR BORDER AROUND THE BIRD
        //bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.size.width/2.0)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: 17.0)
        bird.physicsBody?.linearDamping = 4.4
        //bird.physicsBody?.charge = 9.0
        //bird.physicsBody?.angularDamping = 0.2
        bird.physicsBody?.restitution = 0.02
        //CREATE A BIT MASK AROUND THE BIRD
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = pipeCategory
        //                          bird.physicsBody?.velocity = 33
        bird.physicsBody?.density = 0.11
        bird.physicsBody?.mass = 0.08
        bird.physicsBody?.friction = 0.2
        //bird.physicsBody?.affectedByGravity = false
        birdIsActive = true
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //GAMEOVER = TRUE
        //
        
        
        let nodeName : String? = contact.bodyA.node?.name
        
        if (nodeName != nil) {
            if ((nodeName != "floor1") && (nodeName != "floor2")){
                print("BIRD HAS MADE CONTACT\(contact.collisionImpulse)")
                
                
                if (isCollided == false) {
                    
                    isCollided = true
                    crashAudioPlayer.play()
                    
                    
                    crashImage.position = contact.contactPoint
                    crashImage.hidden = false
                    if crashCounter == 2 {
                        // show game over
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stopTheGame()
                        })
                        //            NSNotificationCenter.defaultCenter().postNotificationName("showGameOverPopUp", object: nil, userInfo: ["score" :"\(scoreCounter)"])
                    }
                    else {
                        crashCounter = crashCounter + 1
                    }
                    
                    self.performSelector(#selector(GameScene.removeCrashImage), withObject: self, afterDelay: 0.5)
                }
                
            }
        }
        
    }
    
    
    // MARK: Reciever Delegated
    
    
    // MARK : Remote Reciever delegate
    
    //    func didReceiveMessage(userInfo: [NSObject : AnyObject]!) {
    //
    //
    ////        let statusStr = userInfo?["status"] as! String
    ////        let playerViewController = PlayerViewController()
    ////
    ////        if statusStr == "play" {
    ////
    ////            let urlStr = userInfo?["videoURL"] as! String
    ////            if urlStr.isEmpty == false {
    ////
    ////                playerViewController.playVideo(urlStr as String)
    ////                self.presentViewController(playerViewController, animated: true, completion: nil)
    ////            }
    ////        }
    ////        else if statusStr == "stop"{
    ////            playerViewController.stopVideo()
    ////            self.dismissViewControllerAnimated(true, completion: {
    ////
    ////            })
    ////        }
    ////
    //
    //    }
    
    
    
    
    func server(theServer: AsyncServer!, didConnect connection: AsyncConnection!) {
        //print("didconnect")
        print(connection)
    }
    
    func server(theServer: AsyncServer!, didReceiveCommand command: AsyncCommand, object: AnyObject!, connection: AsyncConnection!) {
        // print("didreceivecommand")
        //  print(command)
        //  print(object)
        
        //        let dayTimePeriodFormatter = NSDateFormatter()
        //        dayTimePeriodFormatter.dateFormat = "ss"
        //
        //        let dateString = dayTimePeriodFormatter.stringFromDate(NSDate())
        
        dispatch_async(dispatch_get_main_queue()) {
            self.myLabel.text = "\(object as? String)"
            self.startTheBirdToFly()
        }
        // labelHello.text = object as? String
        
        
        
    }
    
    
    
    func startTheBirdToFly() -> Void {
        //USER HAS TOUCHED THE SCREEN, BEGIN THE GAME
        
        if (start == false) && (isGameStopped == false) {
            start = true
            startTheGame()
            
        }
        else {
        
        }
        
        if (birdIsActive)
        {
            
            audioPlayer.play()
            self.bird.physicsBody!.applyImpulse(CGVectorMake(0, 67), atPoint: CGPointZero)      //applyImpulse(CGVectorMake(0, 2), atPoint: CGPoint(x: self.frame.width/2, y: 0))
            //self.bird.physicsBody!.applyForce(CGVectorMake(0, 12))
        }
        else
        {
            createBirdPhysics()
        }
    }
    func server(theServer: AsyncServer!, didDisconnect connection: AsyncConnection!) {
        // print("disconnected server")
    }
    
    func server(theServer: AsyncServer!, didFailWithError error: NSError!) {
        //  print("didfail")
    }
   
    // MARK: Remove crasg Image
    
    func removeCrashImage() -> Void {
        
        isCollided = false
        
        self.crashImage.hidden = true
//        if crashCounter == 2 {
//            // show game over
//            dispatch_async(dispatch_get_main_queue(), {
//                self.stopTheGame()
//            })
////            NSNotificationCenter.defaultCenter().postNotificationName("showGameOverPopUp", object: nil, userInfo: ["score" :"\(scoreCounter)"])
//        }
//        else {
//            crashCounter = crashCounter + 1
//        }
    }
    
    
    // MARK: Start the game
    
    func startTheGame() -> Void {
        
        if self.gameTimer == nil {
            self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.runGameTimer), userInfo: nil, repeats: true)
            self.gameTimer!.fire()
        }
        
    }
    
    
    // MARK: Run App Timer
    
    
    func runGameTimer() -> Void {
       // self.timeCounter = self.timeCounter - 1
        self.timeCounter -= 1
     //   print("TIMER \(self.timeCounter)")
        if self.timeCounter == 0 {
            //show finished screen
            
//            self.start = false
//             self.gameTimer.invalidate()
        //    NSNotificationCenter.defaultCenter().postNotificationName("showGameOverPopUp", object: nil, userInfo: ["score" :"\(self.scoreCounter)"])
            dispatch_async(dispatch_get_main_queue(), { 
               self.stopTheGame()
            })
            
        }
        else {
           self.timeCounterLabel.text = "\(timeCounter)"
        }
    }
    
    
    func stopTheGame() -> Void {
        self.isGameStopped = true
        self.start = false
        self.paused = true
        self.crashCounter = 0
      //  print("sss\(self.scoreCounter)")
        if gameTimer != nil {
            gameTimer!.invalidate()
            gameTimer = nil
        }
        
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("showGameOverPopUp", object: nil, userInfo: ["score" :"\(scoreCounter)"])
    }
    
    
    // MARK: Play sound  
    
   
    
    // Initial setup

    
    // Trigger the sound effect when the player grabs the coin
//    func didBeginContact(contact: SKPhysicsContact!) {
//        
//    }
}
