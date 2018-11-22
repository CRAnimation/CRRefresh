//
//  RamotionBounceLayer.swift
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
// @class RamotionBounceLayer
// @abstract 背景layer
// @discussion 背景layer
//

import UIKit

class RamotionBounceLayer: CALayer {
    // 动画时间
    var animDuration: CFTimeInterval = 0.45
    // 白色渐变的背景
    let backLayer = CALayer()
    // 上方的变动的背景
    let wavelayer: RamotionWaveLayer
    // 球
    let ballLayer: RamotionBallLayer
    // 连接线
    let linkLayer: CAShapeLayer = CAShapeLayer()
    // 执行动画的高度
    var execute: CGFloat = 0
    // 计时器
    var displayLink: CADisplayLink?
    // 记录之前的offY
    private var previousOffY: CGFloat = 0
    /// 上方wave的颜色
    let waveColor: UIColor
    /// 球的颜色
    let ballColor: UIColor
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }

    //MARK: Initial Methods
    init(frame: CGRect, execute: CGFloat, ballColor: UIColor, waveColor: UIColor) {
        self.waveColor = waveColor
        self.ballColor = ballColor
        self.execute  = execute
        wavelayer = .init(frame: .init(origin: .zero, size: frame.size), execute: execute, bounceDuration: animDuration, color: waveColor)
        ballLayer = .init(frame: .init(x: frame.width/2 - 20, y: execute + 40, width: 40, height: 40), duration: animDuration, moveUpDist: 60 + execute/2, color: ballColor)
        linkLayer.fillColor = ballColor.cgColor
        super.init()
        backgroundColor = UIColor.clear.cgColor
        backLayer.frame = .init(origin: .zero, size: frame.size)
        backLayer.backgroundColor = ballColor.cgColor
        backLayer.opacity = 0
        addSublayer(backLayer)
        addSublayer(wavelayer)
        addSublayer(ballLayer)
        addSublayer(linkLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Public Methods
    func wave(_ y: CGFloat) {
        wavelayer.wave(y, execute: execute)
        let progress = y/execute
        backLayer.opacity = Float(progress)
    }
    
    func startAnimation() {
        ballLayer.isHidden = false
        linkLayer.isHidden = false
        addDisPlay()
        wavelayer.startAnimation()
        ballLayer.startAnimation()
    }
    
    func endAnimation() {
        ballLayer.endAnimation { [weak self] in
            self?.removeDisPlay()
            self?.wave(0)
        }
    }
    
    func clear() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    //MARK: Private Methods
    @objc private func displayAction() {
        let offY = ballLayer.circleLayer.presentation()?.frame.origin.y
        let frame1 = ballLayer.frame
        let frame2 = wavelayer.reference.layer.presentation()?.frame
            if let offY = offY, let frame2 = frame2 {
                DispatchQueue.global().async {
                    // 判断是球是向上还是下，false为上,速度快时，获取的位置不及时，向下时需要调整位置
                    let isIncrement = (offY - self.previousOffY) > 0
                    let path = UIBezierPath()
                    let x1 = frame1.origin.x + (isIncrement ? 4 : 0)
                    let y1 = frame1.origin.y + offY
                    let w1 = frame1.size.width - (isIncrement ? 8 : 0)
                    let h1 = frame1.size.height
                    let x2 = frame2.origin.x
                    let y2 = frame2.origin.y
                    let w2 = frame2.size.width
                    let h2 = frame2.size.height
                    let subY = y2 - y1
                    // y1和y2的间距
                    let subScale = subY/self.execute/2
                    // 断开的距离为10
                    let executeSub = self.ballLayer.circleLayer.moveUpDist + offY
                    if executeSub < 10 {
                        if !isIncrement {
                            let executeSubScale = executeSub/10
                            path.move(to: .init(x: x1 - 15, y: y2 + h2/2 + 15))
                            path.addLine(to: .init(x: x1 + w1 + 15, y: y2 + h2/2 + 15))
                            path.addQuadCurve(to: .init(x: x1 - 15, y: y2 + h2/2 + 15), controlPoint: .init(x: x1 + w1/2, y: y2 + h2/2 - self.execute/6 * executeSubScale))
                        }
                    }else {
                        path.move(to: .init(x: x2 , y: y2 + h2))
                        path.addLine(to: .init(x: x2 + w2, y: y2 + h2))
                        path.addQuadCurve(to: .init(x: x1 + w1, y: y1 + h1/2), controlPoint: .init(x: x1 + w1 - w1*2*subScale, y: y1 + (y2 - y1)/2 + h1/2 + h2/2))
                        path.addLine(to: .init(x: x1, y: y1 + h1/2))
                        path.addQuadCurve(to: .init(x: x2 , y: y2 + h2), controlPoint: .init(x: x1 + w1*2*subScale, y: y1 + (y2 - y1)/2 + h1/2 + h2/2))
                        if y1 + h1 <= self.execute, isIncrement {
                            DispatchQueue.main.async {
                                self.wavelayer.startDownAnimation()
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.linkLayer.path = path.cgPath
                    }
                    self.previousOffY = offY
                }
            }
    }
    
    private func addDisPlay() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayAction))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func removeDisPlay() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
