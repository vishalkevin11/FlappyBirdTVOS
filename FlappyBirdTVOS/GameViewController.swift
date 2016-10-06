//
//  GameViewController.swift
//  PlatformGame
//
//  Created by Jamie Brennan on 2015-11-29.
//  Copyright (c) 2015 2D Game World. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

//class GameViewController: UIViewController , AsyncServerDelegate {

class GameViewController: UIViewController {
    
    @IBOutlet weak var menuViewBase: UIView!
    @IBOutlet weak var gameOverViewBase: UIView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    
    //    let server = AsyncServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuViewBase.alpha = 1.0
        self.gameOverViewBase.alpha = 0.0
        self.menuViewBase.hidden = false
        self.gameOverViewBase.hidden = true
        // from existing game
        
        
        self.performSelector(#selector(GameViewController.registerNotification), withObject: nil, afterDelay: 0.1)
        self.performSelector(#selector(GameViewController.showGameScene), withObject: nil, afterDelay: 0.3)
        
    }
    
    // MARK: Notification
    
    func registerNotification() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showGameOverScene(_:)), name: "showGameOverPopUp", object: nil)
    }
    
    func showGameOverScene(notification : NSNotification) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            
            let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
            let messageString = userInfo["score"]
            self.labelScore.text = "Score : \(messageString!)"
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
                
                self.menuViewBase.alpha = 0.0
                self.gameOverViewBase.alpha = 1.0
                
            }) { (done : Bool) in
                
                self.menuViewBase.hidden = true
                self.gameOverViewBase.hidden = false
                 //self.updateFocusIfNeeded()
                self.setNeedsFocusUpdate()
               // self.preferredFocusedView
                
            }
        }
        
        
        
    }
    
    
override var preferredFocusedView: UIView?    {
    // Add your logic here, it could be more complicated then what is below
    if ((self.gameOverViewBase.hidden == false) && (self.menuViewBase.hidden == true))
    {
    return self.btnPlayAgain;
    }
    else if ((self.gameOverViewBase.hidden == true) && (self.menuViewBase.hidden == false))
    {
    return self.btnPlay
    }
    return super.preferredFocusedView
    }

    
    func showGameScene() -> Void {
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.allowsTransparency  = false
            
            //SHOW THE PHSYICS BORDERS
            //skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            // let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1.0)
            //            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            //                            self.menuViewBase.alpha = 0.0
            //                        }) { (done : Bool) in
            //self.menuViewBase.hidden = true
            //skView.presentScene(scene, transition: transition)
            skView.presentScene(scene)
            //}
            
        }
    }
    /*
     
     // MARK: Phone to TV connection Delegates
     
     
     func server(theServer: AsyncServer!, didConnect connection: AsyncConnection!) {
     print("didconnect")
     print(connection)
     }
     
     func server(theServer: AsyncServer!, didReceiveCommand command: AsyncCommand, object: AnyObject!, connection: AsyncConnection!) {
     print("didreceivecommand")
     print(command)
     print(object)
     
     //        let dayTimePeriodFormatter = NSDateFormatter()
     //        dayTimePeriodFormatter.dateFormat = "ss"
     //
     //        let dateString = dayTimePeriodFormatter.stringFromDate(NSDate())
     
     
     // labelHello.text = object as? String
     labelHello.text = object as? String
     }
     
     func server(theServer: AsyncServer!, didDisconnect connection: AsyncConnection!) {
     print("disconnected server")
     }
     
     func server(theServer: AsyncServer!, didFailWithError error: NSError!) {
     print("didfail")
     }
     
     //    func server(theServer: AsyncServer!, didReceiveCommand command: AsyncCommand, object: AnyObject!, connection: AsyncConnection!, responseBlock block: AsyncNetworkResponseBlock!) {
     //        print("didreceivecommand - response block")
     //    }
     
     
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playTheGame(sender: AnyObject) {
        //  self.showGameScene()
        //  self.menuViewBase.alpha = 0.0
        self.showGameScene()
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
            
            self.menuViewBase.alpha = 0.0
            self.gameOverViewBase.alpha = 0.0
            
        }) { (done : Bool) in
            self.menuViewBase.hidden = true
            self.gameOverViewBase.hidden = true
            //self.showGameScene()
        }
    }
    
    
    @IBAction func goToMenu(sender: AnyObject) {
        //  self.showGameScene()
        //  self.menuViewBase.alpha = 0.0
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
            
            self.menuViewBase.alpha = 1.0
            self.gameOverViewBase.alpha = 0.0
            self.menuViewBase.hidden = false
            self.gameOverViewBase.hidden = true
            
        }) { (done : Bool) in
            self.menuViewBase.hidden = false
            self.gameOverViewBase.hidden = true
        }
    }
    
    
    
    
    
    //    override func shouldAutorotate() -> Bool {
    //        return true
    //    }
    //
    //    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    //        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
    //            return UIInterfaceOrientationMask.AllButUpsideDown
    //        } else {
    //            return UIInterfaceOrientationMask.All
    //        }
    //    }
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Release any cached data, images, etc that aren't in use.
    //    }
    //    
    //    override func prefersStatusBarHidden() -> Bool {
    //        return true
    //    }
}
