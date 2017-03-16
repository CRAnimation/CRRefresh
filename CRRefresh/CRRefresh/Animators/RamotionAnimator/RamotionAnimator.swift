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
//  Github  :https://github.com/631106979
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

public class RamotionAnimator: UIView, CRRefreshProtocol {
    
    public var view: UIView { return self }
    
    public var insets: UIEdgeInsets = .zero
    
    public var trigger: CGFloat = 140
    
    public var execute: CGFloat = 90
    
    var bounceLayer: RamotionBounceLayer?
    
    func bounceLayer(view: CRRefreshComponent) -> RamotionBounceLayer? {
        if bounceLayer?.superlayer == nil {
            if let scrollView = view.scrollView {
                scrollView.backgroundColor = .white
                bounceLayer = RamotionBounceLayer(frame: scrollView.bounds, execute: execute)
                if let superView = scrollView.superview {
                    superView.layer.addSublayer(bounceLayer!)
                }
            }
        }
        return bounceLayer
    }
    
    public func refreshBegin(view: CRRefreshComponent) {
        bounceLayer(view: view)?.wave(execute)
        bounceLayer(view: view)?.startAnimation()
    }
    
    public func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if !finish {
            bounceLayer(view: view)?.endAnimation()
        }else {
            bounceLayer(view: view)?.wavelayer.endAnimation()
        }
    }
    
    public func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        let offY = trigger * progress
        bounceLayer(view: view)?.wave(offY)
    }
    
    public func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
