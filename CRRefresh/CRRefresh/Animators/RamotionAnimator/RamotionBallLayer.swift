//
//  RamotionBallLayer.swift
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
// @class RamotionBallLayer
// @abstract RamotionBallLayer
// @discussion RamotionBallLayer
//

import UIKit

private var timeFunc = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

private var upDuration: Double = 0.5

class RamotionBallLayer: CALayer {
    
    deinit {
        circleLayer.stopAnimation()
    }
    
    var circleLayer: CircleLayer!
    
    init(frame: CGRect, duration: CFTimeInterval, moveUpDist: CGFloat, color: UIColor = .white) {
        upDuration = duration
        super.init()
        self.frame = frame
        let circleWidth = min(frame.size.width, frame.size.height)
        circleLayer = CircleLayer(size: circleWidth, moveUpDist: moveUpDist, frame: frame, color: color)
        addSublayer(circleLayer)
        isHidden = true
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        circleLayer.startAnimation()
    }
    
    func endAnimation(_ complition: (()-> Void)? = nil) {
        circleLayer.endAnimation(complition)
    }
}

class CircleLayer :CAShapeLayer, CAAnimationDelegate {
    
    deinit {
        spiner?.stopAnimation()
    }
    
    var moveUpDist: CGFloat = 0
    var spiner: SpinerLayer?
    var didEndAnimation: (() -> Void)?
    
    init(size: CGFloat, moveUpDist: CGFloat, frame: CGRect, color: UIColor = UIColor.white) {
        self.moveUpDist = moveUpDist
        let selfFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        spiner = SpinerLayer(superLayerFrame: selfFrame, ballSize: size, color: color)
        super.init()
        
        addSublayer(spiner!)
        
        let radius:CGFloat = size / 2
        self.frame = selfFrame
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height/2)
        let startAngle = 0 - Double.pi/2
        let endAngle = Double.pi * 2 - Double.pi/2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
        self.fillColor = color.withAlphaComponent(1).cgColor
        self.strokeColor = self.fillColor
        self.lineWidth = 0
        self.strokeEnd = 1
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        moveUp(moveUpDist)
        DispatchQueue.main.asyncAfter(deadline: .now() + upDuration) { [weak self] in
            self?.spiner?.animation()
        }
    }
    
    func endAnimation(_ complition:(()->())? = nil) {
        spiner?.stopAnimation()
        moveDown(moveUpDist)
        didEndAnimation = complition
    }
    
    func stopAnimation() {
        spiner?.stopAnimation()
        removeAllAnimations()
        didEndAnimation?()
    }
    
    func moveUp(_ distance: CGFloat) {
        let move = CABasicAnimation(keyPath: "position")
        
        move.fromValue = NSValue(cgPoint: position)
        move.toValue = NSValue(cgPoint: CGPoint(x: position.x,
                                                y: position.y - distance))
        
        move.duration = upDuration
        move.timingFunction = timeFunc
        
        move.fillMode = CAMediaTimingFillMode.forwards
        move.isRemovedOnCompletion = false
        add(move, forKey: move.keyPath)
    }
    
    func moveDown(_ distance: CGFloat) {
        let move = CABasicAnimation(keyPath: "position")
        
        move.fromValue = NSValue(cgPoint: CGPoint(x: position.x, y: position.y - distance))
        move.toValue = NSValue(cgPoint: position)
        
        move.duration = upDuration
        move.timingFunction = timeFunc
        
        move.fillMode = CAMediaTimingFillMode.forwards
        move.isRemovedOnCompletion = false
        move.delegate = self
        add(move, forKey: move.keyPath)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didEndAnimation?()
    }
}


class SpinerLayer: CAShapeLayer, CAAnimationDelegate {
    
    init(superLayerFrame: CGRect, ballSize: CGFloat, color: UIColor = UIColor.white) {
        super.init()
        
        let radius:CGFloat = (ballSize / 2) * 1.2//1.45
        self.frame = CGRect(x: 0, y: 0, width: superLayerFrame.height, height: superLayerFrame.height)
        let center = CGPoint(x: superLayerFrame.size.width / 2, y: superLayerFrame.origin.y + superLayerFrame.size.height/2)
        let startAngle = 0 - Double.pi/2
        let endAngle = (Double.pi * 2 - Double.pi/2) + Double.pi / 8
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
        
        self.fillColor = nil
        self.strokeColor = color.cgColor
        self.lineWidth = 2
        self.lineCap = CAShapeLayerLineCap.round
        
        self.strokeStart = 0
        self.strokeEnd = 0
        self.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 1
        rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        rotate.repeatCount = HUGE
        rotate.fillMode = CAMediaTimingFillMode.forwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
        
        strokeEndAnimation()
    }
    
    func strokeEndAnimation() {
        let endPoint = CABasicAnimation(keyPath: "strokeEnd")
        endPoint.fromValue = 0
        endPoint.toValue = 1
        endPoint.duration = 1.8
        endPoint.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        endPoint.repeatCount = HUGE
        endPoint.fillMode = CAMediaTimingFillMode.forwards
        endPoint.isRemovedOnCompletion = false
        endPoint.delegate = self
        add(endPoint, forKey: endPoint.keyPath)
    }
    
    func strokeStartAnimation() {
        let startPoint = CABasicAnimation(keyPath: "strokeStart")
        startPoint.fromValue = 0
        startPoint.toValue = 1
        startPoint.duration = 0.8
        startPoint.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        startPoint.repeatCount = HUGE
        startPoint.delegate = self
        add(startPoint, forKey: startPoint.keyPath)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.isHidden == false {
            let a:CABasicAnimation = anim as! CABasicAnimation
            if a.keyPath == "strokeStart" {
                strokeEndAnimation()
            }else if a.keyPath == "strokeEnd" {
                strokeStartAnimation()
            }
        }
    }
    
    func stopAnimation() {
        isHidden = true
        removeAllAnimations()
    }
}

