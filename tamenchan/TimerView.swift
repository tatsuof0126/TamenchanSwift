//
//  TimerView.swift
//  tamenchan
//
//  Created by 藤原 達郎 on 2018/01/04.
//  Copyright © 2018年 Tatsuo Fujiwara. All rights reserved.
//

import UIKit

class TimerView: UIView {

    var remainTime = 0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let targetX = remainTime / 200
        
        if targetX >= 140 {
            UIColor.blue.setStroke()
            let blueLine = UIBezierPath();
            blueLine.lineWidth = 40
            blueLine.move(to: CGPoint(x: 140, y: 25));
            blueLine.addLine(to: CGPoint(x: targetX, y: 25));
            blueLine.stroke();
            
            UIColor.yellow.setStroke()
            let yellowLine = UIBezierPath();
            yellowLine.lineWidth = 40
            yellowLine.move(to: CGPoint(x: 70, y: 25));
            yellowLine.addLine(to: CGPoint(x: 140, y: 25));
            yellowLine.stroke();
            
            UIColor.red.setStroke()
            let redLine = UIBezierPath();
            redLine.lineWidth = 40
            redLine.move(to: CGPoint(x: 0, y: 25));
            redLine.addLine(to: CGPoint(x: 70, y: 25));
            redLine.stroke();
        } else if targetX >= 70 {
            UIColor.yellow.setStroke()
            let yellowLine = UIBezierPath()
            yellowLine.lineWidth = 40
            yellowLine.move(to: CGPoint(x: 70, y: 25))
            yellowLine.addLine(to: CGPoint(x: targetX, y: 25))
            yellowLine.stroke()

            UIColor.red.setStroke()
            let redLine = UIBezierPath()
            redLine.lineWidth = 40
            redLine.move(to: CGPoint(x: 0, y: 25))
            redLine.addLine(to: CGPoint(x: 70, y: 25))
            redLine.stroke()
        } else {
            UIColor.red.setStroke()
            let redLine = UIBezierPath();
            redLine.lineWidth = 40
            redLine.move(to: CGPoint(x: 0, y: 25));
            redLine.addLine(to: CGPoint(x: targetX, y: 25));
            redLine.stroke();
        }
        
        UIColor.black.setStroke()
        let baseline = UIBezierPath();
        baseline.lineWidth = 1
        baseline.move(to: CGPoint(x: 0, y: 0));
        baseline.addLine(to: CGPoint(x: 0, y: 50));
        baseline.stroke();
    }

    func updateTimerView(_ time : Int){
        remainTime = time
        
        self.setNeedsDisplay()
    }

}
