//
//  CommonAdsViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import Firebase

class CommonAdsViewController: UIViewController, GADBannerViewDelegate {

    var gadBannerView: GADBannerView!
    var gadLoaded: Bool = false
    
    func makeGadBannerView(withTab: Bool) {
        if(ConfigManager.isShowAds() == false){
            return
        }
        
        gadBannerView = GADBannerView(adSize:kGADAdSizeBanner)
        
        let y = self.view.frame.size.height - gadBannerView.frame.size.height - (withTab ? 50 : 0)
        
        gadBannerView.frame = CGRect(origin: CGPoint(x: 0, y: y), size: gadBannerView.frame.size)
        
        // gadBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  // テスト用
        gadBannerView.adUnitID = "ca-app-pub-6719193336347757/3847848543"
        gadBannerView.delegate = self
        gadBannerView.rootViewController = self
        
        let gadRequest: GADRequest = GADRequest()
        // gadRequest.testDevices = @[ @"2dc8fc8942df647fb90b48c2272a59e6" ];
        gadBannerView.load(gadRequest)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView){
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        print("didFailToReceiveAdWithError : \(error)")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView){
    }
    func adViewWillDismissScreen(_ bannerView: GADBannerView){
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView){
    }
    func adViewWillLeaveApplication(_ bannerView: GADBannerView){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
