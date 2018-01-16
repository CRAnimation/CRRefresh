//
//  FastLayer.swift
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
//  HomePage:https://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class FastLayer
// @abstract FastLayer
// @discussion FastLayer
//

import UIKit

class FastLayer: CALayer {
    
    private (set)var circle: FastCircleLayer?
    
    private (set)var arrow: FastArrowLayer?
    
    let color: UIColor
    
    let arrowColor: UIColor

    let lineWidth: CGFloat
    
    //MARK: Public Methods
    
    
    //MARK: Override
    
    
    //MARK: Initial Methods
    init(frame: CGRect, color: UIColor = .init(rgb: (214, 214, 214)), arrowColor: UIColor = .init(rgb: (165, 165, 165)), lineWidth: CGFloat = 1) {
        self.color      = color
        self.arrowColor = arrowColor
        self.lineWidth  = lineWidth
        super.init()
        self.frame = frame
        backgroundColor = UIColor.clear.cgColor
        initCircle()
        initArrowLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func initCircle() {
        circle = FastCircleLayer(frame: bounds, color: color, pointColor: arrowColor, lineWidth: lineWidth)
        addSublayer(circle!)
    }
    
    private func initArrowLayer() {
        arrow = FastArrowLayer(frame: bounds, color: arrowColor, lineWidth: lineWidth)
        addSublayer(arrow!)
    }
    
}
