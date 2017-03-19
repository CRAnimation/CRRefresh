//
//  RefreshCell.swift
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
// @class RefreshCell
// @abstract 刷新的cell
// @discussion 刷新的cell

import UIKit

class RefreshCell: UITableViewCell {

    @IBOutlet weak var oneRight: NSLayoutConstraint!
    @IBOutlet weak var twoRight: NSLayoutConstraint!
    
    //MARK: Public Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        oneRight.constant = CGFloat(arc4random()%100) + 40
        twoRight.constant = CGFloat(arc4random()%100) + 40
    }
    
    //MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
