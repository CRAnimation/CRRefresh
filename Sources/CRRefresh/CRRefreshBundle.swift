//
//  CRRefreshBundle.swift
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
// @class CRRefreshBundle
// @abstract 从Bundle中获取数据的类
// @discussion 从Bundle中获取数据的类
//

import UIKit

class CRRefreshBundle {
    
    var crBundle: Bundle
    
    init(bundle: Bundle) {
        crBundle = bundle
    }
    
    @discardableResult
    static func bundle(name: String, for aClass: Swift.AnyClass) -> CRRefreshBundle? {
        let bundle = Bundle(for: aClass)
        if let path = bundle.path(forResource: name, ofType: "bundle") {
            if let bundle = Bundle(path: path) {
                return CRRefreshBundle(bundle: bundle)
            }
        }
        return nil
    }
    
    func imageFromBundle(_ imageName: String) -> UIImage? {
        var imageName = imageName
        if UIScreen.main.scale == 2 {
            imageName = imageName + "@2x"
        }else if UIScreen.main.scale == 3 {
            imageName = imageName + "@3x"
        }
        let bundle = Bundle(path: crBundle.bundlePath + "/images")
         if let path = bundle?.path(forResource: imageName, ofType: "png") {
            let image = UIImage(contentsOfFile: path)
            return image
        }
        return nil
    }
    
    func localizedString(key: String) -> String {
        if let current = Locale.current.languageCode {
            var language = ""
            switch current {
            case "zh":
                language = "zh"
            default:
                language = "en"
            }
            if let path = crBundle.path(forResource: language, ofType: "lproj") {
                if let bundle = Bundle(path: path) {
                    let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                    return Bundle.main.localizedString(forKey: key, value: value, table: nil)
                }
            }
        }
        return key
    }
}
