//
//  CRRefreshExtension.swift
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
// @class CRRefreshExtension
// @abstract CRRefreshExtension
// @discussion CRRefreshExtension
//

import UIKit

private var kCRRefreshHeaderKey = "kCRRefreshHeaderKey"
private var kCRRefreshFooterKey = "kCRRefreshFooterKey"

typealias CRRefreshView = UIScrollView

extension CRRefreshView {
    public var cr: CRRefreshDSL {
        return CRRefreshDSL(scroll: self)
    }
}

public struct CRRefreshDSL: CRRefreshViewProtocol {
    
    internal var scroll: CRRefreshView
    
    internal init(scroll: CRRefreshView) {
        self.scroll = scroll
    }
    /// 添加上拉刷新控件
    @discardableResult
    public func addHeadRefresh(animator: CRRefreshProtocol = NormalHeaderAnimator(), handler: @escaping CRRefreshHandler) -> CRRefreshHeaderView {
        return CRRefreshMake.addHeadRefreshTo(refresh: scroll, animator: animator, handler: handler)
    }
    
    public func beginHeaderRefresh() {
        header?.beginRefreshing()
    }
    
    public func endHeaderRefresh() {
        header?.endRefreshing()
    }
    
    public func removeHeader() {
        var headRefresh = CRRefreshMake(scroll: scroll)
        headRefresh.removeHeader()
    }
    
    /// 添加下拉加载控件
    @discardableResult
    public func addFootRefresh(animator: CRRefreshProtocol = NormalFooterAnimator(), handler: @escaping CRRefreshHandler) -> CRRefreshFooterView {
        return CRRefreshMake.addFootRefreshTo(refresh: scroll, animator: animator, handler: handler)
    }
    
    public func noticeNoMoreData() {
        footer?.endRefreshing()
        footer?.noticeNoMoreData()
    }
    
    public func resetNoMore() {
        footer?.resetNoMoreData()
    }
    
    public func endLoadingMore() {
        footer?.endRefreshing()
    }
    
    public func removeFooter() {
        var footRefresh = CRRefreshMake(scroll: scroll)
        footRefresh.removeFooter()
    }
}


public struct CRRefreshMake: CRRefreshViewProtocol {
    
    internal var scroll: CRRefreshView
    
    internal init(scroll: CRRefreshView) {
        self.scroll = scroll
    }
    
    /// 添加上拉刷新
    @discardableResult
    internal static func addHeadRefreshTo(refresh: CRRefreshView, animator: CRRefreshProtocol = NormalHeaderAnimator(), handler: @escaping CRRefreshHandler) -> CRRefreshHeaderView {
        var make = CRRefreshMake(scroll: refresh)
        make.removeHeader()
        let header     = CRRefreshHeaderView(animator: animator, handler: handler)
        let headerH    = header.animator.execute
        header.frame   = .init(x: 0, y: -headerH, width: refresh.bounds.size.width, height: headerH)
        refresh.addSubview(header)
        make.header = header
        return header
    }
    
    public mutating func removeHeader() {
        header?.endRefreshing()
        header?.removeFromSuperview()
        header = nil
    }
    
    /// 添加下拉加载
    @discardableResult
    internal static func addFootRefreshTo(refresh: CRRefreshView, animator: CRRefreshProtocol = NormalFooterAnimator(), handler: @escaping CRRefreshHandler) -> CRRefreshFooterView {
        var make = CRRefreshMake(scroll: refresh)
        make.removeFooter()
        let footer     = CRRefreshFooterView(animator: animator, handler: handler)
        let footerH    = footer.animator.execute
        footer.frame   = .init(x: 0, y: refresh.contentSize.height + refresh.contentInset.bottom, width: refresh.bounds.size.width, height: footerH)
        refresh.addSubview(footer)
        make.footer = footer
        return footer
    }
    
    public mutating func removeFooter() {
        footer?.endRefreshing()
        footer?.removeFromSuperview()
        footer = nil
    }
}

protocol CRRefreshViewProtocol {
    var scroll: CRRefreshView {set get}
    /// 头部控件
    var header: CRRefreshHeaderView? {set get}
    /// 头部控件
    var footer: CRRefreshFooterView? {set get}
}

extension CRRefreshViewProtocol {
    
    public var header: CRRefreshHeaderView? {
        get {
            return (objc_getAssociatedObject(scroll, &kCRRefreshHeaderKey) as? CRRefreshHeaderView)
        }
        set {
            objc_setAssociatedObject(scroll, &kCRRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var footer: CRRefreshFooterView? {
        get {
            return (objc_getAssociatedObject(scroll, &kCRRefreshFooterKey) as? CRRefreshFooterView)
        }
        set {
            objc_setAssociatedObject(scroll, &kCRRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
