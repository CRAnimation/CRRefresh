//
//  RamotionWaveLayer.swift
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
// @class RamotionWaveLayer
// @abstract 上方的wavelayer
// @discussion 上方的wavelayer
//

import UIKit

private let referenceWitdh: CGFloat = 150
private let referenceHeight: CGFloat = 50

class RamotionWaveLayer: CALayer, CAAnimationDelegate {
    
    // 上方的wavelayer
    let waveLayer: CAShapeLayer = CAShapeLayer()
    // 参考的UIView
    let reference: UIView = UIView(frame: .init(x: 0, y: 0, width: referenceWitdh, height: referenceHeight))
    //  动画时间
    var bounceDuration: CFTimeInterval
    // layer的颜色
    let color: UIColor
    // 执行动画的高度
    var execute: CGFloat
    // 是否在动画中
    var isAnimation: Bool = false
    // 计时器
    var displayLink: CADisplayLink?

    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    //MARK: Initial Methods
    init(frame: CGRect, execute: CGFloat, bounceDuration: CFTimeInterval = 0.45, color: UIColor = .init(rgb: (140, 141, 178))) {
        self.bounceDuration = bounceDuration
        self.color = color
        self.execute = execute
        super.init()
        self.frame = frame
        backgroundColor = UIColor.clear.cgColor
        initWave()
        initReferenceLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWave() {
        waveLayer.lineWidth = 0
        waveLayer.path = wavePath(x: 0.0, y: 0.0)
        waveLayer.strokeColor = color.cgColor
        waveLayer.fillColor = color.cgColor
        addSublayer(waveLayer)
    }
    
    func initReferenceLayer() {
        let w = frame.size.width
        reference.isUserInteractionEnabled = false
        reference.frame = .init(x: w/2 - referenceWitdh/2, y: -referenceHeight/2, width: referenceWitdh, height: referenceHeight)
        reference.backgroundColor = UIColor.clear
        waveLayer.addSublayer(reference.layer)
        var trans = CGAffineTransform.identity
        trans = trans.translatedBy(x: 0, y: execute)
        reference.transform = trans
    }
    
    //MARK: Public Methods
    func wave(_ y: CGFloat, execute: CGFloat) {
        self.execute = execute
        waveLayer.path = wavePath(x: 0, y: y)
        if !isAnimation {
            var trans = CGAffineTransform.identity
            trans = trans.translatedBy(x: 0, y: y)
            reference.transform = trans
        }
    }
    
    func startAnimation() {
        isAnimation = true
        addDisPlay()
        boundAnimation(x: 0, y: execute)
    }
    
    func startDownAnimation() {
        if !isAnimation {
            isAnimation = true
            addDisPlay()
            boundDownAnimation(x: 0, y: execute)
        }
    }
    
    func endAnimation() {
        endBoundAnimation()
    }
    
    //MARK: Privater Methods
    private func wavePath(x: CGFloat, y: CGFloat) -> CGPath {
        let w = frame.width
        let path = UIBezierPath()
        if y < execute {
            path.move(to: .zero)
            path.addLine(to: .init(x: w, y: 0))
            path.addLine(to: .init(x: w, y: y))
            path.addLine(to: .init(x: 0, y: y))
            path.addLine(to: .zero)
        } else {
            path.move(to: .zero)
            path.addLine(to: .init(x: w, y: 0))
            path.addLine(to: .init(x: w, y: execute))
            path.addQuadCurve(to: .init(x: 0, y: execute), controlPoint: .init(x: w/2, y: y))
            path.addLine(to: .zero)
        }
        return path.cgPath
    }
    
    private func displayWavePath(x: CGFloat, y: CGFloat) -> CGPath {
        let w = frame.width
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: .init(x: w, y: 0))
        path.addLine(to: .init(x: w, y: execute))
        path.addQuadCurve(to: .init(x: 0, y: execute), controlPoint: .init(x: w/2, y: y))
        path.addLine(to: .zero)
        return path.cgPath
    }
    
    @objc private func displayAction() {
        if let frame = reference.layer.presentation()?.frame {
            DispatchQueue.global().async {
                let path = self.displayWavePath(x: 0, y: frame.origin.y + referenceHeight/2)
                DispatchQueue.main.async {
                    self.waveLayer.path = path
                }
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
    
    private func endBoundAnimation() {
        let end = CABasicAnimation(keyPath: "path")
        end.duration = 0.25
        end.fromValue = wavePath(x: 0, y: execute)
        end.toValue = wavePath(x: 0, y: 0)
        waveLayer.add(end, forKey: "end")
    }
    
    private func boundAnimation(x: CGFloat, y: CGFloat) {
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        bounce.duration = bounceDuration
        bounce.values = [
            reference.frame.origin.y,
            y * 0.5,
            y * 1.2,
            y * 0.8,
            y * 1.1,
            y
        ]
        bounce.isRemovedOnCompletion = true
        bounce.fillMode = CAMediaTimingFillMode.forwards
        bounce.delegate = self
        reference.layer.add(bounce, forKey: "return")
    }
    
    private func boundDownAnimation(x: CGFloat, y: CGFloat) {
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        bounce.duration = bounceDuration/2
        bounce.values = [
            y,
            y * 1.1,
            y
        ]
        bounce.isRemovedOnCompletion = true
        bounce.fillMode = CAMediaTimingFillMode.forwards
        bounce.delegate = self
        reference.layer.add(bounce, forKey: "returnDown")
    }
    
    //MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        removeDisPlay()
        isAnimation = false
    }

}
