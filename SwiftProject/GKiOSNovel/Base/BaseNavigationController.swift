//
//  BaseNavigationController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    var isPushing = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return self.visibleViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.visibleViewController?.prefersStatusBarHidden ?? false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        if self.navigationController?.responds(to: #selector(getter: interactivePopGestureRecognizer)) ?? false {
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        
        let array = NSArray.init(array: [BaseNavigationController.self])
        
        let navBar = UINavigationBar.appearance(whenContainedInInstancesOf: array as! [UIAppearanceContainer.Type])
        
        let attribute =  [NSAttributedString.Key.foregroundColor:UIColor.white,
                          NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0),
           ]
        navBar.titleTextAttributes = attribute
        navBar.setBackgroundImage(UIImage.image(with: UIColor.systemTeal), for: .default)
        navBar.shadowImage = UIImage()
    }
    
    
}

extension BaseNavigationController:UINavigationControllerDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.isPushing {
            debugPrint("被拦截")
            return;
        } else {
            debugPrint("push")
            self.isPushing = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.isPushing = false
    }
}
