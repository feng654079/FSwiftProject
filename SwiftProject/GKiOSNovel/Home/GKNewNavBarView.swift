//
//  GKNewNavBarView.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

@IBDesignable
class GKNewNavBarView: UIView {
    
    let searchView = UIView()
    let serchIcon = UIImageView()
    let typeBtn = UIButton()
    let mainView = UIView()
    
    enum ViewType {
        case boy
        case girl
    }
    
    var viewType: ViewType = .boy {
        didSet {
            switch viewType {
            case .boy: break
            case .girl: break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    func commonInit() {
        self.addSubviews(views: [
            searchView,typeBtn
        ])
        self.searchView.addSubviews(views: [
            serchIcon,mainView
        ])
        
        UIView.disnableTranslatesAutoresizingMaskIntoConstraints(views: [
            searchView,serchIcon,mainView,serchIcon,typeBtn
        ])
        
        
        self.backgroundColor = .systemTeal
        
        //"icon_girl_h"
        typeBtn.setImage(UIImage(named: "icon_boy_h"), for: .normal)
        
        searchView.backgroundColor = .white
        
        serchIcon.image = UIImage(named: "ic_strategy_search")
        serchIcon.contentMode = .scaleAspectFit
        
        typeBtn.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        typeBtn.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        typeBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        typeBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0).isActive = true
        
        searchView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: typeBtn.leadingAnchor, constant: -5.0).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0).isActive = true
        searchView.centerYAnchor.constraint(equalTo: typeBtn.centerYAnchor, constant:0).isActive = true
        
        serchIcon.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10.0).isActive = true
        serchIcon.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0).isActive = true
        serchIcon.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
        serchIcon.heightAnchor.constraint(equalToConstant: 13.0).isActive = true
        
        
        mainView.leadingAnchor.constraint(equalTo: serchIcon.trailingAnchor, constant: 8.0).isActive = true
        mainView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0.0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 0.0).isActive = true
        mainView.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 0.0).isActive = true
        
    }
    
    override func layoutSubviews() {
        
       
        
        
    }
    
    
}
