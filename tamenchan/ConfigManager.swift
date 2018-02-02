//
//  ConfigManager.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class ConfigManager: NSObject {

    static func isShowAds() -> Bool {
        if AppDelegate.SHOW_ADS == false {
            return false
        }
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "SHOWADS") == nil) {
            setShowAds(true)
        }
        return userDefaults.bool(forKey: "SHOWADS")
    }
    
    static func setShowAds(_ showAds: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(showAds, forKey: "SHOWADS")
    }
    
    static func getDifficulty() -> Int {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "DIFFICULTY") == nil) {
            setDifficulty(TamenchanDefine.DIFFICULTY_EASY)
        }
        return userDefaults.integer(forKey: "DIFFICULTY")
    }
    
    static func setDifficulty(_ difficulty: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(difficulty, forKey: "DIFFICULTY")
    }

    static func getHaiType() -> Int {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "HAITYPE") == nil) {
            setHaiType(TamenchanDefine.HAITYPE_MANZU)
        }
        return userDefaults.integer(forKey: "HAITYPE")
    }
    
    static func setHaiType(_ haiType: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(haiType, forKey: "HAITYPE")
    }
}
