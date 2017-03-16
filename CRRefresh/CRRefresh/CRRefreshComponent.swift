//
//  CRRefreshComponent.swift
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
// @class CRRefreshComponent
// @abstract 刷新控件的基类
// @discussion 刷新控件的基类
//

import UIKit

public typealias CRRefreshHandler = (() -> ())

public enum CRRefreshState {
    /// 普通闲置状态
    case idle
    /// 松开就可以进行刷新的状态
    case pulling
    /// 正在刷新中的状态
    case refreshing
    /// 即将刷新的状态
    case willRefresh
    /// 所有数据加载完毕，没有更多的数据了
    case noMoreData
}

open class CRRefreshComponent: UIView {
    
    open weak var scrollView: UIScrollView?
    
    open var scrollViewInsets: UIEdgeInsets = .zero
    
    open var handler: CRRefreshHandler?
    
    open var animator: CRRefreshProtocol!
    
    open var state: CRRefreshState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.animator.refresh(view: self, stateDidChange: self.state)
            }
        }
    }
    
    fileprivate var isObservingScrollView = false
    
    fileprivate var isIgnoreObserving     = false
    
    fileprivate(set) var isRefreshing     = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin]
    }
    
    public convenience init(animator: CRRefreshProtocol = CRRefreshAnimator(), handler: @escaping CRRefreshHandler) {
        self.init(frame: .zero)
        self.handler  = handler
        self.animator = animator
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // 旧的父控件移除监听
        removeObserver()
        if let newSuperview = newSuperview as? UIScrollView {
            // 记录UIScrollView最开始的contentInset
            scrollViewInsets = newSuperview.contentInset
            DispatchQueue.main.async { [weak self, newSuperview] in
                guard let weakSelf = self else { return }
                weakSelf.addObserver(newSuperview)
            }
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        scrollView = superview as? UIScrollView
        let view = animator.view
        if view.superview == nil {
            let inset = animator.insets
            addSubview(view)
            view.frame = CGRect(x: inset.left,
                                y: inset.top,
                                width: bounds.size.width - inset.left - inset.right,
                                height: bounds.size.height - inset.top - inset.bottom)
            view.autoresizingMask = [
                .flexibleWidth,
                .flexibleTopMargin,
                .flexibleHeight,
                .flexibleBottomMargin
            ]
        }
    }
}

//MARK: Public Methods
extension CRRefreshComponent {
    public final func beginRefreshing() -> Void {
        guard isRefreshing == false else { return }
        if self.window != nil {
            state = .refreshing
            start()
        }else {
            if state != .refreshing {
                state = .willRefresh
                // 预防view还没显示出来就调用了beginRefreshing
                DispatchQueue.main.async {
                    self.scrollViewInsets = self.scrollView?.contentInset ?? .zero
                    if self.state == .willRefresh {
                        self.state = .refreshing
                        self.start()
                    }
                }
            }
        }
    }
    
    public final func endRefreshing() -> Void {
        guard isRefreshing else { return }
        self.stop()
    }
    
    public func ignoreObserver(_ ignore: Bool = false) {
        if let scrollView = scrollView {
            scrollView.isScrollEnabled = !ignore
        }
        isIgnoreObserving = ignore
    }
    
    public func start() {
        isRefreshing = true
    }
    
    public func stop() {
        isRefreshing = false
    }
    
    public func sizeChange(change: [NSKeyValueChangeKey : Any]?) {}
    
    public func offsetChange(change: [NSKeyValueChangeKey : Any]?) {}
}

//MARK: Observer Methods 
extension CRRefreshComponent {
    
    fileprivate static var context            = "CRRefreshContext"
    fileprivate static let offsetKeyPath      = "contentOffset"
    fileprivate static let contentSizeKeyPath = "contentSize"
    public static let animationDuration       = 0.25
    
    fileprivate func removeObserver() {
        if let scrollView = superview as? UIScrollView, isObservingScrollView {
            scrollView.removeObserver(self, forKeyPath: CRRefreshComponent.offsetKeyPath, context: &CRRefreshComponent.context)
            scrollView.removeObserver(self, forKeyPath: CRRefreshComponent.contentSizeKeyPath, context: &CRRefreshComponent.context)
            isObservingScrollView = false
        }
    }
    
    fileprivate func addObserver(_ view: UIView?) {
        if let scrollView = view as? UIScrollView, !isObservingScrollView {
            scrollView.addObserver(self, forKeyPath: CRRefreshComponent.offsetKeyPath, options: [.initial, .new], context: &CRRefreshComponent.context)
            scrollView.addObserver(self, forKeyPath: CRRefreshComponent.contentSizeKeyPath, options: [.initial, .new], context: &CRRefreshComponent.context)
            isObservingScrollView = true
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CRRefreshComponent.context {
            guard isUserInteractionEnabled == true && isHidden == false else {
                return
            }
            if keyPath == CRRefreshComponent.contentSizeKeyPath {
                if isIgnoreObserving == false {
                    sizeChange(change: change)
                }
            } else if keyPath == CRRefreshComponent.offsetKeyPath {
                if isIgnoreObserving == false {
                    offsetChange(change: change)
                }
            }
        }
    }
}
