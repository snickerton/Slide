//
//  GameScene.swift
//  Slide
//
//  Created by   on 5/16/15.
//  Copyright (c) 2015 True Colors. All rights reserved.
//

import Darwin

import SpriteKit;

import CoreMotion;

import UIKit;

import Foundation;

class GameScene: SKScene {

    var upNode, downNode, leftNode, rightNode, timerNode: SKSpriteNode;

    var sqockSize: CGSize;

    var sent: [SKSpriteNode];

    var curr: [SKSpriteNode];

    //var timer: NSTimer;

    var lScore, lLives, lCombo: SKLabelNode;

    var inARow, scorePts, score, combo, lives: Int;

    var scoreFS, comboFS: CGFloat;

    var vOffset: CGFloat;

    var sqockDist: CGFloat;

    var center: CGPoint;

    var scrn: CGRect;

    var spdLvl: Double;

    override init(size: CGSize) {

        self.curr = [SKSpriteNode]();
        self.sent = [SKSpriteNode]();

        self.sqockSize = CGSize(width: 50, height: 50);

        //self.timer = NSTimer();

        self.score = 0;

        self.inARow = 0;

        self.combo = 0;

        self.comboFS = 0;

        self.scoreFS = 15;

        self.vOffset = 70;

        self.lives = 3;

        self.sqockDist = 150;

        self.lLives = SKLabelNode(fontNamed:"Chalkduster");
        self.lScore = SKLabelNode(fontNamed:"Chalkduster");
        self.lCombo = SKLabelNode(fontNamed:"Chalkduster");

        self.scorePts = 1;

        self.upNode = SKSpriteNode(color: UIColor.blueColor(), size: sqockSize);
        self.downNode = SKSpriteNode(color: UIColor.blueColor(), size: sqockSize);
        self.leftNode = SKSpriteNode(color: UIColor.blueColor(), size: sqockSize);
        self.rightNode = SKSpriteNode(color: UIColor.blueColor(), size: sqockSize);

        self.scrn = UIScreen.mainScreen().bounds;

        self.spdLvl = 0.25;

        self.center = CGPointMake(scrn.width/2, scrn.height/2-vOffset);

        //self.view.backgroundColor = UIColorFromRGB(0xAAAAAA);
        self.timerNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(scrn.width, scrn.height));


        super.init(size: size);
    }


    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
        )
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        lScore.text = "Score: /(score)";
        lScore.fontSize = scoreFS;
        lScore.position = CGPoint(x:scrn.width/2, y:scrn.height*(5/7));

        lLives.text = "Lives: /(lives)";
        lLives.fontSize = 30;
        lLives.position = CGPoint(x:scrn.width-72, y:scrn.height-27);

        lCombo.text = "Combo: x/(combo)";
        lCombo.fontSize = 20;
        lCombo.position = CGPoint(x:scrn.width-72, y:scrn.height*(3/5));

        //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: NSSelectorFromString("lifelosttoTime"), userInfo: nil, repeats: true);
        upNode.color = UIColorFromRGB(0x775BA3).colorWithAlphaComponent(0.85);
        downNode.color = UIColorFromRGB(0x91C5A9).colorWithAlphaComponent(0.85);
        leftNode.color = UIColorFromRGB(0xF8E1B4).colorWithAlphaComponent(0.85);
        rightNode.color = UIColorFromRGB(0xF98A5F).colorWithAlphaComponent(0.85);


        //SHOULD BE SAME COLOR AS BACKGROUND
        timerNode.color = UIColorFromRGB(0x333333);

        upNode.position = CGPointMake(center.x, center.y+sqockDist);
        downNode.position = CGPointMake(center.x, center.y-sqockDist);
        leftNode.position = CGPointMake(center.x-sqockDist, center.y);
        rightNode.position = CGPointMake(center.x+sqockDist, center.y);

        timerNode.position = CGPointMake(scrn.width/2, scrn.height/2);

        self.addChild(timerNode);
        self.addChild(upNode);
        self.addChild(downNode);
        self.addChild(leftNode);
        self.addChild(rightNode);

        self.addChild(lLives);
        self.addChild(lScore);
        self.addChild(lCombo);

        //self.addChild(myLabel);

        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeUp)

        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)

        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)

        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)


    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */

    }

    func checkAndDo(endNode: SKSpriteNode) {

        if(self.curr[0].color == endNode.color){
            println("up node matched");
            self.score += self.scorePts; //self.scorePts;
            self.inARow++;


            //account for lag and calculations
            let delay = SKAction.waitForDuration(spdLvl-spdLvl/10);

            let quickPop = SKAction.sequence([delay,
                                              SKAction.scaleBy(1.2, duration: 0.04),
                                              SKAction.scaleBy(1/1.2, duration: 0.10)]);

            endNode.runAction(quickPop);

            if(inARow>5){
                self.combo++;


                let expand = SKAction.scaleBy(1.4, duration: 0.07);
                let contract = SKAction.scaleBy(1/1.4, duration: 0.20);
                let pop = SKAction.sequence([delay, expand, contract]);

                lCombo.runAction(pop);



                /*SKScene.animateWithDuration(0.1, delay: 0,
                                   options: nil, animations: {
                            CGFloat(self.comboFS) += CGFloat(10);
                        }, completion: {
                            SKScene.animateWithDuration(0.5, delay: 0,
                                    options: .CurveEaseOut, animations: {
                                self.comboFS -= CGFloat(10);
                            }, completion: nil);
                        });*/

            }

        }
        else {//remove and delete the last sqock in sent array
            self.lives--;
            self.inARow = 0;
            self.combo = 0;

        }

    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {


        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {

            case UISwipeGestureRecognizerDirection.Up:


                //3/4ths is to adjust for weird positioning
                let swipeUp = SKAction.moveTo(upNode.position, duration: spdLvl);

                curr[0].runAction(swipeUp,

                        //once the action is done, check for collision to goals
                        completion: {
                            self.sent[0].removeFromParent();
                            self.sent.removeAtIndex(0);
                        }

                );

                checkAndDo(self.upNode);



            case UISwipeGestureRecognizerDirection.Down:

                let swipeDown = SKAction.moveTo(downNode.position, duration: spdLvl);
                curr[0].runAction(swipeDown,

                        //once the action is done, check for collision to goals
                        completion: {
                            self.sent[0].removeFromParent();
                            self.sent.removeAtIndex(0);
                        }

                );


                checkAndDo(self.downNode);


            case UISwipeGestureRecognizerDirection.Right:

                let swipeRight = SKAction.moveTo(rightNode.position, duration: spdLvl);
                curr[0].runAction(swipeRight,

                        //once the action is done, check for collision to goals
                        completion: {
                            self.sent[0].removeFromParent();
                            self.sent.removeAtIndex(0);
                        }

                );

                checkAndDo(self.rightNode);

            case UISwipeGestureRecognizerDirection.Left:

                let swipeLeft = SKAction.moveTo(leftNode.position, duration: spdLvl);
                curr[0].runAction(swipeLeft,

                        //once the action is done, check for collision to goals
                        completion: {
                            self.sent[0].removeFromParent();
                            self.sent.removeAtIndex(0);
                        }

                );

                checkAndDo(self.leftNode);


            default:
                break
            }

            sent.append(curr[0]);

            curr.removeAtIndex(0);

            println(score);

        }
    }






    //only detect collision here
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //self.moveObstacle()

        //
        //UPDATE
        //

        if (scoreFS < 35) {
            scoreFS = 20+sqrt(CGFloat(score));
        }

        lCombo.fontSize = comboFS;
        lScore.fontSize = scoreFS;

        scorePts = 1+combo;


        if(lives == 0){
            //change to game over screen
        }

        //println(curr);

        lScore.text = "Score: \(score)";
        lLives.text = "Lives: ";

        for (var i = 0; i<lives; i++) {
            lLives.text = lLives.text+"X";
        }

        lCombo.text = "X\(combo)";

        //
        //UPDATE
        //

        if curr.isEmpty {

            var r = Int(arc4random_uniform(4));

            var sqock = SKSpriteNode(color: UIColor.redColor(), size: sqockSize);

            sqock.position = center;

            if(r == 0){
                sqock.color = UIColorFromRGB(0x775BA3).colorWithAlphaComponent(0.85);
                curr.append(sqock);
                self.addChild(curr[0]);
            }

            if(r == 1){
                sqock.color = UIColorFromRGB(0x91C5A9).colorWithAlphaComponent(0.85);
                curr.append(sqock);
                self.addChild(curr[0]);
            }

            if(r == 2){
                sqock.color = UIColorFromRGB(0xF8E1B4).colorWithAlphaComponent(0.85);
                curr.append(sqock);
                self.addChild(curr[0]);
            }

            if(r == 3){
                sqock.color = UIColorFromRGB(0xF98A5F).colorWithAlphaComponent(0.85);
                curr.append(sqock);
                self.addChild(curr[0]);
            }
        }

    }
}
