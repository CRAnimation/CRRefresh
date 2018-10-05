//
//  FastCheckLayer.swift
//  CRRefresh
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/imwcl
//  HomePage:https://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class FastCheckLayer
// @abstract FastCheckLayer
// @discussion FastCheckLayer
//

import UIKit

class FastCheckLayer: CALayer {
    
    private(set) var check: CAShapeLayer?
    
    let color: UIColor
    
    let lineWidth: CGFloat
    
    //MARK: Public Methods
    func startAnimation() {
        let start = CAKeyframeAnimation(keyPath: "strokeStart")
        start.values = [0, 0.4, 0.3]
        start.isRemovedOnCompletion = false
        start.fillMode = CAMediaTimingFillMode.forwards
        start.duration = 0.5
        start.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let end = CAKeyframeAnimation(keyPath: "strokeEnd")
        end.values = [0, 1, 0.9]

        end.isRemovedOnCompletion = false
        end.fillMode = CAMediaTimingFillMode.forwards
        end.duration = 0.8
        end.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        check?.add(start, forKey: "start")
        check?.add(end, forKey: "end")
    }
    
    func endAnimation() {
        check?.removeAllAnimations()
    }
    
    //MARK: Initial Methods
    init(frame: CGRect, color: UIColor = .init(rgb: (165, 165, 165)), lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth*2
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        drawCheck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func drawCheck() {
        let width = Double(frame.size.width)
        check = CAShapeLayer()
        check?.lineCap   = CAShapeLayerLineCap.round
        check?.lineJoin  = CAShapeLayerLineJoin.round
        check?.lineWidth = lineWidth
        check?.fillColor = UIColor.clear.cgColor
        check?.strokeColor = color.cgColor
        check?.strokeStart = 0
        check?.strokeEnd = 0
        let path = UIBezierPath()
        let a = sin(0.4) * (width/2)
        let b = cos(0.4) * (width/2)
        path.move(to: CGPoint.init(x: width/2 - b, y: width/2 - a))
        path.addLine(to: CGPoint.init(x: width/2 - width/20 , y: width/2 + width/8))
        path.addLine(to: CGPoint.init(x: width - width/5, y: width/2 - a))
        check?.path = path.cgPath
        addSublayer(check!)
    }

}
