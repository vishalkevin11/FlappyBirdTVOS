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
    
    @IBOutlet weak var labelHello: UILabel!
    
   
//    let server = AsyncServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        server.serviceType = "_ClientServer._tcp"
//        server.serviceName = "tvOS"
//        
//        server.delegate = self
//        server.start()
        
        // from existing game
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
            
            skView.presentScene(scene, transition: SKTransition.fadeWithColor(UIColor.redColor(), duration: 0.3))
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
            
            skView.presentScene(scene, transition: SKTransition.fadeWithColor(UIColor.redColor(), duration: 0.3))
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
