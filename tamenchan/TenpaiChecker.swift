//
//  TenpaiChecker.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class TenpaiChecker: NSObject {
    
    // 刻子に数に応じた場合分け
    private static let kotsuRemoveArrayArray = [
                            [[]],
                            [[],[0]],
                            [[],[0],[1],[0,1]],
                            [[],[0],[1],[2],[0,1],[0,2],[1,2],[0,1,2]],
                            [[],[0],[1],[2],[3],[0,1],[0,2],[0,3],[1,2],[1,3],[2,3],
                             [0,1,2],[0,1,3],[0,2,3],[1,2,3],[0,1,2,3]]]
    
    func checkMachihai(_ tehai : Tehai) -> Array<Bool> {
        var machi = [Bool](repeating: false, count: 10)
        
        for i in 1 ... 9 {
            // print("["+String(i)+"]が待ち牌かをチェック")
            if tehai.hai[i] < 4 {
                let targetTehai = tehai.copyTehai()
                targetTehai.hai[i] = targetTehai.hai[i] + 1
                machi[i] = checkAgari(targetTehai)
            }
            // print("["+String(i)+"]が待ち牌か -> "+String(machi[i]))
            
        }

        return machi
    }
    
    func checkAgari(_ tehai : Tehai) -> Bool {
        // 始めに七対子かどうかをチェック
        if checkChitoitsu(tehai) == true {
            return true
        }
        
        // 刻子の数をチェック
        var kotsuHai : Array<Int> = []
        for i in 0 ... 9 {
            if tehai.hai[i] >= 3 {
                kotsuHai.append(i)
            }
        }
        
        // print("刻子のリスト："+kotsuHai.description)
        // 刻子を刻子として見たとき見ないときに分けてチェック
        let kotsuRemoveArray = TenpaiChecker.kotsuRemoveArrayArray[kotsuHai.count]
        for kotsuRemove in kotsuRemoveArray {
            let targetTehai = tehai.copyTehai()
            for i in kotsuRemove {
                // print("刻子の["+String(kotsuHai[i])+"]を削除")
                targetTehai.hai[kotsuHai[i]] = targetTehai.hai[kotsuHai[i]] - 3
            }
            if checkToitsuShuntsu(targetTehai) == true {
                return true
            }
        }
        
        return false
    }

    private func checkToitsuShuntsu(_ tehai : Tehai) -> Bool {
        // 対子の数をチェック
        var toitsuHai : Array<Int> = []
        for i in 0 ... 9 {
            if tehai.hai[i] >= 2 {
                toitsuHai.append(i)
            }
        }
        
        // print("対子のリスト："+toitsuHai.description)
        
        for toitsu in toitsuHai {
            // print("["+String(toitsu)+"]を頭としたとき")
            let targetTehai = tehai.copyTehai()
            targetTehai.hai[toitsu] = targetTehai.hai[toitsu] - 2
            
            let checked = checkShuntsu(targetTehai)
            if checked == true {
                return true
            }
        }
        
        return false;
    }
    
    private func checkShuntsu(_ tehai : Tehai) -> Bool {
        // print("順子チェック")
        // tehai.printTehai()
        
        for i in 1 ... 7 {
            while(tehai.hai[i]>=1 && tehai.hai[i+1]>=1 && tehai.hai[i+2]>=1){
                tehai.hai[i] = tehai.hai[i] - 1
                tehai.hai[i+1] = tehai.hai[i+1] - 1
                tehai.hai[i+2] = tehai.hai[i+2] - 1
            }
        }
        
        // print("順子チェック後")
        // tehai.printTehai()
        
        return tehai.isEmpty()
    }
    
    private func checkChitoitsu(_ tehai : Tehai) -> Bool {
        // tehai.printTehai()
        
        var toitsunum = 0
        for i in 0 ... 9 {
            if tehai.hai[i] == 2 {
                // print("対子発見 -> "+String(i))
                toitsunum = toitsunum + 1
            }
        }
        
        // print("対子の数＝"+String(toitsunum))
        
        if toitsunum == 7 {
            return true
        }
        
        return false
    }
    
}
