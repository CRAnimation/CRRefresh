//
//  BaseViewController.swift
//  HotLine
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
// @class BaseViewController
// @abstract 所有VC的基类
// @discussion 所有VC的基类
//

import UIKit

let APP_NAV_BG_COLOR = UIColor(rgb: (140, 141, 178))
let APP_NAV_LINE_COLOR = UIColor.clear
let APP_BACK_COLOR = UIColor.white


class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var isFirstDidAppear: Bool = false
    var isViewAppear: Bool     = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var navTitle: String?{
        didSet{
            let titleLabel = UILabel.init(frame: CGRect.zero)
            titleLabel.font = UIFont.appMediumFontOfSize(18)
            titleLabel.textColor = UIColor.white
            titleLabel.text = navTitle
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
        }
    }
    
    //MARK: Public Methods    
    /**
     配置NavBar
     */
    func configNavBar() {
        setNavImage(bgColor: APP_NAV_BG_COLOR, shadowColor: APP_NAV_LINE_COLOR)
    }
    
    /**
     View的相关配置
     */
    func configView() {
        view.backgroundColor = APP_BACK_COLOR
    }
    
    //左边nav的点击事件
    @objc func leftButtonAction(_ button: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    /**
     添加默认返回按钮
     */
    @discardableResult
    func addNavDefaultBackButton() -> UIButton {
        let leftBt = UIButton()
        let btImage = UIImage.init(named: "nav_back")
        leftBt.setImage(btImage, for: UIControl.State())
        leftBt.frame.size = (btImage?.size)!
        leftBt.addTarget(self, action: #selector(leftButtonAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBt)
        return leftBt
    }
    
    /**
     设置navBar的颜色
     
     - parameter bgColor:     背景色
     - parameter shadowColor: 阴影色
     
     - returns: self
     */
    func setNavImage(bgColor: UIColor, shadowColor: UIColor) {
        let width = UIScreen.main.bounds.width
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: 64), false, scale)
        var context = UIGraphicsGetCurrentContext()!
        CGContext.setFillColor(context)(bgColor.cgColor)
        CGContext.addRect(context)(CGRect.init(x: 0, y: 0, width: width, height: 64))
        CGContext.drawPath(context)(using: .fill)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: 1), false, scale)
        context = UIGraphicsGetCurrentContext()!
        CGContext.setLineWidth(context)(1)
        CGContext.setStrokeColor(context)(shadowColor.cgColor)
        CGContext.move(context)(to: CGPoint.zero)
        CGContext.addLine(context)(to: CGPoint.init(x: width, y: 0))
        CGContext.drawPath(context)(using: .stroke)
        let shadowImage = UIGraphicsGetImageFromCurrentImageContext()
        
        self.navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = shadowImage
    }
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configNavBar()
        configView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFirstDidAppear == false {
            self.isFirstDidAppear = true
        }
        self.isViewAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavImage(bgColor: APP_NAV_BG_COLOR, shadowColor: APP_NAV_LINE_COLOR)
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isViewAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 字体
let appFontLightName   = "PingFangSC-Light"
let appFontRegularName = "PingFangSC-Regular"
let appFontMediumName  = "PingFangSC-Medium"
extension UIFont {
    /**
     更具系统不同返回light字体
     */
    class func appLightFontOfSize(_ fontSize:CGFloat) -> UIFont {
        if getSystemVersion() >= 9.0 {
            return UIFont.init(name: appFontLightName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    /**
     更具系统不同返回Regular字体
     */
    class func appRegularFontOfSize(_ fontSize:CGFloat) -> UIFont {
        if getSystemVersion() >= 9.0 {
            return UIFont.init(name: appFontRegularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    /**
     更具系统不同返回Medium字体
     */
    class func appMediumFontOfSize(_ fontSize:CGFloat) -> UIFont {
        if getSystemVersion() >= 9.0 {
            return UIFont.init(name: appFontMediumName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }else {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
}

/**
 返回系统版本
 */
func getSystemVersion() -> Double {
    let version = UIDevice.current.systemVersion
    var systemVersion = ""
    var itemIndex = 0
    for item in version.components(separatedBy: ".") {
        if itemIndex == 0 {
            systemVersion = systemVersion + item + "."
        }else {
            systemVersion = systemVersion + item
        }
        itemIndex += 1
    }
    return Double(systemVersion) ?? 0
}

public extension UIColor {
    convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
}
