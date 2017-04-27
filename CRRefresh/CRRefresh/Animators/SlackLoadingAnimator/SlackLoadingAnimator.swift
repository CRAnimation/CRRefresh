//
//  SlackLoadingHeaderAnimator.swift
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
// @class SlackLoadingHeaderAnimator
// @abstract SlackLoading的刷新效果
// @discussion SlackLoading的刷新效果
//

import UIKit

public class SlackLoadingAnimator: UIView, CRRefreshProtocol {
    
    public var view: UIView { return self }
    
    public var insets: UIEdgeInsets = .zero
    
    public var trigger: CGFloat = 60
    
    public var execute: CGFloat = 60
    
    public var endDelay: CGFloat = 0
    
    var loadingView: WCLLoadingView = {
        let loadView = WCLLoadingView(frame: .init(x: 0, y: 0, width: 40, height: 40))
        loadView.isUserInteractionEnabled = false
        return loadView
    }()
    
    public func refreshBegin(view: CRRefreshComponent) {
        loadingView.startAnimation()
    }
    
    public func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        loadingView.stopAnimation()
    }
    
    public func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    public func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let s = bounds.size
        let w = s.width
        let h = s.height
        loadingView.center = .init(x: w / 2.0, y: h / 2.0)
    }
}
