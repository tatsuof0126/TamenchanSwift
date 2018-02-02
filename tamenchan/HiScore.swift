//
//  HiScore.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/14.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class HiScore: NSObject {
    
    var mode: Int = 0
    var difficulty : Int = 0
    var score: Int = 0
    var count: Int = 0
    var date: Date = Date(timeIntervalSince1970: 0)
    var registedDate: Date = Date(timeIntervalSince1970: 0)
    
    static let ranktitle = [NSLocalizedString("rank1", comment: ""),
                            NSLocalizedString("rank2", comment: ""),
                            NSLocalizedString("rank3", comment: ""),
                            NSLocalizedString("rank4", comment: ""),
                            NSLocalizedString("rank5", comment: "")]
    
    static func loadHiScoreList(_ mode: Int, _ difficulty: Int) -> [HiScore] {
        let filename = "hiscorelist"+String(mode)+String(difficulty)+".dat"
        
        var hiScoreList: [HiScore] = []
        
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let targetFilePath = documentDirectoryFileURL.appendingPathComponent(filename)
            // print("読み込むファイルのパス: \(targetFilePath)")
            
            do {
                let loadString = try String(contentsOf: targetFilePath, encoding: String.Encoding.utf8)
                
                loadString.enumerateLines(invoking: {hiScoreStr, stop in
                    // print("HiScoreStr : \(hiScoreStr)")
                    
                    let hiScore = HiScore.makeHiScore(hiScoreStr)
                    // print("Read HiScore : \(hiScore.getHiScoreString())")
                    if hiScore.mode == mode {
                        // print("Add")
                        hiScoreList.append(hiScore)
                    } else {
                        print("No Add \(mode)-\(hiScore.mode)")
                    }
                })
            } catch let error as NSError {
                print("failed to read: \(error)")
            }
        }
        
        return hiScoreList
    }

    static func saveHiScoreList(_ mode: Int, _ difficulty: Int, _ hiScoreList: [HiScore]) {
        let filename = "hiscorelist"+String(mode)+String(difficulty)+".dat"
        
        // 保存対象の文字列を作成
        var saveString = ""
        for hiScore in hiScoreList {
            saveString.append(hiScore.getHiScoreString())
            saveString.append("\n")
        }
        
        // ファイル書き込み
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let targetFilePath = documentDirectoryFileURL.appendingPathComponent(filename)
            // print("書き込むファイルのパス: \(targetFilePath)")
            // print("ファイル内容 : \n\(saveString)")
            do {
                try saveString.write(to: targetFilePath, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
        }
    }

    static func makeHiScore(_ hiScoreString: String) -> HiScore {
        let hiScore = HiScore()
        
        let stringList = hiScoreString.components(separatedBy: ",")
        
        // print("StringList : \(stringList.count) / \(stringList.description)")
        
        if stringList.count == 6 {
            hiScore.mode = Int(stringList[0])!
            hiScore.difficulty = Int(stringList[1])!
            hiScore.score = Int(stringList[2])!
            hiScore.count = Int(stringList[3])!
            hiScore.date = Date(timeIntervalSince1970: Double(stringList[4])!)
            hiScore.registedDate = Date(timeIntervalSince1970: Double(stringList[5])!)
        }
        
        return hiScore
    }
    
    static func initHiScore() {
        let initHiScore11 = HiScore()
        initHiScore11.mode = TamenchanDefine.MODE_TIMEATTACK
        initHiScore11.difficulty = TamenchanDefine.DIFFICULTY_EASY
        initHiScore11.score = 10
        initHiScore11.count = 1
        initHiScore11.date = Date(timeIntervalSince1970: 946684800)
        initHiScore11.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList11 = [initHiScore11, initHiScore11, initHiScore11, initHiScore11, initHiScore11]
        
        let initHiScore12 = HiScore()
        initHiScore12.mode = TamenchanDefine.MODE_TIMEATTACK
        initHiScore12.difficulty = TamenchanDefine.DIFFICULTY_NORMAL
        initHiScore12.score = 10
        initHiScore12.count = 1
        initHiScore12.date = Date(timeIntervalSince1970: 946684800)
        initHiScore12.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList12 = [initHiScore12, initHiScore12, initHiScore12, initHiScore12, initHiScore12]
        
        let initHiScore13 = HiScore()
        initHiScore13.mode = TamenchanDefine.MODE_TIMEATTACK
        initHiScore13.difficulty = TamenchanDefine.DIFFICULTY_HARD
        initHiScore13.score = 10
        initHiScore13.count = 1
        initHiScore13.date = Date(timeIntervalSince1970: 946684800)
        initHiScore13.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList13 = [initHiScore13, initHiScore13, initHiScore13, initHiScore13, initHiScore13]

        let initHiScore21 = HiScore()
        initHiScore21.mode = TamenchanDefine.MODE_ENDLESS
        initHiScore21.difficulty = TamenchanDefine.DIFFICULTY_EASY
        initHiScore21.score = 10
        initHiScore21.count = 1
        initHiScore21.date = Date(timeIntervalSince1970: 946684800)
        initHiScore21.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList21 = [initHiScore21, initHiScore21, initHiScore21, initHiScore21, initHiScore21]
        
        let initHiScore22 = HiScore()
        initHiScore22.mode = TamenchanDefine.MODE_ENDLESS
        initHiScore22.difficulty = TamenchanDefine.DIFFICULTY_NORMAL
        initHiScore22.score = 10
        initHiScore22.count = 1
        initHiScore22.date = Date(timeIntervalSince1970: 946684800)
        initHiScore22.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList22 = [initHiScore22, initHiScore22, initHiScore22, initHiScore22, initHiScore22]
        
        let initHiScore23 = HiScore()
        initHiScore23.mode = TamenchanDefine.MODE_ENDLESS
        initHiScore23.difficulty = TamenchanDefine.DIFFICULTY_HARD
        initHiScore23.score = 10
        initHiScore23.count = 1
        initHiScore23.date = Date(timeIntervalSince1970: 946684800)
        initHiScore23.registedDate = Date(timeIntervalSince1970: 946684800)
        let initHiScoreList23 = [initHiScore23, initHiScore23, initHiScore23, initHiScore23, initHiScore23]
        
        HiScore.saveHiScoreList(TamenchanDefine.MODE_TIMEATTACK, TamenchanDefine.DIFFICULTY_EASY, initHiScoreList11)

        HiScore.saveHiScoreList(TamenchanDefine.MODE_TIMEATTACK, TamenchanDefine.DIFFICULTY_NORMAL, initHiScoreList12)

        HiScore.saveHiScoreList(TamenchanDefine.MODE_TIMEATTACK, TamenchanDefine.DIFFICULTY_HARD, initHiScoreList13)
        
        HiScore.saveHiScoreList(TamenchanDefine.MODE_ENDLESS, TamenchanDefine.DIFFICULTY_EASY, initHiScoreList21)
        
        HiScore.saveHiScoreList(TamenchanDefine.MODE_ENDLESS, TamenchanDefine.DIFFICULTY_NORMAL, initHiScoreList22)
        
        HiScore.saveHiScoreList(TamenchanDefine.MODE_ENDLESS, TamenchanDefine.DIFFICULTY_HARD, initHiScoreList23)
}
    
    func getHiScoreString() -> String {
        return "\(mode),\(difficulty),\(score),\(count),\(date.timeIntervalSince1970),\(registedDate.timeIntervalSince1970)"
    }
    
    func getHiScoreDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        // formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
    
    static func getLeaderBoardId(_ mode: Int, _ difficulty: Int) -> String {
        var leaderboardId = ""
        if mode == TamenchanDefine.MODE_TIMEATTACK {
            switch difficulty {
            case TamenchanDefine.DIFFICULTY_EASY:
                leaderboardId = "com.tatsuo.tamenchan.lb.timeattackeasy"
            case TamenchanDefine.DIFFICULTY_NORMAL:
                leaderboardId = "com.tatsuo.tamenchan.lb.timeattacknormal"
            case TamenchanDefine.DIFFICULTY_HARD:
                leaderboardId = "com.tatsuo.tamenchan.lb.timeattackhard"
            default:
                break
            }
        } else if mode == TamenchanDefine.MODE_ENDLESS {
            switch difficulty {
            case TamenchanDefine.DIFFICULTY_EASY:
                leaderboardId = "com.tatsuo.tamenchan.lb.endlesseasy"
            case TamenchanDefine.DIFFICULTY_NORMAL:
                leaderboardId = "com.tatsuo.tamenchan.lb.endlessnormal"
            case TamenchanDefine.DIFFICULTY_HARD:
                leaderboardId = "com.tatsuo.tamenchan.lb.endlesshard"
            default:
                break
            }
        }
        return leaderboardId;
    }
}
