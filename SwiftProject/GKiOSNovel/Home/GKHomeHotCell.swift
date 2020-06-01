//
//  GKHomeHotCell.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

protocol GKHomeHotCellData {
    var name: String { get }
    var imageUrl: String { get }
    var tag: String {get}
}


class GKHomeHotCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deletBtn: UIButton!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .gray
        self.imageV.backgroundColor = .lightGray
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint("layoutSubviews:\(self.contentView.bounds.width)")
    }

}
