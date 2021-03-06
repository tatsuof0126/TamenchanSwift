//
//  AppDelegate.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate {

    // 広告を非表示にするならfalse（リリース時はtrue）
    static let SHOW_ADS = true
    
    // テストデータ作成用（リリース時はfalse）
    static let MAKE_TEST_DATA = false
    
    // インタースティシャル広告の表示割合（％）
    static let SHOW_INTERSTITIAL_RATIO = 30
    
    var gadInterstitial: GADInterstitial!
    var showInterstitialFlag: Bool!
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebaseの初期化
        FirebaseApp.configure()
        
        // AdMobの初期化
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6719193336347757~6845852259")
        showInterstitialFlag = false
        prepareInterstitial()
        
        // GameCenterにログイン
        // if let presentView = window?.rootViewController {
        //    let targetViewController = presentView
        //    GameKitUtility.login(target: targetViewController)
        // }
        
        if AppDelegate.MAKE_TEST_DATA == true {
            // MakeTestData
            
            // ConfigManager.setShowAds(false)

        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // アプリID: ca-app-pub-6719193336347757~6845852259
    // 広告ユニットID（インタースティシャル）: ca-app-pub-6719193336347757/8091002427
    // 広告ユニットID（バナー）: ca-app-pub-6719193336347757/3847848543
    func prepareInterstitial() {
        // gadInterstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") // テスト用
        gadInterstitial = GADInterstitial(adUnitID: "ca-app-pub-6719193336347757/8091002427")
        gadInterstitial.delegate = self
        let gadRequest:GADRequest = GADRequest()
        // gadRequest.testDevices = [kGADSimulatorID]
        // gadRequest.testDevices = @[ @"2dc8fc8942df647fb90b48c2272a59e6" ]
        gadInterstitial.load(gadRequest)
    }
    
    func showInterstitial(_ controller: UIViewController) -> Bool {
        showInterstitialFlag = false
        
        if(ConfigManager.isShowAds() == false){
            return false
        }
        
        let rand = (Int)(arc4random_uniform(100))
        // print("rand : \(rand) show -> \(rand < AppDelegate.SHOW_INTERSTITIAL_RATIO)")
        if rand >= AppDelegate.SHOW_INTERSTITIAL_RATIO {
            return false
        }
        
        if gadInterstitial.isReady {
            gadInterstitial?.present(fromRootViewController: controller)
            return true
        } else {
            prepareInterstitial()
            return false
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // print("interstitialDidDismissScreen")
        prepareInterstitial()
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        // print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        // print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        // print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        // print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    //    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    //        print("interstitialDidDismissScreen")
    //    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        // print("interstitialWillLeaveApplication")
    }
    
    static func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}

