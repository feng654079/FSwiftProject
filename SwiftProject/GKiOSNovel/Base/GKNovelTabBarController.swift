//
//  GKNovelTabBarController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class GKNovelTabBarController: UITabBarController {
    
    var listData : [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listData = [UIViewController]()
        
        
        let home = GKHomeViewController.create()
        self.addVCToListData(home, title: "首页", normal: "icon_home_n", select: "icon_home_h")
        
        let cate = GKClassContentViewController()
        self.addVCToListData(cate, title: "分类", normal: "icon_class_n", select: "icon_class_h")
        
        let book = GKBooCaseController()
        self.addVCToListData(book, title: "书架", normal: "icon_case_n", select: "icon_case_h")
        let mine = GKMineController()
        self.addVCToListData(mine, title: "我的", normal: "icon_mine_n", select: "icon_mine_h")
        self.viewControllers = self.listData
        
    }
    
    
    func addVCToListData(_ vc:UIViewController ,title: String,normal:String,select:String) {
        let nav = BaseNavigationController(rootViewController: vc)
        vc.showNavTitle(title, backItem: false)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(named: normal)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage(named: select)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "0x999999")
        ], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.systemTeal 
        ], for: .selected)
        self.listData?.append(nav)
    }
    
    
    
    
}
