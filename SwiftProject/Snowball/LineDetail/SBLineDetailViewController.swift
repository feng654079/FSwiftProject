//
//  SBLineDetailViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

enum ScrollControlPositon {
    case top
    case bottom
    case right
    case left
}

//protocol ScrollController {
//    func subview(view:UIView, didScrollTo positon: ScrollControlPositon)
//}

protocol ScrollControlProtocol {
    typealias ScrollPostionHandler = (ScrollControlPositon) -> Void
    
    var canScroll:Bool {get set}
    
    var didScrollToPosition: ScrollPostionHandler? {get set}
}

//MARK:-

class SBLineDetailItemViewController: UIViewController {
    private lazy var textView = UITextView(frame: .zero)
    
    private var _canScroll = false
    private var _didScrollToPonsition: ScrollPostionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textView)
        textView.frame = CGRect(x: 0, y: 0, width: self.view.width , height: self.view.height)
        textView.delegate = self
        if  let path = Bundle.main.path(forResource: "基督教《圣经》新旧约全书 (1)", ofType: "txt") {
            let url = URL(fileURLWithPath:path)
            let text = try? String.init(contentsOf: url)
            
            textView.text = text
        }
    }
}

//MARK:- Scroll Controll
extension SBLineDetailItemViewController:UITextViewDelegate,ScrollControlProtocol {
    
    var didScrollToPosition: ScrollPostionHandler? {
        get {
            return _didScrollToPonsition
        }
        set {
            _didScrollToPonsition = newValue
        }
    }
    
    var canScroll: Bool {
        get {
            return _canScroll
        }
        set {
            _canScroll = newValue
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.canScroll == false {
            scrollView.contentOffset = .zero
        } else {
            if scrollView.contentOffset.y < 0 {
                self.canScroll = false
                self._didScrollToPonsition?(.top)
            }
        }
    }
}

//MARK:-
class SBScrollView: UIScrollView , UIGestureRecognizerDelegate{
    //必须xian'shi
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



//MARK:-
class SBLineDetailViewController: UIViewController {
    
    private lazy var scrollView = SBScrollView(frame: .zero)
    private lazy var categoriesSelectView = SBLineCategorySelectView(frame: .zero)
    private lazy var headView = UIView(frame: .zero)
    private lazy var pageVc = SBLineDetailPageViewController.create()
    
    
    private lazy var detailItemVC:SBLineDetailItemViewController = {
        let vc = SBLineDetailItemViewController()
        vc.didScrollToPosition = {
            [weak self] (position) in
            if position == .top {
                self?.canScroll = true
            }
        }
        return vc
    }()
    
    private lazy var _canScroll = true
    private lazy var _didScrollToPonsition: ScrollPostionHandler? = nil
    
    static func create() -> SBLineDetailViewController{
        return  UIViewController.create(fromStoryboardName: "Snowball", identifier: "SBLineDetailViewController") as! SBLineDetailViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUI()
        _configHandlers()
    }
    
    private func _setUpUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headView)
        self.scrollView.addSubview(self.categoriesSelectView)
        self.addChild(self.pageVc)
        // self.addChild(self.detailItemVC)
        self.scrollView.addSubview(self.pageVc.view)
        
        self.scrollView.frame = self.view.bounds
        self.scrollView.delegate = self
        // self.scrollView.bounces = false
        
        self.headView.backgroundColor = .lightGray
        self.headView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300.hs)
        
        self.categoriesSelectView.frame = CGRect(x: 0, y: self.headView.bottom, width: self.headView.width, height: 50.hs)
        self.categoriesSelectView.config(titles: ["讨论","资金","资讯","公告","简况","财务","研报","股市","年报","市值"]) {
            [weak self]  (idx) in
            self?.pageVc.setCurrentIndex(index: idx)
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //self.detailItemVC.view.frame = CGRect(x: 0, y: self.categoriesSelectView.bottom, width: self.headView.width, height: view.height - self.categoriesSelectView.height - statusBarHeight)
        
        self.pageVc.view.frame = CGRect(x: 0, y: self.categoriesSelectView.bottom, width: self.headView.width, height: view.height - self.categoriesSelectView.height - statusBarHeight)
        self.pageVc.pageDataSource = self
        self.pageVc.pageDelegate = self
        self.pageVc.reload()
        
        self.scrollView.contentSize = CGSize(width: 0, height: headView.height + categoriesSelectView.height + pageVc.view.height)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .lightGray
        
        
        
    }
    
    private func _configHandlers() {
        
    }
    
}

//MARK: page vc
extension SBLineDetailViewController:SBLineDetailPageViewControllerDatasource {
    func numOfControllers(for pageVC: SBLineDetailPageViewController) -> Int {
        2
    }
    
    func viewController(for pageVC: SBLineDetailPageViewController, atIndex: Int) -> UIViewController {
        if atIndex == 0 {
            return self.detailItemVC
        } else {
            let vc = UIViewController()
            vc.view.backgroundColor = .green
            return vc
        }
    }
    
    
}

//MARK: page vc delegate
extension SBLineDetailViewController:SBLineDetailPageViewControllerDelegate {
    func pageViewControllerWillBeginDragging(_ pageVc: SBLineDetailPageViewController) {
        self.scrollView.isScrollEnabled = false
    }
    
    func pageViewControllerWillEndDragging(_ pageVc: SBLineDetailPageViewController, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollView.isScrollEnabled = true
    }
    
    
}

//MARK:Scroll Control
extension SBLineDetailViewController:UIScrollViewDelegate,ScrollControlProtocol {
    var didScrollToPosition: ScrollPostionHandler? {
        get {
            return _didScrollToPonsition
        }
        set {
            _didScrollToPonsition = newValue
        }
    }
    
    var canScroll: Bool {
        get {
            return _canScroll
        }
        set {
            _canScroll = newValue
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        spDebugLog(items: scrollView.contentOffset)
        
        if (!self.canScroll) {
            //防止因为计算误差,导致scrollViewDidScroll重复调用
            if fabsf(Float(scrollView.contentOffset.y - self.categoriesSelectView.top)) > 10 {
                scrollView.contentOffset = CGPoint(x: 0, y: self.categoriesSelectView.top)
            }
            return
        }
        
        if scrollView.contentOffset.y > self.categoriesSelectView.top{
            if self.canScroll {
                self.canScroll = false
                self.detailItemVC.canScroll = true
                
            }
        }
        
    }
}

//extension SBLineDetailViewController:UIGestureRecognizerDelegate {
//手势识别器是否应该开始
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (scrollView.contentOffset.y > categoriesSelectView.bottom) {
//            return true
//        }
//
//        return false
//    }

//     //手势识别器是否应该和其它手势识别器同步
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//       return true
//    }
//
//      //手势识别器的失败是否需要另一个手势识别器失败
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//
//    //询问手势识别器是否被其他手势识别器要求失败
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//
//    //询问代理手势识别器是否应接收表示触摸的对象
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return true
//    }
//
//    //手势识别器是否应该接收按压对象
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
//        return false
//    }
//
//
//      //手势识别器是否应该接收UIEvent对象
//     @available(iOS 13.4, *)
//     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
//         return true
//      }
//}


