//
//  Utility.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static func isJapaneseLocale() -> Bool {
        if let prefLang = Locale.preferredLanguages.first {
            if (prefLang.hasPrefix("ja")){
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /*
    static func isInUSA() -> Bool {
        if Locale.current.regionCode == "US" {
            return true
        } else {
            return false
        }
    }
    */
    
    static func showAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                      style: UIAlertActionStyle.default, handler:nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirmDialog(controller: UIViewController,
                                  title: String, message: String, handler: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                      style: UIAlertActionStyle.default, handler: handler))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                      style: UIAlertActionStyle.cancel))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func decorateBtn(_ btn: UIButton) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.0
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.minimumScaleFactor = 0.6
    }
    
}

