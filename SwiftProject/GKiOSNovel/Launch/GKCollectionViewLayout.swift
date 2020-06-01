//
//  GKCollectionViewLayout.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class GKCollectionViewLayout: UICollectionViewFlowLayout {
    var layoutAttrArr : [UICollectionViewLayoutAttributes]?
    
    var stringDatas: [NSString]?
    //MARK:-
    
    override func prepare() {
        super.prepare()
                
        self.layoutAttrArr = [UICollectionViewLayoutAttributes]()
        
        var x = self.minimumInteritemSpacing
        var y = self.minimumLineSpacing
        
        if let stringDatas = self.stringDatas {
            for idx in 0..<stringDatas.count {
                
                //debugPrint(self.stringDatas?[idx] ?? "")
                
                let attr = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath(row: idx, section: 0))
                var size = stringDatas[idx].boundingRect(with: CGSize(width: 1000, height: 30), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], context: nil).size
                size.width = size.width + 18
                size.height = size.height + 5
                
                if x + size.width > self.collectionView?.bounds.width ?? 0 {
                    x = self.minimumInteritemSpacing
                    y = y + size.height + self.minimumLineSpacing
                }
                attr.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                x += size.width + self.minimumInteritemSpacing
                
                self.layoutAttrArr?.append(attr)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else {
            return false
        }
        return !newBounds.equalTo(collectionView.bounds)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttrArr
    }

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttrArr?[indexPath.item]
     
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attr.frame = CGRect(x: 0, y: 0, width: self.collectionView?.frame.width ?? 375.0, height: 40)
        return attr
    }
}
