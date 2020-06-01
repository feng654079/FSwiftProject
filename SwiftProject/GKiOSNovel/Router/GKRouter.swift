//
//  GKRouter.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

class GKRouter {
    
    static func pushToAppGuidePage(fromVc:UIViewController,completion: GKStartViewController.EndConfigHandler? = nil) {
        
        let vc = GKStartViewController.create(with: completion)
        vc.hidesBottomBarWhenPushed = true
        fromVc.navigationController?.pushViewController(vc, animated:true )
    }
}
