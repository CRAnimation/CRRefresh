//
//  NormalHeaderAnimator.swift
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
// @class NormalFootAnimator
// @abstract 普通顶部加载Animator
// @discussion 普通顶部加载Animator
//

import UIKit

open class NormalHeaderAnimator: UIView, CRRefreshProtocol {
    
    static let crBundle = CRRefreshBundle.bundle(name: "NormalHeader", for: NormalHeaderAnimator.self)
    
    open var pullToRefreshDescription = crBundle?.localizedString(key: "CRRefreshHeaderIdleText") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = crBundle?.localizedString(key: "CRRefreshHeaderPullingText")
    open var loadingDescription = crBundle?.localizedString(key: "CRRefreshHeaderRefreshingText")

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = .zero
    open var trigger: CGFloat = 60.0
    open var execute: CGFloat = 60.0

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = crBundle?.imageFromBundle("refresh_arrow")
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden     = true
        titleLabel.text        = loadingDescription
        imageView.transform    = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
    }
  
    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if finish {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            imageView.isHidden = false
            imageView.transform = CGAffineTransform.identity
        }else {
            titleLabel.text = pullToRefreshDescription
            setNeedsLayout()
        }
    }
    
    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing:
            titleLabel.text = loadingDescription
            setNeedsLayout()
            break
        case .pulling:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
            }) { (animated) in }
            break
        case .idle:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = .init(x: w / 2.0, y: h / 2.0)
            indicatorView.center = .init(x: titleLabel.frame.origin.x - 16.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
}
