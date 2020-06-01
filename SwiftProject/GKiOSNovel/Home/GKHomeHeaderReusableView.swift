//
//  GKHomeReusableView.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/27.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class GKHomeHeaderReusableView: UICollectionReusableView {


    @IBOutlet weak var titleLabel: UILabel!
    
   
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        moreBtn.setImagePostion(postion: .right)
    }
    
    
    
}
