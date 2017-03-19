//
//  NavigationViewController.swift
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
// @class NavigationViewController
// @abstract 所有nav的基类
// @discussion 所有nav的基类
//

import UIKit

class NavigationViewController: UINavigationController,
                              UINavigationControllerDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Public Methods
    
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationBar.isTranslucent = false
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
        if navigationController.viewControllers.count == 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.interactivePopGestureRecognizer?.delegate  = nil
        }
    }

    
    //MARK: Initial Methods
    convenience init(rootViewController: UIViewController, navBarColor: UIColor) {
        self.init(rootViewController: rootViewController)
        setNavImage(bgColor: navBarColor, shadowColor: UIColor.clear)
    }
    
    //MARK: Setter Getter Methods
    
    
    //MARK: Privater Methods
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
        
        self.navigationBar.setBackgroundImage(bgImage, for: .default)
        self.navigationBar.shadowImage = shadowImage
    }
    
    //MARK: KVO Methods
    
    
    //MARK: Notification Methods
    
    
    //MARK: Target Methods

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
