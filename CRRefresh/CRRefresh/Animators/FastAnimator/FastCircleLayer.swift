//
//  FastCircleLayer.swift
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
// @class FastCircleLayer
// @abstract 外层圆环的layer
// @discussion 外层圆环的layer
//

import UIKit

class FastCircleLayer: CALayer {
    
    let color: UIColor
    
    let pointColor: UIColor
    
    let lineWidth: CGFloat
    
    let circle = CAShapeLayer()
    
    let point  = CAShapeLayer()
        
    private let pointBack = CALayer()
    
    private var rotated: CGFloat = 0
    
    private var rotatedSpeed: CGFloat = 0
    
    private var speedInterval: CGFloat = 0
    
    private var stop: Bool = false
    
    private(set) var check: FastCheckLayer?
    
    var codeTimer: DispatchSourceTimer?
    
    //MARK: Initial Methods
    init(frame: CGRect,
         color: UIColor = .init(rgb: (214, 214, 214)),
         pointColor: UIColor = .init(rgb: (165, 165, 165)),
         lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth
        self.pointColor = pointColor
        pointBack.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        pointBack.backgroundColor = UIColor.clear.cgColor
        drawCircle()
        addSublayer(pointBack)
        drawPoint()
        addCheckLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Methods
    func startAnimation() {
        circle.isHidden = false
        point.isHidden  = false
        
        codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer?.schedule(deadline: .now(), repeating: .milliseconds(42))
        codeTimer?.setEventHandler(handler: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.rotated = self.rotated - self.rotatedSpeed
            if self.stop {
                let count = Int(self.rotated / CGFloat(Double.pi * 2))
                if (CGFloat(Double.pi * 2 * Double(count)) - self.rotated) >= 1.1 {
                    var transform = CGAffineTransform.identity
                    transform = transform.rotated(by: -1.1)
                    DispatchQueue.main.async {
                        self.pointBack.setAffineTransform(transform)
                        self.point.isHidden  = true
                        self.check?.startAnimation()
                    }
                    self.codeTimer?.cancel()
                    return
                }
            }
            if self.rotatedSpeed < 0.65 {
                if self.speedInterval < 0.02 {
                    self.speedInterval = self.speedInterval + 0.001
                }
                self.rotatedSpeed = self.rotatedSpeed + self.speedInterval
            }
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: self.rotated)
            DispatchQueue.main.async {
                self.pointBack.setAffineTransform(transform)
            }
        })
        codeTimer?.resume()
        
        addPointAnimation()
    }
    
    func endAnimation(finish: Bool) {
        if finish {
            stop = false
            rotated       = 0
            rotatedSpeed  = 0
            speedInterval = 0
            pointBack.setAffineTransform(CGAffineTransform.identity)
            circle.isHidden = true
            point.isHidden  = true
            codeTimer?.cancel()
            check?.endAnimation()
        }else {
            DispatchQueue.global().async {
                self.stop = true
            }
        }
    }
    
    //MARK: Privater Methods
    private func drawCircle() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: width/2,
                                      y: height/2),
                    radius: height/2,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi * 2.0),
                    clockwise: false)
        circle.lineWidth   = lineWidth
        circle.strokeColor = color.cgColor
        circle.fillColor   = UIColor.clear.cgColor
        circle.path        = path.cgPath
        addSublayer(circle)
        circle.isHidden = true
    }

    private func drawPoint() {
        let width  = frame.size.width
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: width/2, y: width/2),
                    radius: width/2,
                    startAngle: CGFloat(Double.pi * 0.5),
                    endAngle: CGFloat((Double.pi * 0.5) - 0.1),
                    clockwise: false)
        point.lineCap     = CAShapeLayerLineCap.round
        point.lineWidth   = lineWidth*2
        point.fillColor   = UIColor.clear.cgColor
        point.strokeColor = pointColor.cgColor
        point.path        = path.cgPath
        pointBack.addSublayer(point)
        point.isHidden = true
    }
    
    private func addPointAnimation() {
        let width  = frame.size.width
        let path = CABasicAnimation(keyPath: "path")
        path.beginTime = CACurrentMediaTime() + 1
        path.fromValue = point.path
        let toPath = UIBezierPath()
        toPath.addArc(withCenter: .init(x: width/2, y: width/2),
                      radius: width/2,
                      startAngle: CGFloat(Double.pi * 0.5),
                      endAngle: CGFloat((Double.pi * 0.5) - 0.3),
                      clockwise: false)
        path.toValue = toPath.cgPath
        path.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        path.duration = 2
        path.isRemovedOnCompletion = false
        path.fillMode = CAMediaTimingFillMode.forwards
        point.add(path, forKey: "path")
    }
    
    private func addCheckLayer() {
        check = FastCheckLayer(frame: CGRect(x: 0,
                                             y: 0,
                                             width: frame.size.width,
                                             height: frame.size.height),
                               color: pointColor,
                               lineWidth: lineWidth)
        addSublayer(check!)
    }
}
