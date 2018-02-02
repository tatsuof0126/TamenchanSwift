//
//  Tehai.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class Tehai: NSObject {
    
    var hai = [Int](repeating: 0, count: 10)
    var used = [Bool](repeating: false, count: 40)
    
    static let haiImagePath = [
        ["","m1.gif","m2.gif","m3.gif","m4.gif","m5.gif","m6.gif","m7.gif","m8.gif","m9.gif"],
        ["","p1.gif","p2.gif","p3.gif","p4.gif","p5.gif","p6.gif","p7.gif","p8.gif","p9.gif"],
        ["","s1.gif","s2.gif","s3.gif","s4.gif","s5.gif","s6.gif","s7.gif","s8.gif","s9.gif"]
    ]

    static let jihaiImagePath = ["j1.gif","j2.gif","j3.gif","j4.gif","j5.gif","j6.gif","j7.gif"]

    func haipai(){
        haipai([])
    }
    
    func haipai(_ motohai: [Int]){
        shipai()
        
        var motohaiCount = 0
        for i in 0..<motohai.count {
            hai[i] = motohai[i]
            for j in 0..<motohai[i] {
                used[i*4+j] = true
                motohaiCount += 1
                // print("\(i*4+j)をTRUE")
            }
        }
        
        var num = 0;
        for _ in motohaiCount ..< 13 {
            repeat {
                num = (Int)(arc4random_uniform(36))+4
            } while (used[num] == true)
            used[num] = true
            hai[(Int)(num/4)] += 1;
        }
        
    }
    
    func shipai(){
        hai = [Int](repeating: 0, count: 10)
        used = [Bool](repeating: false, count: 40)
    }
    
    func printTehai(){
        var tehaiStr = ""
        for i in 0 ..< hai.count {
            for _ in 0 ..< hai[i] {
                tehaiStr += String(i)
            }
        }
        print("手牌 : "+tehaiStr)
    }
    
    func copyTehai() -> Tehai {
        let retTehai = Tehai()
        retTehai.hai = hai
        retTehai.used = used
        return retTehai
    }
    
    func getHaiArray() -> [Int] {
        var retHaiArray:[Int] = []
        
        for i in 1 ..< hai.count {
            for _ in 0 ..< hai[i] {
                retHaiArray.append(i)
            }
        }
        for _ in 0 ..< hai[0] {
            retHaiArray.append(0)
        }
        
        return retHaiArray
    }
    
    func getHaiArrayWithNoRihai() -> [Int] {
        var retHaiArray:[Int] = []
        
        var tempHai:[Int] = []
        for i in 0 ..< hai.count {
            for _ in 0 ..< hai[i] {
                tempHai.append(i)
            }
        }
        
        while(tempHai.count > 0){
            let num = (Int)(arc4random_uniform(UInt32(tempHai.count)))
            retHaiArray.append(tempHai[num])
            tempHai.remove(at: num)
        }
        
        return retHaiArray
    }
    
    func getMachiCount() -> Int {
        let checker = TenpaiChecker()
        let machi = checker.checkMachihai(self)
        
        var num = 0
        for i in 0 ..< machi.count {
            if machi[i] == true {
                num = num + 1
            }
        }
        
        return num
    }
    
    func isEmpty() -> Bool {
        for haiCount in hai {
            if haiCount >= 1 {
                return false
            }
        }
        return true
    }
    
    func getTehaiArray() -> Array<Int> {
        return hai
    }
    
    func setTehaiArray(_tehai : Array<Int>) {
        hai = _tehai
    }

    static func getJihaiImagePathAtRandom() -> String {
        let num = (Int)(arc4random_uniform(UInt32(jihaiImagePath[0].count)))
        return jihaiImagePath[num]
    }
        
}
