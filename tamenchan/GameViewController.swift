//
//  GameViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var tehaiImage: [UIImageView]!
    @IBOutlet var choiceBtn: [UIButton]!
    
    @IBOutlet var judgeBtn: UIButton!
    
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var timerView: TimerView!
    
    var mode = TamenchanDefine.MODE_TIMEATTACK
    var difficulty = TamenchanDefine.DIFFICULTY_NORMAL
    var haiType = TamenchanDefine.HAITYPE_MANZU
    
    var question = 0
    var correctCount = 0
    var score = 0
    var answering = false
    var remainTime = 0;
    var timer: Timer!

    var tehai = Tehai()
    var choice = [Bool](repeating: false, count: 9)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficulty = ConfigManager.getDifficulty()
        haiType = ConfigManager.getHaiType()
        
        initGame()
        
        Utility.decorateBtn(judgeBtn)
    }

    func initGame(){
        // テストコード
        // remainTime = 10000
        remainTime = 60000
        question = 0
        correctCount = 0
        score = 0
        answering = false
        
        setModeLabel()
    }
    
    func startQuestion(){
        answering = false
        question = question + 1
        if mode == TamenchanDefine.MODE_ENDLESS {
            remainTime = 60000
        }
        
        tehai = Tehai()
        
        // 配牌を行う（待ちが０なら５％を除いてやり直し）
        while(true) {
            if difficulty == TamenchanDefine.DIFFICULTY_EASY {
                // 初級なら字牌を３枚入れて配牌
                tehai.haipai([3])
            } else {
                tehai.haipai()
            }
            
            let machiCount = tehai.getMachiCount()
            if machiCount > 0 || (Int)(arc4random_uniform(100)) < 5 {
                break
            }
        }
        
        // デバッグ用テストコード
        let correctAnswer = TenpaiChecker().checkMachihai(tehai)
        var machiStr = ""
        for i in 1 ... 9 {
            if correctAnswer[i] == true {
                machiStr += String(i)+" "
            }
        }
        print("---")
        tehai.printTehai()
        print("待ち牌 : "+machiStr)
        print("---")
        
        
        questionLabel.text = String(question)
        scoreLabel.text = String(score)
        
        initTehaiImage()
        initChoiceButton()
        
        timerView.updateTimerView(remainTime)
        
        // 1.5秒は牌を裏面で表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.startAnswering()
            self.answering = true
        }
    }
    
    func initTehaiImage(){
        for image in tehaiImage {
            image.image = UIImage(named: "bk.gif")
        }
    }
    
    func initChoiceButton(){
        choice = [Bool](repeating: false, count: 9)
        
        for i in 1...9 {
            choiceBtn[i-1].setImage(UIImage(named: Tehai.haiImagePath[ConfigManager.getHaiType()][i]), for: .normal)
        }
        
        showChoiceButton()
    }
    
    func startAnswering(){
        // 手牌をオープン
        // 牌の一覧を取得（初級・中級の場合、字牌が最後に来る。上級の場合は理牌なし。）
        let haiArray = (difficulty == TamenchanDefine.DIFFICULTY_HARD ?
            tehai.getHaiArrayWithNoRihai() : tehai.getHaiArray())
        let jihaiImagePath = Tehai.getJihaiImagePathAtRandom()
        
        // 各牌に画像をセット
        for i in 0 ..< haiArray.count {
            if haiArray[i] == 0 {
                tehaiImage[i].image = UIImage(named: jihaiImagePath)
            } else {
                tehaiImage[i].image = UIImage(named: Tehai.haiImagePath[haiType][haiArray[i]])
            }
        }
        
        // タイマーを開始
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self,
            selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func timerUpdate(timer : Timer){
        remainTime -= 200
        if mode == TamenchanDefine.MODE_ENDLESS {
            remainTime -= 400
        }
        
        timerView.updateTimerView(remainTime)
        
        if remainTime < 0 {
            timeOver()
        }
    }
    
    func showChoiceButton(){
        for i in 0 ..< choice.count {
            showChoiceButton(i)
        }
    }
    
    func showChoiceButton(_ target : Int){
        if choice[target] == true {
            choiceBtn[target].alpha = CGFloat(1.0)
        } else {
            choiceBtn[target].alpha = CGFloat(0.4)
        }
    }
    
    @IBAction func choiceButton(_ sender: UIButton) {
        if answering == false {
            return
        }
        
        let target = sender.tag - 1
        choice[target] = !choice[target]
        showChoiceButton(target)
    }
    
    
    @IBAction func judgeButton(_ sender: Any) {
        if answering == false {
            return
        }
        
        answering = false
        timer.invalidate()
        
        // 正しい回答を取得して、合っているかを判定
        let correctAnswer = TenpaiChecker().checkMachihai(tehai)
        var correct = true
        for i in 1...9 {
            if correctAnswer[i] != choice[i-1] {
                correct = false
            }
        }
        
        // 得点計算と表示メッセージを作成
        var titleStr = ""
        var messageStr = ""
        if correct == true {
            correctCount += 1
            
            let getScore = 10
            let bonus = TamenchanDefine.TAMENCHAN_BONUS[tehai.getMachiCount()]
            var timebonus = 0
            if mode == TamenchanDefine.MODE_ENDLESS && remainTime >= 28000 {
                timebonus = Int((remainTime - 28000) / 4000 + 3)
            }
            
            score += getScore + bonus + timebonus
            
            titleStr = NSLocalizedString("correct", comment: "")
            messageStr = String(format: NSLocalizedString("correctbody", comment: ""), getScore)
            // messageStr = "正解です！ "+String(getScore)+"点獲得"
            if timebonus != 0 {
                messageStr += "\n"
                messageStr += String(format: NSLocalizedString("timebonus", comment: ""), timebonus)
            }
            if bonus != 0 {
                messageStr += "\n"
                messageStr += String(format: NSLocalizedString("tamenchanbonus", comment: ""), bonus)
            }
        } else {
            titleStr = NSLocalizedString("incorrect", comment: "")
            
            messageStr = String(format: NSLocalizedString("incorrectbody", comment: ""), makeMachiStr(correctAnswer))
            messageStr += "\n"
            messageStr += String(format: NSLocalizedString("youranswer", comment: ""), makeChoiceStr())
            
            if mode == TamenchanDefine.MODE_TIMEATTACK {
                remainTime -= 5000
                timerView.updateTimerView(remainTime)
            }
            // messageStr = "正しくは「"+makeMachiStr(correctAnswer)+"」です\nあなたの回答「"+makeChoiceStr()+"」"
        }
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        let nextBtn = UIAlertAction(title: NSLocalizedString("nextquestion", comment: ""), style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            self.startQuestion()
        })
        let resultBtn = UIAlertAction(title: NSLocalizedString("showresult", comment: ""), style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            self.showResult()
        })
        
        if (mode == TamenchanDefine.MODE_ENDLESS && correct == false) || remainTime < 0 {
            alert.addAction(resultBtn)
        } else {
            alert.addAction(nextBtn)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func timeOver() {
        timer.invalidate()
        answering = false
        
        // 正しい回答を取得
        let correctAnswer = TenpaiChecker().checkMachihai(tehai)
        let titleStr = NSLocalizedString("timeover", comment: "")
        let messageStr = String(format: NSLocalizedString("timeoverbody", comment: ""), makeMachiStr(correctAnswer))
        // let messageStr = "正解は「"+makeMachiStr(correctAnswer)+"」です"
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        let nextBtn = UIAlertAction(title: NSLocalizedString("showresult", comment: ""), style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            self.showResult()
        })
        alert.addAction(nextBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showResult() {
        performSegue(withIdentifier: "showresult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showresult" {
            let showHiScoreViewController = segue.destination as! ShowHiScoreViewController
            showHiScoreViewController.mode = mode
            showHiScoreViewController.difficulty = difficulty
            showHiScoreViewController.question = question
            showHiScoreViewController.correctCount = correctCount
            showHiScoreViewController.score = score
        }
    }
    
    func makeChoiceStr() -> String {
        var retString = ""
        
        for i in 0..<choice.count {
            if choice[i] == true {
                retString += ","
                retString += String(i+1)
            }
        }
        
        if retString == "" {
            return NSLocalizedString("nowaiting", comment: "")
        } else {
            retString += NSLocalizedString("waiting", comment: "")
            return String(retString[retString.index(after: retString.startIndex)..<retString.endIndex])
        }
    }
    
    func makeMachiStr(_ machi : Array<Bool>) -> String {
        var retString = ""
        
        for i in 0..<machi.count {
            if machi[i] == true {
                retString += ","
                retString += String(i)
            }
        }
        
        if retString == "" {
            return NSLocalizedString("nowaiting", comment: "")
        } else {
            retString += NSLocalizedString("waiting", comment: "")
            return String(retString[retString.index(after: retString.startIndex)..<retString.endIndex])
        }
    }
    
    func setModeLabel(){
        modeLabel.text = TamenchanDefine.getModeString(mode)+"("+TamenchanDefine.getDifficultyString(difficulty)+")"
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startQuestion()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil && timer.isValid  {
            timer.invalidate()
        }
    }
    
}
