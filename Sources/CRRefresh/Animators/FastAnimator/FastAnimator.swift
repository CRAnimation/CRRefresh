//
//  FastAnimator.swift
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
//  HomePage:http://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class FastAnimator
// @abstract FastAnimator
// @discussion FastAnimator
//

import UIKit

open class FastAnimator: UIView, CRRefreshProtocol {
    
    open var view: UIView { return self }
    
    open var insets: UIEdgeInsets = .zero
    
    open var trigger: CGFloat = 55.0
    
    open var execute: CGFloat = 55.0
    
    open var endDelay: CGFloat = 1.5
    
    open var hold: CGFloat = 55.0
    
    private(set) var color: UIColor = .init(rgb: (214, 214, 214))
    
    private(set) var arrowColor: UIColor = .init(rgb: (165, 165, 165))
    
    private(set) var lineWidth: CGFloat = 1
    
    private(set) var fastLayer: FastLayer?


    //MARK: CRRefreshProtocol
    /// 开始刷新
    open func refreshBegin(view: CRRefreshComponent) {
        fastLayer?.arrow?.startAnimation().animationEnd = { [weak self] in
            self?.fastLayer?.circle?.startAnimation()
        }
    }
    
    /// 结束刷新
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if finish {
            fastLayer?.arrow?.endAnimation()
            fastLayer?.circle?.endAnimation(finish: finish)
            fastLayer?.arrow?.setAffineTransform(CGAffineTransform.identity)
        }
    }
    
    open func refreshWillEnd(view: CRRefreshComponent) {
        fastLayer?.circle?.endAnimation(finish: false)
    }
    
    /// 刷新进度的变化
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        if progress >= 1 {
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
            fastLayer?.arrow?.setAffineTransform(transform)
        } else {
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(2 * Double.pi))
            fastLayer?.arrow?.setAffineTransform(transform)
        }
    }
    
    /// 刷新状态的变化
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {

    }
    
    //MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if fastLayer == nil {
            let width  = frame.width
            let height = frame.height
            fastLayer = FastLayer(frame: .init(x: width/2 - 14,
                                               y: height/2 - 14,
                                               width: 28, height: 28),
                                  color: color,
                                  arrowColor: arrowColor,
                                  lineWidth: lineWidth)
            layer.addSublayer(fastLayer!)
        }
    }
    
    //MARK: Initial Methods
    public init(frame: CGRect,
             color: UIColor = .init(rgb: (214, 214, 214)),
             arrowColor: UIColor = .init(rgb: (165, 165, 165)),
             lineWidth: CGFloat = 1) {
        self.color      = color
        self.arrowColor = arrowColor
        self.lineWidth  = lineWidth
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
