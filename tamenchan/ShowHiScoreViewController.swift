//
//  ShowHiScoreViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/15.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import Firebase
import GameKit

class ShowHiScoreViewController: CommonAdsViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet var toMenuBtn: UIButton!
    @IBOutlet var againBtn: UIButton!
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    
    @IBOutlet var rankLabel: [UILabel]!
    @IBOutlet var scoreLabel: [UILabel]!
    @IBOutlet var questionLabel: [UILabel]!
    @IBOutlet var dateLabel: [UILabel]!
    
    var mode = 0
    var difficulty = 0
    var question = 0
    var correctCount = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.decorateBtn(toMenuBtn)
        Utility.decorateBtn(againBtn)
        
        // resultLabel.text = "結果は \(correctCount)問正解 \(score)点 でした"
        resultLabel.text = String(format: NSLocalizedString("resultbody", comment: ""),
            correctCount, score)
        
        // ハイスコア画面に難易度を表示
        modeLabel.text = TamenchanDefine.getModeString(mode)+"("+TamenchanDefine.getDifficultyString(difficulty)+")"
        
        // ハイスコア登録
        var hiScoreList = HiScore.loadHiScoreList(mode, difficulty)
        let dummyRank = 999
        var rank = dummyRank
        for (index, hiScore) in hiScoreList.enumerated() {
            if hiScore.score < score {
                rank = index
                break
            }
            if hiScore.score == score && hiScore.count <= correctCount {
                rank = index
                break
            }
        }
        
        print("rank : \(rank)")
        var hiScoreEdited = false
        if rank != dummyRank {
            let newHiScore = HiScore()
            newHiScore.score = score
            newHiScore.count = correctCount
            newHiScore.date = Date()
            newHiScore.mode = mode

            hiScoreList.insert(newHiScore, at: rank)
            hiScoreList.removeLast()
            hiScoreEdited = true
        }
        
        // 1位の記録がLeaderBoardに未登録なら送信
        if hiScoreList[0].registedDate == Date(timeIntervalSince1970: 0) {
            print("LeaderBoard送信：\(hiScoreList[0].score)")
            let leaderBoardId = HiScore.getLeaderBoardId(mode, difficulty)
            GameKitUtility.reportScore(value: hiScoreList[0].score, leaderboardid: leaderBoardId)
            hiScoreList[0].registedDate = Date()
            hiScoreEdited = true
        }
        
        // ハイスコアが更新されていたら保存
        if hiScoreEdited == true {
            HiScore.saveHiScoreList(mode, difficulty, hiScoreList)
        }
        
        // ハイスコア表示
        let hiScoreListForShow = HiScore.loadHiScoreList(mode, difficulty)
        for (index, hiScore) in hiScoreListForShow.enumerated() {
            scoreLabel[index].text = String(hiScore.score)+NSLocalizedString("pts", comment: "")
            questionLabel[index].text = String(hiScore.count)+NSLocalizedString("answer", comment: "")
            dateLabel[index].text = hiScore.getHiScoreDateString()
        }
        
        // ハイスコア登録があった場合は色付け
        if rank != dummyRank {
            rankLabel[rank].textColor = UIColor.red
            scoreLabel[rank].textColor = UIColor.red
            questionLabel[rank].textColor = UIColor.red
            dateLabel[rank].textColor = UIColor.red
        }
        
        // インタースティシャル広告を表示
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.showInterstitialFlag = true
        
        makeGadBannerView(withTab: false)
    }
    
    override func adViewDidReceiveAd(_ bannerView: GADBannerView){
        if gadLoaded == false && ConfigManager.isShowAds() == true {
            // scrollView.frame = CGRect(origin: scrollView.frame.origin,
            //                          size: CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height-gadBannerView.frame.size.height))
            self.view.addSubview(gadBannerView)
            gadLoaded = true
        }
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

    @IBAction func showLeaderBoardButton(_ sender: Any) {
        let leaderboardId = HiScore.getLeaderBoardId(mode, difficulty)
        GameKitUtility.showLeaderBoard(target: self, leaderboardid: leaderboardId)
    }
    
    @IBAction func toMenuButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tryAgainButton(_ sender: Any) {
        let gameViewController = self.presentingViewController as? GameViewController
        gameViewController?.initGame()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 0.7秒後にインタースティシャル広告を表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.showInterstitialFlag {
                delegate.showInterstitial(self)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
