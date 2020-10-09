//
//  RamotionAnimator.swift
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
//  HomePage:http://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class RamotionAnimator
// @abstract Ramotion动画的Animator
// @discussion Ramotion动画的Animator
//

import UIKit

open class RamotionAnimator: UIView, CRRefreshProtocol {
    
    open var view: UIView { return self }
    
    open var insets: UIEdgeInsets = .zero
    
    open var trigger: CGFloat  = 140
    
    open var execute: CGFloat  = 90
    
    open var endDelay: CGFloat = 0
    
    open var hold: CGFloat     = 90

    
    var bounceLayer: RamotionBounceLayer?
    /// 上方wave的颜色
    let waveColor: UIColor
    /// 球的颜色
    let ballColor: UIColor
    
    deinit {
        bounceLayer?.clear()
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - ballColor: 小球的颜色
    ///   - waveColor: 上方wave的颜色
    public init(ballColor: UIColor = .white,
                waveColor: UIColor = .init(rgb: (140, 141, 178))) {
        self.ballColor = ballColor
        self.waveColor = waveColor
        super.init(frame: .zero)
    }
    
    func bounceLayer(view: CRRefreshComponent) -> RamotionBounceLayer? {
        if bounceLayer?.superlayer == nil {
            if let scrollView = view.scrollView {
                bounceLayer = RamotionBounceLayer(frame: scrollView.bounds, execute: execute, ballColor: ballColor, waveColor: waveColor)
                if let superView = scrollView.superview {
                    superView.layer.addSublayer(bounceLayer!)
                }
            }
        }
        return bounceLayer
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        bounceLayer(view: view)?.wave(execute)
        bounceLayer(view: view)?.startAnimation()
    }
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if !finish {
            bounceLayer(view: view)?.endAnimation()
        }else {
            bounceLayer(view: view)?.ballLayer.isHidden = true
            bounceLayer(view: view)?.linkLayer.isHidden = true
            bounceLayer(view: view)?.wavelayer.endAnimation()
        }
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        let offY = trigger * progress
        bounceLayer(view: view)?.wave(offY)
    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        
    }
    
    open func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    public override init(frame: CGRect) {
        self.ballColor = .white
        self.waveColor = .init(rgb: (140, 141, 178))
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
