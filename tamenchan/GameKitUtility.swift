//
//  GameKitUtility.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/07.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import GameKit

class GameKitUtility: NSObject {
    
    static var localPlayer:GKLocalPlayer = GKLocalPlayer();
    
    static func login(target: UIViewController){
        self.localPlayer = GKLocalPlayer.localPlayer()
        self.localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                print("LoginCheck: Failed - LoginPageOpen")
                target.present(viewController!, animated: true, completion: nil)
            } else {
                print("LoginCheck: Success")
                if (error == nil){
                    print("LoginAuthentication: Success")
                } else {
                    print("LoginAuthentication: Failed")
                }
            }
        }
    }
    
    static func reportScore(value: Int, leaderboardid: String){
        let score = GKScore()
        score.value = Int64(value)
        score.leaderboardIdentifier = leaderboardid
        let scoreArr:[GKScore] = [score]
        GKScore.report(scoreArr, withCompletionHandler:{(error) -> Void in
            if((error != nil)){
                print("ReportScore NG")
            } else {
                print("ReportScore OK")
            }
        })
    }
    
    static func showLeaderBoard(target: UIViewController, leaderboardid: String){
        // LeaderBoard
        let localPlayer = GKLocalPlayer()
        localPlayer.loadDefaultLeaderboardIdentifier(completionHandler:{
            (leaderboardIdentifier, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let gameCenterController:GKGameCenterViewController = GKGameCenterViewController()
                gameCenterController.gameCenterDelegate = target as? GKGameCenterControllerDelegate
                gameCenterController.viewState = GKGameCenterViewControllerState.leaderboards
                gameCenterController.leaderboardIdentifier = leaderboardid
                target.present(gameCenterController, animated: true, completion: nil)
            }
        })
    }
    
}
