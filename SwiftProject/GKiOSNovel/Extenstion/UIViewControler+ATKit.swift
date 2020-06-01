//
//  UIViewControler+ATKit.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

extension UIViewController {
    func setKeyBoardDismiss() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func setLargeTitleDisplayModeNever() {
        if #available(iOS 11.0,*) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    
    func navItem(with contentHorizontalAlignment:UIControl.ContentHorizontalAlignment = .right, image:UIImage? = nil , title:String? = nil  , color: UIColor = .gray, target:Any = self , action:Selector ) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setImage(image, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setTitleColor(color, for: .normal)
        btn.contentHorizontalAlignment = contentHorizontalAlignment
        return UIBarButtonItem.init(customView: btn)
    }
    
    func set(_ backItem: UIImage? , closeItem: UIImage?) {
        if self.navigationController?.viewControllers.count == 1 &&
            self.presentingViewController != nil{
            self.navigationItem.leftBarButtonItem = self.navItem(with: .left, image: closeItem, title: closeItem == nil ? nil :"ㄨ", color: .gray, target: self, action:#selector(goBack(_:)) )
        }
        else if self.navigationController?.viewControllers.count ?? 0 > 1 || (self.navigationController != nil && self.parent == nil) {
            
             self.navigationItem.leftBarButtonItem = self.navItem(with: .left, image: backItem, title: backItem != nil ? nil :"ㄑ", color: .gray, target: self, action:#selector(goBack(_:)) )
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton  = true
        }
    }
    
    @objc func goBack(_ animated:Bool = true) {
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: animated)
        } else if self.presentingViewController != nil {
            self.navigationController?.dismiss(animated: animated, completion: nil)
        }
         self.view.endEditing(true)
    }
    
    func showNavTitle(_ title:String , backItem show: Bool = true) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.isHidden = false
        if (show) {
            self.set(UIImage(named: "icon_nav_back"), closeItem: UIImage(named: "icon_nav_close"))
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
    }
    
    
}



