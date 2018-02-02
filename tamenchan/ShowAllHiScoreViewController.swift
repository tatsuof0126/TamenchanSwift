//
//  ShowAllHiScoreViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/21.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import Firebase
import GameKit

class ShowAllHiScoreViewController: CommonAdsViewController, GKGameCenterControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var difficultySelect: UISegmentedControl!
    
    var showDifficulty = TamenchanDefine.DIFFICULTY_EASY
    
    var showingLabelList : [UILabel] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        showDifficulty = ConfigManager.getDifficulty()
        difficultySelect.selectedSegmentIndex = showDifficulty - 1
        
        showHiScore()
        
        // バナー項目を表示
        makeGadBannerView(withTab: false)
    }

    override func adViewDidReceiveAd(_ bannerView: GADBannerView){
        if gadLoaded == false && ConfigManager.isShowAds() == true {
            scrollView.frame = CGRect(origin: scrollView.frame.origin,
                                      size: CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height-gadBannerView.frame.size.height))
            self.view.addSubview(gadBannerView)
            gadLoaded = true
        }
    }
    
    func showHiScore() {
        // 順位ラベルを一旦全部削除
        for label in showingLabelList {
            label.removeFromSuperview()
        }
        showingLabelList = []
        
        let timeAttackHiScoreList = HiScore.loadHiScoreList(TamenchanDefine.MODE_TIMEATTACK, showDifficulty)
        let endlessHiScoreList = HiScore.loadHiScoreList(TamenchanDefine.MODE_ENDLESS, showDifficulty)
        
        for (index, hiScore) in timeAttackHiScoreList.enumerated() {
            let rankLabel = UILabel()
            rankLabel.frame = CGRect(x: 25, y: 100+index*30, width: 30, height: 30)
            rankLabel.text = HiScore.ranktitle[index]
            scrollView.addSubview(rankLabel)
            showingLabelList.append(rankLabel)
            
            let scoreLabel = UILabel()
            scoreLabel.frame = CGRect(x: 60, y: 100+index*30, width: 75, height: 30)
            scoreLabel.text = String(hiScore.score)+NSLocalizedString("pts", comment: "")
            scoreLabel.textAlignment = NSTextAlignment.center
            scoreLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(scoreLabel)
            showingLabelList.append(scoreLabel)

            let questionLabel = UILabel()
            questionLabel.frame = CGRect(x: 135, y: 100+index*30, width: 75, height: 30)
            questionLabel.text = String(hiScore.count)+NSLocalizedString("answer", comment: "")
            questionLabel.textAlignment = NSTextAlignment.center
            questionLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(questionLabel)
            showingLabelList.append(questionLabel)
            
            let dateLabel = UILabel()
            dateLabel.frame = CGRect(x: 210, y: 100+index*30, width: 110, height: 30)
            dateLabel.text = hiScore.getHiScoreDateString()
            dateLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(dateLabel)
            showingLabelList.append(dateLabel)
        }
        
        for (index, hiScore) in endlessHiScoreList.enumerated() {
            let rankLabel = UILabel()
            rankLabel.frame = CGRect(x: 25, y: 300+index*30, width: 30, height: 30)
            rankLabel.text = HiScore.ranktitle[index]
            scrollView.addSubview(rankLabel)
            showingLabelList.append(rankLabel)
            
            let scoreLabel = UILabel()
            scoreLabel.frame = CGRect(x: 60, y: 300+index*30, width: 75, height: 30)
            scoreLabel.text = String(hiScore.score)+NSLocalizedString("pts", comment: "")
            scoreLabel.textAlignment = NSTextAlignment.center
            scoreLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(scoreLabel)
            showingLabelList.append(scoreLabel)
            
            let questionLabel = UILabel()
            questionLabel.frame = CGRect(x: 135, y: 300+index*30, width: 75, height: 30)
            questionLabel.text = String(hiScore.count)+NSLocalizedString("answer", comment: "")
            questionLabel.textAlignment = NSTextAlignment.center
            questionLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(questionLabel)
            showingLabelList.append(questionLabel)
            
            let dateLabel = UILabel()
            dateLabel.frame = CGRect(x: 210, y: 300+index*30, width: 110, height: 30)
            dateLabel.text = hiScore.getHiScoreDateString()
            dateLabel.adjustsFontSizeToFitWidth = true
            scrollView.addSubview(dateLabel)
            showingLabelList.append(dateLabel)
        }
        
        scrollView.contentSize = CGSize(width: 320, height: 700)
        
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

    @IBAction func segmentedControlChanged(_ sender: Any) {
        showDifficulty = difficultySelect.selectedSegmentIndex + 1
        showHiScore()
    }
    
    @IBAction func showLeaderBoard1Button(_ sender: Any) {
        let leaderboardId = HiScore.getLeaderBoardId(TamenchanDefine.MODE_TIMEATTACK, showDifficulty)
        GameKitUtility.showLeaderBoard(target: self, leaderboardid: leaderboardId)
    }
    
    @IBAction func showLeaderBoard2Button(_ sender: Any) {
        let leaderboardId = HiScore.getLeaderBoardId(TamenchanDefine.MODE_ENDLESS, showDifficulty)
        GameKitUtility.showLeaderBoard(target: self, leaderboardid: leaderboardId)
    }
    
    @IBAction func clearHiScoreButton(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("clearhiscore", comment: ""),
                                      message: NSLocalizedString("clearhiscoreconfirm", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        let okBtn = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            HiScore.initHiScore()
            self.showHiScore()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        })
        let cancelBtn = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
