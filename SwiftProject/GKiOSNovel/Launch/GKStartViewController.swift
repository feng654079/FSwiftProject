//
//  GKStartViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class GKStartViewController: UIViewController {
    
    
    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias EndConfigHandler = () -> Void
    var endConfigHanlder: EndConfigHandler?
    
    var rankInfo:RankInfo?
    
    var selectedIndexPath: [IndexPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle("修改性别")
        self.selectedIndexPath = [IndexPath]()
        setUpUI()
        
        fetchRank()
    }
    
    static func create(with endConfigHandler: EndConfigHandler?) -> GKStartViewController {
        let sb = UIStoryboard.init(name: "GKiOSNovel", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GKStartViewController") as! GKStartViewController
        vc.endConfigHanlder = endConfigHandler
        return vc
    }
    //MARK: network
    func fetchRank() {
        RankRequest().send(success: { [weak self] (info) in
            
            self?.rankInfo = info
            self?.rankInfo?.state = .boy
            self?.rerefrehUI()
            
            debugPrint("to json")
            debugPrint("\(String(describing: self?.rankInfo?.toJSON()))")
                        
        }) { (error) in
            let nserror = error as NSError
            self.showTipAlert(with: nserror.getErrorReason())
        }
    }
    
    //MARK: UI
    func rerefrehUI() {
        self.selectedIndexPath?.removeAll()
        
        if let layout = self.collectionView.collectionViewLayout as? GKCollectionViewLayout {
            layout.stringDatas = self.rankInfo?.listData?.map({ (rankModel) -> NSString in
                return (rankModel.title as NSString?) ?? ""
            })
            
            self.collectionView.reloadData()
        }
    }
    
    
    func setUpUI() {

        let flowLayout = GKCollectionViewLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumLineSpacing = 5
        
        self.collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(GKStartCell.self, forCellWithReuseIdentifier: NSStringFromClass(GKStartCell.self))
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    
    //MARK: action
    @IBAction func sexChanged(_ sender: UIButton) {
        
        sender.layer.masksToBounds = true
        sender.layer.cornerRadius = 4.0
        sender.layer.borderWidth = 4.0
        sender.layer.borderColor = UIColor.blue.cgColor
        
        if sender == boyBtn {
            girlBtn.layer.borderColor = UIColor.white.cgColor
            self.rankInfo?.state = .boy
        } else if sender == girlBtn {
            boyBtn.layer.borderColor = UIColor.white.cgColor
            self.rankInfo?.state = .girl
        }
        rerefrehUI()
        
    }
    
    @IBAction func makeSure(_ sender: UIButton) {
        if self.selectedIndexPath?.count == 0 {
            self.showTipAlert(with: "选择一个或者多个做为首页推荐吧！")
            return
        }
        
     }
}

extension GKStartViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if  let layout = collectionView.collectionViewLayout as? GKCollectionViewLayout {
            return layout.stringDatas?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(GKStartCell.self), for: indexPath) as?  GKStartCell,
            
            let layout = collectionView.collectionViewLayout as? GKCollectionViewLayout
        {
            cell.titleLabel.text = layout.stringDatas?[indexPath.item] as String?
            cell.isSelected = self.selectedIndexPath?.contains(indexPath) ?? false
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath?.append(indexPath)
        
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            })
        }
        
    }
    
}
