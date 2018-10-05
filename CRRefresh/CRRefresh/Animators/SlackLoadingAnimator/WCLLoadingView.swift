//
//  WCLLoadingView.swift
//  WCL
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
// @class WCLLoadingView
// @abstract Slack 的 Loading 动画
// @discussion Slack 的 Loading 动画
//
// 动画步骤解析：http://blog.csdn.net/wang631106979/article/details/52473985

import UIKit

class WCLLoadingView: UIView, CAAnimationDelegate {
    
    //线的宽度
    var lineWidth:CGFloat = 0
    //线的长度
    var lineLength:CGFloat = 0
    //边距
    var margin:CGFloat = 0
    //动画时间
    var duration:Double = 2
    //动画的间隔时间
    var interval:Double = 1
    //四条线的颜色
    var colors:[UIColor] = [UIColor(rgb: (157, 212, 233)) , UIColor(rgb: (245, 189, 88)),  UIColor(rgb: (255, 49, 126)) , UIColor(rgb: (111, 201, 181))]
    //动画的状态
    private(set) var status:AnimationStatus = .normal
    //四条线
    private var lines:[CAShapeLayer] = []
    
    enum AnimationStatus {
        //普通状态
        case normal
        //动画中
        case animating
        //暂停
        case pause
    }
    
    //MARK: Public Methods
    /**
     开始动画
     */
    func startAnimation() {
        angleAnimation()
        lineAnimationOne()
        lineAnimationTwo()
        lineAnimationThree()
    }
    
    /**
      暂停动画
     */
    func pauseAnimation() {
        layer.pauseAnimation()
        for lineLayer in lines {
            lineLayer.pauseAnimation()
        }
        status = .pause
    }
    
    /**
     继续动画
     */
    func resumeAnimation() {
        layer.resumeAnimation()
        for lineLayer in lines {
            lineLayer.resumeAnimation()
        }
        status = .animating
    }
    
    /**
     结束动画
    */
    func stopAnimation() {
        layer.removeAllAnimations()
        for lineLayer in lines {
            lineLayer.removeAllAnimations()
        }
        status = .normal
    }
    
    //MARK: Initial Methods
    convenience init(frame: CGRect , colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = colors
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    //MARK: Animation Delegate
    func animationDidStart(_ anim: CAAnimation) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "transform.rotation.z" {
                status = .animating
            }
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "strokeEnd" {
                if flag {
                    status = .normal
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(interval) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        if self.status != .animating {
                            self.startAnimation()
                        }
                    })
                }
            }
        }
    }
    
    //MARK: Privater Methods
    //MARK: 绘制线
    /**
     绘制四条线
     */
    private func drawLineShapeLayer() {
        //开始点
        let startPoint = [point(lineWidth/2, y: margin),
                          point(lineLength - margin, y: lineWidth/2),
                          point(lineLength - lineWidth/2, y: lineLength - margin),
                          point(margin, y: lineLength - lineWidth/2)]
        //结束点
        let endPoint   = [point(lineLength - lineWidth/2, y: margin) ,
                         point(lineLength - margin, y: lineLength - lineWidth/2) ,
                         point(lineWidth/2, y: lineLength - margin) ,
                         point(margin, y: lineWidth/2)]
        for i in 0...3 {
            let line:CAShapeLayer = CAShapeLayer()
            line.lineWidth   = lineWidth
            line.lineCap     = CAShapeLayerLineCap.round
            line.opacity     = 0.8
            line.strokeColor = colors[i].cgColor
            line.path        = getLinePath(startPoint[i], endPoint: endPoint[i]).cgPath
            layer.addSublayer(line)
            lines.append(line)
        }
        
    }
    
    /**
     获取线的路径
     
     - parameter startPoint: 开始点
     - parameter endPoint:   结束点
     
     - returns: 线的路径
     */
    private func getLinePath(_ startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
    
    //MARK: 动画步骤
    /**
     旋转的动画，旋转两圈
     */
    private func angleAnimation() {
        let angleAnimation                 = CABasicAnimation.init(keyPath: "transform.rotation.z")
        angleAnimation.beginTime           = CACurrentMediaTime()
        angleAnimation.fromValue           = angle(-30)
        angleAnimation.toValue             = angle(690)
        angleAnimation.fillMode            = CAMediaTimingFillMode.forwards
        angleAnimation.isRemovedOnCompletion = false
        angleAnimation.duration            = duration
        angleAnimation.delegate            = self
        layer.add(angleAnimation, forKey: "angleAnimation")
    }
    
    
    /**
     线的第一步动画，线长从长变短
     */
    private func lineAnimationOne() {
        let lineAnimationOne                 = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationOne.beginTime           = CACurrentMediaTime()
        lineAnimationOne.duration            = duration/2
        lineAnimationOne.fillMode            = CAMediaTimingFillMode.forwards
        lineAnimationOne.isRemovedOnCompletion = false
        lineAnimationOne.fromValue           = 1
        lineAnimationOne.toValue             = 0
        for i in 0...3 {
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationOne, forKey: "lineAnimationOne")
        }
    }
    
    /**
     线的第二步动画，线向中间平移
     */
    private func lineAnimationTwo() {
        for i in 0...3 {
            var keypath = "transform.translation.x"
            if i%2 == 1 {
                keypath = "transform.translation.y"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i < 2 {
                lineAnimationTwo.toValue = lineLength/4
            }else {
                lineAnimationTwo.toValue = -lineLength/4
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationTwo")
        }
        
        //三角形两边的比例
        let scale = (lineLength - 2*margin)/(lineLength - lineWidth)
        for i in 0...3 {
            var keypath = "transform.translation.y"
            if i%2 == 1 {
                keypath = "transform.translation.x"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i == 0 || i == 3 {
                lineAnimationTwo.toValue = lineLength/4 * scale
            }else {
                lineAnimationTwo.toValue = -lineLength/4 * scale
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationThree")
        }
    }
    
    /**
     线的第三步动画，线由短变长
     */
    private func lineAnimationThree() {
        //线移动的动画
        let lineAnimationFour                   = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationFour.beginTime             = CACurrentMediaTime() + duration
        lineAnimationFour.duration              = duration/4
        lineAnimationFour.fillMode              = CAMediaTimingFillMode.forwards
        lineAnimationFour.isRemovedOnCompletion = false
        lineAnimationFour.fromValue             = 0
        lineAnimationFour.toValue               = 1
        for i in 0...3 {
            if i == 3 {
                lineAnimationFour.delegate = self
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationFour, forKey: "lineAnimationFour")
        }
    }
    
    //MARK: Private Methods
    private func point(_ x:CGFloat , y:CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func angle(_ angle: Double) -> CGFloat {
        return CGFloat(angle *  (Double.pi/180))
    }
    
    private func config() {
        layoutIfNeeded()
        lineLength = max(frame.width, frame.height)
        lineWidth  = lineLength/6.0
        margin     = lineLength/4.5 + lineWidth/2
        drawLineShapeLayer()
        //调整角度
        transform = CGAffineTransform.identity.rotated(by: angle(-30))
    }
}

extension CALayer {
    //暂停动画
    func pauseAnimation() {
        // 将当前时间CACurrentMediaTime转换为layer上的时间, 即将parent time转换为localtime
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        // 设置layer的timeOffset, 在继续操作也会使用到
        timeOffset    = pauseTime
        // localtime与parenttime的比例为0, 意味着localtime暂停了
        speed         = 0
    }
    
    //继续动画
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed          = 1
        timeOffset     = 0
        beginTime      = 0
        // 计算暂停时间
        let sincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        // local time相对于parent time时间的beginTime
        beginTime      = sincePause
    }
}
