//
//  ViewController.swift
//  CRRefresh
//
//  Created by 王崇磊 on 2017/2/24.
//  Copyright © 2017年 王崇磊. All rights reserved.
//

import UIKit
import CRRefresh

class ViewController: BaseViewController {
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        return table
    }()
    
    var refreshs: [Refresh] = [
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_1"), title: "NormalAnimator", subTitle: "普通刷新控件"), header: .nomalHead, footer: .nomalFoot),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_2"), title: "SlackLoadingAnimator", subTitle: "SlackLoading的刷新控件"), header: .slackLoading, footer: .slackLoading),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_3"), title: "RamotionAnimator", subTitle: "Ramotion的刷新控件"), header: .ramotion, footer: .nomalFoot),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_1"), title: "FastAnimator", subTitle: "FastAnimator的刷新控件"), header: .fast, footer: .nomalFoot)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavBar() {
        super.configNavBar()
        navTitle = "CRRefresh"
    }
    
    override func configView() {
        super.configView()
        tableView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 64)
        tableView.register(UINib.init(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Table view data source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let refresh = refreshs[indexPath.row]
        let vc = RefreshController(refresh: refresh)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refreshs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalCell
        let refresh = refreshs[indexPath.row]
        cell.config(refresh.model)
        return cell
    }
}

struct Refresh {
    var model: Model
    var header: Style
    var footer: Style
    struct Model {
        var icon: UIImage
        var title: String
        var subTitle: String
    }
    
    enum Style {
        // 普通刷新类
        case nomalHead
        case nomalFoot
        // slackLoading刷新控件
        case slackLoading
        // ramotion动画
        case ramotion
        // fast动画
        case fast
        
        func commont() -> CRRefreshProtocol {
            switch self {
            case .nomalHead:
                return NormalHeaderAnimator()
            case .nomalFoot:
                return NormalFooterAnimator()
            case .slackLoading:
                return SlackLoadingAnimator()
            case .ramotion:
                return RamotionAnimator()
            case .fast:
                return FastAnimator()
            }
        }
    }
}

