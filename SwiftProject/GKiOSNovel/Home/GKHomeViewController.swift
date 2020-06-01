//
//  GKHomeViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit


class GKHomeViewController: UIViewController {
    
        
    @IBOutlet var navBarView: GKNewNavBarView!
    @IBOutlet var naviBarHeight: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    
    
    static func create() -> GKHomeViewController {
        
        let sb = UIStoryboard.init(name: "GKiOSNovel", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GKHomeViewController") as! GKHomeViewController
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: UI
    func setUpUI() {
        
        self.view.backgroundColor = .white
       
        let statusBarHeight = UIApplication.shared.statusBarFrame.height as CGFloat
        let navHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(44.0)
        naviBarHeight.constant = statusBarHeight + navHeight
        navBarView.typeBtn.addTarget(self, action: #selector(typeBtnTouched(_:)), for: .touchUpInside)
     
        self.collectionView.registerCell(reuseID: GKHomeHotCell.self, nibName: "GKHomeHotCell")
      
        
       if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        flowLayout.minimumLineSpacing = 15.0
        flowLayout.minimumInteritemSpacing = 15.0
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        let width  = (UIScreen.main.bounds.width - 4 * 15.0) / 3.0
        let height = width * 131.0 / 75.0
        flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    //MARK: Action
    @objc func typeBtnTouched(_ sender: UIButton) {
        GKRouter.pushToAppGuidePage(fromVc: self)
    }
}

extension GKHomeViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
        self.collectionView.register(UINib(nibName: "GKHomeHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "GKHomeHeaderReusableView")
        let  view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GKHomeHeaderReusableView", for: indexPath) as? GKHomeHeaderReusableView
        view?.titleLabel.text = "热搜榜"
        return view ?? UICollectionReusableView()
    }
    
    
    //MARK:UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:GKHomeHotCell.reuseID, for: indexPath) as?  GKHomeHotCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    
//    //MARK: UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 15.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 15.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//       // if let cell = UINib(nibName: "GKHomeHotCell", bundle: nil).instantiate(withOwner: nil, options: nil);
//
//        return UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width  = (collectionView.bounds.width - 4 * 15.0) / 3.0
//        let height = width * 131.0 / 85.0
//
//        debugPrint("\(width),\(collectionView.bounds.width)")
//        return CGSize(width: width, height: height)
//
//    }
    
    
}
