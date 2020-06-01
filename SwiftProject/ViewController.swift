//
//  ViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2019/10/28.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    var colorOperationDisposer = YLOperationDisposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let redView = UIView(frame: .zero)
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(redView)
        
        redView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        redView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10).isActive = true
        redView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10).isActive = true
        redView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -10).isActive = true
    }

    deinit {
        colorOperationDisposer.dispose()
    }
    
}

