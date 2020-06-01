//
//  UIViewController+Alert.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
extension UIViewController {
    
    func showTipAlert(with message:String, title:String? = nil,style:UIAlertController.Style = .alert) {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction.init(title: "确定", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
}
