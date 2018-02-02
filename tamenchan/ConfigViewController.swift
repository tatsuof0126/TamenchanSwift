//
//  ConfigViewController.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit
import GameKit

class ConfigViewController: UIViewController, PurchaseManagerDelegate {
    
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var haiTypeLabel: UILabel!
    @IBOutlet var haiTypeImage: UIImageView!
    
    @IBOutlet var removeAdsBtn: UIButton!
    @IBOutlet var restoreBtn: UIButton!
    
    var doingPurchase = false
    var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHaiTypeLabel()
        
        showPurchaseBtn()
        
        // アプリ名とバージョンの表示
        let version: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        versionLabel.text = NSLocalizedString("appname", comment: "") + " ver" + version!
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        indicatorView.center = self.view.center
        self.view.addSubview(indicatorView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func haiTypeChangeButton(_ sender: Any) {
        let titleStr = NSLocalizedString("changehaitype", comment: "")
        
        let alert = UIAlertController(title: titleStr, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let easyBtn = UIAlertAction(title: TamenchanDefine.HAITYPE_STRING_MANZU, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setHaiType(TamenchanDefine.HAITYPE_MANZU)
            self.setHaiTypeLabel()
        })
        let normalBtn = UIAlertAction(title: TamenchanDefine.HAITYPE_STRING_PINZU, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setHaiType(TamenchanDefine.HAITYPE_PINZU)
            self.setHaiTypeLabel()
        })
        let hardBtn = UIAlertAction(title: TamenchanDefine.HAITYPE_STRING_SOUZU, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            ConfigManager.setHaiType(TamenchanDefine.HAITYPE_SOUZU)
            self.setHaiTypeLabel()
        })
        let cancelBtn = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(easyBtn)
        alert.addAction(normalBtn)
        alert.addAction(hardBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setHaiTypeLabel(){
        let haiType = ConfigManager.getHaiType()
        switch haiType {
        case TamenchanDefine.HAITYPE_MANZU:
            haiTypeLabel.text = TamenchanDefine.HAITYPE_STRING_MANZU
        case TamenchanDefine.HAITYPE_PINZU:
            haiTypeLabel.text = TamenchanDefine.HAITYPE_STRING_PINZU
        case TamenchanDefine.HAITYPE_SOUZU:
            haiTypeLabel.text = TamenchanDefine.HAITYPE_STRING_SOUZU
        default:
            break
        }
        haiTypeImage.image = UIImage(named: Tehai.haiImagePath[haiType][1])
    }

    func showPurchaseBtn(){
        if ConfigManager.isShowAds() == true {
            removeAdsBtn.isHidden = false
            restoreBtn.isHidden = false
        } else {
            removeAdsBtn.isHidden = true
            restoreBtn.isHidden = true
        }
    }
    
    @IBAction func removeAdsButton(_ sender: Any) {
        // 広告を削除
        if ConfigManager.isShowAds() == true {
            startPurchase(productIdentifier: "removeads")
        }
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        startRestore()
    }
    
    // 購入処理
    func startPurchase(productIdentifier: String) {
        print("購入処理開始")
        
        if doingPurchase == true {
            return
        }
        doingPurchase = true
        
        // インジケーター
        indicatorView.startAnimating()
        
        // 購入処理を開始
        let purchaseManager = InAppPurchaseManager.getPurchaseManager()
        purchaseManager.delegate = self
        purchaseManager.purchase(productIdentifier: productIdentifier)
    }
    
    // リストア
    func startRestore() {
        print("リストア処理開始")
        
        if doingPurchase == true {
            return
        }
        doingPurchase = true
        
        // インジケーター
        indicatorView.startAnimating()
        
        // リストア処理を開始
        let purchaseManager = InAppPurchaseManager.getPurchaseManager()
        purchaseManager.delegate = self
        purchaseManager.restore()
    }
    
    // 購入成功
    func purchaseSuccess(productIdentifier: String) {
        print("PurchaseSuccess : \(productIdentifier)")
        
        if productIdentifier == "removeads" {
            ConfigManager.setShowAds(false)
            Utility.showAlert(controller: self, title: NSLocalizedString("completepurchase", comment: ""),
                              message: NSLocalizedString("removedads", comment: ""))
        }
        doingPurchase = false
        indicatorView.stopAnimating()
        showPurchaseBtn()
    }
    
    // 購入失敗
    func purchaseFail(message: String) {
        print("PurchaseFail : \(message)")
        
        Utility.showAlert(controller: self, title: "", message: message)
        doingPurchase = false
        indicatorView.stopAnimating()
        showPurchaseBtn()
    }
    
    // リストア成功（復元した購入を反映）
    func restorePurchase(productIdentifier: String) {
        print("RestorePurchase : \(productIdentifier)")
        
        if productIdentifier == "removeads" && ConfigManager.isShowAds() == true {
            ConfigManager.setShowAds(false)
            Utility.showAlert(controller: self, title: NSLocalizedString("donerestore", comment: ""),
                              message: NSLocalizedString("removedads", comment: ""))
        }
    }
    
    // リストア完了
    func restoreSuccess() {
        print("RestoreSuccess")
        
        Utility.showAlert(controller: self, title: "", message: NSLocalizedString("completerestore", comment: ""))
        doingPurchase = false
        indicatorView.stopAnimating()
        showPurchaseBtn()
    }
    
    // リストア失敗
    func restoreFail(message: String) {
        print("RestoreFail")
        
        Utility.showAlert(controller: self, title: "", message: message)
        doingPurchase = false
        indicatorView.stopAnimating()
        showPurchaseBtn()
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
