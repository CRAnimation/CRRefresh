[![Version](https://img.shields.io/cocoapods/v/CRRefresh.svg?style=flat)](http://cocoapods.org/pods/CRRefresh)
[![License](https://img.shields.io/cocoapods/l/CRRefresh.svg?style=flat)](http://cocoapods.org/pods/CRRefresh)
[![Platform](https://img.shields.io/cocoapods/p/CRRefresh.svg?style=flat)](http://cocoapods.org/pods/CRRefresh)
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/) 
![Language](https://img.shields.io/badge/Language-%20swift%20%20-blue.svg)

![](CRRefresh.png)

**CRRefresh** 是一个简单易用的上拉刷新控件，你可以高度自定义UI样式，我们会不定期更新一些好看的动效，同时也欢迎大家投稿~~

[英文介绍](README.md) / [博客介绍](http://blog.csdn.net/wang631106979/article/details/62888435)

## 效果图

| ![](CRRefresh1.gif) |  ![](CRRefresh2.gif)   | ![](CRRefresh3.gif) |
| :-----------------: | :--------------------: | :-----------------: |
|  `NormalAnimator`   | `SlackLoadingAnimator` | `RamotionAnimator`  |
| ![](CRRefresh4.gif) |                        |                     |
|   `FastAnimator`    |                        |                     |

## 支持环境

- Xcode 8 or later
- iOS 8.0 or later
- ARC
- Swift 3.0 or later

## Features

- 支持`UIScrollView`及其子类`UICollectionView`、`UITableView`、`UIWebView`等
- 支持下拉刷新和上拉加载更多
- 支持下拉刷新和上拉加载更多

## 如何安装

### CocoaPods

```ruby
pod 'CRRefresh'
```

### Carthage

使用Carthage安装

1. 在`Cartfile`中添加`github "CRAnimation/CRRefresh"`
2. 执行`carthage update`
3. 导入`CRRefresh.framework`

### 手动安装

1. 下载最新版本的代码
2. 将 Source 内的源文件添加(拖放)到你的工程
3. 导入 `import CRRefresh `.

## 使用

![](CRRefresh3.gif)

**添加 `CRRefresh` 到你的工程**

```swift
import CRRefresh
```

**添加上拉刷新控件**

```swift
/// animator: 你的上拉刷新的Animator, 默认是 NormalHeaderAnimator
tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
    /// 开始刷新了
    /// 开始刷新的回调
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        /// 停止刷新
        self?.tableView.cr.endHeaderRefresh()
    })
}
/// 手动刷新
tableView.cr.beginHeaderRefresh()
```

**添加下拉加载控件**

```swift
/// animator: 你的下拉加载的Animator, 默认是NormalFootAnimator
tableView.cr.addFootRefresh(animator: NormalFootAnimator()) { [weak self] in
    /// 开始下拉加载
    /// 回调
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        /// 结束加载
        self?.tableView.cr.endLoadingMore()
        /// 没有更多数据
        self?.tableView.cr.noticeNoMoreData()
		/// 复位
		self?.tableView.cr.resetNoMore()
    })
}
```

## 自定义样式

你只需要实现`CRRefreshProtocol`就可以自定义样式了

```swift
public protocol CRRefreshProtocol {
    /// 自定义的view
    var view: UIView {get}
    
    /// view的insets
    var insets: UIEdgeInsets {set get}
    
    /// 触发刷新的高度
    var trigger: CGFloat {set get}
    
    /// 动画执行时的高度
    var execute: CGFloat {set get}
    
    /// 开始刷新
    mutating func refreshBegin(view: CRRefreshComponent)
    
    /// 结束刷新
    mutating func refreshEnd(view: CRRefreshComponent, finish: Bool)
    
    /// 刷新进度的变化
    mutating func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat)
    
    /// 刷新状态的变化
    mutating func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState)
}
```

## 移除控件

```swift
tableView.cr.removeFooter()
tableView.cr.removeHeader()
```

## 贡献你的代码

欢迎大家贡献代码，或者投稿好看的动效

## 联系

如果你想联系我：

- Email: wangchonglei93@icloud.com
- Github: https://github.com/imwcl
- QQ： 631106979
- 动效学习群：547897182

## 许可证

CRRefresh [MIT license](LICENSE)下发布。有关详细信息,请参阅许可证。