//
//  SBLineDetailPageViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/29.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

protocol SBLineDetailPageViewControllerDatasource:NSObjectProtocol {
    
    func numOfControllers(for pageVC:SBLineDetailPageViewController) -> Int
    
    func viewController(for pageVC:SBLineDetailPageViewController, atIndex:Int) -> UIViewController
}

protocol SBLineDetailPageViewControllerDelegate:NSObjectProtocol {
    func  pageViewControllerWillBeginDragging(_ pageVc: SBLineDetailPageViewController)
    
    func  pageViewControllerWillEndDragging(_ pageVc: SBLineDetailPageViewController, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}


class SBLineDetailPageViewController:UIViewController {
    
    weak var pageDataSource:SBLineDetailPageViewControllerDatasource?
    
    weak var pageDelegate: SBLineDetailPageViewControllerDelegate?
    
    private lazy var _countOfVc = 0
    private lazy var _currentVcIndex = 0
    private lazy var _scrollViewContianer = UIScrollView(frame: .zero)
    private lazy var _pageCache = Array.init(repeating: 0, count:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _commonInit()
    }
    
    func reload() {
        for view in _scrollViewContianer.subviews {
            view.removeFromSuperview()
        }
        
        if let myDataSource = pageDataSource {
            _countOfVc = myDataSource.numOfControllers(for: self)
            _currentVcIndex = 0
            _scrollViewContianer.contentSize = CGSize(width: _countOfVc * Int(self.view.bounds.width), height:0)
            _pageCache = Array.init(repeating: 0, count: _countOfVc)
            
            let vc = myDataSource.viewController(for: self, atIndex: 0)
            _addSubview(from: vc)
            _pageCache[_currentVcIndex] = 1
        }
    }
    
    func setCurrentIndex(index:Int) {
        _currentVcIndex = max(0, min(index, _countOfVc - 1))
        _scrollViewContianer.setContentOffset(CGPoint(x: CGFloat(_currentVcIndex) * self.view.bounds.width, y: 0), animated: true)
    }
    
    private func _addSubview(from vc:UIViewController) {
        self.addChild(vc)
        vc.view.frame = CGRect(x: CGFloat(_currentVcIndex) * self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        _scrollViewContianer.addSubview(vc.view)
    }
    
    private func _commonInit() {
        _scrollViewContianer.frame = self.view.bounds
        _scrollViewContianer.isPagingEnabled = true
        self.view.addSubview(_scrollViewContianer)
        _scrollViewContianer.delegate = self
    }
    
}

//MARK: create
extension SBLineDetailPageViewController {
    static func create() -> SBLineDetailPageViewController {
        
        return SBLineDetailPageViewController.init()
    }
}

extension SBLineDetailPageViewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pageDelegate?.pageViewControllerWillBeginDragging(self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  index = Int(scrollView.contentOffset.x / self.view.bounds.width)
        _currentVcIndex = max(0, min(index, _countOfVc - 1))
        //debugPrint("currentIndex:\(_currentVcIndex)")
        if _pageCache[_currentVcIndex] == 0,
            let myDataSource = self.pageDataSource {
            let vc = myDataSource.viewController(for: self, atIndex: _currentVcIndex)
            _addSubview(from: vc)
            _pageCache[_currentVcIndex] = 1
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageDelegate?.pageViewControllerWillEndDragging(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
}

//MARK: public interface
