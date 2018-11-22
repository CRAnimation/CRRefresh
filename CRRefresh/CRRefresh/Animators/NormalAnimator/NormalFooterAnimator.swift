//
//  NormalFooterAnimator.swift
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
// @class NormalFooterAnimator
// @abstract 普通底部加载Animator
// @discussion 普通底部加载Animator
//

import UIKit

open class NormalFooterAnimator: UIView, CRRefreshProtocol {
    
    static let crBundle = CRRefreshBundle.bundle(name: "NormalFooter", for: NormalFooterAnimator.self)

    open var loadingMoreDescription = crBundle?.localizedString(key: "CRRefreshFooterIdleText")
    open var noMoreDataDescription  = crBundle?.localizedString(key: "CRRefreshFooterNoMoreText")
    open var loadingDescription     = crBundle?.localizedString(key: "CRRefreshFooterRefreshingText")

    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets   = .zero
    open var trigger: CGFloat       = 50.0
    open var execute: CGFloat       = 50.0
    open var endDelay: CGFloat      = 0
    open var hold: CGFloat          = 50
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = loadingDescription
        indicatorView.isHidden = false
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        indicatorView.stopAnimating()
        titleLabel.text = loadingMoreDescription
        indicatorView.isHidden = true
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing :
            titleLabel.text = loadingDescription
            break
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
            break
        case .pulling:
            titleLabel.text = loadingMoreDescription
            break
        default:
            break
        }
        setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 - 5.0 + insets.top)
        indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
    }
}
