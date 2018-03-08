//
//  CRRefreshAnimator.swift
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
// @class CRRefreshAnimator
// @abstract 默认的Animator
// @discussion 默认的Animator
//

import UIKit

open class CRRefreshAnimator: CRRefreshProtocol {
    
    open var view: UIView
    
    open var insets: UIEdgeInsets
    
    open var trigger: CGFloat = 60.0
    
    open var execute: CGFloat = 60.0
    
    open var endDelay: CGFloat = 0
    
    public var hold: CGFloat   = 60
    
    public init() {
        view = UIView()
        insets = UIEdgeInsets.zero
    }
    
    open func refreshBegin(view: CRRefreshComponent) {}
    
    open func refreshWillEnd(view: CRRefreshComponent) {}
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {}
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {}
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {}
}
