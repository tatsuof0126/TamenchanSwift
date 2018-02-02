//
//  TamenchanDefine.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/07.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import Foundation

class TamenchanDefine: NSObject {

    static let MODE_TIMEATTACK = 1
    static let MODE_ENDLESS = 2

    static let MODE_STRING_TIMEATTACK = NSLocalizedString("timeattack", comment: "")
    static let MODE_STRING_ENDLESS = NSLocalizedString("endlessmode", comment: "")
    static let MODE_STRING_LIST = ["", MODE_STRING_TIMEATTACK, MODE_STRING_ENDLESS]
    
    static let DIFFICULTY_EASY = 1
    static let DIFFICULTY_NORMAL = 2
    static let DIFFICULTY_HARD = 3

    static let DIFFICULTY_STRING_EASY = NSLocalizedString("easy", comment: "")
    static let DIFFICULTY_STRING_NORMAL = NSLocalizedString("normal", comment: "")
    static let DIFFICULTY_STRING_HARD = NSLocalizedString("hard", comment: "")
    static let DIFFICULTY_STRING_LIST = ["", DIFFICULTY_STRING_EASY,
                                         DIFFICULTY_STRING_NORMAL, DIFFICULTY_STRING_HARD]
    
    static let HAITYPE_MANZU = 0
    static let HAITYPE_PINZU = 1
    static let HAITYPE_SOUZU = 2
    
    static let HAITYPE_STRING_MANZU = NSLocalizedString("manzu", comment: "")
    static let HAITYPE_STRING_PINZU = NSLocalizedString("pinzu", comment: "")
    static let HAITYPE_STRING_SOUZU = NSLocalizedString("souzu", comment: "")
    
    static let TAMENCHAN_BONUS = [0,0,0,5,5,10,10,10,10,20]

    static func getModeString(_ mode: Int) -> String {
        if mode < MODE_STRING_LIST.count {
            return MODE_STRING_LIST[mode]
        } else {
            return ""
        }
    }
    
    static func getDifficultyString(_ difficulty: Int) -> String {
        if difficulty < DIFFICULTY_STRING_LIST.count {
            return DIFFICULTY_STRING_LIST[difficulty]
        } else {
            return ""
        }
    }
    
    
}
