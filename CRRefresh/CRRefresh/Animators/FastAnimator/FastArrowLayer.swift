//
//  FastArrowLayer.swift
//  FastAnimator
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
// @class FastArrowLayer
// @abstract 箭头的layer
// @discussion 箭头的layer
//

import UIKit

class FastArrowLayer: CALayer,
                      CAAnimationDelegate {
    
    let color: UIColor
    
    let lineWidth: CGFloat
    
    private var lineLayer: CAShapeLayer?
    
    private var arrowLayer: CAShapeLayer?
    
    private let animationDuration: Double = 0.2
    
    var animationEnd: (()->Void)?
    
    //MARK: Initial Methods
    init(frame: CGRect, color: UIColor = .init(rgba: "#A5A5A5"), lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        initLineLayer()
        initArrowLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func initLineLayer() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.move(to: .init(x: width/2, y: 0))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        lineLayer = CAShapeLayer()
        lineLayer?.lineWidth   = lineWidth*2
        lineLayer?.strokeColor = color.cgColor
        lineLayer?.fillColor   = UIColor.clear.cgColor
        lineLayer?.lineCap     = kCALineCapRound
        lineLayer?.path        = path.cgPath
        lineLayer?.strokeStart = 0.5
        addSublayer(lineLayer!)
    }
    
    private func initArrowLayer() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.move(to: .init(x: width/2 - height/6, y: height/2 + height/6))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        path.addLine(to: .init(x: width/2 + height/6, y: height/2 + height/6))
        arrowLayer = CAShapeLayer()
        arrowLayer?.lineWidth   = lineWidth*2
        arrowLayer?.strokeColor = color.cgColor
        arrowLayer?.lineCap     = kCALineCapRound
        arrowLayer?.lineJoin    = kCALineJoinRound
        arrowLayer?.fillColor   = UIColor.clear.cgColor
        arrowLayer?.path        = path.cgPath
        addSublayer(arrowLayer!)
    }
    
    //MARK: public Methods
    @discardableResult
    public func startAnimation() -> Self {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.duration  = animationDuration
        start.fromValue = 0
        start.toValue   = 0.5
        start.isRemovedOnCompletion = false
        start.fillMode  = kCAFillModeForwards
        start.delegate    = self
        start.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.duration  = animationDuration
        end.fromValue = 1
        end.toValue   = 0.5
        end.isRemovedOnCompletion = false
        end.fillMode  = kCAFillModeForwards
        end.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        arrowLayer?.add(start, forKey: "strokeStart")
        arrowLayer?.add(end, forKey: "strokeEnd")
        
        return self
    }

    public func endAnimation() {
        arrowLayer?.isHidden = false
        lineLayer?.isHidden  = false
        arrowLayer?.removeAllAnimations()
        lineLayer?.removeAllAnimations()
    }

    private func addLineAnimation() {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.fromValue = 0.5
        start.toValue = 0
        start.isRemovedOnCompletion = false
        start.fillMode  = kCAFillModeForwards
        start.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        start.duration  = animationDuration/2
        lineLayer?.add(start, forKey: "strokeStart")
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.beginTime = CACurrentMediaTime() + animationDuration/3
        end.duration  = animationDuration/2
        end.fromValue = 1
        end.toValue   = 0.03
        end.isRemovedOnCompletion = false
        end.fillMode  = kCAFillModeForwards
        end.delegate  = self
        end.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        lineLayer?.add(end, forKey: "strokeEnd")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let anim = anim as? CABasicAnimation {
                if anim.keyPath == "strokeStart" {
                    arrowLayer?.isHidden = true
                    addLineAnimation()
                }else {
                    lineLayer?.isHidden = true
                    animationEnd?()
                }
            }
        }
    }
}
