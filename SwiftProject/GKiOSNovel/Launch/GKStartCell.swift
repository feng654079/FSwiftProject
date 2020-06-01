//
//  GKStartCell.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit


@IBDesignable
class GKStartCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            debugPrint("isSelected")
            
            if isSelected {
                
                self.titleLabel.layer.borderColor =
                    UIColor.systemTeal.cgColor
                self.titleLabel.textColor = UIColor.white
                self.titleLabel.backgroundColor = UIColor.systemTeal
                
            } else {
                
                self.titleLabel.backgroundColor = UIColor.white
                self.titleLabel.textColor = UIColor.systemTeal
                self.titleLabel.layer.borderColor =
                    UIColor.systemTeal.cgColor
                
                
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        debugPrint("prepareForReuse")
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
        
        self.contentView.addSubview(titleLabel)
        
        
       self.isSelected = false
                 
         titleLabel.font = UIFont.Font(name: .pingfangsc_regular, size: 15.0)
         titleLabel.layer.borderWidth = 1.0
         titleLabel.layer.cornerRadius = 4.0
         titleLabel.layer.masksToBounds = true
         titleLabel.text = "哈哈哈"
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         titleLabel.textAlignment = .center
         
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
         
         titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
         titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
         titleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: 0).isActive = true
         titleLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: 0).isActive = true
    }
    
    
}
