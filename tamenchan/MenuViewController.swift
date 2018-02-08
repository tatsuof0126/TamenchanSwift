//
//  MenuViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var appnameLabel: UILabel!
    @IBOutlet var timeAttackBtn: UIButton!
    @IBOutlet var endlessModeBtn: UIButton!
    @IBOutlet var difficultyLabel: UILabel!
    @IBOutlet var hiScoreBtn: UIButton!
    @IBOutlet var gameConfigBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ハイスコアデータがなければ作る
        let hiScoreList = HiScore.loadHiScoreList(TamenchanDefine.MODE_TIMEATTACK, TamenchanDefine.DIFFICULTY_EASY)
        if hiScoreList.count < 5 {
            HiScore.initHiScore()
        }
        
        // GameCenterにログイン
        // if let presentView = self.rootViewController {
        //    let targetViewController = presentView
            GameKitUtility.login(target: self)
        // }
                
        Utility.decorateBtn(timeAttackBtn)
        Utility.decorateBtn(endlessModeBtn)

        Utility.decorateBtn(hiScoreBtn)
        Utility.decorateBtn(gameConfigBtn)
        hiScoreBtn.layer.borderColor = UIColor.darkGray.cgColor
        gameConfigBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        setDifficultyLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func timeAttackButton(_ sender: Any) {
        performSegue(withIdentifier: "gamestart", sender: sender)
    }
    
    
    @IBAction func endlessModeButton(_ sender: Any) {
        performSegue(withIdentifier: "gamestart", sender: sender)
    }
    
    @IBAction func changeDifficultyButton(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("choicedifficulty", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let easyBtn = UIAlertAction(title: TamenchanDefine.DIFFICULTY_STRING_EASY, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setDifficulty(TamenchanDefine.DIFFICULTY_EASY)
            self.setDifficultyLabel()
        })
        let normalBtn = UIAlertAction(title: TamenchanDefine.DIFFICULTY_STRING_NORMAL, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setDifficulty(TamenchanDefine.DIFFICULTY_NORMAL)
            self.setDifficultyLabel()
        })
        let hardBtn = UIAlertAction(title: TamenchanDefine.DIFFICULTY_STRING_HARD, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setDifficulty(TamenchanDefine.DIFFICULTY_HARD)
            self.setDifficultyLabel()
        })
        let cancelBtn = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(easyBtn)
        alert.addAction(normalBtn)
        alert.addAction(hardBtn)
        alert.addAction(cancelBtn)

        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderBtn = sender {
            if senderBtn as? UIButton == timeAttackBtn {
                let gameViewController = segue.destination as? GameViewController
                gameViewController?.mode = TamenchanDefine.MODE_TIMEATTACK
            } else if senderBtn as? UIButton == endlessModeBtn {
                let gameViewController = segue.destination as? GameViewController
                gameViewController?.mode = TamenchanDefine.MODE_ENDLESS
            }
        }
    }
    
    func setDifficultyLabel(){
        difficultyLabel.text = TamenchanDefine.getDifficultyString(ConfigManager.getDifficulty())
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
